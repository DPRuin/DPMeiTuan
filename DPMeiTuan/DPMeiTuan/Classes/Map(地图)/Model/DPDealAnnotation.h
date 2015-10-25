//
//  DPDealAnnotation.h
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/25.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DPDealAnnotation : NSObject <MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
/** 图片名 */
@property (nonatomic, copy) NSString *icon;
@end
