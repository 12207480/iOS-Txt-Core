//
//  PCFontAdjustView.m
//  PCReaderDemo
//
//  Created by Zheng on 15/7/30.
//  Copyright © 2015年 com.duowan. All rights reserved.
//

#import "PCFontAdjustView.h"
#import "PCGlobalModel.h"

@implementation PCFontAdjustView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.plusButton];
        [self addSubview:self.minusButton];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_plusButton, _minusButton);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_plusButton(44)]-10-[_minusButton(44)]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_plusButton(44)]" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_minusButton(44)]" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)plusAction
{
    if ([PCGlobalModel shareModel].fontSize >= 30) {
        
    } else {
        self.plusButton.enabled = YES;
        [PCGlobalModel shareModel].fontSize += 2;
        if ([self.delegate respondsToSelector:@selector(adjustRangeArrayForText)]) {
            [self.delegate adjustRangeArrayForText];
        }
    }
}

- (void)minusAction
{
    if ([PCGlobalModel shareModel].fontSize <= 14) {
        
    } else {
        self.minusButton.enabled = YES;
        [PCGlobalModel shareModel].fontSize -= 2;
        if ([self.delegate respondsToSelector:@selector(adjustRangeArrayForText)]) {
            [self.delegate adjustRangeArrayForText];
        }
    }
}

- (UIButton *)plusButton
{
    if (!_plusButton) {
        _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _plusButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_plusButton setTitle:@"+" forState:UIControlStateNormal];
        _plusButton.backgroundColor = [UIColor blackColor];
        [_plusButton addTarget:self action:@selector(plusAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

- (UIButton *)minusButton
{
    if (!_minusButton) {
        _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _minusButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_minusButton setTitle:@"-" forState:UIControlStateNormal];
        _minusButton.backgroundColor = [UIColor blackColor];
        [_minusButton addTarget:self action:@selector(minusAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minusButton;
}

@end
