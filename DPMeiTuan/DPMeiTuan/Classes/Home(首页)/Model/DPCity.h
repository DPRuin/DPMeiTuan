//
//  DPCity.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCity : NSObject
/** 城市的名称 */
@property (nonatomic, copy) NSString *name;
/** 城市的名称拼音 */
@property (nonatomic, copy) NSString *pinYin;
/** 城市名称拼音首字母 */
@property (nonatomic, copy) NSString *pinYinHead;
/** 区域（存放DPRegin模型） */
@property (nonatomic, strong) NSArray *regions;
@end
