//
//  ParamModel.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ParamModel.h"
#import "XDeviceHelper.h"
#import "XCacheHelper.h"
@implementation ParamModel
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (NSString*)getContent{
    if (self) {
        NSDictionary* dic = [self mj_keyValues];
        NSString* str = [dic jsonStringWithPrettyPrint:YES];
        NSUInteger strLength = [str length];
        NSString* param = [str substringWithRange:NSMakeRange(1, strLength-2)];
        return param;
    }
    return nil;
}
@end

@implementation BaseInfoPM
- (instancetype)init{
    self = [super init];
    if (self) {
        self.accessChannelCode = @"AppStore";
        self.appVersionCode = [NSString stringWithFormat:@"%d",[XDeviceHelper getAppIntVersion]];
        self.clientType = @1;
        self.imei = @"";
        self.uid = [XDeviceHelper getUUID];
        
    }
    return self;
}
@end
@implementation ClientGlobalInfo
MJCodingImplementation
- (void)setClientGlobalInfoModel{
    [XCacheHelper saveToFileWithModel:self fileName:@"ClientGlobalInfoModel" isCanClear:NO];
}
+ (ClientGlobalInfo *)getClientGlobalInfoModel{
    return  [XCacheHelper getModelWithFileName:@"ClientGlobalInfoModel" withClass:[ClientGlobalInfo class] isCanClear:NO];
}
@end
@implementation VersionInfo
@end
@implementation BannerAdList
@end








