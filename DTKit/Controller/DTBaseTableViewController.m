//
//  DTBaseTableViewController.m
//  DTKitDemo
//
//  Created by zhaojh on 16/9/19.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import "DTBaseTableViewController.h"
#import "DTKitMacro.h"
#import "UIView+Frame.h"
#import "UITableView+Expand.h"

#define kBackImageViewDefaultHeight dtEqualRate(165)

@interface DTBaseTableViewController ()
<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _lastContentOffset;
    BOOL    _hasBackImage;
}

@end

@implementation DTBaseTableViewController

- (void)viewDidLoad {
    [self loadDataSource];
    [super viewDidLoad];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect tbFrame = self.view.bounds;
        if (self.automaticallyAdjustsScrollViewInsets == NO) {
            tbFrame.origin.y = dtNavBarHeight;
            tbFrame.size.height -= dtNavBarHeight;
            NSArray *viewControllers = self.navigationController.viewControllers;
            if (viewControllers.count == 1 && self.tabBarController != nil) {
                tbFrame.size.height -= dtNavBarHeight;
            }
        }
        _tableView = [[UITableView alloc] initWithFrame:tbFrame style:self.tableViewStyle];
        if ([self respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
            _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        }
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delaysContentTouches = NO;
        _tableView.canCancelContentTouches = YES;
        
        // Remove touch delay (since iOS 8)
        UIView *wrapView = _tableView.subviews.firstObject;
        // UITableViewWrapperView
        if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
            for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
                // UIScrollViewDelayedTouchesBeganGestureRecognizer
                if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                    gesture.enabled = NO;
                    break;
                }
            }
        }
        // 此处添加
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _hasBackImage = YES;
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, dtScreenWidth, kBackImageViewDefaultHeight)];
        _backImageHeight = kBackImageViewDefaultHeight;
        _backImageView.clipsToBounds = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_backImageView];
        
        self.view.backgroundColor = self.tableView.backgroundColor;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self.view bringSubviewToFront:self.tableView];
    }
    return _backImageView;
}

- (void)setBackImageHeight:(CGFloat)backImageHeight
{
    _backImageHeight = backImageHeight;
    self.backImageView.height = backImageHeight;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)loadDataSource {}

#pragma mark - UITableViewDataSource

TABLE_DATA_SECTION(tableView) {
    return 1;
}

TABLE_DATA_ROWS(tableView, section) {
    return self.dataSource.count;
}

TABLE_DATA_CELL(tableView, indexPath) {
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

TABLE_DELEGATE_SELECT(tableView, indexPath)
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (dtIsKindOf(scrollView, UITableView)) {
        if (_hasBackImage) {
            CGPoint offset = scrollView.contentOffset;
            CGRect rect = self.backImageView.frame;
            rect.origin.y = scrollView.y;
            rect.size.height = self.backImageHeight - offset.y;
            self.backImageView.frame = rect;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.y;
    
    if (dtIsKindOf(scrollView, UITableView)) {
        [self.view endEditing:YES];
    }
}

@end
