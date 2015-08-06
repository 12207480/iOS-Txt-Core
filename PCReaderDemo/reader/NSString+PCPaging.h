//
//  NSString+PCPaging.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/10.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPageData.h"

@interface NSString (PCPaging)

+ (CGFloat)heightForAttributedString:(NSAttributedString *)attrString forWidth:(CGFloat)inWidth;

- (PCPageData *)paginationWithAttributes:(NSDictionary *)attributes
                       constrainedToSize:(CGSize)size
                                   range:(NSRange)range
                           allowRelocate:(BOOL)shouldRelocate;

- (NSString *)halfWidthToFullWidth;

- (NSString *)filterBlankAndBlankLines;

@end
