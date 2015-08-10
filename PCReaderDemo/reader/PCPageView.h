//
//  PCPageView.h
//  PCPageDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCPageView : UIView

@property (nonatomic, copy) NSAttributedString *attributedText;

- (void)setText:(NSAttributedString *)attributedText;

@end
