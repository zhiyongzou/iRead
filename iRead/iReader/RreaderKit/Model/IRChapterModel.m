//
//  IRChapterModel.m
//  iReader
//
//  Created by zzyong on 2018/7/25.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRChapterModel.h"
#import "IRPageModel.h"
#import "NSString+Extension.h"
#import "IRReaderConfig.h"
#import "IRTocRefrence.h"
#import "IRResource.h"
#import "NSAttributedString+HTML.h"
#import "DTCoreTextLayouter.h"
#import "DTCoreTextConstants.h"
#import "DTCoreTextParagraphStyle.h"
#import "DTCoreTextLayoutLine.h"
#import "DTCoreTextGlyphRun.h"

@interface IRChapterModel ()

@property (nonatomic, strong) UIColor *textColor;

@end

@implementation IRChapterModel

- (instancetype)init
{
    if (self = [super init]) {
        self.textColor = IR_READER_CONFIG.readerTextColor;
    }
    
    return self;
}

+ (instancetype)modelWithTocRefrence:(IRTocRefrence *)tocRefrence chapterIndex:(NSUInteger)chapterIndex
{
    IRChapterModel *chapter = [[self alloc] init];
    chapter.title = tocRefrence.title;
    chapter.chapterIndex = chapterIndex;
    NSURL *baseUrl = [[NSURL alloc] initFileURLWithPath:tocRefrence.resource.fullHref];
    NSData *htmlData = [NSData dataWithContentsOfURL:baseUrl];

    NSDictionary *options = @{
                              NSBaseURLDocumentOption            : baseUrl,
                              NSTextSizeMultiplierDocumentOption : @(IR_READER_CONFIG.textSizeMultiplier),
                              DTDefaultFontName   : IR_READER_CONFIG.fontName,
                              DTDefaultLinkColor  : @"purple",
                              DTDefaultTextColor  : chapter.textColor,
                              DTDefaultFontSize   : @(IR_READER_CONFIG.textDefaultFontSize),
                              DTMaxImageSize      : [NSValue valueWithCGSize:[IR_READER_CONFIG pageSize]]
                            };
    
    NSMutableAttributedString *htmlString = [[[NSAttributedString alloc] initWithHTMLData:htmlData options:options documentAttributes:nil] mutableCopy];
    [htmlString addAttribute:NSParagraphStyleAttributeName
                       value:[self customParagraphStyleWithFirstLineHeadIndent:YES alignment:NSTextAlignmentJustified]
                       range:NSMakeRange(0, htmlString.length)];
    
    DTCoreTextLayouter *textLayout = [[DTCoreTextLayouter alloc] initWithAttributedString:htmlString];
    CGRect rect = CGRectMake(0, 0, [IR_READER_CONFIG pageSize].width, [IR_READER_CONFIG pageSize].height);
    DTCoreTextLayoutFrame *layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(0, htmlString.length)];
    
    NSString *title = nil;
    NSAttributedString *paragraph = nil;
    NSRange titleRange = NSMakeRange(0, 0);
    for (NSValue *rangeValue in layoutFrame.paragraphRanges) {
        
        paragraph = [htmlString attributedSubstringFromRange:rangeValue.rangeValue];
        
        if (!title.length) {
            title = [[paragraph.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
            if (title.length) {
                titleRange = rangeValue.rangeValue;
                break;
            }
        }
    }
    
    IRDebugLog(@"First paragraph string: %@ chapter title: %@", title, chapter.title);
    if ([title isEqualToString:[chapter.title lowercaseString]]) {
        [htmlString addAttribute:NSParagraphStyleAttributeName
                           value:[self customParagraphStyleWithFirstLineHeadIndent:NO alignment:NSTextAlignmentCenter]
                           range:titleRange];
    }
    
    [layoutFrame.lines enumerateObjectsUsingBlock:^(DTCoreTextLayoutLine  *_Nonnull line, NSUInteger idx, BOOL * _Nonnull stop) {
        if (line.attachments.count) {
            [htmlString addAttribute:NSParagraphStyleAttributeName
                               value:[self customParagraphStyleWithFirstLineHeadIndent:NO alignment:NSTextAlignmentJustified]
                               range:line.stringRange];
        }
    }];
    
    NSRange visibleRange = layoutFrame.visibleStringRange;
    CGFloat pageOffset = visibleRange.location + visibleRange.length;
    NSUInteger pageCount = 1;
    NSMutableArray *pages = [[NSMutableArray alloc] init];
    
    while (pageOffset <= htmlString.length && pageOffset != 0) {
        
        IRPageModel *pageModel = [IRPageModel modelWithPageIdx:pageCount - 1 chapterIdx:chapterIndex];
        pageModel.isParsed = YES;
        pageModel.content = [htmlString attributedSubstringFromRange:visibleRange];
        
        __block BOOL nextPageNeedFirstLineHeadIndent = YES;
        [layoutFrame.paragraphRanges enumerateObjectsUsingBlock:^(NSValue  *_Nonnull rangeValue, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [rangeValue rangeValue];
            if (pageOffset > range.location && pageOffset < (range.location + range.length)) {
                nextPageNeedFirstLineHeadIndent = NO;
            }
        }];
        
        layoutFrame = [textLayout layoutFrameWithRect:rect range:NSMakeRange(pageOffset, htmlString.length - pageOffset)];
        if (!nextPageNeedFirstLineHeadIndent) {
            DTCoreTextLayoutLine *firstLine = layoutFrame.lines.firstObject;
            [htmlString addAttribute:NSParagraphStyleAttributeName
                               value:[self customParagraphStyleWithFirstLineHeadIndent:NO alignment:NSTextAlignmentJustified]
                               range:firstLine.stringRange];
            nextPageNeedFirstLineHeadIndent = YES;
        }
        
        
        visibleRange = layoutFrame.visibleStringRange;
        if (visibleRange.location == NSNotFound) {
            pageOffset = 0;
        } else {
            pageOffset = visibleRange.location + visibleRange.length;
        }
        
        pageCount++;
        if ([pageModel.content.string isEqualToString:@"\n"]) {
            continue;
        }
        
        [pages addObject:pageModel];
    }
    
    chapter.pages = pages;
    chapter.pageCount = pageCount;
    
    return chapter;
}

+ (NSMutableParagraphStyle *)customParagraphStyleWithFirstLineHeadIndent:(BOOL)need alignment:(NSTextAlignment)alignment
{
    NSMutableParagraphStyle *customStyle = [[NSMutableParagraphStyle alloc] init];
    customStyle.lineSpacing = IR_READER_CONFIG.lineSpacing;
    customStyle.paragraphSpacing = IR_READER_CONFIG.paragraphSpacing;
    customStyle.lineHeightMultiple = 2;
    customStyle.alignment = alignment;
    customStyle.firstLineHeadIndent = need ? IR_READER_CONFIG.firstLineHeadIndent : 0;
    
    return customStyle;
}

@end
