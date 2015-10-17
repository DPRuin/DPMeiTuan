//
//  DPDistrictViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDistrictViewController.h"
#import "DPCityViewController.h"
#import "DPNavigationController.h"
#import "DPHomeDropdown.h"
#import "UIView+AutoLayout.h"
#import "DPMetalTool.h"
#import "DPRegion.h"

@interface DPDistrictViewController () <DPHomeDropdownDataSource, DPHomeDropdownDelegate>
- (IBAction)changeCity:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation DPDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建下拉菜单
    DPHomeDropdown *dropdown = [DPHomeDropdown dropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    [self.view addSubview:dropdown];
    // 添加约束
    [dropdown autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [dropdown autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topView];

}

/**
 *  切换城市
 */
- (IBAction)changeCity:(UIButton *)sender {
    // 清除popo
    [self.districtPopo dismissPopoverAnimated:YES];
    
    DPCityViewController *city = [[DPCityViewController alloc] init];
    DPNavigationController *nav = [[DPNavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - DPHomeDropdownDataSource
- (NSInteger)numberOfRowsHomeDropdow:(DPHomeDropdown *)dropdown
{
    return self.regions.count;
}

- (id<DPHomeDropdownData>)homeDropdown:(DPHomeDropdown *)dropdown dataForRow:(NSInteger)row
{
    return self.regions[row];
}

#pragma mark - DPHomeDropdownDelegate
- (void)homeDropdown:(DPHomeDropdown *)dropdown didSelectRowInMainTable:(NSInteger)row
{
    // 取出模型
    DPRegion *region = self.regions[row];
    // 发出通知
    if (region.subregions.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DPDistrictDidChangeNotification object:nil userInfo:@{DPSelectRegion : region}];
    }
    
}
- (void)homeDropdown:(DPHomeDropdown *)dropdown didSelectRowInSubTable:(NSInteger)subRow inMainTable:(NSInteger)mainRow
{
    // 取出模型
    DPRegion *region = self.regions[mainRow];
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DPDistrictDidChangeNotification object:nil userInfo:@{DPSelectRegion : region, DPSelectSubregionName : region.subregions[subRow]}];
}
@end
