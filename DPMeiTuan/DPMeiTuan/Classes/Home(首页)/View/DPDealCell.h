//
//  DPDealCell.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/18.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPDeal;
@class DPDealCell;

@protocol DPDealCellDelegate <NSObject>

@optional
- (void)dealCellCheckingStateDidChang:(DPDealCell *)Cell;

@end

@interface DPDealCell : UICollectionViewCell
/** 模型数据 */
@property (nonatomic, strong) DPDeal *deal;

@property (nonatomic, weak) id<DPDealCellDelegate> delegate;

@end
