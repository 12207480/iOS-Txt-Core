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

- (void)loadText:(NSURL *)text;
- (void)closeDocument;
- (BOOL)shouldAutorotate;

@end
