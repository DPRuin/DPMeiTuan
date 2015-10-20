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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *plistPriceLabel;


- (IBAction)buy:(UIButton *)sender;
- (IBAction)collect:(UIButton *)sender;
- (IBAction)share:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;
@end

@implementation DPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 基本设置
    self.view.backgroundColor = DPGlobalBg;
    
    // 加载网页
    [self setupWeb];
    // 设置基本信息
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
}

// 返回控制器支持的反向 只支持横屏
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

/**
 *  加载网页
 */
- (void)setupWeb
{
    self.webView.delegate = self;
    self.webView.hidden = YES;
    NSString *ID = [self.deal.deal_id substringFromIndex:([self.deal.deal_id rangeOfString:@"-"].location + 1)];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", ID];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

#pragma mark - UIWebViewDelegate
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

#pragma mark - 监听按钮点击
/**
 *  返回
 */
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  立即购买
 */
- (IBAction)buy:(UIButton *)sender {
}
/**
 *  收藏
 */
- (IBAction)collect:(UIButton *)sender {
}
/**
 *  分享
 */
- (IBAction)share:(UIButton *)sender {
}


@end
