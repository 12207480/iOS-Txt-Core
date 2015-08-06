//
//  PCCollectViewModel.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/17.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPageData.h"

@interface PCCollectViewModel : NSObject<UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) PCPageData *data;
@property (nonatomic, strong) NSDictionary *attributes;

@end
