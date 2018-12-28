//
//  AppUtils.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/2.
//  Copyright © 2018年 xwm. All rights reserved.
//

#ifndef AppUtils_h
#define AppUtils_h


#endif /* AppUtils_h */


/** APP配置信息*/

static NSString *const TalkingData_ChannelId = @"AppStore";

#if (APP_Type == 0)

#define SERVICEURL @"http://pd-mapi.91qnd.com" // 测试环境
//#define SERVICEURL @"http://192.168.5.66:8053" // 从秦测试环境
//#define SERVICEURL @"http://192.168.5.126:8053" // 测试环境


static NSString *const AppName = @"来风现金贷";
static NSString *const AppScheme = @"LaiFengXJD";
static NSString *const AMapKey = @"7021cdb14ec5bdc9f52b5b420512f3db";
static NSString *const TalkingData_AppID =   @"";
#elif (APP_Type == 1)

//#define SERVICEURL @"http://mapi.lf.sdhoo.me" //正式环境
#define SERVICEURL @"http://pd-mapi.91qnd.com" // 测试环境
static NSString *const AppName = @"来风现金贷";
static NSString *const AppScheme = @"LaiFengXJD";
static NSString *const TalkingData_AppID =   @"969A998745F14C05B8634C3B9ACB872D";
static NSString *const AMapKey = @"7021cdb14ec5bdc9f52b5b420512f3db";
#elif (APP_Type == 2)

#define SERVICEURL @"http://cxh-mapi.pdl001.com"

static NSString *const AppName = @"潮享花";
static NSString *const AppScheme = @"ChaoHengHuaLoan";
static NSString *const TalkingData_AppID =   @"30F9A95726F44039A9872B7F3C940444";
static NSString *const AMapKey = @"1f75efab0632a947e96d6c099b5d5a9e";
#elif (APP_Type == 3)

#define SERVICEURL @"https://mapi.lf.hujiujinfu.com"

static NSString *const AppName = @"用呗";
static NSString *const AppScheme = @"YongBeiLoan";
static NSString *const TalkingData_AppID =   @"BF529F0C63914860999F0F85F6B198BA";
static NSString *const AMapKey = @"396a4baefddd54c5d7ff19b1f8a374d6";
#elif (APP_Type == 4)

#define SERVICEURL @"https://mapi.lf.myhairun.com"

static NSString *const AppName = @"海量花";
static NSString *const AppScheme = @"HaiLiangHuaLoan";
static NSString *const TalkingData_AppID =   @"1D959493B7044E65B1C70D70BC021A85";
static NSString *const AMapKey = @"b71aee16533e4683b02681f66cc7cee2";

#elif (APP_Type == 5)

#define SERVICEURL @"https://mapi.mykuaibei.net"

static NSString *const AppName = @"快呗";
static NSString *const AppScheme = @"kuaibeiLoan";
static NSString *const TalkingData_AppID =   @"96985635A7D5435DA29602B214034B1C";
static NSString *const AMapKey = @"309135e58e292bf426310adb188f7c82";

#elif (APP_Type == 6)

#define SERVICEURL @"https://mapi.lf.yrxin.com"

static NSString *const AppName = @"优来花";
static NSString *const AppScheme = @"YouLaiHuaLoan";
static NSString *const TalkingData_AppID =   @"1B79EDD8ED374A6D91679BAE6F7224BB";
static NSString *const AMapKey = @"325e91aa43515bc2b76f0d332c47dd8e";

#elif (APP_Type == 7)

#define SERVICEURL @"http://mapi.jidaibao168.com"

static NSString *const AppName = @"急贷宝";
static NSString *const AppScheme = @"JiDaiBaoLoan";
static NSString *const TalkingData_AppID =   @"E2EC96B77E3E4967821F7CFA605FEA0A";
static NSString *const AMapKey = @"7cf771e4ffc357d670c1ce58374eea06";

#elif (APP_Type == 8)

#define SERVICEURL @"https://mapi.tspsy.net.cn"

static NSString *const AppName = @"梦想贷";
static NSString *const AppScheme = @"MengXiangLoan";
static NSString *const TalkingData_AppID =   @"59BA7F6C8C2944AEA4642434479E92AA";
static NSString *const AMapKey = @"98b016a3e2c4b17f9ca42c41888965d2";

#elif (APP_Type == 9)

#define SERVICEURL @"http://mapi.xiaodaishu01.com"

static NSString *const AppName = @"小贷鼠";
static NSString *const AppScheme = @"XiaoDaiShuLoan";
static NSString *const TalkingData_AppID =   @"44373F983D954F83AA20297ECE277C94";
static NSString *const AMapKey = @"e22ac688e591cd1efd8e7c427d748863";

#elif (APP_Type == 10)

#define SERVICEURL @"http://xhy-mapi.pdl001.com"

static NSString *const AppName = @"小黄鱼";
static NSString *const AppScheme = @"XiaoHuangYuLoan";
static NSString *const TalkingData_AppID =   @"1AF4D12666EC4A0CADF20A1F2CD5A8D1";
static NSString *const AMapKey = @"8d24ffe23173796fa7b5d7a362665f5d";

#elif (APP_Type == 11)

#define SERVICEURL @"http://mapi.xiaokoudai00.com"

static NSString *const AppName = @"小口袋";
static NSString *const AppScheme = @"XiaoKouLoan";
static NSString *const TalkingData_AppID =   @"B53D426EE09B460D936BD52F3E77F217";
static NSString *const AMapKey = @"de5999050bb72794ffa789231542e7d2";

#elif (APP_Type == 12)

#define SERVICEURL @"https://mapi.pdl001.com"

