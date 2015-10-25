//
//  DPMetalTool.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/16.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DPCategary, DPDeal, DPSort;

@interface DPMetalTool : NSObject
/**
 *  返回所有城市模型数组
 */
+ (NSArray *)cities;

/**
 *  返回分类模型数组
 */
+ (NSArray *)categaries;
+ (DPCategary *)categaryWithDeal:(DPDeal *)deal;

/**
 *  返回排序模型数组
 */
+ (NSArray *)sorts;


/**
 *  存储选中的城市名称
 */
+ (void)saveSelectedCityName:(NSString *)name;
/**
 *  存储选中的排序
 */
+ (void)saveSelectedSort:(DPSort *)sort;
+ (NSString *)selectedCityName;
+ (DPSort *)selectedSort;
@end
