//
//  XDeviceHelper.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/14.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

@interface XDeviceHelper : NSObject
+ (instancetype)sharedInstance;
#pragma mark - ***** app 版本号 ******
/**发现appstore上 版本号 */
+ (void)getAppStorVersion:(XBlock)block;
/** 发布版本号 */
+ (NSString*)getAppBundleShortVersion;

/** 打包版本号 */
+ (NSString*)getAppBundleVersion;

/** 发布版本号 int */
+ (int)getAppIntVersion;

#pragma mark - ***** 系统信息 ******

/** 获取设备系统版本字符串 保留2位小数*/
+ (NSString*)getSysVersionString;

/** 获取设备系统版本 */
+ (float)getSysVersion;

/** 设备信息对应名称 */
+ (NSString *)getPlatformString;

/** 获取设备信息 */
+ (NSString *)getDevicePlatform;

/** 获取bundle identifier */
+ (NSString *)getBundleIdentifier;
+ (NSString *)getUUID;
/** 获取设备地址 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
