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
#import "DPNavigationController.h"
#import "DPSearchViewController.h"
#import "MJRefresh.h"
#import "AwesomeMenu.h"
#import "UIView+AutoLayout.h"
#import "DPCollectViewController.h"
#import "DPRecentViewController.h"
#import "MBProgressHUD+MJ.h"
#import "DPMapViewController.h"

NSString *const DPLastSelectedCityKey = @"DPLastSelectedCity";

@interface DPHomeViewController () <AwesomeMenuDelegate>
/** 分类 */
@property (nonatomic, weak) UIBarButtonItem *categaryItem;
/** 地区 */
@property (nonatomic, weak) UIBarButtonItem *districtItem;
/** 排序 */
@property (nonatomic, weak) UIBarButtonItem *sortItem;

/** 选中的城市 */
@property (nonatomic, copy) NSString *selectedCityName;
/** 选中的区域 */
@property (nonatomic, copy) NSString *selectedReginName;
/** 选中的分类 */
@property (nonatomic, copy) NSString *selectedCategaryName;
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

- (instancetype)init
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 进入刷新
    self.selectedCityName = [[NSUserDefaults standardUserDefaults] objectForKey:DPLastSelectedCityKey];
    [self.collectionView headerBeginRefreshing];
    
    // 设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
    
    // 监听通知
    [self setupNotification];
    
    // 初始化Aswesome
    [self setupAwesomeMenu];
    

    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 创建Aswesome
