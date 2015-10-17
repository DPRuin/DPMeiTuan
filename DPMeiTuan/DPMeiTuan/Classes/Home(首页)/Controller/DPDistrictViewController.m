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

@interface DPDistrictViewController () <DPHomeDropdownDataSource>
- (IBAction)changeCity:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation DPDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建下拉菜单
    DPHomeDropdown *dropdown = [DPHomeDropdown dropdown];
    dropdown.backgroundColor = [UIColor redColor];
    dropdown.dataSource = self;
    [self.view addSubview:dropdown];
    // 添加约束
    [dropdown autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [dropdown autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topView];

}

/**
 *  切换城市
 */
- (IBAction)changeCity:(UIButton *)sender {
    
    DPCityViewController *city = [[DPCityViewController alloc] init];
    DPNavigationController *nav = [[DPNavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:nav animated:YES completion:nil];
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

@end
