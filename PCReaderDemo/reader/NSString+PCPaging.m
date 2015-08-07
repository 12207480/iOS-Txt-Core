//
//  NSString+PCPaging.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "NSString+PCPaging.h"
#import "PCConfig.h"
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@implementation NSString (PCPaging)

+ (CGFloat)heightForAttributedString:(NSAttributedString *)attrString forWidth:(CGFloat)inWidth
{
    CGFloat H = 0;
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (CFMutableAttributedStringRef) attrString);
    
    CGRect box = CGRectMake(0,0, inWidth, CGFLOAT_MAX);
    
    CFIndex startIndex = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, box);
    
    // Create a frame for this column and draw it.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    
    // Start the next frame at the first character not visible in this frame.
    //CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    //startIndex += frameRange.length;
    
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex j = 0, lineCount = CFArrayGetCount(lineArray);
    CGFloat h, ascent, descent, leading;
    
    for (j=0; j < lineCount; j++)
    {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, j);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        h = ascent + descent + leading;
        H+=h;
    }
    
    if (frame) CFRelease(frame);
    if (path) CFRelease(path);
    if (framesetter) CFRelease(framesetter);
    
    return H;
}

/**
 * @abstract 根据指定的大小，对字符串进行分页，计算出每页显示的字符串区间 (NSRange)
 *
 * @param attributes 分页所需的字符串样式，需要指定字体大小，行间距等。iOS 6 以上请参见 UIKit 中 NSAttributedString 的扩展，iOS 6 以下请参考 CoreText 中的 CTStringAttributes.h
 * @param size 需要参考的 size。即在 size 区域内
 */
- (PCPageData *)paginationWithAttributes:(NSDictionary *)attributes
                       constrainedToSize:(CGSize)size
                                   range:(NSRange)range
                           allowRelocate:(BOOL)shouldRelocate {
    PCPageData *resultRange = [[PCPageData alloc] init];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // 构造 NSAttributedString
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    resultRange.totalBytes = attributedString.length;
    
    // 最小规模
    NSInteger minScale = range.location - range.length;
    
    // 最大规模
    NSInteger maxScale = ((range.location + range.length) > resultRange.totalBytes) ? resultRange.totalBytes : (range.location + range.length);
    
    NSInteger rangeIndex;
    
    // 采样
    unsigned long length = 0;
    const char indentChars[4] = { 0xe3, 0x80, 0x80, 0x00 };
    NSMutableString *test_str = [NSMutableString string];
    NSUInteger times = 0;
    CFRange frameRange;
    NSString *indentStr = [[NSString alloc] initWithBytes:indentChars length:3 encoding:NSUTF8StringEncoding];
    NSAttributedString *childString = nil;
    CTFramesetterRef childFramesetter;
    UIBezierPath *bezierPath = nil;
    CTFrameRef frame;
    do {
        for (int i = 0; i < 300; i++, times++) {
            [test_str appendString:indentStr];
        }
        
        childString = [[NSAttributedString alloc] initWithString:test_str attributes:attributes];
        
        childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
        frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
        
        frameRange = CTFrameGetVisibleStringRange(frame);
        if (frame) CFRelease(frame);
        if (childFramesetter) CFRelease(childFramesetter);
    } while (frameRange.length >= times);
    
    NSUInteger minEach = frameRange.length;
// TODO: 向前渲染并不准确，一般情况下，采用向后渲染并重新定位 Offset 的方式
//#warning If we created a CTFrameSetter with an attributed string, then we created a CTFrame with a bezier path, but how to get visible string range from the end to the beginning of the attributed string?
//#warning Now we should just look at this silly, ugly algorithm. Just for fun. (i_82)
//    if (!shouldRelocate) {
        // 向前渲染
//        do {
//            length = MIN(minEach, maxScale - rangeIndex);
//            NSInteger startPos = rangeIndex - length;
//            NSInteger len = length;
//            
//            while (1) {
//                startPos = ((int)startPos < 0) ? 0 : startPos;
//                childString = [attributedString attributedSubstringFromRange:NSMakeRange(startPos, length)];
//                childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)childString);
//                bezierPath = [UIBezierPath bezierPathWithRect:rect];
//                frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
//                frameRange = CTFrameGetVisibleStringRange(frame);
//                if (frame) CFRelease(frame);
//                if (childFramesetter) CFRelease(childFramesetter);
//                if (startPos + frameRange.length < rangeIndex) {
//                    startPos += (int)(len / 2);
//                    len /= 2;
//                } else if (startPos + frameRange.length > rangeIndex) {
//                    startPos -= (int)(len / 2);
//                    len /= 2;
//                } else {
//                    break;
//                }
//                if (len <= 0) {
//                    break;
//                }
//            }
//            if (frameRange.length > 0) {
//                [resultRange.cachedPagination setObject:@(frameRange.length) forKey:@(startPos)];
//            }
//            if (startPos <= 0) {
//                break;
//            }
//            rangeIndex = startPos;
//        } while (rangeIndex > minScale);
//    }
    
    if (shouldRelocate) {
        if (minScale < 0) {
            rangeIndex = 0;
        } else {
            rangeIndex = range.location - range.length;
        }
    } else {
        rangeIndex = range.location;
    }
    
    // 向后渲染
    do {
        length = MIN(minEach, maxScale - rangeIndex);
        childString = [attributedString attributedSubstringFromRange:NSMakeRange(rangeIndex, length)];
        
        childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
        bezierPath = [UIBezierPath bezierPathWithRect:rect];
        frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
        
        frameRange = CTFrameGetVisibleStringRange(frame);
        NSRange r = {rangeIndex, frameRange.length};
        
        if (r.length > 0) {
            [resultRange.cachedSort addObject:@(r.location)];
            [resultRange.cachedPagination setObject:@(r.length) forKey:@(r.location)];
            if (shouldRelocate) {
                // 预定初始位置是否在该区间之内
                if (rangeIndex <= range.location && rangeIndex + r.length > range.location) {
                    resultRange.relocatedOffset = rangeIndex;
                    resultRange.relocatedRange = r;
                }
            } else {
                if (rangeIndex == range.location) {
                    resultRange.relocatedOffset = rangeIndex;
                    resultRange.relocatedRange = r;
                }
            }
        }
        
        rangeIndex += r.length;
        if (frame) CFRelease(frame);
        if (childFramesetter) CFRelease(childFramesetter);
    } while (rangeIndex < maxScale);
    
    return resultRange;
}

- (NSString *)halfWidthToFullWidth
{
    //半角转全角
    NSMutableString *convertedString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformHiraganaKatakana, false);
    return [convertedString copy];
}

- (NSString *)filterBlankAndBlankLines
{ // 过滤空行与自动缩进
    NSString *addStr;
    if ([PCConfig shareModel].autoIndent) {
        addStr = @"\n　　";
    } else {
        addStr = @"\n";
    }
    NSMutableString *Mstr = [NSMutableString string];
    NSArray *arr = [self componentsSeparatedByString:@"\n"];
    NSString *tempStr;
    for (int i = 0; i < arr.count; i++) {
        tempStr = [(NSString *)arr[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (tempStr.length != 0) {
            [Mstr appendString:tempStr];
            [Mstr appendString:addStr];
        }
    }
    return Mstr;
}

@end
