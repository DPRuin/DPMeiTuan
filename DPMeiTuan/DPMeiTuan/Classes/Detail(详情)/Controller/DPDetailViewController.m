//
//  DPDetailViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/20.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDetailViewController.h"
#import "DPDeal.h"

@interface DPDetailViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInddicatorView;

@end

@implementation DPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = DPGlobalBg;
    self.webView.delegate = self;
    self.webView.hidden = YES;
    
    NSString *ID = [self.deal.deal_id substringFromIndex:([self.deal.deal_id rangeOfString:@"-"].location + 1)];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", ID];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];

}

// 返回控制器支持的反向 只支持横屏
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - UIWebViewDelegate
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSLog(@"%@ ----- %@", self.deal.deal_id, request.URL);
//    return YES;
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 用来拼接所有的JS
    NSMutableString *js = [NSMutableString string];
    // 删除header
    [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
    [js appendString:@"header.parentNode.removeChild(header);"];
    // 删除顶部的购买
    [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
    [js appendString:@"box.parentNode.removeChild(box);"];
    // 删除底部的购买
    [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
    [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
    
    // 利用webView执行JS
    [webView stringByEvaluatingJavaScriptFromString:js];
    // 显示webView
    webView.hidden = NO;
    
    // 隐藏正在加载
    [self.activityInddicatorView stopAnimating];
}

@end
