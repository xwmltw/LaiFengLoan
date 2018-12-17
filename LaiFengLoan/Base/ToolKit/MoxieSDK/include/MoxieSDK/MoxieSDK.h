//
//  MoxieSDK.h
//  MoxieSDK
//
//  Created by shenzw on 6/23/16.
//  Copyright © 2016 shenzw. All rights reserved.
//
//  MXSDKVersion @"2.3.7"


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MXLoginCustom;
/**
 SDK运行模式
 - MoxieSDKRunModeForeground: 前台导入（有界面）
 - MoxieSDKRunModeBackground: 后台静默导入
 */
typedef NS_ENUM(NSUInteger, MoxieSDKRunMode) {
    MoxieSDKRunModeForeground = 0,
    MoxieSDKRunModeBackground
};

@protocol MoxieSDKDelegate<NSObject>
#pragma mark - SDK 结果代理回调接口
@required
/**
 *  结果回调函数
 */
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary;
@optional
/**
 *  任务进度回调
 */
-(void)receiveMoxieSDKStatus:(NSDictionary*)statusDictionary;
/**
 *  自定义接口情况下，参数可加密自定义，默认情况不需要实现
 */
-(NSString*)postWithBodyString:(NSString*)bodyString;
@end

#pragma mark - SDK 进度回调接口
@protocol MoxieSDKProgressDelegate<NSObject>/**
 *  转圈页面进度回调
 */
-(void)updateProgress:(NSDictionary*)progressDictionary;
@end

#pragma mark - SDK 界面数据源接口
@protocol MoxieSDKDataSource<NSObject>
/**
 *  自定义statusView
 */
-(UIView *)statusViewForMoxieSDK;
@end


@interface MoxieSDK : NSObject
#pragma mark - SDK 函数接口
/**
 *  SDK单例
 */
+(MoxieSDK*)shared;
/**
 *  打开SDK功能函数，如果需要自定义登录，请设置loginCustom参数
 *  调用start函数，从MoxieSDKRunModeForeground启动
 */
-(void)start;
/**
 *  使用后台模式打开SDK功能函数，默认为NO
 *  后台模式下，如果遇到需要输入的项目（如账号或密码错误，需要图片、二次验证码等），都会自动从后台弹出输入界面，输入完会自动隐藏
 */
-(void)startInMode:(MoxieSDKRunMode)mode;
/**
 * 静默更新模式下，显示SDK页面
 */
-(void)show;
/**
 *  退出SDK
 */
-(void)finish;
/**
 从后台唤醒当前App 通知moxieSDK (使用截图认证的必须配置此函数)
 */
- (void)applicationWillEnterForeground:(UIApplication *)application;

#pragma mark - SDK 基本参数（只读）
/**
 * SDK版本号
 */
@property (nonatomic,copy,readonly) NSString *version;
/**
 * 是否有任务在进行中
 */
@property (nonatomic,assign,readonly) BOOL doing;
/**
 * 当前运行的模式
 */
@property (nonatomic,assign,readonly) MoxieSDKRunMode runMode;
/**
 * 当前模式下的controller是否在前台展示
 * MoxieSDKRunModeForeground下一直为YES
 * MoxieSDKRunModeForeground下会随着用户输入变化
 */
@property (nonatomic,assign,readonly) BOOL controllerIsForeground;
#pragma mark - SDK 打开必传配置参数 （必传）
/**
 * 接受回调的代理
 */
@property (nonatomic,weak) id <MoxieSDKDelegate> delegate;
/**
 * 自定义数据源，目前可自定义的有：statusView
 */
@property (nonatomic,weak) id <MoxieSDKDataSource> dataSource;
/**
 * 进度回调的代理
 */
@property (nonatomic,weak) id <MoxieSDKProgressDelegate> progressDelegate;
/**
 * 来自controller，用来做push或present
 */
@property (nonatomic,weak) UIViewController *fromController;
/**
 * 租户的用户id标识（会在服务端回调给租户）
 */
@property (nonatomic,copy) NSString *userId;
/**
 * 租户在魔蝎的apiKey
 */
@property (nonatomic,copy) NSString *apiKey;
/**
 * 打开的业务类型
 */
@property (nonatomic,copy) NSString *taskType;

#pragma mark - SDK 自定义登录参数列表（可选）
/*
 * 三要素传参 （此方式也可用于运营商登录参数填写）
 */
//手机号码
@property (nonatomic,copy) NSString *phone;
//姓名
@property (nonatomic,copy) NSString *name;
//身份证
@property (nonatomic,copy) NSString *idcard;

//自定义登录参数（每次打开SDK都需要进行设置）
@property (nonatomic,strong) MXLoginCustom *loginCustom;

#pragma mark - SDK 自定义控制参数列表（可选）
/*
 * 登录验证成功后即退出，默认为NO
 */
@property (nonatomic,assign) BOOL quitOnLoginDone;
/*
 * 任务失败的时候自动退出，默认为NO
 */
@property (nonatomic,assign) BOOL quitOnFail;
/*
 * 退出后，回调创建任务的信息（如账号，密码等），通过taskInfo的key进行获取
 */
