//
//  PCReaderViewController.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "PCFileHandler.h"
#import "PCFontAdjustView.h"
#import "PCGlobalModel.h"

@class PCReaderViewController;

@protocol PCReaderViewControllerDelegate <NSObject>

@optional // Delegate protocols

- (void)didFinishLoadingPCReader:(PCReaderViewController *)viewController;
- (void)didFatalLoadingPCReaderWithError:(NSError *)error;
- (void)dismissPCReaderViewController:(PCReaderViewController *)viewController;

@end

@interface PCReaderViewController : UIViewController <UIPageViewControllerDelegate, PCFontAdjustViewDelegate, PCFileHandlerDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) PCFileHandler *fileHandler;
@property (nonatomic) id <PCReaderViewControllerDelegate> delegate;

// 直接定位到某位置
- (void)jumpToOffset:(NSInteger)offset;
// 重新加载页面设置，如翻页方式，翻页方向
- (void)reloadPageConfig;
- (void)loadText:(NSURL *)text;
- (void)closeDocument;

@end
