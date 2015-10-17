//
//  DPHomeDropdown.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DPHomeDropdown;

@protocol DPHomeDropdownData <NSObject>
@required
- (NSString *)title;
- (NSArray *)subData;
@optional
- (UIImage *)cellIcon;
- (UIImage *)selectedCellIcon;

@end

@protocol DPHomeDropdownDataSource <NSObject>
@required
/**
 *  主表多少行
 */
- (NSInteger)numberOfRowsHomeDropdow:(DPHomeDropdown *)dropdown;
/**
 *  每一行的主表的数据模型
 *  @param row      行号
 *
 *  @return 返回数据模型
 */
- (id<DPHomeDropdownData>)homeDropdown:(DPHomeDropdown *)dropdown dataForRow:(NSInteger)row;

@end

@protocol DPHomeDropdownDelegate <NSObject>

@optional
- (void)homeDropdown:(DPHomeDropdown *)dropdown didSelectRowInMainTable:(NSInteger)row;
- (void)homeDropdown:(DPHomeDropdown *)dropdown didSelectRowInSubTable:(NSInteger)subRow inMainTable:(NSInteger)mainRow;
@end

@interface DPHomeDropdown : UIView
+ (instancetype)dropdown;

@property (nonatomic, weak) id<DPHomeDropdownDataSource> dataSource;
@property (nonatomic, weak) id<DPHomeDropdownDelegate> delegate;

@end
