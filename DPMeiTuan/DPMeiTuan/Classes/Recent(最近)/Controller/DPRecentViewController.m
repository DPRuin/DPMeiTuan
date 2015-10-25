//
//  DPRecentViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/19.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPRecentViewController.h"
#import "DPDealTool.h"

@interface DPRecentViewController ()

@end

@implementation DPRecentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近浏览记录";
}

#pragma mark - 实现父类的方法
- (UIImage *)emptyIcon
{
    return [UIImage imageNamed:@"icon_latestBrowse_empty"];
}

- (NSInteger)dealsCount
{
    return [DPDealTool recentDealsCount];
}

- (NSArray *)moreDeals:(int)page
{
    return [DPDealTool recentDeals:page];
}

- (void)removeDeal:(DPDeal *)deal
{
    [DPDealTool removeRecentDeal:deal];
}

@end
