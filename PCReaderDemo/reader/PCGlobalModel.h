//
//  PCGlobalModel.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/17.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "PCPageData.h"
#import "PCConfig.h"
#import <UIKit/UIKit.h>

static NSString *kUpdatePageNotification = @"kUpdatePageNotification";

@interface PCGlobalModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) PCPageData *rangeData;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic) CGSize area;
@property (nonatomic) NSInteger currentOffset;
@property (nonatomic) NSRange currentRange;

+ (instancetype)shareModel;
// 从某处开始缓存分页，直接定位请允许重定位 (allowRelocate = YES)
- (PCPageData *)reloadPaginationByOffset:(NSInteger)offset
                           allowRelocate:(BOOL)shouldRelocate;
- (void)loadText:(NSString *)text
      completion:(void(^)(void))completion;
- (void)updateFontCompletion:(void(^)(void))completion;
- (void)clear;
- (void)updateArea;

@end
