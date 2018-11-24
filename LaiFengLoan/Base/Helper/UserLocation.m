//
//  UserLocation.m
//  QuanWangDai
//
//  Created by yanqb on 2018/1/29.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "UserLocation.h"
#import <CoreLocation/CoreLocation.h>
#import "XAlertView.h"

@interface UserLocation ()


@end
@implementation UserLocation

XSharedInstance(UserLocation);
#pragma mark - 检查授权状态
- (void)checkLocationServicesAuthorizationStatus {
    
    [self reportLocationServicesAuthorizationStatus:[CLLocationManager authorizationStatus]];
}


- (void)reportLocationServicesAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status == kCLAuthorizationStatusNotDetermined)
    {
        //未决定，继续请求授权
//        [self requestLocationServicesAuthorization];
//        [self alertViewWithMessage];
        
    }
    else if(status == kCLAuthorizationStatusRestricted)
    {
        //受限制，尝试提示然后进入设置页面进行处理（根据API说明一般不会返回该值）
        [self alertViewWithMessage];
        return;
        
    }
    else if(status == kCLAuthorizationStatusDenied)
    {
        //拒绝使用，提示是否进入设置页面进行修改
        [self alertViewWithMessage];
        return;
        
    }
    else if(status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        //授权使用，不做处理
        
    }
    else if(status == kCLAuthorizationStatusAuthorizedAlways)
    {
        //始终使用，不做处理
    }
    
}
- (void)alertViewWithMessage{
    [XAlertView alertWithTitle:@"温馨提示" message:@"您还未设置定位功能，请前往设置" cancelButtonTitle:@"取消" confirmButtonTitle:@"前往设置" completion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }];
}


#pragma mark - 获取定位信息
- (void)UserLocation{
    
    [self checkLocationServicesAuthorizationStatus];
    
    self.locationManager = [[AMapLocationManager alloc]init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setLocationTimeout:10];
    [self.locationManager setReGeocodeTimeout:5];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            MyLog(@"locError:%ld-%@",(long)error.code,error.localizedDescription);
    
        }
        MyLog(@"location:%@",location);
        if (regeocode) {
            
            self.adCode = regeocode.adcode;
            self.cityCode = regeocode.citycode;
            self.cityName = regeocode.city;
            self.areaName = regeocode.district;
            self.province = regeocode.province;
//            [XNotificationCenter postNotificationName:XLocationCityName object:self.cityName];
            MyLog(@"reGeicode:%@",regeocode);
        }
    }];
}
- (NSString *)getProvince{
    if (!self.province.length) {
    }
    return self.province;
}
- (NSString *)getCityCode{
    if (!self.cityCode.length) {
    }
    return self.cityCode;
}
- (NSString *)getAdCode{
    if (!self.adCode.length) {
    }
    return self.adCode;
}
- (NSString *)getCityName{
    if (!self.cityName.length) {
//        [self UserLocation];
    }
    return self.cityName;
}
- (NSString *)getAreaName{
    if (!self.areaName.length) {
        
    }
    return self.areaName;
}
@end
