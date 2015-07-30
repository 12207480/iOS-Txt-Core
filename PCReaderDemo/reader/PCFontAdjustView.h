//
//  PCFontAdjustView.h
//  PCReaderDemo
//
//  Created by Zheng on 15/7/30.
//  Copyright © 2015年 com.duowan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCFontAdjustViewDelegate <NSObject>
- (void)adjustRangeArrayForText;
@end

@interface PCFontAdjustView : UIView

@property (nonatomic, weak) id <PCFontAdjustViewDelegate> delegate;

@property (nonatomic, strong) UIButton *plusButton;
@property (nonatomic, strong) UIButton *minusButton;

@end
