//
//  PCModelViewController.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCDataViewController.h"
#import "PCReaderViewController.h"

#define kAdjustFontNotification     @"kAdjustFontNotification"

@interface PCModelViewController : NSObject<UIPageViewControllerDataSource>

@property (weak, nonatomic) PCReaderViewController *readerController;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSArray *pageData;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *attributes;

- (PCDataViewController *)viewControllerAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfViewController:(PCDataViewController *)viewController;

@end
