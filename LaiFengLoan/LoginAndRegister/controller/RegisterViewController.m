//
//  RegisterViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/2.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "RegisterViewController.h"
#import "XCountDownButton.h"
#import "XWMCodeImageView.h"
#import "XTextField.h"
#import "XRootWebVC.h"
#import "UserLocation.h"
#import "PersonViewController.h"
#import "LoanMainVC.h"
typedef NS_ENUM(NSInteger , RegisterBtnTag) {
    RegisterBtnTagRegist,
    RegisterBtnTagAgreement,
    RegisterBtnTagLogin,
};
typedef NS_ENUM(NSInteger , RegisterTextFileTag) {
    RegisterTextFileTagPhone,
    RegisterTextFileTagImage,
    RegisterTextFileTagMessage,
    RegisterTextFileTagPwd,
};
typedef NS_ENUM(NSInteger , RegisterRequest) {
    RegisterRequestCodeImage,
    RegisterRequestCode,
    RegisterRequestSure,
    RegisterRequestLogin,
};
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIView *alertView;
@end

@implementation RegisterViewController
{
    XTextField *_phoneTextAccount;
    XTextField *_pwdTextAccount;
    XTextField *_verificationText;
    XCountDownButton *_getVerificationCodeButton;
    NSData *decodedImageData;
    XWMCodeImageView *codeView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitUI];
}
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, 60, 22);
    button.tag = 9999;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(17)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:XColorWithRBBA(34, 58, 80, 0.8) forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, AdaptationWidth(20), 0, -AdaptationWidth(20));
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)setInitUI{
    
    UILabel *lblLogin = [[UILabel alloc]init];
    [lblLogin setText:@"快速注册"];
    [lblLogin setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(24)]];
    [lblLogin setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    [self.view addSubview:lblLogin];
    [lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lblLogin.mas_bottom).offset(AdaptationWidth(10));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    _phoneTextAccount = [[XTextField alloc]init];
    _phoneTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_phoneTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _phoneTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _phoneTextAccount.tag = RegisterTextFileTagPhone;
    _phoneTextAccount.delegate = self;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextAccount setCornerValue:AdaptationWidth(22)];
    
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    phoneImage.image = [UIImage imageNamed:@"login_phone"];
    _phoneTextAccount.leftView  = phoneImage;
    _phoneTextAccount.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_phoneTextAccount];
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(40));
        make.width.mas_equalTo(line);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.centerX.mas_equalTo(line);
    }];

    
    _verificationText = [[XTextField alloc]init];
    _verificationText.backgroundColor = XColorWithRGB(244, 244, 244);
    _verificationText.borderStyle = UITextBorderStyleNone;
    _verificationText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    _verificationText.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [_verificationText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationText.keyboardType = UIKeyboardTypeNumberPad;
    _verificationText.tag = RegisterTextFileTagMessage;
    _verificationText.delegate = self;
     [_verificationText setCornerValue:AdaptationWidth(22)];
    [_verificationText setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    [self.view addSubview:_verificationText];
    
    UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    messageImage.image = [UIImage imageNamed:@"login_message"];
    _verificationText.leftView  = messageImage;
    _verificationText.leftViewMode = UITextFieldViewModeAlways;
    
    XCountDownButton *getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));

    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:AppMainColor forState:UIControlStateNormal];
    getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    getVerificationCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -AdaptationWidth(24));
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    _verificationText.rightView = getVerificationCodeButton;
    _verificationText.rightViewMode = UITextFieldViewModeAlways;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
//    _verificationText.rightView.
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self->_phoneTextAccount.mas_bottom).offset(AdaptationWidth(18));
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    
    _pwdTextAccount = [[XTextField alloc]init];
    _pwdTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请设置登录密码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_pwdTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _pwdTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _pwdTextAccount.tag = RegisterTextFileTagPwd;
    _pwdTextAccount.delegate = self;
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    [_pwdTextAccount setCornerValue:AdaptationWidth(22)];
    
    UIImageView *pwdImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    pwdImage.image = [UIImage imageNamed:@"login_pwd"];
    _pwdTextAccount.leftView  = pwdImage;
    _pwdTextAccount.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdTextAccount];
    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_verificationText.mas_bottom).offset(AdaptationWidth(18));
        make.width.mas_equalTo(line);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.centerX.mas_equalTo(line);
    }];
    
    
    UIButton *registerBtn = [[UIButton alloc]init];
    registerBtn.tag = RegisterBtnTagRegist;
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setCornerValue:AdaptationWidth(22)];
    [registerBtn setTitle:@"登录" forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:AppMainColor];
    [registerBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line);
        make.top.mas_equalTo(self->_pwdTextAccount.mas_bottom).offset(AdaptationWidth(45));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = @"注册即代表您已同意";
    tipsLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    tipsLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [self.view addSubview:tipsLab];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).offset(-AdaptationWidth(35));
        make.top.mas_equalTo(registerBtn.mas_bottom).offset(AdaptationWidth(18));
    }];
    UIButton *AgreementBtn = [[UIButton alloc]init];
    AgreementBtn.tag = RegisterBtnTagAgreement;
    [AgreementBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)]];
    [AgreementBtn setTitleColor:XColorWithRGB(48, 136, 255) forState:UIControlStateNormal];
    [AgreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [AgreementBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:AgreementBtn];
    [AgreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipsLab.mas_right).offset(AdaptationWidth(1));
        make.centerY.mas_equalTo(tipsLab);
    }];
    
    UIButton *loginBtn = [[UIButton alloc]init];
    loginBtn.tag = RegisterBtnTagLogin;
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)]];
    [loginBtn setTitleColor:XColorWithRGB(48, 136, 255) forState:UIControlStateNormal];
    [loginBtn setTitle:@"已有账号,请登录" forState:UIControlStateNormal];
    [loginBtn setImage:[UIImage imageNamed:@"GoRegiter"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(65));
        
    }];
}
#pragma  mark -UITextField事件
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == _pwdTextAccount) {
        if (_pwdTextAccount.text.length >= 20) {
            _pwdTextAccount.text = [_pwdTextAccount.text substringToIndex:20];
        }
    }else if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
        }else if (_phoneTextAccount.text.length == 0) {
            if (_pwdTextAccount.text.length > 0) {
                _pwdTextAccount.text = @"";
            }
        }
    }
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case RegisterBtnTagRegist:
        {
            [self.view endEditing:YES];
            if (_verificationText.text.length == 0) {
                [self setHudWithName:@"请输入手机验证码" Time:0.5 andType:3];
                return;
            }
            if (_pwdTextAccount.text.length == 0){
                [self setHudWithName:@"请输入密码" Time:0.5 andType:3];
                return;
            }
            if (_pwdTextAccount.text.length<8) {
                [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
                return;
            }
            NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if ([pred evaluateWithObject:_pwdTextAccount.text]){
                [self prepareDataWithCount:RegisterRequestSure];
            }else{
                [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:1 andType:3];
                return;
            }
        }
            break;
        case RegisterBtnTagLogin:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case RegisterBtnTagAgreement:
        {
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = self.clientGlobalInfo.registAgreementUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;

        default:
            break;
    }
}

