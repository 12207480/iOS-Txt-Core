//
//  UIColor+PCColor.h
//  PCReaderDemo
//
//  Created by Zheng on 15/8/5.
//  Copyright © 2015年 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PCColor)

+ (UIColor *)colorWithHex:(NSString *)hexValue
                   alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHex:(NSString *)hexValue;
+ (NSString *)hexFromUIColor:(UIColor *)color;

@end
