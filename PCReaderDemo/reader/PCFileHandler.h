//
//  PCFileHandler.h
//  PCReaderDemo
//
//  Created by Zheng on 15/8/5.
//  Copyright © 2015 com.stoneread.read All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCFileHandler;

@protocol PCFileHandlerDelegate <NSObject>

@optional // Delegate protocols

- (void)didFinishChapterProcessing:(PCFileHandler *)fileHandler;
- (void)didFatalChapterProcessingWithError:(NSError *)error;
- (void)didFinishLoadingText:(PCFileHandler *)fileHandler;
- (void)didFatalLoadingWithError:(NSError *)error;

@end

@interface PCFileHandler : NSObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSMutableDictionary *chapterData; // 分节数据
@property (nonatomic) id <PCFileHandlerDelegate> delegate;

- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithURL:(NSURL *)fileURL;
- (void)startProcessingWithCache:(NSURL *)cachePath;

@end
