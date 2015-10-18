//
//  DPCenterLineLabel.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/18.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCenterLineLabel.h"

@implementation DPCenterLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 画矩形 - 线
    UIRectFill(CGRectMake(0, self.frame.size.height * 0.5, self.frame.size.width, 1));
    
//    CGContextRef ctr = UIGraphicsGetCurrentContext();
//
//    // 设置起点
//    CGContextMoveToPoint(ctr, 0, self.frame.size.height * 0.5);
//    // 连接另一点
//    CGContextAddLineToPoint(ctr, self.frame.size.width, self.frame.size.height * 0.5);
//    
//    // 渲染
//    CGContextStrokePath(ctr);
}


@end
