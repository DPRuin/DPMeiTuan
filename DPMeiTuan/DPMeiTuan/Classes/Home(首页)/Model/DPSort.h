//
//  DPSort.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/17.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPSort : NSObject
/** 排序名称 */
@property (nonatomic, copy) NSString *label;
/** 排序的值（将来发给服务器） */
@property (nonatomic, assign) int value;

@end
