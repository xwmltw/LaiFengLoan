//
//  AppDelegate.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/10/31.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "AppDelegate.h"
#import "ServiceURLVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "UserLocation.h"
#import "JPEngine.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //第三方配置
    [self addThreeConfig:launchOptions];
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ServiceURLVC *vc = [[ServiceURLVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)addThreeConfig:(NSDictionary *)launchOptions{
    //键盘
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [TalkingData setExceptionReportEnabled:YES];
    [TalkingData sessionStarted:TalkingData_AppID withChannelId:TalkingData_ChannelId];
    
    //高德
    [AMapServices sharedServices].apiKey = AMapKey;
    [[UserLocation sharedInstance]UserLocation];
    
//    jsp
}
#pragma mark - 支付宝
/**
 *  支付宝返回字段解析
 *
 *  @param AllString            字段
 *  @param FirstSeparateString  第一个分离字段的词
 *  @param SecondSeparateString 第二个分离字段的词
 *
 *  @return 返回字典
 */
-(NSMutableDictionary *)setComponentsStringToDic:(NSString*)AllString withSeparateString:(NSString *)FirstSeparateString AndSeparateString:(NSString *)SecondSeparateString{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    
    NSArray *FirstArr=[AllString componentsSeparatedByString:FirstSeparateString];
    
    for (int i=0; i<FirstArr.count; i++) {
        NSString *Firststr=FirstArr[i];
        NSArray *SecondArr=[Firststr componentsSeparatedByString:SecondSeparateString];
        [dic setObject:SecondArr[1] forKey:SecondArr[0]];
        
    }
    
    return dic;
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    //    if (!result) {
    // 其他如支付等SDK的回调
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
        if (orderState==9000) {
            NSString *allString=resultDic[@"result"];
            NSString * FirstSeparateString=@"\"&";
            NSString *  SecondSeparateString=@"=\"";
            NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
            NSLog(@"ali=%@",dic);
            if ([dic[@"success"]isEqualToString:@"true"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:XAliPaySucceed object:nil userInfo:@{@"success":@"支付成功"}];
            }
        }else{
            NSString *returnStr;
            switch (orderState) {
                case 8000:returnStr=@"订单正在处理中";break;
                case 4000:returnStr=@"订单支付失败";break;
                case 6001:returnStr=@"订单取消";break;
                case 6002:returnStr=@"网络连接出错";break;
                default:break;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:XAliPaySucceed object:nil userInfo:@{@"success":returnStr}];
        }
    }];
    return YES;

}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    //    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    //    if (!result) {
    // 其他如支付等SDK的回调
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
        if (orderState==9000) {
            NSString *allString=resultDic[@"result"];
            NSString * FirstSeparateString=@"\"&";
            NSString *  SecondSeparateString=@"=\"";
            NSMutableDictionary *dic=[self setComponentsStringToDic:allString withSeparateString:FirstSeparateString AndSeparateString:SecondSeparateString];
            MyLog(@"ali=%@",dic);
            //                if ([dic[@"msg"]isEqualToString:@"success"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":@"支付成功"}];
            //                }
        }else{
            NSString *returnStr;
            switch (orderState) {
                case 8000:returnStr=@"订单正在处理中";break;
                case 4000:returnStr=@"订单支付失败";break;
                case 6001:returnStr=@"订单取消";break;
                case 6002:returnStr=@"网络连接出错";break;
                default:break;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AliPaySucceed" object:nil userInfo:@{@"success":returnStr}];
        }
    }];
    return YES;
    //    }
    //    return result;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
