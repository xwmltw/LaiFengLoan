//
//  OrderDetailModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailModel : NSObject
@property (nonatomic ,copy) NSNumber *dueRepayAmt;
@property (nonatomic ,copy) NSNumber *dueRepayDate;
@property (nonatomic ,copy) NSString *eleContractPreviewUrl;
@property (nonatomic ,copy) NSString *eleCtrctDownloadUrl;
@property (nonatomic ,copy) NSNumber *orderAmt;
@property (nonatomic ,copy) NSString *orderNo;
@property (nonatomic ,copy) NSNumber *orderStatus;
@property (nonatomic ,copy) NSNumber *overDueAmt;
@property (nonatomic ,copy) NSNumber *overDueDays;
@property (nonatomic ,copy) NSNumber *repayAmt;
@property (nonatomic ,copy) NSNumber *repayPlanId;
@property (nonatomic ,copy) NSNumber *repayTime;
@property (nonatomic ,copy) NSNumber *stageTimeunitCnt;
@property (nonatomic ,copy) NSNumber *syspayAmt;
@property (nonatomic ,copy) NSString *syspayBankCardNo;
@property (nonatomic ,strong) NSArray *orderNodeInfoList;
@end
//dueRepayAmt    number($double)
//到期还款金额
//dueRepayDate    integer($int64)
//应还款日期
//eleContractPreviewUrl    string
//合同预览地址
//eleCtrctDownloadUrl    string
//合同查看地址
//orderAmt    number($double)
//借款金额(用户提交的金额),例:1000.00
//orderNo    string
//订单编号
//orderNodeInfoList    [
//                      订单进度信息
//                      OrderNodeInfo{
//                      description:
//                          订单节点数据
//                          nodeDesc    string
//                          订单进度详情
//                          nodeTime    integer($int64)
//                          订单进度时间[格式为：时间戳]
//                          nodeTitle    string
//                          订单进度标题
//                      }]
//orderStatus  订单状态订单状态: 0创建,1待审核 2审核中,3待签约,4签约中,5签约失败,6待放款,7放款中,8放款失败,9放款成功(还款中),98订单失败(审核拒绝,放款退单等),99订单结清(还款成功)
//overDueAmt    number($double)
//违约金
//overDueDays    integer($int32)
//违约天数
//repayAmt    number($double)
//应还总额
//repayPlanId    integer($int64)
//还款计划ID
//repayTime    integer($int64)
//还款时间
//stageTimeunitCnt    integer($int32)
//借款(周期)天数
//syspayAmt    number($double)
//放款金额
//syspayBankCardNo    string
//到账卡号
