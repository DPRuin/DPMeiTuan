//
//  DPDetailViewController.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/20.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPDeal;

@interface DPDetailViewController : UIViewController
/** 模型数据 */
@property (nonatomic, strong) DPDeal *deal;
@end
