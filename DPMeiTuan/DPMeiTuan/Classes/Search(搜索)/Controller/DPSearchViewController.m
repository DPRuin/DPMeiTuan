//
//  DPSearchViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/19.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPSearchViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MJRefresh.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"

@interface DPSearchViewController () <UISearchBarDelegate>
@property (nonatomic, copy) NSString *keyWord;
@end

@implementation DPSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置背景色
    self.collectionView.backgroundColor = DPGlobalBg;
    
    // 左边返回
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) Image:@"icon_back" highlightImage:@"icon_back_highlighted"];
    // 中间搜索框
    [self setupSearchBar];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入关键词";
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    searchBar.tintColor = DPGreenColor;
    
    UIView *titleView = [[UIView alloc] init];
    titleView.width = 480;
    titleView.height = 30;
    [titleView addSubview:searchBar];
    
    self.navigationItem.titleView = titleView;
    [searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}
#pragma mark - 实现父类的方法
- (void)setupParams:(NSMutableDictionary *)params
{
    // 城市
    params[@"city"] = self.cityName;
    // 关键字
    params[@"keyword"] = self.keyWord;
}

#pragma mark - UISearchBarDelegate
/**
 *  键盘弹出：搜索框文字开始编辑
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // 搜索框背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield_hl"];

    // 显示搜索框取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
}

/**
 *  键盘退下：搜索框文字结束编辑
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    // 搜索框背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"bg_login_textfield"];
    
    // 隐藏搜索框取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.keyWord = searchBar.text;
    // 进入下拉刷新状态 发送请求给服务器
    [self.collectionView headerBeginRefreshing];
    
    // 退出键盘
    [searchBar resignFirstResponder];
}

/**
 *  搜索框右边取消按钮点击了就会调用
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    searchBar.text = nil;
}
@end
