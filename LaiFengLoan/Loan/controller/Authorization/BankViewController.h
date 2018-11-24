//
//  BankViewController.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ScanningBankVC.h"
#import "CreditInfoModel.h"
@interface BankViewController : ScanningBankVC
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end
