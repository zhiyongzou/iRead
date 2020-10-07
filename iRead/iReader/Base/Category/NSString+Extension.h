//
//  NSString+Extension.h
//  iReader
//
//  Created by zouzhiyong on 2017/12/7.
//  Copyright © 2017年 zouzhiyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (IR_URLDecode)

/**
 lowercase 是否需要对key转成小写,默认 NO
 decode 是否对value进行百分号解码，默认 YES
 */
- (NSDictionary *)decodeUrlParameters;

/**
 获取URL参数列表，以字典形式返回
 NOTE:如果value里面包含 ":/=" 字符，请将其进行百分号编码，例如：http://test.com/?shareTitle=abc&shareUrl=http://share.com/ -> http://test.com/?shareTitle=abc&shareUrl=http%3a%2f%2fshare.com%2f
 
 @param lowercase 是否需要对key转成小写
 @param decode 是否对value进行百分号解码
 @return NSDictionary<string*, string*>
 */
- (NSDictionary *)decodeUrlParametersWithKeyLowercase:(BOOL)lowercase valueDecode:(BOOL)decode;

@end

@interface NSString (IR_AttributedString)

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize;

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize textColor:(UIColor *)color;

@end
