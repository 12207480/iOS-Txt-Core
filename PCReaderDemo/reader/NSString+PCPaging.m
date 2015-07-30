//
//  NSString+PCPaging.m
//  PCReaderDemo
//
//  Created by Zheng on 15/3/10.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "NSString+PCPaging.h"
#import <CoreText/CoreText.h>

@implementation NSString (PCPaging)

/**
 * @abstract 根据指定的大小，对字符串进行分页，计算出每页显示的字符串区间 (NSRange)
 *
 * @param attributes 分页所需的字符串样式，需要指定字体大小，行间距等。iOS 6 以上请参见 UIKit 中 NSAttributedString 的扩展，iOS 6 以下请参考 CoreText 中的 CTStringAttributes.h
 * @param size 需要参考的 size。即在 size 区域内
 */
- (NSArray *)paginationWithAttributes:(NSDictionary *)attributes constrainedToSize:(CGSize)size range:(NSRange)range {
    NSMutableArray * resultRange = [NSMutableArray arrayWithCapacity:5];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 构造 NSAttributedString
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    // 以下方法耗时 基本在 0.5s 以内
    NSDate * date = [NSDate date];
    NSInteger rangeIndex = range.location;
    do {
        unsigned long length = MIN(750, range.length - rangeIndex);
        NSAttributedString *childString = [attributedString attributedSubstringFromRange:NSMakeRange(rangeIndex, length)];
        
        CTFramesetterRef childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];
        CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
        
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange r = {rangeIndex, frameRange.length};
        
        if (r.length > 0) {
            [resultRange addObject:NSStringFromRange(r)];
        }
        rangeIndex += r.length;
        CFRelease(frame);
        CFRelease(childFramesetter);
    } while (rangeIndex < range.length && range.length > 0);
    NSTimeInterval millionSecond = [[NSDate date] timeIntervalSinceDate:date];
    NSLog(@"Time used: %@", [NSString stringWithFormat:@"%lf", millionSecond]);
    return resultRange;
}

- (NSString *)halfWidthToFullWidth
{
    //半角转全角
    NSMutableString *convertedString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformHiraganaKatakana, false);
    return [convertedString copy];
}

@end
