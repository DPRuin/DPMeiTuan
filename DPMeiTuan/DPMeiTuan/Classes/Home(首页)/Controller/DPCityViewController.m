//
//  DPCityViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DPCityGroup.h"
#import "MJExtension.h"
#import "Masonry.h"

const int DPCoverTag = 999;

@interface DPCityViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *cityGroups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DPCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏内容基本设置
    self.title = @"切换城市";
    [UIImage imageNamed:@"btn_navigation_close_hl"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) Image:@"btn_navigation_close" highlightImage:@"btn_navigation_close_hl"];
    
    // 加载组数据
    self.cityGroups = [DPCityGroup objectArrayWithFilename:@"cityGroups.plist"];
}

- (void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate
/**
 *  键盘弹出：搜索框文字开始编辑
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 搜索框背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];
    
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 显示遮盖
    UIView *cover = [[UIView alloc] init];
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.5;
    cover.tag = DPCoverTag;
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:searchBar action:@selector(resignFirstResponder)]];
    [self.view addSubview:cover];
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.bottom.equalTo(self.tableView.mas_bottom);
        make.right.equalTo(self.tableView.mas_right);
        make.left.equalTo(self.tableView.mas_left);
    }];
    
}
/**
 *  键盘退下：搜索框文字结束编辑
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 搜索框背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    // 显示导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // 隐藏遮盖
    [[self.view viewWithTag:DPCoverTag] removeFromSuperview];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityGroups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DPCityGroup *cityGroup = self.cityGroups[section];
    return cityGroup.cities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 加载模型数据
    DPCityGroup  *cityGroup = self.cityGroups[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    DPCityGroup *cityGroup = self.cityGroups[section];
    return cityGroup.title;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // kvc
    return [self.cityGroups valueForKeyPath:@"title"];
}

#pragma mark - UITableViewDelegate

@end
