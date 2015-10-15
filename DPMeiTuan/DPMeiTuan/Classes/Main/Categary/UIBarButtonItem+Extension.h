//
//  UIBarButtonItem+Extension.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (instancetype)itemWithTarget:(id)target action:(SEL)action Image:(NSString *)image highlightImage:(NSString *)highlightImage;
@end
