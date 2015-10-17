//
//  DPRegion.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/16.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPRegion.h"
#import "DPHomeDropdown.h"

@interface DPRegion () <DPHomeDropdownData>

@end

@implementation DPRegion
- (NSString *)title
{
    return self.name;
}
- (NSArray *)subData
{
    return self.subregions;
}
@end
