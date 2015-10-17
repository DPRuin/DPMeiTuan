//
//  DPHomeDropdown.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeDropdown.h"
#import "DPHomeDropdownSubCell.h"
#import "DPHomeDropdownMainCell.h"

@interface DPHomeDropdown () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (nonatomic, assign) id<DPHomeDropdownData> selectedData;
@end

@implementation DPHomeDropdown

+ (instancetype)dropdown
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DPHomeDropdown" owner:nil options:nil] lastObject];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.mainTableView) {
        return [self.dataSource numberOfRowsHomeDropdow:self];
    } else {
        return self.selectedData.subData.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView) { // 主表
        cell = [DPHomeDropdownMainCell cellWithTableView:tableView];
        
        // 加载数据模型
        id<DPHomeDropdownData> cellData = [self.dataSource homeDropdown:self dataForRow:indexPath.row];
        cell.textLabel.text = cellData.title;
        if ([cellData respondsToSelector:@selector(icon)]) {
            cell.imageView.image = cellData.icon;
        }
        if ([cellData respondsToSelector:@selector(selectedIcon)]) {
            cell.imageView.highlightedImage = cellData.selectedIcon;
        }
    
        if (cellData.subData.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { // 次表
        cell = [DPHomeDropdownSubCell cellWithTableView:tableView];
        cell.textLabel.text = self.selectedData.subData[indexPath.row];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        // 被点击的分类
        self.selectedData = [self.dataSource homeDropdown:self dataForRow:indexPath.row];
        
        // 刷新次菜单数据
        [self.subTableView reloadData];

    }

}
@end
