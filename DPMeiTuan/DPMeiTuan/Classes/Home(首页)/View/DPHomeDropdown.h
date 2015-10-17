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
- (UIImage *)icon;
- (UIImage *)selectedIcon;

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

///**
// *  每一行的表标题
// *  @param row      行号
// */
//- (NSString *)homeDropdown:(DPHomeDropdown *)dropdown titleForRow:(NSInteger)row;
///**
// *  每一行的次表的数据
// *  @param row      行号
// */
//- (NSArray *)homeDropdown:(DPHomeDropdown *)dropdown subdataForRow:(NSInteger)row;
//
//@optional
///**
// *  每一行图标
// *  @param row      行号
// */
//- (UIImage *)homeDropdown:(DPHomeDropdown *)dropdown iconForRow:(NSInteger)row;
///**
// *  每一行的选中图标
// *  @param row      行号
// */
//- (UIImage *)homeDropdown:(DPHomeDropdown *)dropdown selectedIconForRow:(NSInteger)row;

@end

@interface DPHomeDropdown : UIView
+ (instancetype)dropdown;

@property (nonatomic, weak) id<DPHomeDropdownDataSource> dataSource;

@end
