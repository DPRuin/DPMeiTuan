//
//  DPHomeViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "DPHomeTopItem.h"
#import "DPCategaryViewController.h"
#import "DPDistrictViewController.h"
#import "DPMetalTool.h"
#import "DPCity.h"
#import "DPSortViewController.h"
#import "DPSort.h"
#import "DPRegion.h"
#import "DPCategary.h"

@interface DPHomeViewController ()
/** 分类 */
@property (nonatomic, weak) UIBarButtonItem *categaryItem;
/** 地区 */
@property (nonatomic, weak) UIBarButtonItem *districtItem;
/** 排序 */
@property (nonatomic, weak) UIBarButtonItem *sortItem;

/** 选中的城市 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 选中的排序 */
@property (nonatomic, strong) DPSort *selectedSort;

/** 分类popover */
@property (nonatomic, strong) UIPopoverController *categaryPopo;
/** 地区popover */
@property (nonatomic, strong) UIPopoverController *districtPopo;
/** 排序popover */
@property (nonatomic, strong) UIPopoverController *sortPopo;
@end

@implementation DPHomeViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // 设置背景色
    self.collectionView.backgroundColor = DPGlobalBg;
    
    // 设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
    
    // 监听城市改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:DPCityDidChangeNotification object:nil];
    // 监听排序改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:DPSortDidChangeNotification object:nil];
    // 监听区域改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(districtDidChange:) name:DPDistrictDidChangeNotification object:nil];
    // 监听分类改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categaryDidChange:) name:DPCategaryDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监听通知方法
/**
 *  分类改变通知方法
 */
- (void)categaryDidChange:(NSNotification *)notification
{
    DPCategary *categary = notification.userInfo[DPSelectCategary];
    NSString *subCategaryName = notification.userInfo[DPSelectSubCategaryName];
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.categaryItem.customView;
    [topItem setTitle:categary.name];
    [topItem setSubTitle:subCategaryName];
    [topItem setIcon:[UIImage imageNamed:categary.icon] highIcon:[UIImage imageNamed:categary.highlighted_icon]];
    
    // 关闭popover
    [self.categaryPopo dismissPopoverAnimated:YES];
    
    // 刷新表格数据
#warning todo
}

/**
 *  区域改变通知方法
 */
- (void)districtDidChange:(NSNotification *)notification
{
    DPRegion *region = notification.userInfo[DPSelectRegion];
    NSString *subregionName = notification.userInfo[DPSelectSubregionName];
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.districtItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@", self.selectedCityName, region.name]];
    [topItem setSubTitle:subregionName];
    
    // 关闭popover
    [self.districtPopo dismissPopoverAnimated:YES];
    
    // 刷新表格数据
#warning todo
}

/**
 *  排序改变通知方法
 */
- (void)sortDidChange:(NSNotification *)notification
{
    self.selectedSort = notification.userInfo[DPSelectSort];
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.sortItem.customView;
    [topItem setSubTitle:self.selectedSort.label];
    
    // 关闭popover
    [self.sortPopo dismissPopoverAnimated:YES];
    
    // 刷新表格数据
#warning todo
}

/**
 *  城市改变通知方法
 */
- (void)cityDidChange:(NSNotification *)notification
{
    self.selectedCityName = notification.userInfo[DPSelectCityName];
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.districtItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectedCityName]];
    [topItem setSubTitle:nil];
    
    // 刷新表格数据
#warning todo
    
}

#pragma mark - 设置导航栏内容
- (void)setupLeftNav
{
    // logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    // 类别
    DPHomeTopItem *categaryTopItem = [DPHomeTopItem item];
    [categaryTopItem addTarget:self action:@selector(categaryClick)];
    UIBarButtonItem *categaryItem = [[UIBarButtonItem alloc] initWithCustomView:categaryTopItem];
    self.categaryItem = categaryItem;
    
    // 地区
    DPHomeTopItem *districtTopItem = [DPHomeTopItem item];
    [districtTopItem addTarget:self action:@selector(districtClick)];
    [districtTopItem setIcon:[UIImage imageNamed:@"icon_district"] highIcon:[UIImage imageNamed:@"icon_district_highlighted"]];
    UIBarButtonItem *districtItem = [[UIBarButtonItem alloc] initWithCustomView:districtTopItem];
    self.districtItem = districtItem;
    
    // 排序
    DPHomeTopItem *sortTopItem = [DPHomeTopItem item];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    [sortTopItem setTitle:@"排序"];
    [sortTopItem setIcon:[UIImage imageNamed:@"icon_sort"] highIcon:[UIImage imageNamed:@"icon_sort_highlighted"]];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem, categaryItem, districtItem, sortItem];
}

- (void)setupRightNav
{
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:nil action:nil Image:@"icon_map" highlightImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:nil action:nil Image:@"icon_search" highlightImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - 导航栏按钮点击
- (void)categaryClick
{
    // 显示分类菜单
    // 创建popo
    UIPopoverController *popo = [[UIPopoverController alloc] initWithContentViewController:[[DPCategaryViewController alloc] init]];
    // 显示popo
    [popo presentPopoverFromBarButtonItem:self.categaryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.categaryPopo = popo;
}

- (void)districtClick
{
    DPDistrictViewController *districtViewController = [[DPDistrictViewController alloc] init];
    if (self.selectedCityName) {
        // 当前选中的城市
        NSPredicate *perdicate = [NSPredicate predicateWithFormat:@"name = %@", self.selectedCityName];
        DPCity *selectedCity = [[[DPMetalTool cities] filteredArrayUsingPredicate:perdicate] lastObject];
        //加载区域数据
        districtViewController.regions = selectedCity.regions;
    }
    
    // 显示区域菜单
    UIPopoverController *popo = [[UIPopoverController alloc] initWithContentViewController:districtViewController];
    [popo presentPopoverFromBarButtonItem:self.districtItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.districtPopo = popo;
    districtViewController.districtPopo = popo;
}

- (void)sortClick
{
    // 显示区域菜单
    UIPopoverController *popo = [[UIPopoverController alloc] initWithContentViewController:[[DPSortViewController alloc] init]];
    [popo presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    self.sortPopo = popo;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete method implementation -- Return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
