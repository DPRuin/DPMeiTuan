//
//  DPCity.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCity.h"
#import "MJExtension.h"
#import "DPRegin.h"

@implementation DPCity

- (NSDictionary *)dictionaryWithValuesForKeys:(NSArray *)keys
{
    return @{@"regions" : [DPRegin class]};
}
@end
