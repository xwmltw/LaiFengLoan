//
//  ParamModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BannerAdList,VersionInfo;

@interface ParamModel : NSObject
- (NSString *)getContent;
@end
//通用参数
@interface BaseInfoPM: ParamModel
@property (nonatomic ,copy) NSString *accessChannelCode;
@property (nonatomic ,copy) NSString *appVersionCode;
@property (nonatomic ,copy) NSNumber *clientType;
@property (nonatomic ,copy) NSString *imei;
@property (nonatomic ,copy) NSString *uid;

@end
@interface ClientGlobalInfo:ParamModel
@property (nonatomic ,strong) NSArray *bannerAdList;
@property (nonatomic ,copy) NSString *borrowDaysMax;
@property (nonatomic ,copy) NSString *borrowDaysMin;
@property (nonatomic ,copy) NSString *firstLoanAmtFixedDesc;
@property (nonatomic ,copy) NSString *firstLoanAmtFixedType;
@property (nonatomic ,copy) NSString *firstLoanAmtMin;
@property (nonatomic ,copy) NSString *firstLoanAmtFixedSupportUserCreditAmt;
@property (nonatomic ,copy) NSString *notFirstLoanAmtFixedDesc;
@property (nonatomic ,copy) NSString *notFirstLoanAmtFixedType;
@property (nonatomic ,copy) NSString *notFirstLoanAmtMin;
@property (nonatomic ,copy) NSString *notFirstLoanAmtFixedSupportUserCreditAmt;
@property (nonatomic ,copy) NSString *riskCreditAmtMax;
@property (nonatomic ,copy) NSString *companyCopyrightInfo;
@property (nonatomic ,copy) NSString *customerContact;
@property (nonatomic ,copy) NSString *registAgreementUrl;
@property (nonatomic ,copy) NSString *notLoginShowCreditMax;
@property (nonatomic ,copy) NSString *repaymentMethod;
@property (nonatomic ,copy) NSString *orderJQZMUrl;
@property (nonatomic ,strong) VersionInfo *versionInfo;
@property (nonatomic ,copy) NSNumber *decisionType;
@property (nonatomic ,copy) NSNumber *isNeedAlipayVerify;
@property (nonatomic ,copy) NSNumber *hasExtension;
//存储数据
- (void)setClientGlobalInfoModel;
+ (ClientGlobalInfo *)getClientGlobalInfoModel;
//bannerAdList             banner广告列表
//borrowDaysMax    string//最长借款期限
//borrowDaysMin    string//最短借款期限
//firstLoanAmtFixedDesc    string//[首借]固定类型描述: 固定值时即为N个固定值,隔开; 区间值时表示金额颗粒度
//firstLoanAmtFixedType    string//[首借]借款金额金额固定类型 1固定值，2区间值
//firstLoanAmtMin    string//[首借]借款金额最低金额
//firstLoanAmtFixedSupportUserCreditAmt //[首借]固定金额时是否支持使用（可用金额）
//notFirstLoanAmtFixedDesc    string//[非首借]固定类型描述: 固定值时即为N个固定值,隔开; 区间值时表示金额颗粒度
//notFirstLoanAmtFixedType    string//[非首借]借款金额金额固定类型 1固定值，2区间值
//notFirstLoanAmtMin    string//[非首借]借款金额最低金额
//notFirstLoanAmtFixedSupportUserCreditAmt //[非首借]固定金额时是否支持使用（可用金额）
//riskCreditAmtMax    string//风控最高授信额度
//companyCopyrightInfo    string//公司版权信息，例：@copyright XX服务有限公司
//customerContact    string//客服联系方式
//registAgreementUrl  注册协议
//notLoginShowCreditMax 用户未登录显示的最大可借额度
//repaymentMethod //还款方式(1,2)  1银行卡2支付宝
//versionInfo    VersionInfoVo
//decisionType    string风控引擎类型: 0系统自动审核(悦才风控) 1人工审核(接入白骑士)
//isNeedAlipayVerify    string是否需要支付宝认证: 1是 0否
//hasExtension    integer($int32)是否开启展期: 1是 0否
@end
@interface VersionInfo:ParamModel
@property (nonatomic ,copy) NSNumber *needForceUpdate;
@property (nonatomic ,copy) NSString *url;
@property (nonatomic ,copy) NSNumber *version;
@property (nonatomic ,copy) NSString *versionDesc;
//    全局配置接口返回版本自动更新信息
//
//    needForceUpdate    integer($int32)
//    强制升级 1是,0否
//
//    url    string
//    升级地址
//
//    version    integer($int32)
//    版本号
//
//    versionDesc    string
//    版本说明
//
//}
@end
@interface BannerAdList:ParamModel
@property (nonatomic ,copy) NSString *adContent;
@property (nonatomic ,copy) NSString *adDetailUrl;
@property (nonatomic ,copy) NSNumber *adId;
@property (nonatomic ,copy) NSString *adImgUrl;
@property (nonatomic ,copy) NSString *adName;
@property (nonatomic ,copy) NSNumber *adType;
//adContent    string
//广告内容
//adDetailUrl    string
//广告详情url
//adId    integer($int64)
//广告id
//adImgUrl    string
//广告内图片地址
//adName    string
//广告名称
//adType    integer($int32)
//广告类型 1:应用内（本地）打开链接，2:浏览器(新窗口)打开链接
@end

