//
//  PCPageView.m
//  PCPageDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "PCPageView.h"
#import <CoreText/CoreText.h>

@implementation PCPageView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the coordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Create Path
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    
    CTFramesetterRef childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedText);
    CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, _attributedText.length), path, NULL);
    
    CTFrameDraw(frame, context);
    if (frame) CFRelease(frame);
    if (path) CFRelease(path);
    if (childFramesetter) CFRelease(childFramesetter);
}

@end
