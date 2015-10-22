#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DPLog(...) NSLog(__VA_ARGS__)
#else
#define DPLog(...)
#endif

#define DPColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DPGlobalBg DPColor(230, 230, 230)

#define DPGreenColor DPColor(32, 191, 179)

// 通知 城市改变
extern NSString *const DPCityDidChangeNotification;
extern NSString *const DPSelectCityName;

// 通知 排序改变
extern NSString *const DPSortDidChangeNotification;
extern NSString *const DPSelectSort;

// 通知 区域改变
extern NSString *const DPDistrictDidChangeNotification;
extern NSString *const DPSelectRegion;
extern NSString *const DPSelectSubregionName;

// 通知 分类改变
extern NSString *const DPCategaryDidChangeNotification;
extern NSString *const DPSelectCategary;
extern NSString *const DPSelectSubCategaryName;

// 通知 收藏改变
extern NSString *const DPCollectStateDidChangeNotification;
extern NSString *const DPCollectDealKey;
extern NSString *const DPIsCollectedKey;