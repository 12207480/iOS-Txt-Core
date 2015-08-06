//
//  PCConfig.h
//  PCReaderDemo
//
//  Created by Zheng on 15/8/5.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import <Foundation/Foundation.h>

#define PC_CACHE_BYTES 30000 // 分页缓存大小
// 注：向前分页误差率 = 取整(文档全长 / 分页缓存大小) / 文档分页数

#define PC_INIT_OFFSET 98
#define PC_INIT_FONT_TYPE 1 // 默认字体
#define PC_INIT_FONT_SIZE 20 // 默认字体大小
#define PC_INIT_BRIGHTNESS 100.0 // 默认亮度
#define PC_INIT_AUTO_INDENT YES // 默认自动缩进
#define PC_INIT_LINE_SPACING 3.0 // 默认行距
#define PC_INIT_PARAGRAPH_SPACING 15.0 // 默认段落间距
#define PC_INIT_COLOR_TYPE 1 // 默认字体颜色方案
#define PC_INIT_PAGE_MODE 1 // 翻页方式：滑动(1) 或 仿真(2)

#define PC_FONT_1 @"STHeitiSC-Light" // 系统黑体
#define PC_FONT_2 @"PingFang-SC-Light" // 苹方黑体
#define PC_FONT_3 @"STKaiti" // 楷体
#define PC_FONT_4 @"Tianshi-SunOld" // 田氏宋体
#define PC_FONT_5 @"SourceHanSansK-Light" // 思源黑体
#define PC_FONT_6 @"HYXiYuanJ" // 汉仪圆体

#define PC_FONT_COLOR_1 @"0x000000" // 天然白
#define PC_BACKGROUND_COLOR_1 @"0xFBF9F7"
#define PC_LABEL_COLOR_1 @"0xACACAC"

#define PC_FONT_COLOR_2 @"0x32342D" // 浅碧
#define PC_BACKGROUND_COLOR_2 @"0xC7CFB4"
#define PC_LABEL_COLOR_2 @"0x8B907E"

#define PC_FONT_COLOR_3 @"0x2C352D" // 水绿
#define PC_BACKGROUND_COLOR_3 @"0xB1D2B5"
#define PC_LABEL_COLOR_3 @"0x89A28C"

#define PC_FONT_COLOR_4 @"0x312F2B" // 枯竹褐
#define PC_BACKGROUND_COLOR_4 @"0xC3BBAE"
#define PC_LABEL_COLOR_4 @"0x8A847B"

#define PC_FONT_COLOR_5 @"0x453D34" // 松花黄
#define PC_BACKGROUND_COLOR_5 @"0xC5AF90"
#define PC_LABEL_COLOR_5 @"0x857159"

#define PC_FONT_COLOR_6 @"0x383838" // 佛头青
#define PC_BACKGROUND_COLOR_6 @"0x919191"
#define PC_LABEL_COLOR_6 @"0x656565"

#define PC_FONT_COLOR_7 @"0x828891" // 乌青
#define PC_BACKGROUND_COLOR_7 @"0x232E40"
#define PC_LABEL_COLOR_7 @"0x5a616e"


@interface PCConfig : NSObject

@property (nonatomic) unsigned int pageMode; // 翻页模式
@property (nonatomic) unsigned int pageTrans; // 翻页方向
@property (nonatomic) float brightness; // 亮度（未实现）
@property (nonatomic) unsigned int fontSize; // 字体大小
@property (nonatomic) BOOL autoIndent; // 自动缩进（向段落开头中添加两个空格）
@property (nonatomic) float lineSpacing; // 行距
@property (nonatomic) float paragraphSpacing; // 段落间距

@property (nonatomic) unsigned int colorType;
@property (nonatomic) unsigned int fontType;

+ (instancetype)shareModel;
- (NSUInteger)initOffset; // 初始化坐标
- (NSString *)fontColor; // 文本颜色
- (NSString *)labelColor; // 标签颜色
- (NSString *)backgroundColor; // 背景颜色
- (NSString *)font; // 字体
- (NSString *)getCachePath:(NSURL *)url; // 设定缓存路径命名规则

@end
