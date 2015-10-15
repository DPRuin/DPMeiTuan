//
//  DPHomeDropdown.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeDropdown.h"
#import "DPCategary.h"
#import "DPHomeDropdownSubCell.h"
#import "DPHomeDropdownMainCell.h"

@interface DPHomeDropdown () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

@property (nonatomic, strong) DPCategary *selectCategary;
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
        return self.categaries.count;
    } else {
        return self.selectCategary.subcategories.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView) { // 主表
        cell = [DPHomeDropdownMainCell cellWithTableView:tableView];
        
        // 加载数据模型
        DPCategary *categary = self.categaries[indexPath.row];
        cell.textLabel.text = categary.name;
        cell.imageView.image = [UIImage imageNamed:categary.small_icon];
        if (categary.subcategories.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else { // 次表
        cell = [DPHomeDropdownSubCell cellWithTableView:tableView];
        cell.textLabel.text = self.selectCategary.subcategories[indexPath.row];
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.mainTableView) {
        // 被点击的分类
        self.selectCategary = self.categaries[indexPath.row];
        
        // 刷新次菜单数据
        [self.subTableView reloadData];

    }

}
@end
