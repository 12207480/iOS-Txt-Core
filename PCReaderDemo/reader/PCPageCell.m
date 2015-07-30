//
//  PCPageCell.m
//  PCReaderDemo
//
//  Created by Zheng on 15/3/17.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "PCPageCell.h"

@implementation PCPageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.pageView];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_pageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageView)]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_pageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageView)]];
    }
    return self;
}

#pragma mark - lazy loading

- (PCPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[PCPageView alloc] init];
        _pageView.translatesAutoresizingMaskIntoConstraints = NO;
        _pageView.backgroundColor = [UIColor whiteColor];
    }
    return _pageView;
}

@end
