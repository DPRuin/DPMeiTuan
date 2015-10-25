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
#import "DPSort.h"
#import "DPDeal.h"

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

static  NSArray *_sorts;
+ (NSArray *)sorts
{
    if (!_sorts) {
        _sorts = [DPSort objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}

+ (DPCategary *)categaryWithDeal:(DPDeal *)deal
{
    NSArray *categaries = [self categaries];
    NSString *categaryName  = [deal.categories firstObject];
    
    for (DPCategary *categary in categaries) {
        if ([categaryName isEqualToString:categary.name]) return categary;
        if ([categary.subcategories containsObject:categaryName]) return categary;
    }
    
    return nil;
}

@end
