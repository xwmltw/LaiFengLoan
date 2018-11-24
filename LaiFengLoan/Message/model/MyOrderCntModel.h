//
//  MyOrderCntModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/20.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderCntModel : NSObject
@property (nonatomic ,copy) NSNumber *auditOrderCnt;
@property (nonatomic ,copy) NSNumber *completedOrderCnt;
@property (nonatomic ,copy) NSNumber *waitPayOrderCnt;
@property (nonatomic ,copy) NSNumber *waitRepayOrderCnt;
@end
//auditOrderCnt    integer($int64)
//审核中订单数
//completedOrderCnt    integer($int64)
//已结清订单数
//waitPayOrderCnt    integer($int64)
//待放款订单数
//waitRepayOrderCnt    integer($int64)
//待还款订单数
