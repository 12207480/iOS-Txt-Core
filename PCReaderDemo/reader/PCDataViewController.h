//
//  PCDataViewController.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPageView.h"

@interface PCDataViewController : UIViewController

@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic) PCPageView *pageView;
@property (strong, nonatomic) UILabel *displayNameLabel;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *batteryLabel;

@property (nonatomic) NSInteger currentOffset;
@property (nonatomic) NSInteger totalBytes;

@end
