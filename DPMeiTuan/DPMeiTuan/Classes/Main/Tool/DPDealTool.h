//
//  DPDealTool.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/21.
//  Copyright (c) 2015年 DP. All rights reserved.
//  数据库团购工具类

#import <Foundation/Foundation.h>
@class DPDeal;

@interface DPDealTool : NSObject
/**
 *  返回第page页的团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;

/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(DPDeal *)deal;

/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(DPDeal *)deal;

/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(DPDeal *)deal;
@end
