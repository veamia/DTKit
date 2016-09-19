//
//  DTGroupTableViewController.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTGroupTableViewController.h"
#import "DTKitMacro.h"
#import "UITableView+Expand.h"

@interface DTGroupTableViewController ()

@end

@implementation DTGroupTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

#pragma mark - UITableView DataSource

TABLE_DATA_SECTION(tableView)
{
    return self.dataSource.count;
}

TABLE_DATA_ROWS(tableView, section)
{
    return [self.dataSource[section] count];
}

TABLE_DATA_CELL(tableView, indexPath)
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate

TABLE_DELEGATE_HEIGHT_HEADER(tableView, section)
{
    return section == 0 ? 17.0f : 0;
}

TABLE_DELEGATE_HEIGHT_FOOTER(tableView, section)
{
    return 0.001f;
}

@end
