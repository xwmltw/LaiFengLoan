//
//  XDeviceHelper.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/14.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "XDeviceHelper.h"
#import "AFNetworking.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AdSupport/AdSupport.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation XDeviceHelper

XSharedInstance(XDeviceHelper);
static NSString* const XSJUserDefault_IDFA  = @"XSJUserDefault_IDFA";

+ (NSString *)getUUID {
//    CFUUIDRef uuidObj = CFUUIDCreate(nil);
//    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
//    CFRelease(uuidObj);
//    return [uuidString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *uuidStr = nil;
    NSString *returnStr = nil;
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    uuidStr = [NSString stringWithFormat:@"%@",uuid];
    NSRange endrange = [uuidStr rangeOfString:@">"];
    if (endrange.location != NSNotFound) {
        returnStr = [uuidStr substringWithRange:NSMakeRange(endrange.location+1, [uuidStr length]-endrange.location-1)];
        return returnStr;
    }
    return uuidStr;
}


#pragma mark - ***** app 版本号 ******
+ (void)getAppStorVersion:(XBlock)block{
//    AFHTTPRequestOperationManager *manager1 = [AFHTTPRequestOperationManager manager];
//    [manager1 POST:@"https://itunes.apple.com/lookup?id=1168227626" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//        NSArray *array = responseObject[@"results"];
//        NSDictionary *dict = [array lastObject];
//        //        NSLog(@"当前版本为：%@", dict[@"version"]);
//        NSString *str = dict[@"version"];
//        [WDUserDefaults setObject:str forKey:@"appStoreVersion"];
//        [WDUserDefaults synchronize];
//        XBlockExec(block,dict[@"version"]);
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//        //        NSLog(@"当前版本为错误%@",error);
//    }];
}
+ (NSString *)getAppBundleShortVersion{
    return [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)getAppBundleVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
+ (int)getAppIntVersion{
    NSString *nowShotV = [XDeviceHelper getAppBundleShortVersion];
    NSArray *numArray = [nowShotV componentsSeparatedByString:@"."];
    int versionInt = 0;
    if (numArray.count > 0) {
        for (NSInteger i = 0; i < numArray.count; i++) {
            NSString *numStr = numArray[i];
            versionInt = versionInt * 10 +numStr.intValue;
        }
    }
    return versionInt;
}
#pragma mark - ***** 系统信息 ******
+ (NSString*)getSysVersionString{
    return [NSString stringWithFormat:@"%.2lf ",[self getSysVersion]];
}

+ (float)getSysVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}
+ (NSString *)getPlatformString{
    NSString *platform = [self getDevicePlatform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone4,2"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone4,3"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6+";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6S+";
    if ([platform isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([platform isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    if ([platform isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([platform isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([platform isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([platform isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([platform isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";

    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini3";
    
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini4";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini4";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air2";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return platform;
}

+ (NSString *)getDevicePlatform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *)getBundleIdentifier{
    return [[NSBundle mainBundle] bundleIdentifier];
}
+ (NSString *)getIPAddress:(BOOL)preferIPv4{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
//    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            MyLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end
