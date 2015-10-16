//
//  DPHomeTopItem.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPHomeTopItem : UIView
+ (instancetype)item;

/**
 *  设置点击的监听器
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)addTarget:(id)target action:(SEL)action;

- (void)setTitle:(NSString *)title;
- (void)setSubTitle:(NSString *)subTitle;
- (void)setIcon:(UIImage *)icon highIcon:(UIImage *)highIcon;
@end
