//
//  DPCategary.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCategary.h"
#import "DPHomeDropdown.h"

@interface DPCategary () <DPHomeDropdownData>

@end

@implementation DPCategary
- (NSString *)title
{
    return self.name;
}
- (NSArray *)subData
{
    return self.subcategories;
}
- (UIImage *)cellIcon
{
    return [UIImage imageNamed:self.small_icon];
}
- (UIImage *)selectedCellIcon
{
    return [UIImage imageNamed:self.small_highlighted_icon];
}
@end
