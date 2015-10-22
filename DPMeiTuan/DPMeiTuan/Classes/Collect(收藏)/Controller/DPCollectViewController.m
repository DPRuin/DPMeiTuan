//
//  DPCollectViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/19.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCollectViewController.h"
#import "MJRefresh.h"
#import "UIView+AutoLayout.h"
#import "UIView+Extension.h"
#import "DPDealCell.h"
#import "DPDetailViewController.h"
#import "DPDealTool.h"
#import "UIBarButtonItem+Extension.h"

NSString *const MTEdit = @"编辑";
NSString *const MTDone = @"完成";
#define DPString(str) [NSString stringWithFormat:@"  %@  ", str]


@interface DPCollectViewController ()

/** 收藏的团购数据 */
@property (nonatomic, strong) NSMutableArray *deals;

/** 没有收藏团购数据图片提示 */
@property (nonatomic, weak) UIImageView *noDateView;

/** 加载收藏团购数据页数 */
@property (nonatomic, assign) int currentPage;


@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *selectAllItem;
@property (nonatomic, strong) UIBarButtonItem *unselectAllbackItem;
@property (nonatomic, strong) UIBarButtonItem *removeItem;

@end

@implementation DPCollectViewController

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
    
    self.title = @"收藏的团购";
    // 设置背景色
    self.collectionView.backgroundColor = DPGlobalBg;
    // 设置垂直方向上可以拉动
    self.collectionView.alwaysBounceVertical = YES;
    
    // 左边返回
    self.navigationItem.leftBarButtonItems = @[self.backItem];

    // 右边编辑
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTEdit style:UIBarButtonItemStyleDone target:self action:@selector(edit:)];
    
    // 添加上拉刷新
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    
    // 加载第一页的收藏数据
    [self loadMoreDeals];
    
    // 监听收藏状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CollectStateDidChange:) name:DPCollectStateDidChangeNotification object:nil];
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

- (void)loadMoreDeals
{
    // 增加页码
    self.currentPage++;
    // 加载新数据
    [self.deals addObjectsFromArray:[DPDealTool collectDeals:self.currentPage]];
    
    // 刷新表格数据
    [self.collectionView reloadData];
    
    // 结束刷新
    [self.collectionView footerEndRefreshing];
    
}

#pragma mark - 懒加载
- (UIImageView *)noDateView
{
    if (!_noDateView) {
        UIImageView *noDateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_collects_empty"]];
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

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) Image:@"icon_back" highlightImage:@"icon_back_highlighted"];
    }
    return _backItem;
}

- (UIBarButtonItem *)selectAllItem
{
    if (!_selectAllItem) {
        self.selectAllItem = [[UIBarButtonItem alloc] initWithTitle:DPString(@"全选") style:UIBarButtonItemStyleDone target:self action:@selector(selectAll)];
    }
    return _selectAllItem;
}

- (UIBarButtonItem *)unselectAllbackItem
{
    if (!_unselectAllbackItem) {
        self.unselectAllbackItem = [[UIBarButtonItem alloc] initWithTitle:DPString(@"全不选") style:UIBarButtonItemStyleDone target:self action:@selector(unselectAllback)];
    }
    return _unselectAllbackItem;
}

- (UIBarButtonItem *)removeItem
{
    if (!_removeItem) {
        self.removeItem = [[UIBarButtonItem alloc] initWithTitle:DPString(@"删除") style:UIBarButtonItemStyleDone target:self action:@selector(remove)];
    }
    return _removeItem;
}

#pragma mark - 按钮点击
- (void)edit:(UIBarButtonItem *)btnItem
{
    if ([btnItem.title isEqualToString:MTEdit]) { // 编辑
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.selectAllItem, self.unselectAllbackItem, self.removeItem];
        [btnItem setTitle:MTDone];
    } else { // 完成
        self.navigationItem.leftBarButtonItems = @[self.backItem];
        [btnItem setTitle:MTEdit];
    }
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectAll
{
    
}

- (void)unselectAllback
{
    
}

- (void)remove
{
    
}


#pragma mark - 监听通知方法
- (void)CollectStateDidChange:(NSNotification *)notification
{
//    if ([notification.userInfo[DPIsCollectedKey] boolValue]) { // 收藏成功
//        [self.deals insertObject:notification.userInfo[DPCollectDealKey] atIndex:0];
//    } else { // 取消收藏成功
//        [self.deals removeObject:notification.userInfo[DPCollectDealKey]];
//    }
    
    [self.deals removeAllObjects];
    self.currentPage = 0;
    [self loadMoreDeals];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    // 控制尾部刷新控件的显示和隐藏
    self.collectionView.footerHidden = (self.deals.count == [DPDealTool collectDealsCount]);
    
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
