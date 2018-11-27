//
//  BankViewController.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XBaseViewController.h"
#import "CreditInfoModel.h"
@interface IdentityViewController : XBaseViewController
@property (nonatomic ,copy) NSNumber *isFromVC;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end
