//
//  ViewController.m
//  PCReaderDemo
//
//  Created by Zheng on 15/3/9.
//  Copyright (c) 2015 com.stoneread.read All rights reserved.
//

#import "ViewController.h"
#import "PCReaderViewController.h"

@interface ViewController ()

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
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"txt"];
    PCReaderViewController *reader = [[PCReaderViewController alloc] init];
    reader.displayName = @"test.txt";
    [reader loadText:[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil]];
    [self.navigationController pushViewController:reader animated:YES];
}

@end
