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
#import "DPCategary.h"

@interface DPCategaryViewController () <DPHomeDropdownDataSource, DPHomeDropdownDelegate>

@end

@implementation DPCategaryViewController

- (void)loadView
{
    DPHomeDropdown *dropdown = [DPHomeDropdown dropdown];
    // 设置数据源
    dropdown.dataSource = self;
    dropdown.delegate = self;
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

#pragma mark - DPHomeDropdownDelegate
- (void)homeDropdown:(DPHomeDropdown *)dropdown didSelectRowInMainTable:(NSInteger)row
{
    // 取出模型
    DPCategary *categary = [DPMetalTool categaries][row];
    // 发出通知
    if (categary.subcategories.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DPCategaryDidChangeNotification object:nil userInfo:@{DPSelectCategary : categary}];
    }
    
}
- (void)homeDropdown:(DPHomeDropdown *)dropdown didSelectRowInSubTable:(NSInteger)subRow inMainTable:(NSInteger)mainRow
{
    // 取出模型
    DPCategary *categary = [DPMetalTool categaries][mainRow];
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DPCategaryDidChangeNotification object:nil userInfo:@{DPSelectCategary : categary, DPSelectSubCategaryName : categary.subcategories[subRow]}];
}
@end
