//
//  MoxieSDKOperation.h
//  MoxieSDKOCDemo
//
//  Created by shenzw on 2018/7/11.
//  Copyright © 2018年 shenzw. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MoxieSDK.h"
static NSString *const receiveMoxieSDKResultNotifiction = @"receiveMoxieSDKResultNotifiction";

@interface MoxieSDKOperation : NSOperation

@property (copy, nonatomic) NSString *taskType;
@property (strong, nonatomic) MXLoginCustom *loginCustom;
@property (assign, nonatomic) MoxieSDKRunMode runMode;
@end
