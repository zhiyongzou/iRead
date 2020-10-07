//
//  DTHTMLAttributedStringBuilder.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 21.01.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#if DEBUG_LOG_METRICS
    #import "NSString+DTFormatNumbers.h"
#endif
#import "DTLog.h"
#import "DTHTMLParser.h"
#import "NSString+DTURLEncoding.h"
#import "DTHTMLAttributedStringBuilder.h"
#import "DTTextHTMLElement.h"
#import "DTBreakHTMLElement.h"
#import "DTStylesheetHTMLElement.h"
#import "DTCSSStylesheet.h"
#import "DTCoreTextFontDescriptor.h"
#import "DTHTMLParserTextNode.h"
#import "DTTextAttachmentHTMLElement.h"
#import "DTColorFunctions.h"
#import "DTCoreTextParagraphStyle.h"
#import "DTObjectTextAttachment.h"
#import "DTVideoTextAttachment.h"
#import "NSString+HTML.h"
#import "NSCharacterSet+HTML.h"
#import "NSMutableAttributedString+HTML.h"

@interface DTHTMLAttributedStringBuilder ()

@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSDictionary *options;

// settings for parsing
@property (nonatomic, assign) CGFloat textScale;
@property (nonatomic, strong) DTColor *defaultLinkColor;
@property (nonatomic, strong) DTCSSStylesheet *globalStyleSheet;
@property (nonatomic, strong) NSURL *baseURL;
@property (nonatomic, strong) DTCoreTextFontDescriptor *defaultFontDescriptor;
@property (nonatomic, strong) DTCoreTextParagraphStyle *defaultParagraphStyle;

// root node inherits these defaults
@property (nonatomic, strong) DTHTMLElement *defaultTag;

// parsing state, accessed from inside blocks
@property (nonatomic, strong) NSMutableAttributedString *tmpString;

// GCD
@property (nonatomic, strong) dispatch_queue_t stringAssemblyQueue;
@property (nonatomic, strong) dispatch_group_t stringAssemblyGroup;
@property (nonatomic, strong) dispatch_queue_t dataParsingQueue;
@property (nonatomic, strong) dispatch_group_t dataParsingGroup;
@property (nonatomic, strong) dispatch_queue_t treeBuildingQueue;
@property (nonatomic, strong) dispatch_group_t treeBuildingGroup;

// lookup table for blocks that deal with begin and end tags
@property (nonatomic, strong) NSMutableDictionary *tagStartHandlers;
@property (nonatomic, strong) NSMutableDictionary *tagEndHandlers;

@property (nonatomic, assign) BOOL shouldProcessCustomHTMLAttributes;

// new parsing
@property (nonatomic, strong) DTHTMLElement *currentTag;
@property (nonatomic, strong) DTHTMLElement *rootNode;
@property (nonatomic, strong) DTHTMLElement *bodyElement;
@property (nonatomic, strong) DTHTMLParser  *parser;
// ignores events from parser after first HTML tag was finished
@property (nonatomic, assign) BOOL ignoreParseEvents;
// ignores style blocks attached on elements
@property (nonatomic, assign) BOOL ignoreInlineStyles;
// don't remove spaces at end of document
@property (nonatomic, assign) BOOL preserverDocumentTrailingSpaces;

@end


@implementation DTHTMLAttributedStringBuilder

- (id)initWithHTML:(NSData *)data options:(NSDictionary *)options documentAttributes:(NSDictionary * __autoreleasing*)docAttributes
{
	self = [super init];
	if (self)
	{
		_data = data;
		_options = options;
		
		// documentAttributes ignored for now
		// Specify the appropriate text encoding for the passed data, default is UTF8
		NSString *textEncodingName = [_options objectForKey:NSTextEncodingNameDocumentOption];
		NSStringEncoding encoding = NSUTF8StringEncoding; // default
		
		if (textEncodingName)
		{
			CFStringEncoding cfEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)textEncodingName);
			encoding = CFStringConvertEncodingToNSStringEncoding(cfEncoding);
		}
		_parser = [[DTHTMLParser alloc] initWithData:_data encoding:encoding];
		_parser.delegate = (id)self;
		
		// GCD setup
		_stringAssemblyQueue = dispatch_queue_create("DTHTMLAttributedStringBuilder", 0);
		_stringAssemblyGroup = dispatch_group_create();
		_dataParsingQueue = dispatch_queue_create("DTHTMLAttributedStringBuilderParser", 0);
		_dataParsingGroup = dispatch_group_create();
		_treeBuildingQueue = dispatch_queue_create("DTHTMLAttributedStringBuilderParser Tree Queue", 0);
		_treeBuildingGroup = dispatch_group_create();
	}
	
	return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
	dispatch_release(_stringAssemblyQueue);
	dispatch_release(_stringAssemblyGroup);
	dispatch_release(_dataParsingQueue);
	dispatch_release(_dataParsingGroup);
	dispatch_release(_treeBuildingQueue);
	dispatch_release(_treeBuildingGroup);
