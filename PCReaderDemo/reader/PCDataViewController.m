//
//  PCDataViewController.m
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "UIColor+PCColor.h"
#import "PCDataViewController.h"
#import "PCGlobalModel.h"
#import "PCReaderTool.h"

@interface PCDataViewController ()

@property (nonatomic, strong) PCReaderTool *readerTool;

@end

@implementation PCDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:[[PCConfig shareModel] backgroundColor]];
    [self.view addSubview:self.pageView];
    [self.view addSubview:self.displayNameLabel];
    [self.view addSubview:self.progressLabel];
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.batteryLabel];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_pageView]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[_pageView]-40-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[_displayNameLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayNameLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_displayNameLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayNameLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_progressLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageView, _progressLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_progressLabel]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_pageView, _progressLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_batteryLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_batteryLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[_batteryLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_batteryLabel)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_timeLabel]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_timeLabel)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_batteryLabel]-[_timeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_batteryLabel, _timeLabel)]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePage) name:kUpdatePageNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.pageView setAttributedText:[[NSAttributedString alloc] initWithString:self.dataObject attributes:self.attributes]];
    [self updatePage];
    [self.displayNameLabel setText:self.displayName];
    
    [self.readerTool startMonitorTimeWithBlock:^(NSDate *currentDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *datestr = [dateFormatter stringFromDate:currentDate];
        self.timeLabel.text = datestr;
    }];
    
    [self.readerTool startMonitorBatteryWithBlock:^(CGFloat batteryLevel) {
        NSString *powerStr = [[NSString alloc] initWithFormat:@"%d%%", (int)(batteryLevel * 100)];
        self.batteryLabel.text = powerStr;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.readerTool stopMonitorTime];
}

- (void)updatePage
{
    [self.progressLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * ((float)([PCGlobalModel shareModel].currentOffset + 1) / (self.totalBytes + 1))]];
}

#pragma mark - lazy loading

- (PCPageView *)pageView
{
    if (!_pageView) {
        _pageView = [[PCPageView alloc] init];
        _pageView.translatesAutoresizingMaskIntoConstraints = NO;
        _pageView.backgroundColor = [UIColor colorWithHex:[[PCConfig shareModel] backgroundColor]];
    }
    return _pageView;
}

- (UILabel *)displayNameLabel
{
    if (!_displayNameLabel) {
        _displayNameLabel = [[UILabel alloc] init];
        _displayNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _displayNameLabel.font = [UIFont systemFontOfSize:13];
        _displayNameLabel.textColor = [UIColor colorWithHex:[[PCConfig shareModel] labelColor]];
    }
    return _displayNameLabel;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _progressLabel.font = [UIFont systemFontOfSize:13];
        _progressLabel.textColor = [UIColor colorWithHex:[[PCConfig shareModel] labelColor]];
    }
    return _progressLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor colorWithHex:[[PCConfig shareModel] labelColor]];
    }
    return _timeLabel;
}

- (UILabel *)batteryLabel
{
    if (!_batteryLabel) {
        _batteryLabel = [[UILabel alloc] init];
        _batteryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _batteryLabel.font = [UIFont systemFontOfSize:13];
        _batteryLabel.textColor = [UIColor colorWithHex:[[PCConfig shareModel] labelColor]];
        _batteryLabel.textAlignment = NSTextAlignmentRight;
    }
    return _batteryLabel;
}

- (PCReaderTool *)readerTool
{
    if (!_readerTool) {
        _readerTool = [[PCReaderTool alloc] init];
    }
    return _readerTool;
}

@end
