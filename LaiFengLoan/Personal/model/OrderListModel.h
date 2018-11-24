//
//  OrderListModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListModel : NSObject
@property (nonatomic ,copy) NSNumber *dueRepayDate;
@property (nonatomic ,copy) NSNumber *orderAmt;
@property (nonatomic ,copy) NSNumber *orderNo;
@property (nonatomic ,copy) NSNumber *overDueAmt;
@property (nonatomic ,copy) NSNumber *overDueDays;
@property (nonatomic ,copy) NSNumber *repayAmt;
@property (nonatomic ,copy) NSNumber *repayPlanId;
@property (nonatomic ,copy) NSNumber *repayTime;
@property (nonatomic ,copy) NSNumber *stageTimeunitCnt;
@end
//dueRepayDate    integer($int64)
//应还款日期
//
//orderAmt    number($double)
//借款金额(用户提交的金额),例:1000.00
//
//orderNo    string
//订单编号
//
//overDueAmt    number($double)
//违约金
//
//overDueDays    integer($int32)
//违约天数
//
//repayAmt    number($double)
//应还总额
//
//repayPlanId    integer($int64)
//还款计划ID
//repayTime    integer($int64)
//还款时间
//
//stageTimeunitCnt    integer($int32)
//借款(周期)天数
