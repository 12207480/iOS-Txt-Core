//
//  PCReaderTool.h
//  PCReaderDemo
//
//  Created by Zheng on 15/3/23.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BatteryMonitorBlock)(CGFloat batteryLevel);
typedef void(^TimeMonitorBlock)(NSDate *currentDate);

@interface PCReaderTool : NSObject

- (void)startMonitorBatteryWithBlock:(BatteryMonitorBlock)block;
- (void)stopMonitorBattery;
- (void)startMonitorTimeWithBlock:(TimeMonitorBlock)block;
- (void)stopMonitorTime;

@end
