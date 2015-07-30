//
//  PCReaderViewController.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCCollectViewModel.h"
#import "PCFontAdjustView.h"
#import "PCGlobalModel.h"

@interface PCReaderViewController : UIViewController <UIPageViewControllerDelegate, PCFontAdjustViewDelegate>

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)loadText:(NSString *)text;

@end
