//
//  UserLocation.h
//  QuanWangDai
//
//  Created by yanqb on 2018/1/29.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface UserLocation : NSObject <AMapLocationManagerDelegate>
@property (nonatomic ,strong) AMapLocationManager *locationManager;
@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *adCode;
@property (nonatomic ,copy) NSString *cityCode;
@property (nonatomic ,copy) NSString *cityName;
@property (nonatomic ,copy) NSString *areaName;
+ (instancetype)sharedInstance;
- (void)UserLocation;
- (NSString *)getProvince;
- (NSString *)getCityCode;
- (NSString *)getAdCode;
- (NSString *)getCityName;
- (NSString *)getAreaName;
@end
