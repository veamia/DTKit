//
//  DTWebViewController.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTBaseViewController.h"

@interface DTWebViewController : DTBaseViewController

@property (nonatomic, copy) NSString *urlString;

//是否可以关闭，默认NO
@property (nonatomic, assign) BOOL isCanClose;

//是否本地的，默认NO
@property (nonatomic, assign) BOOL isLocal;

@end
