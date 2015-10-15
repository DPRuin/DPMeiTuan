//
//  DPCityGroup.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCityGroup : NSObject
/** 组名 */
@property (nonatomic, copy) NSString *title;
/** 组（存放字符串城市名称） */
@property (nonatomic, strong) NSArray *cities;
@end
