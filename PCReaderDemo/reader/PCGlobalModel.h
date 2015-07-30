//
//  PCGlobalModel.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/17.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *kUpdatePageNotification = @"kUpdatePageNotification";

@interface PCGlobalModel : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSMutableArray *rangeArray;
@property (nonatomic, strong) NSDictionary *attributes;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) NSInteger currentOffset;
@property (nonatomic) NSRange currentRange;

+ (instancetype)shareModel;

- (void)loadText:(NSString *)text completion:(void(^)(void))completion;

- (void)updateFontCompletion:(void(^)(void))completion;

@end
