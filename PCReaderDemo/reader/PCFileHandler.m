//
//  PCFileHandler.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/5.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import "PCConfig.h"
#import "NSString+PCPaging.h"
#import "PCFileHandler.h"

@implementation PCFileHandler

- (instancetype)init {
    if (self = [super init]) {
        _chapterData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    if (self = [self init]) {
        _text = text;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)fileURL {
    _error = nil;
    
    
    NSError *convertError =  nil;
    NSStringEncoding usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    
    // 判断缓存是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cache = [[PCConfig shareModel] getCachePath:fileURL];
    NSString *str;
    
    if(![fileManager fileExistsAtPath:cache]) { // 缓存不存在，进行转码
        str = [[NSString alloc] initWithContentsOfURL:fileURL encoding:usedEncoding error:&convertError];
        if (str && convertError != nil) {
            str = [[NSString alloc] initWithContentsOfURL:fileURL encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000) error:&convertError];
        }
        if (str && convertError != nil) {
            str = [[NSString alloc] initWithContentsOfURL:fileURL encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80) error:&convertError];
        }
        if (str && convertError != nil) {
            str = [[NSString alloc] initWithContentsOfURL:fileURL encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGBK_95) error:&convertError];
        }
    } else { // 缓存存在，直接读入
        str = [[NSString alloc] initWithContentsOfFile:cache encoding:NSUTF8StringEncoding error:&convertError];
    }
    if (convertError != nil) {
        _error = convertError;
    }
    
    return (self = [self initWithText:str]);
}

- (void)startProcessingWithCache:(NSURL *)cachePath {
    if (_error != nil) {
        if ([self.delegate respondsToSelector:@selector(didFatalLoadingWithError:)] == YES)
        {
            [self.delegate didFatalLoadingWithError:_error];
        }
        else
        {
            NSAssert(NO, @"Delegate must respond to -didFatalLoadingWithError:");
        }
        return;
    }
    NSLog(@"%@", cachePath);
    // 判断缓存是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cache = [[PCConfig shareModel] getCachePath:cachePath];
    if(![fileManager fileExistsAtPath:cache]) {
        // 缓存不存在，进行分节与排版
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的分节操作
            _text = [_text filterBlankAndBlankLines];
            NSUInteger offset = 0;
            NSArray *arr = [_text componentsSeparatedByString:@"\n"];
            NSPredicate *pred;
            NSString *tempStr;
            NSArray *regex_arr = @[@"^\\s*第.+(章|节|回)\\s*.*$", @"^\\s*(零|一|二|三|四|五|六|七|八|九|十|百|千|[0-9])\\s*.*"];
            for (int j = 0; j < [regex_arr count]; j++) {
                pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [regex_arr objectAtIndex:j]];
                for (int i = 0; i < arr.count; i++) {
                    tempStr = (NSString *)arr[i];
                    if ([pred evaluateWithObject:tempStr]) {
                        [_chapterData setObject:tempStr forKey:@(offset)];
                    }
                    offset += tempStr.length + 1;
                }
                if ([_chapterData count] != 0) {
                    break;
                }
            }
            
            // 写出重排版数据
            NSData *outputCache = [_text dataUsingEncoding:NSUTF8StringEncoding];
            [outputCache writeToFile:cache atomically:NO];
            
            // 写出分节数据
            if ([_chapterData count] != 0) {
                [NSKeyedArchiver archiveRootObject:_chapterData toFile:[cache stringByAppendingString:@".chap"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(didFinishLoadingText:)] == YES)
                {
                    [self.delegate didFinishLoadingText:self];
                }
                else
                {
                    NSAssert(NO, @"Delegate must respond to -didFinishLoadingText:");
                }
            });
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 缓存存在，读入分节数据（排版数据已被读入）
            _chapterData = [NSKeyedUnarchiver unarchiveObjectWithFile:[cache stringByAppendingString:@".chap"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(didFinishLoadingText:)] == YES)
                {
                    [self.delegate didFinishLoadingText:self];
                }
                else
                {
                    NSAssert(NO, @"Delegate must respond to -didFinishLoadingText:");
                }
            });
        });
    }
}

@end
