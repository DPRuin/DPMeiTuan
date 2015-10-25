//
//  DPMapViewController.m
//  DPMeiTuan
//
//  Created by 土老帽 on 15/10/25.
//  Copyright (c) 2015年 DP. All rights reserved.
//

#import "DPMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <MapKit/MapKit.h>
#import "DPHomeTopItem.h"
#import "DPCategaryViewController.h"
#import "DPCategary.h"
#import "DPDealAnnotation.h"
#import "DPAPI.h"
#import "MJExtension.h"
#import "DPDeal.h"
#import "DPBusiness.h"
#import "DPMetalTool.h"

@interface DPMapViewController () <MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
/** 地理编码对象 */
@property (nonatomic, strong) CLGeocoder *geocoder;
/** 定位管理者 */
@property (nonatomic, strong) CLLocationManager *locationMgr;
@property (nonatomic, copy) NSString *city;

@property (nonatomic, weak) UIBarButtonItem *categaryItem;
@property (nonatomic, strong) UIPopoverController *categoryPopover;

/** 选中的分类 */
@property (nonatomic, copy) NSString *selectedCategaryName;

@property (nonatomic, strong) DPRequest *lastRequest;

@end

@implementation DPMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左边的返回
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) Image:@"icon_back" highlightImage:@"icon_back_highlighted"];
    
    // 设置左上角的分类菜单
    DPHomeTopItem *categaryTopItem = [DPHomeTopItem item];
    [categaryTopItem addTarget:self action:@selector(categaryClick)];
    UIBarButtonItem *categaryItem = [[UIBarButtonItem alloc] initWithCustomView:categaryTopItem];
     self.navigationItem.leftBarButtonItems = @[backItem, categaryItem];
    self.categaryItem = categaryItem;
    
    // 设置标题
    self.title = @"地图";
    // 在ios8 主动请求获取隐私权限（获取用户位置）
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        [self.locationMgr requestAlwaysAuthorization];
    }
    // 设置地图跟踪用户位置
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    // 监听分类改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categaryDidChange:) name:DPCategaryDidChangeNotification object:nil];
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)categaryDidChange:(NSNotification *)notification
{
    // 关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    
    // 获得发给服务器的类型名称
    DPCategary *categary = notification.userInfo[DPSelectCategary];
    NSString *subCategaryName = notification.userInfo[DPSelectSubCategaryName];
    
    if (subCategaryName == nil || [subCategaryName isEqualToString:@"全部"]) { // 没有次表
        self.selectedCategaryName = categary.name;
    } else {
        self.selectedCategaryName = subCategaryName;
    }
    if ([self.selectedCategaryName isEqualToString:@"全部分类"]) {
        self.selectedCategaryName = nil;
    }
    
    // 更改顶部区域item的文字
    DPHomeTopItem *topItem = (DPHomeTopItem *)self.categaryItem.customView;
    [topItem setTitle:categary.name];
    [topItem setSubTitle:subCategaryName];
    [topItem setIcon:[UIImage imageNamed:categary.icon] highIcon:[UIImage imageNamed:categary.highlighted_icon]];
    
    //删除之前的所有大头zhen
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 重新发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    
}

#pragma mark - 按钮点击
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)categaryClick
{
    // 显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc] initWithContentViewController:[[DPCategaryViewController alloc] init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categaryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - 懒加载
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (CLLocationManager *)locationMgr
{
    if (!_locationMgr) {
        self.locationMgr = [[CLLocationManager alloc] init];
    }
    return _locationMgr;
}

#pragma mark - MKMapViewDelegate
/**
 *  当用户的位置更新了就会调用
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // 让地图显示到用户所在的位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    // 反地理编码
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error || placemarks == 0) return;
        
        CLPlacemark *pm = [placemarks firstObject];
        NSString *city = pm.locality ? pm.locality : pm.addressDictionary[@"state"];
        self.city = [city substringToIndex:city.length - 1];
        
        // 第一次发送请求给服务器
        [self mapView:mapView regionDidChangeAnimated:YES];
    }];

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(DPDealAnnotation *)annotation
{
    // 系统默认大头针 返回nil 交给洗系统去处理
    if (![annotation isKindOfClass:[DPDealAnnotation class]]) return nil;
    
    // 创建大头针
    static NSString *ID = @"annoView";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (!annoView) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    // 传递模型
    annoView.annotation = annotation;
    
    // 设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];
    
    return annoView;
}

// 区域改变就会调用
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.city == nil) return;
    
    DPAPI *api = [[DPAPI alloc] init];
    // 设置请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.city;
    if (self.selectedCategaryName) {
        params[@"category"] = self.selectedCategaryName;
    }
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request != self.lastRequest) return;
    NSArray *deals = [DPDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (DPDeal *deal in deals) {
        
        // 获得团购所属类型
        DPCategary *categary = [DPMetalTool categaryWithDeal:deal];
        
        for (DPBusiness *business in deal.businesses) {
            DPDealAnnotation *anno = [[DPDealAnnotation alloc] init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = categary.map_icon;
            
            if ([self.mapView.annotations containsObject:anno]) break;
            [self.mapView addAnnotation:anno];
        }
    }
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    if (request != self.lastRequest) return;
    DPLog(@"%@", error);
}

@end
