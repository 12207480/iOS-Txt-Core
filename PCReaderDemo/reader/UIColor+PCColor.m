//
//  UIColor+PCColor.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/5.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import "UIColor+PCColor.h"

@implementation UIColor (PCColor)

+ (UIColor*)colorWithHex:(NSString *)hexValue
                   alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((strtoul([hexValue UTF8String], 0, 16) & 0xFF0000) >> 16))/255.0
                           green:((float)((strtoul([hexValue UTF8String], 0, 16) & 0xFF00) >> 8))/255.0
                            blue:((float)(strtoul([hexValue UTF8String], 0, 16) & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*)colorWithHex:(NSString *)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

+ (NSString *)hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

@end