static NSString *const AppName = @"鑫易贷";
static NSString *const AppScheme = @"XinYiDai";
static NSString *const TalkingData_AppID =   @"2138E87340F64502BAF22FB2B413BE72";
static NSString *const AMapKey = @"fd7016bdd0be18a5ddf2ebc27ddd0783";
#endif

/** JSPatch*/
static NSString *const JSPatchId = @"ea6f4017d1244661";
static NSString *const JSPatchRSAPublicKey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDqUvdaT0L9fTuJ3n+aFsV3DUnL\nD3VYqXoS6DZcDhoZKxvQVMs7WBefiJSzDdKtLQZinJYH1gZAkkV8l4useGO9TvJB\nlPV++MXmFwSLUtvG4Hoq+vVLq/mH9DTMddGgTPvAxrFAG8Nyb5f2OsgeBsp8Xu21\nYsPcIUlFCStmln5kcwIDAQAB\n-----END PUBLIC KEY-----";







/**通知*/
static NSString *const XUpdateCreditInfo = @"XUpdateCreditInfo";
static NSString *const XAliPaySucceed = @"AliPaySucceed";

/**接口名称*/
#define XUserLogin              @"/mapi/session/login"                     /*!< 登录*/
#define XUserlogout             @"/mapi/session/logout"                    /*!< 退出登录*/
#define XUserRegister           @"/mapi/session/register"                  /*!< 注册*/
#define XModifyPassword         @"/mapi/session/updatePwd"                 /*!< 更新密码*/
#define XSMSCode                @"/mapi/valid/get_sms_code"                /*!< 短信验证码*/
#define XImageCode              @"/mapi/valid/get_image_code"              /*!< 图形验证码*/

#define XGetGlobal              @"/mapi/global/get_global_cfg"             /*!< 全局配置*/

#define XGetIdentityVerify      @"/mapi/identity/verify/get_params"        /*!< 身份认证获取所需参数*/
#define XPostIdentityVerify     @"/mapi/identity/verify/post_verify_info"  /*!< 提交身份认证信息*/
#define XGetIdentityInfo        @"/mapi/user/get_identity_info"             /*!< 获取身份认证信息*/

#define XPostContactVerify      @"/mapi/user/post_contact_info"            /*!< 提交联系人信息*/
#define XGetContactVerify       @"/mapi/user/get_contact_info"             /*!< 获取联系人信息*/
#define XGetBaseVerify          @"/mapi/user/get_base_info"                /*!< 获取基本信息*/
#define XPostBaseVerify         @"/mapi/user/post_base_info"               /*!< 提交基本信息*/
#define XPostOperatorVerify     @"/mapi/operator/v2/request_report"           /*!< 提交运营商信息*/
#define XGetOperatorVerify      @"/mapi/operator/v2/request_info"             /*!< 请求运营商信息*/

#define XGetBankList            @"/mapi/bank/get_bank_list"                /*!< 获取银行卡列表*/
#define XGetUserBankList        @"/mapi/bank/get_bind_card_list"            /*!< 获取用户绑定银行卡列表*/
#define XGetValidCode           @"/mapi/bank/get_valid_code"                /*!< 绑定银行卡接口（获取验证码接口）*/
#define XGetValidCodeAgain      @"/mapi/bank/get_valid_code_again"          /*!< 绑定银行卡接口（重新获取验证码接口）*/
#define XPostBankCard           @"/mapi/bank/post_bind_bank_card"           /*!< 提交绑定银行卡接口*/

#define XGetCreditInfoVerify    @"/mapi/credit/get_credit_info"            /*!< 获取授信相关信息*/
#define XPostCreditInfoVerify   @"/mapi/credit/post_get_credit"            /*!< 提交授信相关信息*/

#define XFeedback               @"/mapi/help/post_feedback"               /*!< 意见反馈信息*/
#define XCommonProblem          @"/mapi/help/get_qa_list"                 /*!< 常见问题信息*/
#define XAboutUsInfo            @"/mapi/help/get_about_us"                /*!< 关于我们信息*/
#define XQuestionInfo           @"/mapi/help/get_qa_list"                 /*!< 常见问题信息*/

#define XGetOrderDetail         @"/mapi/order/get_order_detail"           /*!< 获取订单详情数据*/
#define XGetOrderList           @"/mapi/order/get_order_list"             /*!< 获取订单列表*/
#define XGetOrderCntInf         @"/mapi/order/get_order_cnt_inf"          /*!< 获取订单列表统计数据*/
#define XRepayOrder             @"/mapi/order/repay_order"                 /*!< 订单还款*/


#define XGetPreviewOrder        @"/mapi/order/preview_order"              /*!< 订单预览*/
#define XPostConfirmOrder       @"/mapi/order/confirm_order"              /*!< 提交订单*/
#define XPostConfirmOrderNocredit       @"/mapi/order/confirm_order_nocredit"              /*!< 提交订单(授信通过之前)*/


#define XGetMessageList         @"/mapi/message/get_message_list"          /*!< 获取消息列表*/

#define XGetAlipayParam         @"/mapi/alipay/getAlipayParam"
#define XPostAlipayParam        @"/mapi/alipay/postAlipayParam"
#define XGetTaoBaoParam         @"/data/getTaoBaoParam"
#define XPostTaoBaoParam        @"/data/postTaoBaoParam"

#define XOperatorLogin          @"/mapi/operator/bqs/do_login"
#define XOperatorSendAuthSMS    @"/mapi/operator/bqs/do_send_auth_sms"
#define XOperatorSendLoginSMS   @"/mapi/operator/bqs/do_send_login_sms"
#define XOperatorVerifyLoginSMS @"/mapi/operator/bqs/do_verify_auth_sms"




