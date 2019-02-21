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
@property (nonatomic ,copy) NSNumber *repayStatus;
@property (nonatomic ,copy) NSNumber *repayTime;
@property (nonatomic ,copy) NSNumber *stageTimeunitCnt;
@property (nonatomic ,copy) NSNumber *hasExtension;
@property (nonatomic ,copy) NSNumber *waitingAmt;
@property (nonatomic ,copy) NSNumber *extensionDueRepayDate;
@property (nonatomic ,copy) NSNumber *extensionAmt;
@property (nonatomic ,copy) NSNumber *extensionStatus;
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
//repayStatus    integer($int32)
//账单状态: 1还款成功,2待还款,3还款失败,4还款中,等于4的时候需要限制用户重复提交还款
//repayTime    integer($int64)
//还款时间
//
//stageTimeunitCnt    integer($int32)
//借款(周期)天数
//hasExtension    integer($int32)是否展期
//waitingAmt    number($double)待还金额
//extensionDueRepayDate 展期时间
//extensionAmt 展期服务费
//extensionStatus    integer($int32)展期还款状态:0创建,1还款成功,2待还款,3还款失败,4还款中,97退单(预留)
