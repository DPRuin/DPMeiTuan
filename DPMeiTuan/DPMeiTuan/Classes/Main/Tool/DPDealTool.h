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
 *  返回第page页的收藏团购数据:page从1开始
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

/**
 *  收藏的团购的数量
 */
+ (int)collectDealsCount;


/**
 *  返回第page页的最近团购数据:page从1开始
 */
+ (NSArray *)recentDeals:(int)page;

/**
 *  记录一个团购
 */
+ (void)addRecentDeal:(DPDeal *)deal;

/**
 *  取消记录一个团购
 */
+ (void)removeRecentDeal:(DPDeal *)deal;

/**
 *  记录的团购的数量
 */
+ (int)recentDealsCount;

/**
 *  团购是否记录
 */
+ (BOOL)isRecented:(DPDeal *)deal;
@end
