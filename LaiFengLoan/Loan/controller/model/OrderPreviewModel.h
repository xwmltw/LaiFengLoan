//
//  OrderPreviewModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/15.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPreviewModel : NSObject
@property (nonatomic ,copy) NSNumber *dueRepayAmt;
@property (nonatomic ,copy) NSString *eleContractPreviewUrl;
@property (nonatomic ,copy) NSNumber *orderAmt;
@property (nonatomic ,copy) NSString *orderNo;
@property (nonatomic ,copy) NSDictionary *orderNodeInfo;
@property (nonatomic ,copy) NSNumber *stageTimeunitCnt;
@property (nonatomic ,copy) NSNumber *syspayAmt;
@property (nonatomic ,copy) NSString *syspayBankCardNo;
@end
//dueRepayAmt    number($double)
//到期应还金额
//eleContractPreviewUrl    string
//合同预览地址
//orderAmt    number($double)
//借款金额(用户提交的金额),例:1000.00
//orderNo    string
//订单编号
//orderNodeInfo    OrderNodeInfo{
//    订单节点数据
//    nodeDesc    string
//    订单进度详
//    nodeTime    integer($int64)
//    订单进度时间[格式为：时间戳]
//    nodeTitle    string
//    订单进度标题
//}
//stageTimeunitCnt    integer($int32)
//借款(周期)天数
//syspayAmt    number($double)
//放款金额
//syspayBankCardNo    string
//到账卡号
