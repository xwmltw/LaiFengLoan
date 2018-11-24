//
//  BankModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/14.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankModel : NSObject
@property (nonatomic ,copy) NSNumber *bankAccountId;
@property (nonatomic ,copy) NSString *bankCardNo;
@property (nonatomic ,copy) NSString *bankCode;
@property (nonatomic ,copy) NSString *bankName;
@property (nonatomic ,copy) NSString *bankPhone;
@property (nonatomic ,copy) NSString *smsCode;
@property (nonatomic ,copy) NSString *trueName;
@end
//bankAccountId    integer($int64)
//开卡账户ID（第一次获取验证码会下发）,重新获取验证码和提交绑定时必传
//
//bankCardNo*    string
//银行卡号(第一次获取验证码必传)
//
//bankCode*    string
//银行编号(第一次获取验证码必传)
//
//bankName*    string
//银行名称(第一次获取验证码必传)
//
//bankPhone*    string
//银行预留手机号(第一次获取验证码必传)
//
//smsCode*    string
//短信验证码，提交绑定接口时《必传》
//
//trueName*    string
//用户姓名(第一次获取验证码必传)
