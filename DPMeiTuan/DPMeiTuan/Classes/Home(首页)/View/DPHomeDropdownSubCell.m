//
//  DPHomeDropdownSubCell.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/14.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPHomeDropdownSubCell.h"

@implementation DPHomeDropdownSubCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *subID = @"subell";
    DPHomeDropdownSubCell *cell = [tableView dequeueReusableCellWithIdentifier:subID];
    if (!cell) {
        cell = [[DPHomeDropdownSubCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:subID];
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_rightpart"]];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dropdown_right_selected"]];
        // self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.highlightedTextColor = DPGreenColor;
    }
    return self;
}

@end