@property (nonatomic,assign) BOOL callbackTaskInfo;
/**
 * 缓存是否生效，默认为NO
 */
@property (nonatomic,assign) BOOL cacheDisable;
/**
 * 禁止SDK内SDK的退出操作，即结束后pop和push逻辑在SDK外处理，只适用于useNavigationPush=YES的情况
 * 默认为NO
 * backgroundMode模式下，该字段设置是无效的。（因为默认会无界面运行）
 */
@property (nonatomic,assign) BOOL quitDisable;
/**
 * 静默更新下，设置是否禁止自动弹出验证码让用户交互。默认为NO，会自动弹出。
 */
@property (nonatomic,assign) BOOL autoPresentDisable;
/**
 *  主题色定义
 */
@property (nonatomic,strong) UIColor *themeColor;
/**
 *  加载进度条颜色
 */
@property (nonatomic,strong) UIColor *progressLineColor;
/**
 *  协议地址
 */
@property (nonatomic,copy) NSString *agreementUrl;
/**
 *  协议入口文字
 */
@property (nonatomic,copy) NSString *agreementEntryText;
/**
 *  加载界面文字
 */
@property (nonatomic,copy) NSString *loadingViewText;
/**
 *  隐藏导入界面的刷新按钮，默认为NO
 */
@property (nonatomic,assign) BOOL hideRightButton;
/**
 *  内部Controller的edgesForExtendedLayout属性设置，默认为UIRectEdgeAll
 */
@property (nonatomic,assign) UIRectEdge edgesForExtendedLayout;
/**
 *  第一页的title
 */
@property (nonatomic,copy) NSString *title;
/**
 *  返回按钮图片名
 */
@property (nonatomic,copy) NSString *backImageName;
/**
 *  关闭按钮图片名
 */
@property (nonatomic,copy) NSString *quitImageName;
/**
 *  刷新按钮图片名
 */
@property (nonatomic,copy) NSString *refreshImageName;
/**
 *  自定义图片加载路径（图片名请依旧保持目前的图片名）
 imagePath示例如下：[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"MXResources"]
 */
@property (nonatomic,copy) NSString *imagePath;

#pragma mark - SDK 自定义接口（默认不需要定制）
/**
 *  根据图片大小设置navBarButtonItem，默认为NO
 */
@property (nonatomic,assign) BOOL barButtonItemDisplayWithImageSize;
/**
 * 打开SDK效果，是否使用Push（PUSH方式需要fromController包含navigationController）
 * 默认为YES
 */
@property (nonatomic,assign) BOOL useNavigationPush;
/**
 * useNavigationPush为YES情况下（默认为YES），不需要设置navigationController
 * useNavigationPush为NO情况下，present进入的导航器设置，可以通过设置navigationController来设定内置NavBar的属性
 */
@property (nonatomic,strong) UINavigationController *navigationController;
/**
 *  自定义接口，默认情况不需要实现
 */
@property (nonatomic,strong) NSDictionary *customAPI;

@end


/**
 * 自定义登录参数类
 */
@interface MXLoginCustom : NSObject
//登录项目类型
@property (nonatomic,copy) NSString *loginType;
//登录项目编号
@property (nonatomic,copy) NSString *loginCode;
//登录预填参数
@property (nonatomic,strong) NSDictionary *loginParams;
//登录元素不传时隐藏，默认为NO
@property (nonatomic,assign) BOOL loginOthersHide;
//是否支持修改默认传参
@property (nonatomic,assign) BOOL editable;

/**
 * 【网银自定义登录】
 loginCode 如网银为bankId，公积金为areaCode等，为nil时打开列表页/首页
 loginType 如网银为CREDITCARD/DEBITCARD
 如打开网银-招商银行-信用卡-身份证登录-预填username，且隐藏其他登录方式，如下：
 MXLoginCustom *loginCustom = [MXLoginCustom new];
 loginCustom.loginCode = @"CMB";
 loginCustom.loginType = @"CREDITCARD";
 loginCustom.loginParams = @{
     @"IDCARD":@{
         @"username":@"330501198910101010",
         @"password":@"yyyyyy",
         @"editable":@"1", //是否可修改账号（可不传）
         @"selected":@"1"  //是否默认选中该tab（可不传）
     }
 };
 loginCustom.loginOthersHide = YES;
 [MoxieSDK shared].loginCustom = loginCustom;
 
 * 【邮箱自定义登录】
 MXLoginCustom *loginCustom = [MXLoginCustom new];
 loginCustom.loginCode = @"qq.com";
 loginCustom.loginParams = @{
     @"username":@"xxxxxx@qq.com",
     @"password":@"yyyyyy",
     @"sepwd":@"zzzzzz"
 }
 [MoxieSDK shared].loginCustom = loginCustom;
 
 * 【运营商自定义登录】示例：
 MXLoginCustom *loginCustom = [MXLoginCustom new];
 loginCustom.loginParams" = @{
     @"phone":@"13000000000",
     @"name":@"张三",
     @"idcard":@"313045678902234"
 }
 [MoxieSDK shared].loginCustom = loginCustom;
 */
@end
