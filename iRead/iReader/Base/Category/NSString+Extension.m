//
//  NSString+Extension.m
//  iReader
//
//  Created by zouzhiyong on 2017/12/7.
//  Copyright © 2017年 zouzhiyong. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (IR_URLDecode)

- (NSDictionary *)decodeUrlParameters
{
    return [self decodeUrlParametersWithKeyLowercase:NO valueDecode:YES];
}

- (NSDictionary *)decodeUrlParametersWithKeyLowercase:(BOOL)lowercase valueDecode:(BOOL)decode
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray<NSString *> *urlComponents = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":/?&"]];
    
    for (NSString *strItem in urlComponents) {
        NSArray *itemComponents = [strItem componentsSeparatedByString:@"="];
        NSString *key = [itemComponents count] > 0 ? itemComponents[0] : @"";
        NSString *value = [itemComponents count] > 1 ? itemComponents[1] : @"";
        if (key && key.length && value && value.length){
            
            if (lowercase) {
                key = [key lowercaseString];
            }
            
            if (decode) {
                value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
            if (value) {
                [dict setObject:value forKey:key];
            }
        }
    }
    
    return dict;
}

@end


@implementation NSString (IR_AttributedString)

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize
{
    return [self attributedStringWithFontSize:fontSize textColor:[UIColor blackColor]];
}

- (NSAttributedString *)attributedStringWithFontSize:(CGFloat)fontSize textColor:(UIColor *)color
{
    if (!self.length) {
        return nil;
    }

    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : [UIColor blackColor],
                                 NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                 };
    
    return [[NSMutableAttributedString alloc] initWithString:self attributes:attributes];
}

@end
