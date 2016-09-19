//
//  UITableView+Expand.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/18.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>

// 常用表数据源简写
#pragma mark - UITableViewDataSource

#undef  TABLE_DATA_SECTION // 返回区域的数量
#define TABLE_DATA_SECTION(tableView) \
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

#undef  TABLE_DATA_ROWS // 返回每个区域的行数
#define TABLE_DATA_ROWS(tableView, section) \
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

#undef  TABLE_DATA_CELL // cell
#define TABLE_DATA_CELL(tableView, indexPath) \
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

#undef  TABLE_DATA_HEADER // 区域头部标题
#define TABLE_DATA_HEADER(tableView, section) \
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

#undef  TABLE_DATA_FOOTER //区域尾部标题
#define TABLE_DATA_FOOTER(tableView, section) \
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section

#undef  TABLE_DATA_CANEDIT  //是否可编辑
#define TABLE_DATA_CANEDIT(tableView, indexPath) \
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

// 常用表代理简写
#pragma mark - UITableViewDelegate

#undef  TABLE_DELEGATE_SELECT // 选择事件
#define TABLE_DELEGATE_SELECT(tableView, indexPath) \
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

#undef  TABLE_DELEGATE_HEIGHT_ROW // 行高
#define TABLE_DELEGATE_HEIGHT_ROW(tableView, indexPath) \
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

#undef  TABLE_DELEGATE_HEIGHT_HEADER // 头部高度
#define TABLE_DELEGATE_HEIGHT_HEADER(tableView, section) \
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section

#undef  TABLE_DELEGATE_HEIGHT_FOOTER // 尾部高度
#define TABLE_DELEGATE_HEIGHT_FOOTER(tableView, section) \
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

#undef  TABLE_DELEGATE_VIEW_HEADER // 头部视图
#define TABLE_DELEGATE_VIEW_HEADER(tableView, section) \
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

#undef  TABLE_DELEGATE_VIEW_FOOTER //尾部视图
#define TABLE_DELEGATE_VIEW_FOOTER(tableView, section) \
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

#undef  TABLE_DELEGATE_EDIT_STYLE //是否允许编辑
#define TABLE_DELEGATE_EDIT_STYLE(tableView, indexPath) \
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

#undef  TABLE_DELEGATE_EDIT_ACTIONS //编辑按钮事件
#define TABLE_DELEGATE_EDIT_ACTIONS(tableView, indexPath) \
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath

#pragma mark -

#undef  SectionIndexTitles //右边索引标题
#define SectionIndexTitles [UILocalizedIndexedCollation.currentCollation sectionIndexTitles]

#pragma mark -

@interface UITableView (Expand)

@end
