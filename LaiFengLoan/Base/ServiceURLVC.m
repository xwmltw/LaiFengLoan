//
//  ServiceURLVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/1.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ServiceURLVC.h"
#import "LoanMainVC.h"

@interface ServiceURLVC ()

@end

@implementation ServiceURLVC
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您手机系统版本过低，该应用只支持iOS8.0以上使用" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
    [self prepareDataWithCount:0];
}
- (void)getServiceURL{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
     LoanMainVC *vc = [[LoanMainVC alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    window.rootViewController = navi;
}
- (void)setRequestParams{
    self.cmd = XGetGlobal;
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    [[ClientGlobalInfo mj_objectWithKeyValues:response.data] setClientGlobalInfoModel];
    [self getServiceURL];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
