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
    // 原价
    self.listPriceLabel.text = [NSString stringWithFormat:@"￥ %@", self.deal.list_price];
    // 购买数
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d", self.deal.purchase_count];
    
    
    
}

- (void)drawRect:(CGRect)rect
{
    // 背景图片
    [[UIImage imageNamed:@"bg_dealcell"] drawInRect:rect];
}
@end
