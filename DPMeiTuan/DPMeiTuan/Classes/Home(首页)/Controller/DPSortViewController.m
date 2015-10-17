//
//  DPSortViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/17.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPSortViewController.h"
#import "DPMetalTool.h"
#import "UIView+AutoLayout.h"
#import "UIView+Extension.h"
#import "DPSort.h"

@interface DPSortButton : UIButton
@property (nonatomic, strong) DPSort *sort;
@end

@implementation DPSortButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return self;
}
- (void)setSort:(DPSort *)sort
{
    _sort = sort;
    [self setTitle:sort.label forState:UIControlStateNormal];
    
}
@end

@interface DPSortViewController ()

@end

@implementation DPSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [DPMetalTool sorts];
    NSUInteger count = sorts.count;
    
    for (int i = 0; i < count; i++) {
        DPSortButton *btn = [[DPSortButton alloc] init];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        btn.sort = sorts[i];
        [self.view addSubview:btn];
    }

    // 添加约束
    NSArray *subviews = self.view.subviews;
    UIButton *firstBtn = [subviews firstObject];
    
    [firstBtn autoSetDimension:ALDimensionWidth toSize:100.0f];
    [subviews autoMatchViewsDimension:ALDimensionWidth];
    
    [firstBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [subviews autoDistributeViewsAlongAxis:ALAxisVertical withFixedSize:30.0f insetSpacing:YES alignment:NSLayoutFormatAlignAllCenterX];
    
     // 设置popover的尺寸
     self.preferredContentSize = CGSizeMake(130, 300);
}

- (void)buttonClick:(DPSortButton *)btn
{
    // 发出通知 排序改变
    [[NSNotificationCenter defaultCenter] postNotificationName:DPSortDidChangeNotification object:self userInfo:@{DPSelectSort : btn.sort}];
}

@end
