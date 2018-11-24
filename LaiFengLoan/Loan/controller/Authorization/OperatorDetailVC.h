//
//  OperatorDetailVC.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/9.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XBaseViewController.h"
#import "OperatorModel.h"
@interface OperatorDetailVC : XBaseViewController
@property (nonatomic, strong) OperatorModel *model;
@property (nonatomic ,copy) NSNumber *isFromVC;
@end
