//
//  DPDistrictViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/15.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDistrictViewController.h"
#import "DPCityViewController.h"
#import "DPNavigationController.h"

@interface DPDistrictViewController ()
- (IBAction)changeCity:(UIButton *)sender;

@end

@implementation DPDistrictViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 *  切换城市
 */
- (IBAction)changeCity:(UIButton *)sender {
    
    DPCityViewController *city = [[DPCityViewController alloc] init];
    DPNavigationController *nav = [[DPNavigationController alloc] initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:nav animated:YES completion:nil];
}
@end
