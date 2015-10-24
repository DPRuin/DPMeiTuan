//
//  DPDealCell.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/18.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPDealCell.h"
#import "DPDeal.h"
#import "UIImageView+WebCache.h"

@interface DPDealCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *dealNewView;

/** 收藏编辑时的遮盖 */
@property (weak, nonatomic) IBOutlet UIButton *coverButton;
- (IBAction)coverClick:(UIButton *)btn;
/** 收藏编辑时打钩 */
@property (weak, nonatomic) IBOutlet UIImageView *checkView;

@end

@implementation DPDealCell

- (void)awakeFromNib {
    
}

- (void)setDeal:(DPDeal *)deal
{
    _deal = deal;
    
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
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d", self.deal.purchase_count];
    
    // 是否显示新单图片
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *nowDate = [formatter stringFromDate:[NSDate date]];
    // 发布日期 《 now 隐藏
    self.dealNewView.hidden = ([self.deal.publish_date compare:nowDate] == NSOrderedAscending);
    
    // 根据模型决定遮盖是否显示和隐藏
    self.coverButton.hidden = !deal.isEditing;
    // 根据模型决定打钩是否显示和隐藏
    self.checkView.hidden = !deal.checking;
    
}

- (void)drawRect:(CGRect)rect
{
    // 背景图片
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}
- (IBAction)coverClick:(UIButton *)btn {
    // 修改模型打钩状态
    self.deal.checking = !self.deal.isChecking;
    
   // 直接修改状态
    self.checkView.hidden = !self.checkView.isHidden;
    
    // 通知代理打钩状态改变了
    if ([self.delegate respondsToSelector:@selector(dealCellCheckingStateDidChang:)]) {
        [self.delegate dealCellCheckingStateDidChang:self];
    }
}
@end
