//
//  SCCaptureCameraController.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#include "Globaltypedef.h"
#import "CameraBankDrawView.h"

@interface SCCaptureCameraController : UIViewController

@property (nonatomic, assign) id scNaigationDelegate;
@property (nonatomic, assign) CGRect previewRect;
@property (nonatomic, assign) BOOL isStatusBarHiddenBeforeShowCamera;
@property (nonatomic, assign) TCARD_TYPE iCardType; /*引擎类型*/
@property (nonatomic, assign) BOOL isDisPlayTxt;    /*是否显示身份证展示信息*/
@property (nonatomic, assign) BOOL isDisPlayView;    /*是否显示身份证展示信息*/
@property (nonatomic, assign) TIDC_REC_MODE ScanMode;       /*身份证是否为扫描模式 默认拍照模式*/

//获取当前页面的截图
//+ (UIView *)captureScreenInRect:(CGRect)captureFrame;
-(UIImage *)captureImageFromViewLow:(UIView *)orgView;
@end


@protocol SCNavigationControllerDelegate <NSObject>
@optional

// 证件识别接口
- (void)sendAllValue:(NSString *)text;
- (void)sendIDCValue:(NSString *)name SEX:(NSString *)sex FOLK:(NSString *)folk BIRTHDAY:(NSString *)birthday ADDRESS:(NSString *) address NUM:(NSString *)num;
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period;
- (void)sendLPRValue:(NSString *)num;
- (void)sendXSZValue:(NSString *)dp_plateno DP_TYPE:(NSString *)dp_type DP_OWNER:(NSString *)dp_owner DP_ADDRESS:(NSString *)dp_address DP_USECHARACTER:(NSString *) dp_usecharacter DP_MODEL:(NSString *)dp_model DP_VIN:(NSString *) dp_vin DP_ENGINENO:(NSString *)dp_engineno DP_REGISTER_DATE:(NSString *) dp_register_date DP_ISSUE_DATE:(NSString *)dp_issue_date;
- (void)sendJSZValue:(NSString *)dl_num DL_NAME:(NSString *)dl_name DL_SEX:(NSString *)dl_sex DL_COUNTRY:(NSString *) dl_country DL_ADDRESS:(NSString *)dl_address DL_BIRTHDAY:(NSString *)dl_birthday DL_ISSUE_DATE:(NSString *)dl_issue_date DL_CLASS:(NSString *)dl_class DL_VALIDFROM:(NSString *)dl_validfrom DL_VALIDFOR:(NSString *)dl_validfor;
- (void)sendTICValue:(NSString *)tic_start TIC_NUM:(NSString *)tic_num TIC_END:(NSString *)tic_end TIC_TIME:(NSString *)tic_time TIC_SEAT:(NSString *)tic_seat TIC_NAME:(NSString *) tic_name;
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage;
- (void)sendCardFaceImage:(UIImage *)image;
- (void)sendFieldImage:(TFIELDID) field  image:(UIImage *)fieldimage;

// 银行卡识别接口
- (void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name;
- (void)sendBankCardImage:(UIImage *)BankCardImage;

@end






