//
//  DPCategaryViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCategaryViewController.h"
#import "DPHomeDropdown.h"
#import "DPMetalTool.h"

@interface DPCategaryViewController () <DPHomeDropdownDataSource>

@end

@implementation DPCategaryViewController

- (void)loadView
{
    DPHomeDropdown *dropdown = [DPHomeDropdown dropdown];
    // 设置数据源
    dropdown.dataSource = self;
    self.view = dropdown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - DPHomeDropdownDataSource
- (NSInteger)numberOfRowsHomeDropdow:(DPHomeDropdown *)dropdown
{
    return [DPMetalTool categaries].count;
}
- (id<DPHomeDropdownData>)homeDropdown:(DPHomeDropdown *)dropdown dataForRow:(NSInteger)row
{
    return [DPMetalTool categaries][row];
}

@end
