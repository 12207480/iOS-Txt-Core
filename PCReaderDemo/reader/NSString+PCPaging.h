//
//  NSString+PCPaging.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/10.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (PCPaging)

- (NSArray *)paginationWithAttributes:(NSDictionary *)attributes constrainedToSize:(CGSize)size range:(NSRange)range;

- (NSString *)halfWidthToFullWidth;

@end
