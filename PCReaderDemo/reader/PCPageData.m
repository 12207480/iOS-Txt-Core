//
//  PCPageData.m
//  PCReaderDemo
//
//  Created by Zheng on 15/7/30.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import "PCPageData.h"
#import <UIKit/UIKit.h>

@implementation PCPageData

- (instancetype) init {
    if (self = [super init]) {
        _cachedPagination = [[NSMutableDictionary alloc] init];
        _cachedSort = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSInteger)getLengthByOffset:(NSInteger)offset {
    if (offset >= _totalBytes) {
        return -1;
    }
    NSNumber *key = [NSNumber numberWithInteger:offset];
    if ([[_cachedPagination allKeys] containsObject:key]) {
        id result = [_cachedPagination objectForKey:key];
        if ([result isKindOfClass:[NSNumber class]]) {
            return [result integerValue];
        }
    }
    return -1;
}

- (NSInteger)offsetBeforeOffset:(NSInteger)offset {
    for (int i = 0; i <= [_cachedSort count] - 1; i++) {
        if ([[_cachedSort objectAtIndex:i] integerValue] == offset) {
            if (i != 0) {
                i--;
                NSInteger newoffset = [[_cachedSort objectAtIndex:i] integerValue];
                if (i == 0 && newoffset != 0) {
                    return -1;
                }
                return newoffset;
            }
        }
    }
    return -1;
}

- (NSInteger)offsetAfterOffset:(NSInteger)offset {
    NSInteger total = [_cachedSort count] - 1;
    for (int i = (int)total; i >= 0; i--) {
        if ([[_cachedSort objectAtIndex:i] integerValue] == offset) {
            if (i != (int)total) {
                i++;
                if (i == (int)total) {
                    return -1;
                }
                return [[_cachedSort objectAtIndex:i] integerValue];
            }
        }
    }
    return -1;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    PCPageData *copy = [[[self class] allocWithZone:zone] init];
    copy->_relocatedOffset = _relocatedOffset;
    copy->_relocatedRange = _relocatedRange;
    copy->_totalBytes = _totalBytes;
    copy->_cachedPagination = [_cachedPagination mutableCopy];
    copy->_cachedSort = [_cachedSort mutableCopy];
    return copy;
}

@end
