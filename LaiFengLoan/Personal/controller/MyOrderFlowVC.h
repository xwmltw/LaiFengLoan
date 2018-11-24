//
//  MyOrderFlowVC.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XBaseViewController.h"

@interface MyOrderFlowVC : XBaseViewController
@property (nonatomic ,assign) MyOrderState orderState;
@property (nonatomic ,copy) NSString *orderNo;
@end