- (void)setupAwesomeMenu
{
    
    AwesomeMenuItem *starMenuItem0 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                                                           highlightedImage:nil
                                                               ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"]
                                                    highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                                                           highlightedImage:nil
                                                               ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"]
                                                    highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                                                           highlightedImage:nil
                                                               ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"]
                                                    highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    
    
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"]
                                                           highlightedImage:nil
                                                               ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"]
                                                    highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];

    NSArray *menus = @[starMenuItem0, starMenuItem1, starMenuItem2, starMenuItem3];
    
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"]
                                                       highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"]
                                                           ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]
                                                highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:CGRectZero startItem:startItem menuItems:menus];
    menu.delegate = self;
    menu.menuWholeAngle = M_PI_2;
    menu.animationDuration = 0.5;
    menu.startPoint = CGPointMake(50.0, 150.0);
    menu.alpha = 0.5;
    // 不要旋转中间按钮
    menu.rotateAddButton = NO;
    [self.view addSubview:menu];
    
    // 添加约束
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
    
    
}
#pragma mark - AwesomeMenuDelegate
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
    switch (idx) {
        case 1: { // 收藏
            DPNavigationController *collectNav = [[DPNavigationController alloc] initWithRootViewController:[[DPCollectViewController alloc] init]];
            [self presentViewController:collectNav animated:YES completion:nil];
            break;
        }
        case 2: { // 最近
            DPNavigationController *recentNav = [[DPNavigationController alloc] initWithRootViewController:[[DPRecentViewController alloc] init]];
            [self presentViewController:recentNav animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
    
    // 更改图片
    [menu setContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]];
    // 半透明显示
    menu.alpha = 0.5;
    
}
- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    // 更改图片
    [menu setContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"]];
    // 半透明显示
    menu.alpha = 0.5;
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {

    // 更改图片
    [menu setContentImage:[UIImage imageNamed:@"icon_pathMenu_cross_normal"]];
    // 完全显示
    menu.alpha = 1.0;
}

#pragma mark - 实现父类的方法
- (void)setupParams:(NSMutableDictionary *)params
{
    // 城市
    params[@"city"] = self.selectedCityName;
    
    // 排序
    if (self.selectedSort.value) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    // 区域
    if (self.selectedReginName) {
        params[@"region"] = self.selectedReginName;
    }
    // 分类
    if (self.selectedCategaryName) {
        params[@"category"] = self.selectedCategaryName;
    }
}

#pragma mark - 监听通知方法
/**
 *  监听通知
 */
- (void)setupNotification
{
    // 监听城市改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:DPCityDidChangeNotification object:nil];
    // 监听排序改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:DPSortDidChangeNotification object:nil];
    // 监听区域改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(districtDidChange:) name:DPDistrictDidChangeNotification object:nil];
    // 监听分类改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categaryDidChange:) name:DPCategaryDidChangeNotification object:nil];
}

/**
 *  分类改变通知方法
 */
- (void)categaryDidChange:(NSNotification *)notification
{
    DPCategary *categary = notification.userInfo[DPSelectCategary];
    NSString *subCategaryName = notification.userInfo[DPSelectSubCategaryName];
    
    if (subCategaryName == nil || [subCategaryName isEqualToString:@"全部"]) { // 没有次表
        self.selectedCategaryName = categary.name;
    } else {
        self.selectedCategaryName = subCategaryName;
    }
    if ([self.selectedCategaryName isEqualToString:@"全部分类"]) {
        self.selectedCategaryName = nil;
    }
    
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.categaryItem.customView;
    [topItem setTitle:categary.name];
    [topItem setSubTitle:subCategaryName];
    [topItem setIcon:[UIImage imageNamed:categary.icon] highIcon:[UIImage imageNamed:categary.highlighted_icon]];
    
    // 关闭popover
    [self.categaryPopo dismissPopoverAnimated:YES];
    
    // 刷新表格数据
    [self.collectionView headerBeginRefreshing];
}

/**
 *  区域改变通知方法
 */
- (void)districtDidChange:(NSNotification *)notification
{
    DPRegion *region = notification.userInfo[DPSelectRegion];
    NSString *subregionName = notification.userInfo[DPSelectSubregionName];
    
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) { // 没有次表
        self.selectedReginName = region.name;
    } else {
        self.selectedReginName = subregionName;
    }
    if ([self.selectedReginName isEqualToString:@"全部"]) {
        self.selectedReginName = nil;
    }
    
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.districtItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@", self.selectedCityName, region.name]];
    [topItem setSubTitle:subregionName];
    
    // 关闭popover
    [self.districtPopo dismissPopoverAnimated:YES];
    
    // 刷新表格数据
    [self.collectionView headerBeginRefreshing];
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
    [self.collectionView headerBeginRefreshing];
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
    [self.collectionView headerBeginRefreshing];
    
    
    // 将当前城市存进沙盒
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedCityName forKey:DPLastSelectedCityKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - 设置导航栏内容
- (void)setupLeftNav
{
    // logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    
    // 类别
    DPHomeTopItem *categaryTopItem = [DPHomeTopItem item];
    [categaryTopItem setIcon:[UIImage imageNamed:@"icon_category_-1"] highIcon:[UIImage imageNamed:@"icon_category_highlighted_-1"]];
    [categaryTopItem setTitle:@"全部分类"];
    [categaryTopItem addTarget:self action:@selector(categaryClick)];
    UIBarButtonItem *categaryItem = [[UIBarButtonItem alloc] initWithCustomView:categaryTopItem];
    self.categaryItem = categaryItem;
    
    // 地区
    DPHomeTopItem *districtTopItem = [DPHomeTopItem item];
    [districtTopItem setTitle:[NSString stringWithFormat:@"%@ - 全部", self.selectedCityName]];
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
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:self action:@selector(mapClick) Image:@"icon_map" highlightImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(searchClick) Image:@"icon_search" highlightImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem, searchItem];
}

#pragma mark - 导航栏按钮点击
- (void)mapClick
{
    DPNavigationController *mapNav = [[DPNavigationController alloc] initWithRootViewController:[[DPMapViewController alloc] init]];
    [self presentViewController:mapNav animated:YES completion:nil];
}

- (void)searchClick
{
    if (self.selectedCityName) { // 选中了城市
        DPSearchViewController *searchViewController = [[DPSearchViewController alloc] init];
        searchViewController.cityName = self.selectedCityName;
        
        DPNavigationController *searchNav = [[DPNavigationController alloc] initWithRootViewController:searchViewController];
        [self presentViewController:searchNav animated:YES completion:nil];
    } else { // 未选中城市
        [MBProgressHUD showError:@"请选择城市后再搜索" toView:self.view];
    }

}

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

@end
