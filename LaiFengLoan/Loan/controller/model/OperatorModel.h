//
//  OperatorModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/9.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperatorModel : NSObject
@property (nonatomic, copy) NSString *captcha;
@property (nonatomic, copy) NSString *operatorPassword;
@property (nonatomic, copy) NSString *operatorPhone;
@property (nonatomic, copy) NSString *operatorToken;
@property (nonatomic, copy) NSString *operatorWebsite;
@property (nonatomic, copy) NSString *type;
@end
//captcha    string
//运营商验证码
//
//operatorPassword    string
//服务密码
//
//operatorPhone*    string
//手机号
//
//operatorToken    string
//token
//operatorWebsite*    string
//website
//type    string
//默认空值（第一次提交请求时，不传入该参数值） SUBMIT_CAPTCHA（提交短信验证码）RESEND_CAPTCHA（重发短信验证码）SUBMIT_QUERY_PWD（提交查询密码）【仅北京移动会出现】
