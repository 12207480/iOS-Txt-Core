//
//  PCPageCell.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/17.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPageView.h"

static NSString *PageCellIdentifier = @"PageCellIdentifier";

@interface PCPageCell : UICollectionViewCell

@property (nonatomic, strong) PCPageView *pageView;

@end
