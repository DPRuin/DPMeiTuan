//
//  DPHomeTopItem.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeTopItem.h"

@implementation DPHomeTopItem

+ (instancetype)item
{
    return  [[[NSBundle mainBundle] loadNibNamed:@"DPHomeTopItem" owner:nil options:nil] lastObject];
}

@end
