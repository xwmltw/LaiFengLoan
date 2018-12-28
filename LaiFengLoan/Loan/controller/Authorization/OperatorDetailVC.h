//
//  OperatorDetailVC.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/9.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XBaseViewController.h"
#import "OperatorModel.h"
#import "OperatorBQSModel.h"
#import "CreditInfoModel.h"
@interface OperatorDetailVC : XBaseViewController
@property (nonatomic, strong) OperatorModel *model;
@property (nonatomic, strong) OperatorBQSModel *BQSmodel;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@property (nonatomic ,copy) NSNumber *isFromVC;
@property (nonatomic ,copy) NSNumber *BQSStatus;
@end
