//
//  DPDeal.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/18.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDeal.h"
#import "MJExtension.h"
#import "DPBusiness.h"

@implementation DPDeal
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

- (BOOL)isEqual:(DPDeal *)other
{
    return [self.deal_id isEqual:other.deal_id];
}

- (NSDictionary *)objectClassInArray
{
    return @{@"businesses" : [DPBusiness class]};
}

MJCodingImplementation
@end
