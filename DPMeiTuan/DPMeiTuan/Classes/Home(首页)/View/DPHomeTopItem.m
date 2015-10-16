//
//  DPHomeTopItem.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeTopItem.h"

@interface DPHomeTopItem ()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation DPHomeTopItem

+ (instancetype)item
{
    return  [[[NSBundle mainBundle] loadNibNamed:@"DPHomeTopItem" owner:nil options:nil] lastObject];
}

//- (void)awakeFromNib
//{
//    self.autoresizingMask = UIViewAutoresizingNone;
//}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle
{
    self.subTitleLabel.text = subTitle;
}

- (void)setIcon:(UIImage *)icon highIcon:(UIImage *)highIcon
{
    [self.iconButton setImage:icon forState:UIControlStateNormal];
    [self.iconButton setImage:highIcon forState:UIControlStateHighlighted];
}
@end
