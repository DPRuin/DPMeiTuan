//
//  DPDistrictViewController.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//  区域控制器：显示区域列表

#import <UIKit/UIKit.h>

@interface DPDistrictViewController : UIViewController
/** 区域模型数组（存放DPRegion模型） */
@property (nonatomic, strong) NSArray *regions;

@property (nonatomic, weak) UIPopoverController *districtPopo;
@end
