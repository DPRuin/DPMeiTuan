//
//  DPMetalTool.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/16.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPMetalTool.h"
#import "DPCategary.h"
#import "DPCity.h"
#import "MJExtension.h"

@implementation DPMetalTool

static  NSArray *_cities;
+ (NSArray *)cities
{
   if (!_cities) {
       _cities = [DPCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}

static  NSArray *_categaries;
+ (NSArray *)categaries
{
    if (!_categaries) {
        _categaries = [DPCategary objectArrayWithFilename:@"categories.plist"];
    }
    return _categaries;
}

@end
