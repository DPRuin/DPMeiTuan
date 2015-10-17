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

@property (nonatomic, strong) id<DPHomeDropdownData> selectedData;

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
        if ([cellData respondsToSelector:@selector(cellIcon)]) {
            cell.imageView.image = cellData.cellIcon;
        }
        if ([cellData respondsToSelector:@selector(selectedCellIcon)]) {
            cell.imageView.highlightedImage = cellData.selectedCellIcon;
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
    static NSInteger selectedMainRow;
    if (tableView == self.mainTableView) { // 主表
        // 被点击的分类
        self.selectedData = [self.dataSource homeDropdown:self dataForRow:indexPath.row];
        selectedMainRow = indexPath.row;
        
        // 刷新次列表数据
        [self.subTableView reloadData];
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInMainTable:selectedMainRow];
        }

    } else { // 次表
        // 通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectRowInSubTable:inMainTable:)]) {
            [self.delegate homeDropdown:self didSelectRowInSubTable:indexPath.row inMainTable:selectedMainRow];
        }
    }

}
@end
