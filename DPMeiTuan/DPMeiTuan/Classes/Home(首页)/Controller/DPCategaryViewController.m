//
//  DPCategaryViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPCategaryViewController.h"
#import "DPHomeDropdown.h"
#import "UIView+Extension.h"
#import "MJExtension.h"
#import "DPCategary.h"
#import "Masonry.h"

@interface DPCategaryViewController ()

@end

@implementation DPCategaryViewController

- (void)loadView
{
    DPHomeDropdown *dropdown = [DPHomeDropdown dropdown];
    // 加载分类数据
    dropdown.categaries = [DPCategary objectArrayWithFilename:@"categories.plist"];
    self.view = dropdown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    DPHomeDropdown *dropdown = [DPHomeDropdown dropdown];
//    // 加载分类数据
//    dropdown.categaries = [DPCategary objectArrayWithFilename:@"categories.plist"];
//    [self.view addSubview:dropdown];
    
//    [dropdown mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//    }];
    
    // 设置控制器view在popo中的尺寸
//    self.preferredContentSize = dropdown.size;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
