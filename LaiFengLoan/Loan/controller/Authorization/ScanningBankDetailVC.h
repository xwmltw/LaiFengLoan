//
//  ScanningBankDetailVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "ScanningBankVC.h"
#import "BankModel.h"

typedef void(^ScannngBankDetail)(NSString *bankName,NSString *bankNumer,NSString *bankCode);
@interface ScanningBankDetailVC : ScanningBankVC
@property (nonatomic, strong) BankModel *model;
@property (nonatomic, strong) UIImage *bankImage;
@property (nonatomic, copy) ScannngBankDetail block;
@end
