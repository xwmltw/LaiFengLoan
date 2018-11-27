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

/** APP NAME*/
static NSString *const AppName = @"来风现金贷";
static NSString *const AppScheme = @"LaiFengXJD";
/** 网络环境*/
#ifdef DEBUG

//#define SERVICEURL @"http://192.168.5.126:8081" // 测试环境
#define SERVICEURL @"http://mapi.lf.sdhoo.me" // 阿里测试环境


#else

#define SERVICEURL @"http://mapi.lf.sdhoo.me" //正式环境
#endif

/** TalkingData */

static NSString *const TalkingData_ChannelId = @"AppStore";

#ifdef DEBUG
static NSString *const TalkingData_AppID =   @"";
#else
static NSString *const TalkingData_AppID =   @"969A998745F14C05B8634C3B9ACB872D";
#endif

/** 高德*/
static NSString *const AMapKey = @"7021cdb14ec5bdc9f52b5b420512f3db";


/** 极光*/
#ifdef DEBUG
static NSString *const JPAppKey = @"";
#else
static NSString *const JPAppKey = @"";
#endif

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
#define XPostOperatorVerify     @"/mapi/operator/request_report"           /*!< 提交运营商信息*/
#define XGetOperatorVerify      @"/mapi/operator/request_info"             /*!< 请求运营商信息*/

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

#define XGetMessageList         @"/mapi/message/get_message_list"          /*!< 获取消息列表*/












