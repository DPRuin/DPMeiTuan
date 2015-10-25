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

#define DPSelectedCityNamesFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selectedCityNames.plist"]
#define DPSelectedSortFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"selectedSort.data"]

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

#pragma mark - 存储方法
static NSMutableArray *_selectedCityNames;
+ (NSMutableArray *)selectedCityNames;
{
    if (!_selectedCityNames) {
        _selectedCityNames = [NSMutableArray arrayWithContentsOfFile:DPSelectedCityNamesFile];
        
        if (!_selectedCityNames) {
            _selectedCityNames = [NSMutableArray array];
        }
    }
    return _selectedCityNames;
}

+ (void)saveSelectedCityName:(NSString *)name
{
    if (name.length == 0) return;
    _selectedCityNames = [self selectedCityNames];
    // 存储城市名字
    [_selectedCityNames removeObject:name];
    [_selectedCityNames insertObject:name atIndex:0];
    
    // 写入plist
    [_selectedCityNames writeToFile:DPSelectedCityNamesFile atomically:YES];
    
}

+ (void)saveSelectedSort:(DPSort *)sort
{
    if (sort == nil) return;
    [NSKeyedArchiver archiveRootObject:sort toFile:DPSelectedSortFile];
}

+ (NSString *)selectedCityName
{
    _selectedCityNames = [self selectedCityNames];
    NSString *cityName = [_selectedCityNames firstObject];
    if (cityName.length == 0) {
        cityName = @"北京";
    }
    return cityName;
}

+ (DPSort *)selectedSort
{
    DPSort *sort = [NSKeyedUnarchiver unarchiveObjectWithFile:DPSelectedSortFile];
    if (sort == nil) {
        sort = [_sorts firstObject];
    }
    return sort;
}
@end
