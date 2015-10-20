//
//  DPDetailViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/20.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDetailViewController.h"
#import "DPDeal.h"

@interface DPDetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInddicatorView;

@end

@implementation DPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DPGlobalBg;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    // Do any additional setup after loading the view from its nib.
}

// 返回控制器支持的反向
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end
