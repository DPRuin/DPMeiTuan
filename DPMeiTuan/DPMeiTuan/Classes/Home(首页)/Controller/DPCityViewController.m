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
#import "DPCitySearchResultViewController.h"
#import "UIView+AutoLayout.h"

@interface DPCityViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *cityGroups;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 搜索框 */
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

/** 遮盖 */
@property (weak, nonatomic) IBOutlet UIButton *cover;
- (IBAction)coverClick:(UIButton *)sender;

@property (nonatomic, weak) DPCitySearchResultViewController *citySearchResult;

@end

@implementation DPCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 导航栏内容基本设置
    self.title = @"切换城市";
    [UIImage imageNamed:@"btn_navigation_close_hl"];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) Image:@"btn_navigation_close" highlightImage:@"btn_navigation_close_hl"];
    
    // self.tableView.sectionIndexBackgroundColor = [UIColor blackColor];
    // 修改城市组索引颜色
    self.tableView.sectionIndexColor = DPGreenColor;
    
    // 加载组数据
    self.cityGroups = [DPCityGroup objectArrayWithFilename:@"cityGroups.plist"];
    
    // 搜索框取消按钮和光标的颜色为绿色
    self.searchBar.tintColor = DPGreenColor;
    
}

#pragma mark - 懒加载
- (DPCitySearchResultViewController *)citySearchResult
{
    if (!_citySearchResult) {
        DPCitySearchResultViewController *citySearchResult = [[DPCitySearchResultViewController alloc] init];
        [self addChildViewController:citySearchResult];
        self.citySearchResult = citySearchResult;
        
        [self.view addSubview:self.citySearchResult.view];
        [self.citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        [self.citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:15];
    }
    return _citySearchResult;
}

#pragma mark - 按钮点击
/**
 *  导航栏返回点击
 */
- (void)close
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  遮盖按钮点击
 */
- (IBAction)coverClick:(UIButton *)sender {
    [self.searchBar resignFirstResponder];
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
    // 显示搜索框取消按钮
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    // 显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.5;
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
    
    // 隐藏搜索框取消按钮
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    // 隐藏遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0;
    }];
    
    // 搜索结果移除
    self.citySearchResult.view.hidden = YES;
    self.searchBar.text = nil;
}

/**
 *  搜索框右边取消按钮点击了就会调用
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/**
 *  搜索框里面的文字改变就会调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    } else {
        self.citySearchResult.view.hidden = YES;
    }
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

/**
 *  显示城市组索引
 */
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    // kvc
    return [self.cityGroups valueForKeyPath:@"title"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DPCityGroup *cityGroup = self.cityGroups[indexPath.section];
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DPCityDidChangeNotification object:nil userInfo:@{DPSelectCityName : cityGroup.cities[indexPath.row]}];
    
    // 移除控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
