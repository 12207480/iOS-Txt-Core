//
//  PCReaderViewController.m
//  PCReaderDemo
//
//  Created by Zheng on 15/8/1.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//


#import "UIColor+PCColor.h"
#import "PCReaderViewController.h"
#import "PCModelViewController.h"
#import "PCDataViewController.h"
#import "PCFontAdjustView.h"
#import "PCGlobalModel.h"
#import "PCFileHandler.h"
#import "PCReaderTool.h"

@interface PCReaderViewController () <PCFontAdjustViewDelegate>

@property (strong, nonatomic) PCModelViewController *modelController;
@property (strong, nonatomic) PCGlobalModel *globalModel;
@property (strong, nonatomic) PCFontAdjustView *fontAdjustView;
@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *backgroundView;
@property (strong, nonatomic) UIToolbar *toolbar_top;
@property (strong, nonatomic) UIToolbar *toolbar;
@property (nonatomic) BOOL isShowMenu;

@property (strong, nonatomic) NSArray *toolbarTopConstraintArray;
@property (strong, nonatomic) NSArray *toolbarConstraintArray;

@end

@implementation PCReaderViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [[PCGlobalModel shareModel] updateArea];
    [self adjustRangeArrayForText];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [[PCGlobalModel shareModel] updateArea];
    [self adjustRangeArrayForText];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:[PCConfig shareModel].backgroundColor];
    
    [self loadPageConfig];
    
    [self.view addSubview:self.menuButton];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_menuButton]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_menuButton)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.menuButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0]];
    
    [self setupBackgroundView];
    [self setupToolbar];
}

- (void)reloadPageConfig {
    // 移除视图
    [_pageController.view removeFromSuperview];
    _pageController = nil;
    
    // 重建视图
    [self loadPageConfig];
}

- (void)loadPageConfig {
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                       forKey: UIPageViewControllerOptionSpineLocationKey];
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:[PCConfig shareModel].pageMode navigationOrientation:[PCConfig shareModel].pageTrans options:options];
    
    self.pageController.delegate = self;
    
    self.pageController.dataSource = self.modelController;
    self.modelController.readerController = self;
    
    [self addChildViewController:self.pageController];
    [self.pageController didMoveToParentViewController:self];
    // 图书内容层始终位于最底层
    [self.view insertSubview:self.pageController.view atIndex:0];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageController.view.frame = pageViewRect;
    
    PCDataViewController *startingViewController = [self.modelController viewControllerAtOffset:[PCGlobalModel shareModel].currentOffset];
    NSArray *viewControllers = @[startingViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)jumpToOffset:(NSInteger)offset {
    // 重新分页
    self.modelController.pageData = [[PCGlobalModel shareModel] reloadPaginationByOffset:offset allowRelocate:YES];
    
    // 设置视图
    PCDataViewController *newViewController = [self.modelController viewControllerAtOffset:[PCGlobalModel shareModel].currentOffset];
    NSArray *viewControllers = @[newViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (void)setupBackgroundView
{
    self.backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backgroundView addTarget:self action:@selector(backgroundAction) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundView.hidden = YES;
    
    [self.view addSubview:self.backgroundView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_backgroundView)]];
}

- (void)setupToolbar
{
    // 顶部工具栏
    self.toolbar_top = [[UIToolbar alloc] init];
    self.toolbar_top.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolbar_top.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *item_close = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeDocument)];
    
    [self.toolbar_top setItems:@[item_close]];
    
    // 底部工具栏
    self.toolbar = [[UIToolbar alloc] init];
    self.toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolbar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *item_font = [[UIBarButtonItem alloc] initWithTitle:@"字体" style:UIBarButtonItemStylePlain target:self action:@selector(adjustFontAction)];
    
    UIBarButtonItem *fixibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self.toolbar setItems:@[fixibleItem, item_font]];
    
    [self.view addSubview:self.toolbar_top];
    [self.view addSubview:self.toolbar];
    [self.view addSubview:self.fontAdjustView];
    
    // 调整位置约束
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_toolbar_top]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar_top)]];
    self.toolbarTopConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-48)-[_toolbar_top(48)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar_top)];
    [self.view addConstraints:self.toolbarTopConstraintArray];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_toolbar]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)]];
    self.toolbarConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(48)]-(-48)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)];
    [self.view addConstraints:self.toolbarConstraintArray];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_fontAdjustView(44)]-48-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_fontAdjustView)]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fontAdjustView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.fontAdjustView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0 constant:98]];
}

