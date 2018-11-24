//
//  MyMessageModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/20.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMessageModel : NSObject
@property (nonatomic ,copy) NSNumber *appModuleId;
@property (nonatomic ,copy) NSNumber *createTime;
@property (nonatomic ,copy) NSString *messageContent;
@property (nonatomic ,copy) NSString *messageTitle;
@property (nonatomic ,copy) NSNumber *optType;
@property (nonatomic ,copy) NSString *orderCode;
@property (nonatomic ,copy) NSString *targetUrl;
@end
//appModuleId    integer($int32)
//原生页面类型id：1首页 2订单详情 3运营商认证页面
//messageContent    string
//消息内容
//messageTitle    string
//消息标题
//optType    integer($int32)
//操作类型:1打开原生页面 2打开web页面
//orderCode    string
//订单编号
//targetUrl    string
//目标页面跳转地址 optType=2下发
//createTime    integer($int64)消息创建时间（时间戳）
