//
//  UIColor+Dogo.m
//  Dogo
//
//  Created by Marsal on 06/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "UIColor+Dogo.h"

@implementation UIColor (Dogo)

#pragma mark - Utils

//! convert a hex string into RGB values and return a color with these values
+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
//    NSLog(@"[%@][%@] red:%f, green:%f, blue: %f, alpha: %f", [self class], NSStringFromSelector(_cmd), red, green, blue, alpha);
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - Custom Colors

+ (UIColor *) backgroundNavigationColor
{
    // Deep Orange 400 from Google Color Palette
    return [UIColor colorFromHexString:@"#FF7043"];
}

+ (UIColor *) backgroundCellUnreadColor
{
    return [UIColor whiteColor];
}

+ (UIColor *) backgroundCellReadColor
{
    // Orange 50 from Google Color Palette
    return [self colorFromHexString:@"#FFF3E0"];
}

+ (UIColor *)defaultFontColor
{
    return [self colorFromHexString:@"#222222"];
}

@end