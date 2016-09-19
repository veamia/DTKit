//
//  DTTestViewController.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTTestViewController.h"
#import "DTWebViewController.h"
#import "DTButton.h"
#import "DTKitMacro.h"

@interface DTTestViewController ()

@end

@implementation DTTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DTKit";
    DTButton *btn = [DTButton new];
    btn.stateNormal.title = @"测试";
    btn.frame = CGRectMake(20, 80, 60, 40);
    [btn setTarget:self action:@selector(action)];
    [self.view addSubview:btn];
}

- (void)action
{
    NSString *str = @"https://www.baidu.com";
    dtInitObject(ctl, DTWebViewController);
    ctl.urlString = str;
    [self push:ctl];
}

@end
