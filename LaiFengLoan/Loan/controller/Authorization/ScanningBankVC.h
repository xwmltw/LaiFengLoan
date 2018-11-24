//
//  ScanningBankVC.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XBaseViewController.h"
#import "Globaltypedef.h"
#import "SCCaptureCameraController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanningBankVC : XBaseViewController
///**开始身份证正面扫描*/
-(void)startIDCardOCR;
///**开始身份证反面扫描*/
-(void)startIDCardBackOCR;
//**
// 开始银行卡扫描
// */
-(void)startBankCardOCR;
/**
 银行卡回调
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name;
/**
 @param BankCardImage 银行卡卡号扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage;

@end
