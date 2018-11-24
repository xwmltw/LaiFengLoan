//
//  Enum.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/2.
//  Copyright © 2018年 xwm. All rights reserved.
//

#ifndef Enum_h
#define Enum_h

typedef NS_ENUM(NSInteger , MyOrderState) {
    MyOrderStateAuditing = 1, //审核中
    MyOrderStatePendMoney,     //已拒绝
    MyOrderStatePendPay,       //待放款
    MyOrderStateCleared,       //待还款
    MyOrderStateRefuse,        //已结清
    MyOrderStateClose,          //已关闭
};
#endif /* Enum_h */
