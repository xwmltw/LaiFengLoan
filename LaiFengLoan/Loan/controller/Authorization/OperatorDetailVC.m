//
//  OperatorDetailVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/9.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "OperatorDetailVC.h"
#import "AuthorizationHeadView.h"
#import "XCountDownButton.h"
#import "XAlertView.h"
#import "LoanMainVC.h"
#import "ZFBViewController.h"
#import "LoanDetailViewController.h"
typedef NS_ENUM(NSInteger ,OperatorDetailRequest) {
    OperatorDetailRequestPostVerify,
    OperatorDetailRequestBQSLogin,
    OperatorDetailRequestBQSSendAuthSMS,
    OperatorDetailRequestBQSSendLoginSMS,
    OperatorDetailRequestBQSVerifyAuthSMS,
};

@interface OperatorDetailVC ()

@end

@implementation OperatorDetailVC
{
    UITextField *_verificationText;
    XCountDownButton *_getVerificationCodeButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    
}
- (void)initUI{
    AuthorizationHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"AuthorizationHead" owner:self options:nil].lastObject;
    headView.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(90));
    [headView setHeadImage:@4];
    [self.view addSubview:headView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"发送短信到手机 %@",[[UserInfo sharedInstance].phoneName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
    label.textColor = LabelShallowColor;
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.top.mas_equalTo(headView.mas_bottom).offset(AdaptationWidth(10));
    }];
    
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.top.mas_equalTo(label.mas_bottom).offset(AdaptationWidth(60));
        make.height.mas_equalTo(AdaptationWidth(1));
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"短信验证码";
    label2.textColor = LabelAssistantColor;
    label2.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.bottom.mas_equalTo(line.mas_top).offset(AdaptationWidth(-14));
    }];
    
    _verificationText = [[UITextField alloc]init];
    _verificationText.backgroundColor = [UIColor whiteColor];
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您的验证码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    _verificationText.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    [_verificationText setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    [self.view addSubview:_verificationText];
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.centerY.mas_equalTo(label2);
        make.left.mas_equalTo(label2.mas_right).offset(AdaptationWidth(15));
    }];

    XCountDownButton *getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:AppMainColor forState:UIControlStateNormal];
    getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //      = UIEdgeInsetsMake(0, 0, 0, -AdaptationWidth(24));
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    _getVerificationCodeButton = getVerificationCodeButton;
    _verificationText.rightView = getVerificationCodeButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setCornerValue:AdaptationWidth(22)];
    [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:AppMainColor];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line);
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(54));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    [self beginCountDown];
    
}
#pragma mark - 验证码事件
- (void)getVerificationCodeClick:(XCountDownButton *)sender
{
    [self beginCountDown];
    if (self.clientGlobalInfo.decisionType.integerValue == 0) {
        self.model.type = @"RESEND_CAPTCHA";
        [self prepareDataWithCount:OperatorDetailRequestPostVerify];
    }else{
        switch (self.BQSStatus.integerValue) {
            case 11006:
                [self prepareDataWithCount:OperatorDetailRequestBQSSendLoginSMS];
                break;
            case 11007:
                [self prepareDataWithCount:OperatorDetailRequestBQSSendAuthSMS];
                break;
            
                
            default:
                break;
        }
    }
    
    
}
- (void)beginCountDown{
    _getVerificationCodeButton.userInteractionEnabled = NO;
    [_getVerificationCodeButton startCountDownWithSecond:60];
    [_getVerificationCodeButton countDownChanging:^NSString *(XCountDownButton *countDownButton,NSUInteger second){
        NSString *title = [NSString stringWithFormat:@"%@s", @(second)];
        return title;
    }];
    [_getVerificationCodeButton countDownFinished:^NSString *(XCountDownButton *countDownButton, NSUInteger second) {
        self->_getVerificationCodeButton.userInteractionEnabled = YES;
        return @"重新发送";
    }];
}
- (void)btnOnClick:(UIButton *)btn{
    if (!_verificationText.text.length) {
        [self setHudWithName:@"请输入验证法" Time:1 andType:1];
    }
    if (self.clientGlobalInfo.decisionType.integerValue == 0) {
        self.model.captcha = _verificationText.text;
        self.model.type = @"SUBMIT_CAPTCHA";
        [self prepareDataWithCount:OperatorDetailRequestPostVerify];
    }else{
        self.BQSmodel.operatorPhone = [UserInfo sharedInstance].phoneName;
        self.BQSmodel.smsCode = _verificationText.text;
        if (self.BQSStatus.integerValue == 11005) {
            [self prepareDataWithCount:OperatorDetailRequestBQSVerifyAuthSMS];
        }else{
            [self prepareDataWithCount:OperatorDetailRequestBQSLogin];
        }
        
    }
    
}
#pragma  mark -UITextField事件
- (void)textFieldDidChange:(UITextField *)text{
    
}
- (void)setRequestParams{
    switch (self.requestCount) {
        case OperatorDetailRequestPostVerify:
            self.cmd = XPostOperatorVerify;
            self.dict = [self.model mj_keyValues];
            break;
        case OperatorDetailRequestBQSLogin:
            self.cmd = XOperatorLogin;
            self.dict = [self.BQSmodel mj_keyValues];
            break;
        case OperatorDetailRequestBQSSendAuthSMS:
            self.cmd = XOperatorSendAuthSMS;
            self.dict = [self.BQSmodel mj_keyValues];
            break;
        case OperatorDetailRequestBQSSendLoginSMS:
            self.cmd = XOperatorSendLoginSMS;
            self.dict = [self.BQSmodel mj_keyValues];
            break;
        case OperatorDetailRequestBQSVerifyAuthSMS:
            self.cmd = XOperatorVerifyLoginSMS;
            self.dict = [self.BQSmodel mj_keyValues];
            break;
        default:
            break;
    }
    
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{

    switch (self.requestCount) {
        case OperatorDetailRequestPostVerify:
            {
                switch ([response.data[@"process_code"] integerValue]) {
                    case 10008:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您的授信资料已收到，我们会尽快完成授信审核。" cancelButtonTitle:@"" confirmButtonTitle:@"返回首页" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            for (UIViewController *controller in self.navigationController.viewControllers) {
                                if ([controller isKindOfClass:[LoanMainVC class]]) {
                                    LoanMainVC *vc = (LoanMainVC *)controller;
                                    [self.navigationController popToViewController:vc animated:YES];
                                }
                            }
                        }];
                        return;
                    }
                        break;
                    case 10001:
                    {
                        [self setHudWithName:@"再次输入短信验证码" Time:1 andType:1];
                        return;
                    }
                        break;
                    case 10004:
                    {
                        [self setHudWithName:@"短信验证码错误" Time:1 andType:1];
                        return;
                    }
                        break;
                    case 10006:
                    {
                        [self setHudWithName:@"短信验证码失效系统已自动重新下发" Time:1 andType:1];
                        return;
                    }
                        break;
                    case 10002:{
                        //            [self prepareDataWithCount:0];
                    }
                        break;
                    case 10003:
                    case 10007:{
                        [self setHudWithName:@"密码错误" Time:1 andType:1];
                        return;
                    }
                        break;
                    default:
                        break;
                }
                [self setHudWithName:response.rspMsg Time:1 andType:1];
            }
            break;
        case OperatorDetailRequestBQSLogin:
        case OperatorDetailRequestBQSVerifyAuthSMS:
        {
            if (self.clientGlobalInfo.isNeedAlipayVerify.integerValue == 1 && self.creditInfoModel.alipayStatus.integerValue != 1) {
                ZFBViewController *vc = [[ZFBViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                if (self.creditInfoModel.hasCreateOrder.integerValue == 1) {
                    [XAlertView alertWithTitle:@"通知" message:@"您的授信资料已收到，我们会尽快完成授信审核。" cancelButtonTitle:@"" confirmButtonTitle:@"返回首页" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        for (UIViewController *controller in self.navigationController.viewControllers) {
                            if ([controller isKindOfClass:[LoanMainVC class]]) {
                                LoanMainVC *vc = (LoanMainVC *)controller;
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }];
                }else{
                    LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                    vc.creditInfoModel = self.creditInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
            break;
        case OperatorDetailRequestBQSSendAuthSMS:
            [self setHudWithName:response.rspMsg Time:1 andType:1];
            break;
        case OperatorDetailRequestBQSSendLoginSMS:
            [self setHudWithName:response.rspMsg Time:1 andType:1];
            break;
        
        default:
            break;
    }
    
    
    
}
- (void)requestFaildWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case OperatorDetailRequestBQSLogin:
        case OperatorDetailRequestBQSSendAuthSMS:
        case OperatorDetailRequestBQSSendLoginSMS:
        case OperatorDetailRequestBQSVerifyAuthSMS:
        {
            self.BQSStatus = response.rspCode;
            switch (response.rspCode.integerValue) {
                case 11004:
                case 11005:{
//                    [self setHudWithName:response.rspMsg Time:2 andType:1];
                }
                    break;
                case 11006:{
//                    [self prepareDataWithCount:OperatorDetailRequestBQSSendLoginSMS];
                }
                    break;
                case 11007:{
//                    [self prepareDataWithCount:OperatorDetailRequestBQSSendAuthSMS];
                }
                    break;
                    
                case 11008:
//                    [self setHudWithName:response.rspMsg Time:2 andType:1];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    [self setHudWithName:response.rspMsg Time:2 andType:1];
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
