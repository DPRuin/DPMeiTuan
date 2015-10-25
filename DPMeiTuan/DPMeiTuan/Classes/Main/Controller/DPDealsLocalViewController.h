//
//  DPDealsLocalViewController.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/26.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPDeal;

@interface DPDealsLocalViewController : UICollectionViewController

- (UIImage *)emptyIcon;

- (NSInteger)dealsCount;

- (NSArray *)moreDeals:(int)page;

- (void)removeDeal:(DPDeal *)deal;

@end
