//
//  UserInfo.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/7.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic,copy)NSString *phoneName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *accessToken;

+ (instancetype)sharedInstance;

//存储用户登录信息
- (void)savePhone:(NSString *)userPhone password:(NSString*)password accessToken:(NSString *)token;
- (UserInfo *)getUserInfo;
- (BOOL)isSignIn;
@end
