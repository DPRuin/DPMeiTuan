//
//  DPCollectViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/19.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCollectViewController.h"
#import "DPDealTool.h"

@interface DPCollectViewController ()

@end

@implementation DPCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏的团购";
    
}

#pragma mark - 实现父类的方法
- (UIImage *)emptyIcon
{
    return [UIImage imageNamed:@"icon_collects_empty"];
}

- (NSInteger)dealsCount
{
    return [DPDealTool collectDealsCount];
}

- (NSArray *)moreDeals:(int)page
{
    return [DPDealTool collectDeals:page];
}

- (void)removeDeal:(DPDeal *)deal
{
    [DPDealTool removeCollectDeal:deal];
}
@end
