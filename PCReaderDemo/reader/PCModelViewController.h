//
//  PCModelViewController.h
//  PCReaderDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPageData.h"
#import "PCDataViewController.h"
#import "PCReaderViewController.h"

#define kAdjustFontNotification     @"kAdjustFontNotification"

@interface PCModelViewController : NSObject <UIPageViewControllerDataSource>

@property (weak, nonatomic) PCReaderViewController *readerController;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) PCPageData *pageData;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *attributes;

- (PCDataViewController *)viewControllerAtOffset:(NSUInteger)offset;

- (NSInteger)offsetOfViewController:(PCDataViewController *)viewController;

@end
