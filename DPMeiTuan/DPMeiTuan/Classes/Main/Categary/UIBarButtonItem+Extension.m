//
//  UIBarButtonItem+Extension.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)
/**
 *  创建一个UIBarButtonItem
 *
 *  @param target         点击item后调用哪个对象的方法
 *  @param action         点击item后调用target的哪个方法
 *  @param image          图片
 *  @param highlightImage 高亮的图片

 */
+ (instancetype)itemWithTarget:(id)target action:(SEL)action Image:(NSString *)image highlightImage:(NSString *)highlightImage
{
    // 设置导航栏上面的内容
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
    // 设置尺寸
    btn.size = btn.currentImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];

}
@end
