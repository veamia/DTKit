//
//  DTBaseTableViewController.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTBaseViewController.h"

@interface DTBaseTableViewController : DTBaseViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

//数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

//需要加载的目标Rect
@property (nonatomic, strong) NSValue *targetRect;

// 可拖动放大缩小的图片控制器
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic)         CGFloat backImageHeight;

- (void)loadDataSource; // 子类覆盖

@end