#endif
}

- (BOOL)_buildString
{
#if DEBUG_LOG_METRICS
	// metrics: get start time
	CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
#endif
	
	// only with valid data
	if (![_data length])
	{
		return NO;
	}
	
	// register default handlers
	[self registerTagStartHandlers];
	[self registerTagEndHandlers];

	// custom option to scale text
	_textScale = [[_options objectForKey:NSTextSizeMultiplierDocumentOption] floatValue];
	if (_textScale==0)
	{
		_textScale = 1.0f;
	}
	
	// use baseURL from options if present
	_baseURL = [_options objectForKey:NSBaseURLDocumentOption];
	
	// the combined style sheet for entire document
	_globalStyleSheet = [[DTCSSStylesheet defaultStyleSheet] copy];
	
	// do we have a default style sheet passed as option?
	DTCSSStylesheet *defaultStylesheet = [_options objectForKey:DTDefaultStyleSheet];
	if (defaultStylesheet)
	{
		// merge the default styles to the combined style sheet
		[_globalStyleSheet mergeStylesheet:defaultStylesheet];
	}
	
	// for performance reasons we will return this mutable string
	_tmpString = [[NSMutableAttributedString alloc] init];
	
	// base tag with font defaults
	_defaultFontDescriptor = [[DTCoreTextFontDescriptor alloc] initWithFontAttributes:nil];
	
	
	// set the default font size
	CGFloat defaultFontSize = 12.0f;
	
	NSNumber *defaultFontSizeNumber = [_options objectForKey:DTDefaultFontSize];
	
	if (defaultFontSizeNumber)
	{
		defaultFontSize = [defaultFontSizeNumber floatValue];
	}
	
	_defaultFontDescriptor.pointSize = defaultFontSize * _textScale;
	
	NSString *defaultFontFamily = [_options objectForKey:DTDefaultFontFamily];
	
	if (defaultFontFamily)
	{
		_defaultFontDescriptor.fontFamily = defaultFontFamily;
	}
	else
	{
		_defaultFontDescriptor.fontFamily = @"Times New Roman";
	}

	NSString *defaultFontName = [_options objectForKey:DTDefaultFontName];

	if (defaultFontName) {
		_defaultFontDescriptor.fontName = defaultFontName;
	}
	else
    {
        _defaultFontDescriptor.fontName = @"TimesNewRomanPSMT";
    }
	
	_defaultLinkColor = [_options objectForKey:DTDefaultLinkColor];
	
	if (_defaultLinkColor)
	{
		if ([_defaultLinkColor isKindOfClass:[NSString class]])
		{
			// convert from string to color
			_defaultLinkColor = DTColorCreateWithHTMLName((NSString *)_defaultLinkColor);
		}
		
		// get hex code for the passed color
		NSString *colorHex = DTHexStringFromDTColor(_defaultLinkColor);
		
		// overwrite the style
		NSString *styleBlock = [NSString stringWithFormat:@"a {color:#%@;}", colorHex];
		[_globalStyleSheet parseStyleBlock:styleBlock];
	}
	
	// default is to have A underlined
	NSNumber *linkDecorationDefault = [_options objectForKey:DTDefaultLinkDecoration];
	
	if (linkDecorationDefault)
	{
		if (![linkDecorationDefault boolValue])
		{
			// remove default decoration
			[_globalStyleSheet parseStyleBlock:@"a {text-decoration:none;}"];
		}
	}
	
	DTColor *defaultLinkHighlightColor = [_options objectForKey:DTDefaultLinkHighlightColor];
	
	if (defaultLinkHighlightColor)
	{
		if ([defaultLinkHighlightColor isKindOfClass:[NSString class]])
		{
			// convert from string to color
			defaultLinkHighlightColor = DTColorCreateWithHTMLName((NSString *)defaultLinkHighlightColor);
		}
		
		// get hex code for the passed color
		NSString *colorHex = DTHexStringFromDTColor(defaultLinkHighlightColor);
		
		// overwrite the style
		NSString *styleBlock = [NSString stringWithFormat:@"a:active {color:#%@;}", colorHex];
		[_globalStyleSheet parseStyleBlock:styleBlock];
	}
	
	// default paragraph style
	_defaultParagraphStyle = [DTCoreTextParagraphStyle defaultParagraphStyle];
	
	NSNumber *defaultLineHeightMultiplierNum = [_options objectForKey:DTDefaultLineHeightMultiplier];
	
	if (defaultLineHeightMultiplierNum)
	{
		CGFloat defaultLineHeightMultiplier = [defaultLineHeightMultiplierNum floatValue];
		_defaultParagraphStyle.lineHeightMultiple = defaultLineHeightMultiplier;
	}
	
	NSNumber *defaultTextAlignmentNum = [_options objectForKey:DTDefaultTextAlignment];
	
	if (defaultTextAlignmentNum)
	{
		_defaultParagraphStyle.alignment = (CTTextAlignment)[defaultTextAlignmentNum integerValue];
	}
	
	NSNumber *defaultFirstLineHeadIndent = [_options objectForKey:DTDefaultFirstLineHeadIndent];
	if (defaultFirstLineHeadIndent)
	{
		_defaultParagraphStyle.firstLineHeadIndent = [defaultFirstLineHeadIndent integerValue];
	}
	
	NSNumber *defaultHeadIndent = [_options objectForKey:DTDefaultHeadIndent];
	if (defaultHeadIndent)
	{
		_defaultParagraphStyle.headIndent = [defaultHeadIndent integerValue];
	}
	
	_defaultTag = [[DTHTMLElement alloc] init];
	_defaultTag.fontDescriptor = _defaultFontDescriptor;
	_defaultTag.paragraphStyle = _defaultParagraphStyle;
	_defaultTag.textScale = _textScale;
	_defaultTag.currentTextSize = _defaultFontDescriptor.pointSize;
	
#if DTCORETEXT_FIX_14684188
	// workaround, only necessary while rdar://14684188 is not fixed
	_defaultTag.textColor = [UIColor blackColor];
#endif
	
	id defaultColor = [_options objectForKey:DTDefaultTextColor];
	if (defaultColor)
	{
		if ([defaultColor isKindOfClass:[DTColor class]])
		{
			// already a DTColor
			_defaultTag.textColor = defaultColor;
		}
		else
		{
			// need to convert first
			_defaultTag.textColor = DTColorCreateWithHTMLName(defaultColor);
		}
	}
	
	_shouldProcessCustomHTMLAttributes = [[_options objectForKey:DTProcessCustomHTMLAttributes] boolValue];
	
	// ignore inline styles if option is passed
	_ignoreInlineStyles = [[_options objectForKey:DTIgnoreInlineStylesOption] boolValue];
	
	// don't remove spaces at end of document
	_preserverDocumentTrailingSpaces = [[_options objectForKey:DTDocumentPreserveTrailingSpaces] boolValue];
	
	DT_WEAK_VARIABLE typeof(self) weakSelf = self;
	__block BOOL result;
	dispatch_group_async(_dataParsingGroup, _dataParsingQueue, ^{ result = [weakSelf.self.parser parse]; });
	
	// wait until all string assembly is complete
	dispatch_group_wait(_dataParsingGroup, DISPATCH_TIME_FOREVER);
	dispatch_group_wait(_treeBuildingGroup, DISPATCH_TIME_FOREVER);
	dispatch_group_wait(_stringAssemblyGroup, DISPATCH_TIME_FOREVER);
	
	// clean up handlers because they retained self
	_tagStartHandlers = nil;
	_tagEndHandlers = nil;

#if DEBUG_LOG_METRICS
	// metrics: get end time
	CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent();
	
	// output metrics
	DTLogDebug((@"DTCoreText created string from %@ HTML in %.2f sec", [NSString stringByFormattingBytes:[_data length]], endTime-startTime);
#endif
	
	return result;
}

- (NSAttributedString *)generatedAttributedString
{
	if (!_tmpString)
	{
		[self _buildString];
	}
	
	return _tmpString;
}

#pragma mark GCD

- (void)registerTagStartHandlers
{
	if (_tagStartHandlers)
	{
		return;
	}
	
	_tagStartHandlers = [[NSMutableDictionary alloc] init];
	
	void (^blockquoteBlock)(void) = ^
	{
		self.currentTag.paragraphStyle.headIndent += (CGFloat)25.0 * self.textScale;
		self.currentTag.paragraphStyle.firstLineHeadIndent = self.currentTag.paragraphStyle.headIndent;
		self.currentTag.paragraphStyle.paragraphSpacing = self.defaultFontDescriptor.pointSize;
	};
	
	[_tagStartHandlers setObject:[blockquoteBlock copy] forKey:@"blockquote"];
	
	
	void (^aBlock)(void) = ^
	{
		if (self.currentTag.isColorInherited || !self.currentTag.textColor)
		{
			self.currentTag.textColor = self.defaultLinkColor;
			self.currentTag.isColorInherited = NO;
		}
		
		// the name attribute of A becomes an anchor
		self.currentTag.anchorName = [self.currentTag attributeForKey:@"name"];

		// remove line breaks and whitespace in links
		NSString *cleanString = [[self.currentTag attributeForKey:@"href"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
		cleanString = [cleanString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		
		if (![cleanString length])
		{
			// no valid href
			return;
		}
		
		NSURL *link = [NSURL URLWithString:cleanString];
		
        if (link == nil)
		{
			cleanString = [cleanString stringByEncodingNonASCIICharacters];
            link = [NSURL URLWithString:cleanString];
        }
		
		// deal with relative URL
		if (![link scheme])
		{
			if ([cleanString length])
			{
				link = [NSURL URLWithString:cleanString relativeToURL:self.baseURL];
				
				if (!link)
				{
					// NSURL did not like the link, so let's encode it
					cleanString = [cleanString stringByAddingHTMLEntities];
					
					link = [NSURL URLWithString:cleanString relativeToURL:self.baseURL];
				}
			}
			else
			{
				link = self.baseURL;
			}
		}
		
		self.currentTag.link = link;
	};
	
	[_tagStartHandlers setObject:[aBlock copy] forKey:@"a"];
	
	void (^listBlock)(void) = ^
	{
		self.currentTag.paragraphStyle.firstLineHeadIndent = self.currentTag.paragraphStyle.headIndent;
		
		// create the appropriate list style from CSS
		DTCSSListStyle *newListStyle = [self.currentTag listStyle];
		
		// append this list style to the current paragraph style text lists
		NSMutableArray *textLists = [self.currentTag.paragraphStyle.textLists mutableCopy];
		
		if (!textLists)
		{
			textLists = [NSMutableArray array];
		}
		
		[textLists addObject:newListStyle];
		
		self.currentTag.paragraphStyle.textLists = textLists;
	};
	
	[_tagStartHandlers setObject:[listBlock copy] forKey:@"ul"];
	[_tagStartHandlers setObject:[listBlock copy] forKey:@"ol"];
	
	void (^h1Block)(void) = ^
	{
		self.currentTag.headerLevel = 1;
	};
	[_tagStartHandlers setObject:[h1Block copy] forKey:@"h1"];
	
	void (^h2Block)(void) = ^
	{
		self.currentTag.headerLevel = 2;
	};
	[_tagStartHandlers setObject:[h2Block copy] forKey:@"h2"];
	
	
	void (^h3Block)(void) = ^
	{
		self.currentTag.headerLevel = 3;
	};
	[_tagStartHandlers setObject:[h3Block copy] forKey:@"h3"];
	
	
	void (^h4Block)(void) = ^
	{
		self.currentTag.headerLevel = 4;
	};
	[_tagStartHandlers setObject:[h4Block copy] forKey:@"h4"];
	
	
	void (^h5Block)(void) = ^
	{
		self.currentTag.headerLevel = 5;
	};
	[_tagStartHandlers setObject:[h5Block copy] forKey:@"h5"];
	
	
	void (^h6Block)(void) = ^
	{
		self.currentTag.headerLevel = 6;
	};
	[_tagStartHandlers setObject:[h6Block copy] forKey:@"h6"];
	
	
	void (^fontBlock)(void) = ^
	{
		CGFloat pointSize;
		
		NSString *sizeAttribute = [self.currentTag attributeForKey:@"size"];
		
		if (sizeAttribute)
		{
			NSInteger sizeValue = [sizeAttribute intValue];
			
			switch (sizeValue)
			{
				case 1:
					pointSize = self.textScale * 10.0f;
					break;
				case 2:
					pointSize = self.textScale * 13.0f;
					break;
				case 3:
					pointSize = self.textScale * 16.0f;
					break;
				case 4:
					pointSize = self.textScale * 18.0f;
					break;
				case 5:
					pointSize = self.textScale * 24.0f;
					break;
				case 6:
					pointSize = self.textScale * 32.0f;
					break;
				case 7:
					pointSize = self.textScale * 48.0f;
					break;
				default:
					pointSize = self.defaultFontDescriptor.pointSize;
					break;
			}
		}
		else
		{
			// size is inherited
			pointSize = self.currentTag.fontDescriptor.pointSize;
		}
		
		NSString *face = [self.currentTag attributeForKey:@"face"];
		
		if (face)
		{
			// create a temp font with this face
			CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)face, pointSize, NULL);
			
			self.currentTag.fontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:font];
			
			CFRelease(font);
		}
		else
		{
			// modify inherited descriptor
			self.currentTag.fontDescriptor.pointSize = pointSize;
		}
		
		NSString *color = [self.currentTag attributeForKey:@"color"];
		
		if (color)
		{
			self.currentTag.textColor = DTColorCreateWithHTMLName(color);
		}
	};
	
	[_tagStartHandlers setObject:[fontBlock copy] forKey:@"font"];
	
	
	void (^pBlock)(void) = ^
	{
		// if have the custom headIndent
		if (self.defaultParagraphStyle.firstLineHeadIndent > 0)
		{
			self.currentTag.paragraphStyle.firstLineHeadIndent = self.currentTag.paragraphStyle.headIndent +
																		 self.defaultParagraphStyle.firstLineHeadIndent;
		}
		else
		{
			self.currentTag.paragraphStyle.firstLineHeadIndent = self.currentTag.paragraphStyle.headIndent + self.currentTag.pTextIndent;
		}
	};
	
	[_tagStartHandlers setObject:[pBlock copy] forKey:@"p"];
}

- (void)registerTagEndHandlers
{
	if (_tagEndHandlers)
	{
		return;
	}
	
	_tagEndHandlers = [[NSMutableDictionary alloc] init];
		
	void (^objectBlock)(void) = ^
	{
		if ([self.currentTag isKindOfClass:[DTTextAttachmentHTMLElement class]])
		{
			if ([self.currentTag.textAttachment isKindOfClass:[DTObjectTextAttachment class]])
			{
				DTObjectTextAttachment *objectAttachment = (DTObjectTextAttachment *)self.currentTag.textAttachment;
				
				// transfer the child nodes to the attachment
				objectAttachment.childNodes = [self.currentTag.childNodes copy];
			}
		}
	};
	
	[_tagEndHandlers setObject:[objectBlock copy] forKey:@"object"];

	void (^videoBlock)(void) = ^
	{
		if ([self.currentTag isKindOfClass:[DTTextAttachmentHTMLElement class]])
		{
			DTTextAttachmentHTMLElement *attachmentElement = (DTTextAttachmentHTMLElement *)self.currentTag;
			
			if ([attachmentElement.textAttachment isKindOfClass:[DTVideoTextAttachment class]])
			{
				DTVideoTextAttachment *videoAttachment = (DTVideoTextAttachment *)attachmentElement.textAttachment;
				
				// find first child that has a source
				if (!videoAttachment.contentURL)
				{
					for (DTHTMLElement *child in attachmentElement.childNodes)
					{
						if ([child.name isEqualToString:@"source"])
						{
							NSString *src = [child attributeForKey:@"src"];
							
							// content URL
							videoAttachment.contentURL = [NSURL URLWithString:src relativeToURL:self.baseURL];
							
							break;
						}
					}
				}
			}
		}
	};
	
	[_tagEndHandlers setObject:[videoBlock copy] forKey:@"video"];
	
	void (^styleBlock)(void) = ^
	{
		DTCSSStylesheet *localSheet = [(DTStylesheetHTMLElement *)self.currentTag stylesheet];
		[self.globalStyleSheet mergeStylesheet:localSheet];
	};
	
	[_tagEndHandlers setObject:[styleBlock copy] forKey:@"style"];
	
	
	void (^linkBlock)(void) = ^
	{
		NSString *href = [self.currentTag attributeForKey:@"href"];
		NSString *type = [[self.currentTag attributeForKey:@"type"] lowercaseString];
		
		if ([type isEqualToString:@"text/css"])
		{
			NSURL *stylesheetURL = [NSURL URLWithString:href relativeToURL:self.baseURL];
			if ([stylesheetURL isFileURL])
			{
				NSString *stylesheetContent = [NSString stringWithContentsOfURL:stylesheetURL encoding:NSUTF8StringEncoding error:nil];
				if (stylesheetContent)
				{
					DTCSSStylesheet *localSheet = [[DTCSSStylesheet alloc] initWithStyleBlock:stylesheetContent];
					[self.globalStyleSheet mergeStylesheet:localSheet];
				}
			}
			else
			{
				DTLogDebug(@"CSS link referencing a non-local target, ignored");
			}
		}
	};
	
	[ _tagEndHandlers setObject:[linkBlock copy] forKey:@"link"];
}

#pragma mark DTHTMLParser Delegate

- (void)parser:(DTHTMLParser *)parser didStartElement:(NSString *)elementName attributes:(NSDictionary *)attributeDict
{
    DTLogDebug(@"%@, %@", elementName, attributeDict);
    
	DT_WEAK_VARIABLE typeof(self) weakSelf = self;
	dispatch_group_async(_treeBuildingGroup, _treeBuildingQueue, ^{
		DTHTMLAttributedStringBuilder *strongSelf = weakSelf;

		if (strongSelf.ignoreParseEvents)
		{
			return;
		}

		DTHTMLElement *newNode = [DTHTMLElement elementWithName:elementName attributes:attributeDict options:strongSelf.options];
		DTHTMLElement *previousLastChild = nil;
		
		if (strongSelf.currentTag)
		{
			// inherit stuff
			[newNode inheritAttributesFromElement:strongSelf.currentTag];
			[newNode interpretAttributes];
			
			previousLastChild = [strongSelf.currentTag.childNodes lastObject];
			
			// add as new child of current node
			[strongSelf.currentTag addChildNode:newNode];
			
			// remember body node
			if (!strongSelf.bodyElement && [newNode.name isEqualToString:@"body"])
			{
				strongSelf.bodyElement = newNode;
			}
			
			if (strongSelf.shouldProcessCustomHTMLAttributes)
			{
				newNode.shouldProcessCustomHTMLAttributes = strongSelf.shouldProcessCustomHTMLAttributes;
			}
		}
		else
		{
			NSAssert(!strongSelf.rootNode, @"Something went wrong, second root node found in document and not ignored.");
			
			// might be first node ever
			if (!strongSelf.rootNode)
			{
				strongSelf.rootNode = newNode;
				
				[strongSelf.rootNode inheritAttributesFromElement:strongSelf.defaultTag];
				[strongSelf.rootNode interpretAttributes];
			}
		}
		
		// apply style from merged style sheet
		NSSet *matchedSelectors;
		NSDictionary *mergedStyles = [strongSelf.globalStyleSheet mergedStyleDictionaryForElement:newNode matchedSelectors:&matchedSelectors ignoreInlineStyle:strongSelf.ignoreInlineStyles];
		
		if (mergedStyles)
		{
			[newNode applyStyleDictionary:mergedStyles];
			
			// do not add the matched class names to 'class' custom attribute 
			if (matchedSelectors)
			{
				NSMutableSet *classNamesToIgnoreForCustomAttributes = [NSMutableSet set];
				
				for (NSString *oneSelector in matchedSelectors)
				{
					// class selectors have a period
					NSRange periodRange = [oneSelector rangeOfString:@"."];
					
					if (periodRange.location != NSNotFound)
					{
						NSString *className = [oneSelector substringFromIndex:periodRange.location+1];
						
						// add this to ignored classes
						[classNamesToIgnoreForCustomAttributes addObject:className];
					}
				}
				
				if ([classNamesToIgnoreForCustomAttributes count])
				{
					newNode.CSSClassNamesToIgnoreForCustomAttributes = classNamesToIgnoreForCustomAttributes;
				}
			}
		}
		
		// adding a block element eliminates previous trailing white space text node
		// because a new block starts on a new line
		if (previousLastChild && newNode.displayStyle != DTHTMLElementDisplayStyleInline)
		{
			if ([previousLastChild isKindOfClass:[DTTextHTMLElement class]])
			{
				DTTextHTMLElement *textElement = (DTTextHTMLElement *)previousLastChild;
				
				if ([[textElement text] isIgnorableWhitespace])
				{
					[strongSelf.currentTag removeChildNode:textElement];
				}
			}
		}
		
		strongSelf.currentTag = newNode;
		
		// find block to execute for this tag if any
		void (^tagBlock)(void) = [strongSelf.tagStartHandlers objectForKey:elementName];
		
		if (tagBlock)
		{
			tagBlock();
		}
	});
}

- (void)parser:(DTHTMLParser *)parser didEndElement:(NSString *)elementName
{
    DTLogDebug(@"%@", elementName);
	DT_WEAK_VARIABLE typeof(self) weakSelf = self;
	dispatch_group_async(_treeBuildingGroup, _treeBuildingQueue, ^{
		@autoreleasepool {
			DTHTMLAttributedStringBuilder *strongSelf = weakSelf;
			if (strongSelf.ignoreParseEvents)
			{
				return;
			}
			
			// output the element if it is direct descendant of body tag, or close of body in case there are direct text nodes
			
			// find block to execute for this tag if any
			void (^tagBlock)(void) = [strongSelf.tagEndHandlers objectForKey:elementName];
			
			if (tagBlock)
			{
				tagBlock();
			}
			
			if (strongSelf.currentTag.displayStyle != DTHTMLElementDisplayStyleNone)
			{
				if (strongSelf.currentTag == strongSelf.bodyElement || strongSelf.currentTag.parentElement == strongSelf.bodyElement)
				{
					DTHTMLElement *theTag = strongSelf.currentTag;
					
					dispatch_group_async(strongSelf.stringAssemblyGroup, strongSelf.stringAssemblyQueue, ^{
						// has children that have not been output yet
						if ([theTag needsOutput])
						{
							// caller gets opportunity to modify tag before it is written
							if (strongSelf.willFlushCallback)
							{
								strongSelf.willFlushCallback(theTag);
							}
							
							NSAttributedString *nodeString = [theTag attributedString];
							
							if (nodeString)
							{
								// if this is a block element then we need a paragraph break before it
								if (theTag.displayStyle != DTHTMLElementDisplayStyleInline)
								{
									if ([strongSelf.tmpString length] && ![[strongSelf.tmpString string] hasSuffix:@"\n"])
									{
										// trim off whitespace
										while ([[strongSelf.tmpString string] hasSuffixCharacterFromSet:[NSCharacterSet ignorableWhitespaceCharacterSet]])
										{
											[strongSelf.tmpString deleteCharactersInRange:NSMakeRange([strongSelf.tmpString length]-1, 1)];
										}
										
										[strongSelf.tmpString appendString:@"\n"];
									}
								}
								
								[strongSelf.tmpString appendAttributedString:nodeString];
								theTag.didOutput = YES;
								
								if (!strongSelf.shouldKeepDocumentNodeTree)
								{
									// we don't need the children any more
									[theTag removeAllChildNodes];
								}
							}
							
						}
					});
				}
				
			}
			
			while (![strongSelf.currentTag.name isEqualToString:elementName])
			{
				// missing end of element, attempt to recover
				strongSelf.currentTag = [strongSelf.currentTag parentElement];
			}
			
			// closing the root node, ignore everything afterwards
			if (strongSelf.currentTag == strongSelf.rootNode)
			{
				strongSelf.ignoreParseEvents = YES;
			}
			
			// go back up a level
			strongSelf.currentTag = [strongSelf.currentTag parentElement];
		}
	});
}

- (void)parser:(DTHTMLParser *)parser foundCharacters:(NSString *)string
{
    DTLogDebug(@"%@", string);
	DT_WEAK_VARIABLE typeof(self) weakSelf = self;
	dispatch_group_async(_treeBuildingGroup, _treeBuildingQueue, ^{
		DTHTMLAttributedStringBuilder *strongSelf = weakSelf;
		if (strongSelf.ignoreParseEvents)
		{
			return;
		}
		
		NSAssert(strongSelf.currentTag, @"Cannot add text node without a current node");
		
		if (!strongSelf.currentTag.preserveNewlines && [string isIgnorableWhitespace])
		{
			// ignore whitespace as first element of block element
			if (strongSelf.currentTag.displayStyle!=DTHTMLElementDisplayStyleInline && ![strongSelf.currentTag.childNodes count])
			{
				return;
			}
			
			// ignore whitespace following a block element
			DTHTMLElement *previousTag = [strongSelf.currentTag.childNodes lastObject];
			
			if (previousTag.displayStyle != DTHTMLElementDisplayStyleInline)
			{
				return;
			}
			
			// ignore whitespace following a BR
			if ([previousTag isKindOfClass:[DTBreakHTMLElement class]])
			{
				return;
			}
		}
		
		// adds a text node to the current node
		DTTextHTMLElement *textNode = [[DTTextHTMLElement alloc] init];
		textNode.text = string;
		
		[textNode inheritAttributesFromElement:strongSelf.currentTag];
		[textNode interpretAttributes];
		
		// save it for later output
		[strongSelf.currentTag addChildNode:textNode];
		
		DTHTMLElement *theTag = strongSelf.currentTag;
		
		// text directly contained in body needs to be output right away
		if (theTag == strongSelf.bodyElement)
		{
			dispatch_group_async(strongSelf.stringAssemblyGroup, strongSelf.stringAssemblyQueue, ^{
				[strongSelf.tmpString appendAttributedString:[textNode attributedString]];
				theTag.didOutput = YES;
			});
			
			// only add it to current tag if we need it
			if (strongSelf.shouldKeepDocumentNodeTree)
			{
				[theTag addChildNode:textNode];
			}
			
			return;
		}
		
	});
}

- (void)parser:(DTHTMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	DT_WEAK_VARIABLE typeof(self) weakSelf = self;
	dispatch_group_async(_treeBuildingGroup, _treeBuildingQueue, ^{
		DTHTMLAttributedStringBuilder *strongSelf = weakSelf;
		
		if (strongSelf.ignoreParseEvents)
		{
			return;
		}
		
		NSAssert(strongSelf.currentTag, @"Cannot add text node without a current node");
		
		NSString *styleBlock = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
		
		// adds a text node to the current node
		DTHTMLParserTextNode *textNode = [[DTHTMLParserTextNode alloc] initWithCharacters:styleBlock];
		
		[strongSelf.currentTag addChildNode:textNode];
	});
}

- (void)parserDidEndDocument:(DTHTMLParser *)parser
{
	DT_WEAK_VARIABLE typeof(self) weakSelf = self;
	dispatch_group_async(_treeBuildingGroup, _treeBuildingQueue, ^{
		DTHTMLAttributedStringBuilder *strongSelf = weakSelf;
		
		NSAssert(!strongSelf.currentTag, @"Something went wrong, at end of document there is still an open node");

		if (!strongSelf.preserverDocumentTrailingSpaces) {
			dispatch_group_async(strongSelf.stringAssemblyGroup, strongSelf.stringAssemblyQueue, ^{
				// trim off white space at end
				while ([[strongSelf.tmpString string] hasSuffixCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]])
				{
					[strongSelf.tmpString deleteCharactersInRange:NSMakeRange([strongSelf.tmpString length]-1, 1)];
				}
			});
		}
	});
}

- (void)parser:(DTHTMLParser *)parser parseErrorOccurred:(NSError *)parseError;
{
	if(_parseErrorCallback)
	{
		_parseErrorCallback(_tmpString,parseError);
	}
}
			  
- (void)abortParsing
{
	[_parser abortParsing];
}

@end
