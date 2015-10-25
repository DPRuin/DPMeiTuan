//
//  DPBusiness.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/25.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPBusiness : NSObject

/** 店名 */
@property (nonatomic, copy) NSString *name;
/** 纬度 */
@property (nonatomic, assign) float latitude;
/** 经度 */
@property (nonatomic, assign) float longitude;

@end
