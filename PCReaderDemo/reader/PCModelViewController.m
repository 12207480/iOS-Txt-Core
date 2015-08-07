//
//  PCModelViewController.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "PCModelViewController.h"
#import "PCGlobalModel.h"

@interface PCModelViewController ()

@end

@implementation PCModelViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
    }
    return self;
}

- (PCDataViewController *)viewControllerAtOffset:(NSUInteger)offset {
    // Return the data view controller for the given index.
    NSInteger length = [self.pageData getLengthByOffset:offset];
    if (([self.pageData totalBytes] == 0) || (length <= 0)) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PCDataViewController *dataViewController = [[PCDataViewController alloc] init];
    dataViewController.dataObject = [self.text substringWithRange:NSMakeRange(offset, length)];
    dataViewController.displayName = self.displayName;
    dataViewController.attributes = self.attributes;
    dataViewController.currentOffset = offset;
    dataViewController.totalBytes = [self.pageData totalBytes];
    [PCGlobalModel shareModel].currentOffset = offset;
    return dataViewController;
}

- (NSInteger)offsetOfViewController:(PCDataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return viewController.currentOffset;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger offset = [self offsetOfViewController:(PCDataViewController *)viewController];
    if ((offset == -1) || (offset == 0) || (offset == NSNotFound)) {
        return nil;
    }
    
    NSInteger newoffset = [self.pageData offsetBeforeOffset:offset];
    if (newoffset < 0) {
        PCPageData *reloadData = [[PCGlobalModel shareModel] reloadPaginationByOffset:offset
                                                                        allowRelocate:YES];
        offset = [reloadData offsetBeforeOffset:reloadData.relocatedOffset];
    } else {
        offset = newoffset;
    }
    
    [PCGlobalModel shareModel].currentRange = NSMakeRange(offset, [self.pageData getLengthByOffset:offset]);
    return [self viewControllerAtOffset:offset];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger offset = [self offsetOfViewController:(PCDataViewController *)viewController];
    if ((offset == -1) || (offset == NSNotFound)) {
        return nil;
    }
    
    NSInteger newoffset = [self.pageData offsetAfterOffset:offset];
    if (newoffset < 0) {
        PCPageData *reloadData = [[PCGlobalModel shareModel] reloadPaginationByOffset:offset
                                                                        allowRelocate:NO];
        offset = [reloadData offsetAfterOffset:reloadData.relocatedOffset];
    } else {
        offset = newoffset;
    }
    
    [PCGlobalModel shareModel].currentRange = NSMakeRange(offset, [self.pageData getLengthByOffset:offset]);
    return [self viewControllerAtOffset:offset];
}

@end