- (void)showToolbar
{
    [self.view removeConstraints:self.toolbarTopConstraintArray];
    [self.view removeConstraints:self.toolbarConstraintArray];
    
    self.toolbarTopConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[_toolbar_top(48)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar_top)];
    self.toolbarConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(48)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)];
    
    [self.view addConstraints:self.toolbarTopConstraintArray];
    [self.view addConstraints:self.toolbarConstraintArray];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)hideToolbar
{
    [self.view removeConstraints:self.toolbarTopConstraintArray];
    [self.view removeConstraints:self.toolbarConstraintArray];
    
    self.toolbarTopConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(-48)-[_toolbar_top(48)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar_top)];
    self.toolbarConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_toolbar(48)]-(-48)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_toolbar)];
    
    [self.view addConstraints:self.toolbarTopConstraintArray];
    [self.view addConstraints:self.toolbarConstraintArray];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)loadText:(NSURL *)url
{
    _fileHandler = [[PCFileHandler alloc] initWithURL:url];
    _fileHandler.delegate = self;
    [_fileHandler startProcessingWithCache:url];
}

- (void)didFinishLoadingText:(PCFileHandler *)fileHandler {
    [self.globalModel loadText:fileHandler.text completion:^{
        self.modelController.text = self.globalModel.text;
        self.modelController.attributes = self.globalModel.attributes;
        self.modelController.pageData = self.globalModel.rangeData;
        [self pageControllerSetOffset:self.globalModel.currentOffset];
    }];
    if ([self.delegate respondsToSelector:@selector(didFinishLoadingPCReader:)] == YES)
    {
        [self.delegate didFinishLoadingPCReader:self];
    }
    else
    {
        NSAssert(NO, @"Delegate must respond to -didFinishLoadingPCReader:");
    }
}

- (void)didFatalLoadingWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFatalLoadingPCReaderWithError:)] == YES)
    {
        [self.delegate didFatalLoadingPCReaderWithError:error];
    }
    else
    {
        NSAssert(NO, @"Delegate must respond to -didFatalLoadingPCReaderWithError:");
    }
}

- (void)pageControllerSetOffset:(NSInteger)offset
{
    [self.pageController setViewControllers:@[[self.modelController viewControllerAtOffset:offset]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeDocument {
    [[PCGlobalModel shareModel] clear];
    _fileHandler = nil;
    _pageController = nil;
    _modelController = nil;
    _globalModel = nil;
    
    if ([self.delegate respondsToSelector:@selector(dismissPCReaderViewController:)] == YES)
    {
        [self.delegate dismissPCReaderViewController:self];
    }
    else
    {
        NSAssert(NO, @"Delegate must respond to -dismissPCReaderViewController:");
    }
}

- (void)menuAction
{
    self.isShowMenu = !self.isShowMenu;
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.backgroundView.hidden = !self.isShowMenu;
    if (self.isShowMenu) {
        [self showToolbar];
    } else {
        [self hideToolbar];
    }
}

- (void)backgroundAction
{
    self.isShowMenu = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    self.backgroundView.hidden = !self.isShowMenu;
    self.fontAdjustView.alpha = 0;
    if (self.isShowMenu) {
        [self showToolbar];
    } else {
        [self hideToolbar];
    }
}

- (PCModelViewController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[PCModelViewController alloc] init];
        _modelController.displayName = self.displayName;
    }
    return _modelController;
}

- (BOOL)prefersStatusBarHidden
{
    return !self.isShowMenu;
}

#pragma mark - UIPageViewController delegate methods

// 横屏双页支持（尚未实现）
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    [self.pageController setViewControllers:@[self.pageController.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - PCFontAdjustViewDelegate

// 重新排布
- (void)adjustRangeArrayForText
{
    [self.globalModel updateFontCompletion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePageNotification object:nil];
        
        self.modelController.text = self.globalModel.text;
        self.modelController.attributes = self.globalModel.attributes;
        self.modelController.pageData = self.globalModel.rangeData;
        [self pageControllerSetOffset:self.globalModel.currentOffset];
    }];
}

#pragma mark - toolbar Action

- (void)adjustFontAction
{
    if (self.fontAdjustView.alpha == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.fontAdjustView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.fontAdjustView.alpha = 0;
        }];
    }
}

#pragma mark - lazy loading

- (UIButton *)menuButton
{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_menuButton addTarget:self action:@selector(menuAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuButton;
}

- (PCGlobalModel *)globalModel
{
    if (!_globalModel) {
        _globalModel = [PCGlobalModel shareModel];
    }
    return _globalModel;
}

- (PCFontAdjustView *)fontAdjustView
{
    if (!_fontAdjustView) {
        _fontAdjustView = [[PCFontAdjustView alloc] init];
        _fontAdjustView.translatesAutoresizingMaskIntoConstraints = NO;
        _fontAdjustView.alpha = 0;
        _fontAdjustView.delegate = self;
    }
    return _fontAdjustView;
}

@end
