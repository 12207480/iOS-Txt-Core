//
//  PCGlobalModel.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "PCGlobalModel.h"
#import "UIColor+PCColor.h"
#import "NSString+PCPaging.h"

@implementation PCGlobalModel

+ (instancetype)shareModel
{
    static PCGlobalModel *model = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        model = [[PCGlobalModel alloc] init];
    });
    return model;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fontSize = [PCConfig shareModel].fontSize;
        [self updateArea];
        _currentOffset = [[PCConfig shareModel] initOffset];
    }
    return self;
}

- (void)loadText:(NSString *)text completion:(void (^)(void))completion
{
    self.text = text;
    [self pagingTextCompletion:completion];
}

- (void)pagingTextCompletion:(void (^)(void))completion
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:6];
    
    // 设置字体
    UIFont *font = [UIFont fontWithName:[[PCConfig shareModel] font] size:[PCConfig shareModel].fontSize];
    [attributes setValue:[UIColor colorWithHex:[PCConfig shareModel].fontColor] forKey:NSForegroundColorAttributeName];
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:@(1.0) forKey:NSKernAttributeName];
    
    // 设置段落
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = [PCConfig shareModel].lineSpacing;
    paragraphStyle.paragraphSpacing = [PCConfig shareModel].paragraphSpacing;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
// TODO: 这种首行缩进方式存在问题
//    if ([PCConfig shareModel].autoIndent) {
//        const char indentChars[7] = { 0xe3, 0x80, 0x80, 0xe3, 0x80, 0x80, 0x00 };
//        NSString *indentStr = [[NSString alloc] initWithBytes:indentChars length:6 encoding:NSUTF8StringEncoding];
//        NSMutableAttributedString *indentMStr = [[NSMutableAttributedString alloc] initWithString:indentStr];
//        [indentMStr addAttributes:attributes range:NSMakeRange(0, indentMStr.length)];
//        paragraphStyle.firstLineHeadIndent = indentMStr.size.width;
//    }
    
    [attributes setValue:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    self.attributes = [attributes copy];
    
    self.rangeData = [[self.text paginationWithAttributes:self.attributes constrainedToSize:_area range:NSMakeRange(_currentOffset, PC_CACHE_BYTES) allowRelocate:YES] mutableCopy];
    self.currentOffset = self.rangeData.relocatedOffset;
    self.currentRange = self.rangeData.relocatedRange;
    if (completion) {
        completion();
    }
}

- (PCPageData *)reloadPaginationByOffset:(NSInteger)offset
                           allowRelocate:(BOOL)shouldRelocate {
    _rangeData = [[_text paginationWithAttributes:_attributes constrainedToSize:_area range:NSMakeRange(offset,PC_CACHE_BYTES) allowRelocate:shouldRelocate] mutableCopy];
    _currentOffset = _rangeData.relocatedOffset;
    _currentRange = _rangeData.relocatedRange;
    return _rangeData;
}

- (void)updateFontCompletion:(void (^)(void))completion
{
    //取回之前的定位页数
    NSRange range = self.currentRange;
    [self pagingTextCompletion:^{
        //重新定位页码
        [self.rangeData.cachedPagination enumerateKeysAndObjectsUsingBlock:^(NSNumber *offset, NSNumber *length, BOOL *stop) {
            NSRange tempRange = NSMakeRange([offset integerValue], [length integerValue]);
            if (tempRange.location <= range.location && tempRange.location + tempRange.length > range.location) {
                self.currentOffset = [offset integerValue];
                *stop = YES;
            }
        }];
        if (completion) {
            completion();
        }
    }];
}

- (void)setFontSize:(CGFloat)fontSize
{
    if (fontSize < 12.0) {
        [PCConfig shareModel].fontSize = 12.0;
    } else if (fontSize > 30.0) {
        [PCConfig shareModel].fontSize = 30.0;
    } else {
        [PCConfig shareModel].fontSize = fontSize;
    }
}

- (void)setCurrentRange:(NSRange)currentRange
{
    _currentRange = currentRange;
}

- (void)clear {
    _text = nil;
    _rangeData = nil;
    _attributes = nil;
}

- (void)updateArea {
    _area = CGSizeMake([UIScreen mainScreen].bounds.size.width - 10 * 2, [UIScreen mainScreen].bounds.size.height - 40 * 2);
}

@end
