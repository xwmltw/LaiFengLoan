//
//  CreditInfoModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/9.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditInfoModel : NSObject
@property (nonatomic, copy) NSNumber *creditAmt;
@property (nonatomic, copy) NSNumber *creditStatus;
@property (nonatomic, copy) NSNumber *alipayStatus;
@property (nonatomic, copy) NSNumber *hasCreateOrder;
@property (nonatomic, copy) NSNumber *isFirstLoan;
@property (nonatomic, copy) NSString *loginCode;
@property (nonatomic, copy) NSNumber *scheduleStatus;
@property (nonatomic, copy) NSString *trueName;
@property (nonatomic, copy) NSNumber *useAmt;
@property (nonatomic, copy) NSNumber *waitPayAmt;
@property (nonatomic, copy) NSNumber *operatorStatus;
@property (nonatomic, copy) NSNumber *mesSmallRedoint;
@property (nonatomic, copy) NSNumber *hasBlack;
@end
//creditAmt    number($double)
//授信额度
//

//mesSmallRedoint  消息中心红点


//creditStatus    integer($int32)
//授信状态：// 0未授信 1授信中 2已授信 3拒绝 4驳回
//
//alipayStatus    integer($int32)支付宝认证状态：支付宝认证状态, 0未认证 1已认证 2已过期
//hasCreateOrder    integer($int32)是否存在审核中订单: 1是 0否
//loginCode    string
//用户手机号
//
//scheduleStatus    integer($int32)
//资料进度: 1身份证认证 2联系人信息 3基本信息 4运营商认证 5已完善
//
//trueName    string
//用户姓名
//
//useAmt    number($double)
//可用额度
//
//waitPayAmt    number($double)
//待还总额

//isFirstLoan    integer($int32)
//当前用户是否首借(第一次借款): 1是 0否
//operatorStatus    integer($int32)
//运营商认证状态：0未认证 1认证中 2已认证3认证失败
//hasBlack 是不是黑名单 1是 0不是
//}
