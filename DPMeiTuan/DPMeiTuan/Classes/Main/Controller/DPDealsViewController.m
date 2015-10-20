//
//  DPDealsViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/19.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDealsViewController.h"
#import "UIView+Extension.h"
#import "DPAPI.h"
#import "DPDealCell.h"
#import "MJExtension.h"
#import "DPDeal.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "DPDetailViewController.h"

@interface DPDealsViewController () <DPRequestDelegate>

/** 所有的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 最后一个网络请求 */
@property (nonatomic, strong) DPRequest *lastRequest;

/** 没有团购数据图片提示 */
@property (nonatomic, weak) UIImageView *noDateView;

/** 总数 */
@property (nonatomic, assign) int totalCount;
@end

@implementation DPDealsViewController

static NSString * const reuseIdentifier = @"DPDealCell";

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"DPDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 设置背景色
    self.collectionView.backgroundColor = DPGlobalBg;
    
    // 设置垂直方向上可以拉动
    self.collectionView.alwaysBounceVertical = YES;
    
    // 添加上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    // 添加下拉刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}

/**
 *  屏幕旋转就会调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // 横屏3列 竖屏2列
    int cols = (size.width == 1024) ? 3: 2;
    
    // 根据列数计算内边距
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat insert = (size.width - cols * flowLayout.itemSize.width) / (cols +1);
    flowLayout.sectionInset = UIEdgeInsetsMake(insert, insert, insert, insert);
    
    // 设置行间距
    flowLayout.minimumLineSpacing = insert * 0.5;
    
}

#pragma mark - 懒加载
- (UIImageView *)noDateView
{
    if (!_noDateView) {
        UIImageView *noDateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        [self.collectionView addSubview:noDateView];
        [noDateView autoCenterInSuperview];
        self.noDateView = noDateView;
    }
    return _noDateView;
}
- (NSMutableArray *)deals
{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

#pragma mark - 与服务器交互
- (void)loadDeals
{
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // 调用子类实现的方法
    [self setupParams:params];
    // 每页限制条数
    params[@"limit"] = @(30);
    
    // 页码
    params[@"page"] = @(self.currentPage);
    
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params  delegate:self];
}
- (void)loadMoreDeals
{
    self.currentPage++;
    [self loadDeals];
    
}

- (void)loadNewDeals
{
    self.currentPage = 1;
    
    [self loadDeals];
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    // 不是最后一次网络请求直接返回
    if (self.lastRequest != request) return;
    self.totalCount = [result[@"total_count"] intValue];
    
    // 字典数组 转 模型数组
    NSArray *newDeals = [DPDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    
    if (self.currentPage == 1) { // 清楚之前的就数据
        [self.deals removeAllObjects];
    }
    
    [self.deals addObjectsFromArray:newDeals];
    
    // 刷新表格数据
    [self.collectionView reloadData];
    
    // 结束上拉刷新
    [self.collectionView footerEndRefreshing];
    // 结束下拉刷新
    [self.collectionView headerEndRefreshing];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    // 只处理最后的请求失败
    if (self.lastRequest != request) return;
    
    [MBProgressHUD showError:@"网络繁忙，请稍后再试" toView:self.collectionView];
    
    // 结束上拉刷新
    [self.collectionView footerEndRefreshing];
    // 结束下拉刷新
    [self.collectionView headerEndRefreshing];
    
    // 如果上拉加载失败了
    if (self.currentPage > 1) {
        self.currentPage--;
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 控制尾部刷新控件的显示和隐藏
    self.collectionView.footerHidden = (self.deals.count == self.totalCount);
    
    // 计算一遍内边距
    [self viewWillTransitionToSize:collectionView.size withTransitionCoordinator:nil];
    
    // 控制没有数据的提醒
    self.noDateView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DPDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // 传递模型数据
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DPDetailViewController *detailVC = [[DPDetailViewController alloc] init];
    detailVC.deal = self.deals[indexPath.item];
    [self presentViewController:detailVC animated:YES completion:nil];
}


@end
