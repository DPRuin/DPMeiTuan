//
//  DPCity.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCity.h"
#import "MJExtension.h"
#import "DPRegion.h"

@implementation DPCity

- (NSDictionary *)objectClassInArray
{
    return @{@"regions" : [DPRegion class]};
}
@end
