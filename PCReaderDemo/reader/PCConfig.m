//
//  PCConfig.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/5.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import "PCConfig.h"
#import <UIKit/UIKit.h>

@implementation PCConfig

+ (instancetype)shareModel
{
    static PCConfig *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[PCConfig alloc] init];
    });
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageMode = UIPageViewControllerTransitionStylePageCurl;
        self.pageTrans = UIPageViewControllerNavigationOrientationHorizontal;
        self.brightness = PC_INIT_BRIGHTNESS;
        self.fontSize = PC_INIT_FONT_SIZE;
        self.autoIndent = PC_INIT_AUTO_INDENT;
        self.lineSpacing = PC_INIT_LINE_SPACING;
        self.paragraphSpacing = PC_INIT_PARAGRAPH_SPACING;
        self.colorType = PC_INIT_COLOR_TYPE;
        self.fontType = PC_INIT_FONT_TYPE;
        self.startOffset = PC_INIT_OFFSET;
    }
    return self;
}

- (NSString *)fontColor {
    switch (_colorType) {
        case 1:
            return PC_FONT_COLOR_1;
            break;
        case 2:
            return PC_FONT_COLOR_2;
            break;
        case 3:
            return PC_FONT_COLOR_3;
            break;
        case 4:
            return PC_FONT_COLOR_4;
            break;
        case 5:
            return PC_FONT_COLOR_5;
            break;
        case 6:
            return PC_FONT_COLOR_6;
            break;
        case 7:
            return PC_FONT_COLOR_7;
            break;
        default:
            return PC_FONT_COLOR_1;
            break;
    }
}

- (NSString *)labelColor {
    switch (_colorType) {
        case 1:
            return PC_LABEL_COLOR_1;
            break;
        case 2:
            return PC_LABEL_COLOR_2;
            break;
        case 3:
            return PC_LABEL_COLOR_3;
            break;
        case 4:
            return PC_LABEL_COLOR_4;
            break;
        case 5:
            return PC_LABEL_COLOR_5;
            break;
        case 6:
            return PC_LABEL_COLOR_6;
            break;
        case 7:
            return PC_LABEL_COLOR_7;
            break;
        default:
            return PC_LABEL_COLOR_1;
            break;
    }
}

- (NSString *)backgroundColor {
    switch (_colorType) {
        case 1:
            return PC_BACKGROUND_COLOR_1;
            break;
        case 2:
            return PC_BACKGROUND_COLOR_2;
            break;
        case 3:
            return PC_BACKGROUND_COLOR_3;
            break;
        case 4:
            return PC_BACKGROUND_COLOR_4;
            break;
        case 5:
            return PC_BACKGROUND_COLOR_5;
            break;
        case 6:
            return PC_BACKGROUND_COLOR_6;
            break;
        case 7:
            return PC_BACKGROUND_COLOR_7;
            break;
        default:
            return PC_BACKGROUND_COLOR_1;
            break;
    }
}

- (NSString *)font {
    switch (_fontType) {
        case 1:
            return PC_FONT_1;
            break;
        case 2:
            return PC_FONT_2;
            break;
        case 3:
            return PC_FONT_3;
            break;
        case 4:
            return PC_FONT_4;
            break;
        case 5:
            return PC_FONT_5;
            break;
        case 6:
            return PC_FONT_6;
            break;
        default:
            return PC_FONT_1;
            break;
    }
}

- (NSUInteger)initOffset {
    return self.startOffset;
}

- (NSString *)getCachePath:(NSURL *)url {
    NSString *cache = [[url path] stringByAppendingString:@".cache"];
    return cache;
}

- (float)brightness {
    return [UIScreen mainScreen].brightness;
}

- (void)setBrightness:(float)brightness {
    [[UIScreen mainScreen] setBrightness:brightness];
}

@end