#pragma mark - 验证码事件
- (void)getVerificationCodeClick:(XCountDownButton *)sender
{
    _getVerificationCodeButton = sender;
     [self prepareDataWithCount:RegisterRequestCodeImage];
    
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
#pragma mark - 网络

- (void)setRequestParams{
    switch (self.requestCount) {
        case RegisterRequestCode:
        {
            self.cmd = XSMSCode;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:codeView.ImageTextField.text,@"imageCode",@1,@"optType",_phoneTextAccount.text,@"phoneNum", nil];
        }
            break;
        case RegisterRequestCodeImage:
        {
            self.cmd = XImageCode;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextAccount.text,@"phoneNum", nil];
        }
            break;
        case RegisterRequestSure:
        {
            self.cmd = XUserRegister;
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        _pwdTextAccount.text,@"loginPwd",
                                        _phoneTextAccount.text,@"phoneNum",
                                        _verificationText.text,@"smsCode", nil];
            [dic addEntriesFromDictionary:[[[BaseInfoPM alloc]init] mj_keyValues]];
            self.dict = [NSDictionary dictionaryWithDictionary:dic];
        }
            break;
        case RegisterRequestLogin:{
            self.cmd = XUserLogin;
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        _pwdTextAccount.text,@"loginPwd",
                                        _phoneTextAccount.text,@"phoneNum",
                                        [UserLocation sharedInstance].areaName,@"areaName",
                                        [UserLocation sharedInstance].cityName,@"cityName",
                                        [UserLocation sharedInstance].province,@"provinceName",nil];
            
            self.dict = [NSDictionary dictionaryWithDictionary:dic];
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case RegisterRequestCode:
        {
            [self setHudWithName:response.rspMsg Time:1.5 andType:0];
            [self beginCountDown];
        }
            break;
        case RegisterRequestCodeImage:
        {
            //解码
            NSString *str = response.data[@"imageCodeBase64"];
            decodedImageData = [[NSData alloc]
                                        initWithBase64EncodedString:[str substringFromIndex:37] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [self.view addSubview:self.alertView];
            _alertView.hidden = NO;
            [codeView creatCodeIamge:decodedImageData];
           
        }
            break;
        case RegisterRequestSure:
        {
//            [self setHudWithName:response.rspMsg Time:1 andType:1];
            [TalkingData onRegister:_phoneTextAccount.text type:TDAccountTypeRegistered name:AppName];
            [self prepareDataWithCount:RegisterRequestLogin];
        }
            break;
        case RegisterRequestLogin:{
            [self setHudWithName:@"登录成功" Time:1.5 andType:1];
            [TalkingData onLogin:_phoneTextAccount.text type:TDAccountTypeRegistered name:AppName];
            [[UserInfo sharedInstance]savePhone:_phoneTextAccount.text password:_pwdTextAccount.text accessToken:response.data[@"token"]];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonViewController class]]) {
                    PersonViewController *vc = (PersonViewController*)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
                if ([controller isKindOfClass:[LoanMainVC class]]) {
                    LoanMainVC *vc = (LoanMainVC*)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                    return;
                }
            }
            
        }
            break;
        default:
            break;
    }
}
#pragma mark - lan
- (UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:self.view.bounds];
        _alertView.backgroundColor = XColorWithRBBA(0, 0, 0, 0.5);
        codeView = [[XWMCodeImageView alloc]initWithFrame:CGRectZero withController:self];
        [_alertView addSubview:codeView];
        [codeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(272);
            make.height.mas_equalTo(175);
            make.center.mas_equalTo(self->_alertView);
        }];
        WEAKSELF
        BLOCKSELF
        codeView.block = ^(UIButton * result) {
            switch (result.tag) {
                case 100:{
                    [weakSelf prepareDataWithCount:RegisterRequestCode];
                    blockSelf->_alertView.hidden = YES;
                }
                    break;
                case 101:{
                    blockSelf->_alertView.hidden = YES;
                }
                    break;
                    
                default:
                    break;
            }
        };
        codeView.tapBlock = ^(id result) {
            [weakSelf prepareDataWithCount:RegisterRequestCodeImage];
        };
    }
    return _alertView;
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
