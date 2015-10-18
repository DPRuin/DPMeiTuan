//
//  DPDeal.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/18.
//  Copyright (c) 2015年 DP. All rights reserved.
//  -个团购的数据模型

#import <Foundation/Foundation.h>

@interface DPDeal : NSObject
/** 团购单ID */
@property (nonatomic, copy) NSString *deal_id;
/** 团购标题 */
@property (nonatomic, copy) NSString *title;
/** 团购描述 */
@property (nonatomic, copy) NSString *desc;

/** 团购包含商品原价值 */
@property (nonatomic, assign) float list_price;
/** 团购价格 */
@property (nonatomic, assign) float current_price;

/** 团购当前已购买数 */
@property (nonatomic, assign) int purchase_count;

/** 团购图片链接，最大图片尺寸450×280 */
@property (nonatomic, copy) NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160×100 */
@property (nonatomic, copy) NSString *s_image_url;
@end
