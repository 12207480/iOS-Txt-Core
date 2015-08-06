//
//  ViewController.m
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "ViewController.h"
#import "PCReaderViewController.h"

@interface ViewController () <PCReaderViewControllerDelegate>

@property (nonatomic, retain) MBProgressHUD *HUD;

- (IBAction)pushAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushAction:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"test.txt"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *arr = [manager contentsOfDirectoryAtPath:[paths objectAtIndex:0] error:nil];
    NSLog(@"%@", arr);
    
    // 文件路径
    NSURL *url = [NSURL fileURLWithPath:docDir];
    
    // 初始化控制器
    PCReaderViewController *reader = [[PCReaderViewController alloc] init];
    
    // 设置委托
    reader.delegate = (id)self;
    
    // 显示名称
    reader.displayName = @"test.txt";
    
    // 载入数据
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"初始化";
    [reader loadText:url];
}

- (void)didFinishLoadingPCReader:(PCReaderViewController *)reader {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self presentViewController:reader
                       animated:YES
                     completion:nil];
}

- (void)didFatalLoadingPCReaderWithError:(NSError *)error {
    if ([error code] == 256) {
        _HUD.labelText = @"文件不存在或无法读取";
    } else {
        _HUD.labelText = @"未知错误";
    }
    [self performSelector:@selector(hideProgressHUD) withObject:nil afterDelay:2.0f];
}

- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)dismissPCReaderViewController:(PCReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
