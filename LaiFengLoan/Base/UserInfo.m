//
//  UserInfo.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/7.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "UserInfo.h"
#import "XCacheHelper.h"

static  NSString * const userInfo = @"UserInfo";
static  UserInfo * userInfoModel = nil;   /*!< 用户信息 */
@implementation UserInfo

XSharedInstance(UserInfo)
MJCodingImplementation
- (void)savePhone:(NSString *)userPhone password:(NSString*)password accessToken:(NSString *)token{
    if (userPhone.length > 0) {
        self.phoneName = userPhone;
    }
    if (password.length > 0) {
        self.password = password;
    }
    if (token.length > 0) {
        self.accessToken = token;
    }
    
    [XCacheHelper saveByNSKeyedUnarchiverWith:self fileName:userInfo isCanClear:YES];
}

- (UserInfo *)getUserInfo{
    userInfoModel = [XCacheHelper getByNSKeyedUnarchiver:userInfo withClass:[UserInfo class] isCanClear:YES];
    return userInfoModel;
}
#pragma mark - ***** 是否登录 ******
- (BOOL)isSignIn{
    userInfoModel  = [self getUserInfo];
    if (userInfoModel.accessToken && userInfoModel.accessToken.length > 0) {
        return YES;
    }
    return NO;
}
@end
