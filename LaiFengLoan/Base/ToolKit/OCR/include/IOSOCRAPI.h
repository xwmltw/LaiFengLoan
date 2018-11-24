//
//  IOSOCRAPI.h
//  IOSOCRAPI
//
//  Created by Turui on 15/8/6.
//  Copyright (c) 2015年 Turui. All rights reserved.
//

#ifndef IOS_OCR_H
#define IOS_OCR_H
#import <UIKit/UIKit.h>
#include "Globaltypedef.h"

NSString *TREC_GetVersionArray();// 获取版本信息
NSString *TREC_GetCopyrightInfoArray();//获取版权信息
NSString *TREC_GetTimeStatus();// 获取引擎测试时间
Gint TREC_StartUP();//引擎初始化
Gint TREC_SetParam(TPARAM euType, void* pValue);//引擎设置参数
Gint TREC_GetParam(TPARAM euType, void* pValue);//引擎获取设置参数
Gint TREC_GetSupportEngine(TCARD_TYPE iCardType);
Gint TREC_SetSupportEngine(TCARD_TYPE iCardType);
Gint TREC_LoadImage(UIImage *uimage);// 引擎 加载图片
Gint TREC_LoadImage_Ex(NSString *pImagePath);// 引擎加载图片(图片路径形式)
Gint TREC_JudgeExist(Gint x1, Gint y1, Gint x2, Gint y2);
Gint TREC_SaveImage(NSString *pImagePath);// 保存图片到本地
Gint TREC_OCR();// 引擎识别
Gint TREC_FreeImage();// 引擎识别(图片路径形式)
TCARD_TYPE TREC_GetCardType();// 引擎识别
NSString *TREC_GetOcrString();// 获取全部的信息
NSString *TREC_GetFieldString(TFIELDID  field);// 获取各个栏的识别信息
UIImage *TREC_GetFieldImage(TFIELDID  field);// 获取对应的图片流
NSString *TREC_GetJsonStringBuffer();// 获取识别信息json流数据
Gint  TREC_GetCardNumState();// 获取身份证证号状态
UIImage *TREC_GetHeadImage();// 获取人头像图片流
Gint TREC_SaveHeadImage(NSString *path);// 保存人头像到本地
Gint TREC_ClearUP();//引擎释放

// 银行卡接口
Gint TBANK_LoadImage(UIImage *uimage);      // 银行卡导入图片
Gint TBANK_LoadImage_Ex1(NSString *pImagePath);// 通过路径导入图片
Gint TBANK_JudgeExist(Gint x1, Gint y1, Gint x2, Gint y2); //  银行卡找边
Gint TBANK_OCR();// 银行卡识别
Gint TBANK_SaveImage(NSString *ImagePath);   // 银行卡保存图片
Gint TBANK_FreeImage();                      // 银行卡释放函数
UIImage *TBANK_GetSmallImage();             // 获取识别区域图片
NSString *TBANK_GetBankInfoString(TGETBANKINFOID tGetBankId);   // 根据识别到的卡号进行信息查询
NSString *TBANK_GetPublicBankInfoString(TGETBANKINFOID tGetBankId,NSString *BankCardNum);// 根据自定义卡号，获取信息

#endif
