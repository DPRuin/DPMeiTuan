//
//  DPDetailViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/20.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDetailViewController.h"
#import "DPDeal.h"
#import "UIImageView+WebCache.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "DPRestrictions.h"
#import "MBProgressHUD+MJ.h"
#import "DPDealTool.h"

// 支付宝头文件
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"



@interface DPDetailViewController () <UIWebViewDelegate, DPRequestDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityInddicatorView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@property (weak, nonatomic) IBOutlet UIButton *refundableAnyTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *refundableExpireButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseCountButton;
@property (weak, nonatomic) IBOutlet UIButton *leftTimeButton;



- (IBAction)buy:(UIButton *)btn;
- (IBAction)collect:(UIButton *)btn;
- (IBAction)share:(UIButton *)btn;

- (IBAction)back:(UIButton *)btn;

/**
 *  为了解决服务器图片bug 创建这个属性
 */
@property (nonatomic, strong) DPDeal *singleDeal;
@end

@implementation DPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 基本设置
    self.view.backgroundColor = DPGlobalBg;
    
    // 设置左边的内容
    [self setupLeftContent];
    // 设置右边的内容
    [self setupRightContent];
    
    // 保存浏览记录
    [self saveRecentDeal];
}

// 返回控制器支持的反向 只支持横屏
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

/**
 *  保存浏览记录
 */
- (void)saveRecentDeal
{
    if ([DPDealTool isRecented:self.deal]) {
        [DPDealTool removeRecentDeal:self.deal];

    }
    
    [DPDealTool addRecentDeal:self.deal];
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DPRecentStateDidChangeNotification object:nil userInfo:@{DPRecentDealKey : self.deal}];
    
}


#pragma mark - 设置左边和右边的内容
/**
 *  设置左边的内容
 */
- (void)setupLeftContent
{
    //更新左边的内容
    [self updateLeftContent];
    
    // 发送请求获得更详细的团购数据
    DPAPI *api = [[DPAPI alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
}

/**
 *  更新左边的内容
 */
- (void)updateLeftContent
{
    // 设置基本信息
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    self.titleLabel.text = self.deal.title;
    self.descLabel.text = self.deal.desc;
    // 现价
    self.currentPriceLabel.text = [NSString stringWithFormat:@"￥ %@", self.deal.current_price];
    NSUInteger dotLoc = [self.currentPriceLabel.text rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        // 超过2位小数
        if (self.currentPriceLabel.text.length - dotLoc > 3) {
            self.currentPriceLabel.text = [self.currentPriceLabel.text substringToIndex:dotLoc + 3];
        }
    }
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥ %@", self.deal.list_price];
    // 购买数
    [self.purchaseCountButton setTitle:[NSString stringWithFormat:@"已售%d", self.deal.purchase_count] forState:UIControlStateNormal];
    
    // 设置剩余时间
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *dead = [formatter dateFromString:self.deal.purchase_deadline];
    // 追加1天
    [dead dateByAddingTimeInterval:24 * 3600];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents *cmps = [[NSCalendar currentCalendar] components:unit fromDate:now toDate:dead options:0];
    
    if (cmps.day > 365) {
        [self.leftTimeButton setTitle:@"一年内不过期" forState:UIControlStateNormal];
    } else {
        [self.leftTimeButton setTitle:[NSString stringWithFormat:@"%ld天%ld小时%ld分钟", cmps.day, cmps.hour, cmps.minute] forState:UIControlStateNormal];
    }
    
    // 设置收藏状态
    self.collectButton.selected = [DPDealTool isCollected:self.deal];
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    // 加载网页
    self.webView.delegate = self;
    self.webView.hidden = YES;
    NSString *ID = [self.deal.deal_id substringFromIndex:([self.deal.deal_id rangeOfString:@"-"].location + 1)];
    NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@", ID];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    self.singleDeal = [DPDeal objectWithKeyValues:[result[@"deals"] lastObject]];
    // 设置退款信息
    self.refundableAnyTimeButton.selected = self.singleDeal.restrictions.is_refundable;
    self.refundableExpireButton.selected = self.singleDeal.restrictions.is_refundable;
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    [MBProgressHUD showError:@"网络繁忙，请稍后再试" toView:self.view];
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
- (IBAction)back:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  立即购买
 */
- (IBAction)buy:(UIButton *)btn {
    // 1.生成订单信息
    Order *order = [[Order alloc] init];
    order.partner = DPPartnerID;
    order.seller = DPSellerID;
    order.productName = self.deal.title;
    order.productDescription = self.deal.desc;
    order.amount = [self.deal.current_price description];
    
    // 2.签名加密
    id<DataSigner> signer = CreateRSADataSigner(DPPartnerPrivKey);
    NSString *signedString = [signer signString:[order description]];
    
    // 3.利用订单信息、签名信息、签名类型生成一个订单字符串
    NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                             [order description], signedString, @"RSA"];
    
    // 4.打开客户端,进行支付(商品名称,商品价格,商户信息)
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"dpmeituan" callback:^(NSDictionary *resultDic) {
#warning 网页支付回传结果
        
    }];
}

/**
 *  收藏
 */
- (IBAction)collect:(UIButton *)btn {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[DPCollectDealKey] = self.deal;
    
    if (btn.isSelected) { // 取消收藏
        [DPDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
        
        userInfo[DPIsCollectedKey] = @NO;
    } else { // 收藏
        [DPDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
        
        userInfo[DPIsCollectedKey] = @YES;
    }
    
    // 按钮选中取反
    btn.selected = !btn.isSelected;
    
    // 发出通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DPCollectStateDidChangeNotification object:nil userInfo:userInfo];
    
}
/**
 *  分享
 */
- (IBAction)share:(UIButton *)btn {
#warning 可以添加友盟分享
    
}


@end
