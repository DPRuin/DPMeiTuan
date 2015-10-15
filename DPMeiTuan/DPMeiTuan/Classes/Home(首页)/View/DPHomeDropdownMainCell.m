//
//  DPHomeDropdownMainCell.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeDropdownMainCell.h"

@implementation DPHomeDropdownMainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *mainID = @"maincell";
    DPHomeDropdownMainCell *cell = [tableView dequeueReusableCellWithIdentifier:mainID];
    if (!cell) {
        cell = [[DPHomeDropdownMainCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:mainID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_leftpart"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_left_selected"]];
    }
    return self;
}

@end
