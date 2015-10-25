//
//  DPDealAnnotation.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/25.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDealAnnotation.h"

@implementation DPDealAnnotation

- (BOOL)isEqual:(DPDealAnnotation *)other
{
    return [self.title isEqual:other.title];
}
@end
