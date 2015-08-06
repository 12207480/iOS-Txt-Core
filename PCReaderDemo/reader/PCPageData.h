//
//  PCPageData.h
//  PCReaderDemo
//
//  Created by Zheng on 15/7/30.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCPageData : NSObject

@property (nonatomic) NSUInteger totalBytes;
@property (nonatomic) NSInteger relocatedOffset;
@property (nonatomic, strong) NSMutableDictionary *cachedPagination;
@property (nonatomic, strong) NSMutableArray *cachedSort;

- (NSInteger)getLengthByOffset:(NSInteger)offset;
- (NSInteger)offsetBeforeOffset:(NSInteger)offset;
- (NSInteger)offsetAfterOffset:(NSInteger)offset;

@end
