//
//  LoginViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/2.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "LoginViewController.h"
#import "XCountDownButton.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"
#import "XTextField.h"
#import "XWMCodeImageView.h"
#import "UserLocation.h"
#import "PersonViewController.h"
typedef NS_ENUM(NSInteger , LoginTextFieldTag) {
    UITextFieldTagQuickPhone,
    UITextFieldTagQuickMessage,
    LoginTextFieldTagPhone,
    LoginTextFieldTagPwd,
};
typedef NS_ENUM(NSInteger, LoginButtonTag) {
    LoginButtonTagLogin,
    LoginButtonTagQuickLogin,
    LoginButtonTagQuickRegister,
    LoginButtonTagForgetPwd,
};
typedef NS_ENUM(NSInteger, LoginRequest) {
    LoginRequestSure,
    LoginRequestQuickSure,
    LoginRequestCode,
    LoginRequestCodeImage,
};
@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView * passwordView;
@property (nonatomic, strong) UIView * messageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic ,strong)UIView *alertView;
@end

@implementation LoginViewController
{
    XTextField *_phoneTextAccount;
    XTextField *_pwdTextAccount;
    XTextField *_phoneTextQuick;
    XTextField *_verificationTextQuick;
    XCountDownButton *_getVerificationButton;
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
- (void)BarbuttonClick:(UIButton *)button{
    switch (self.isFrom.integerValue) {
        case 2:
        {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonViewController class]]) {
                    PersonViewController *vc = (PersonViewController*)controller;
                    [self.navigationController popToViewController:vc animated:YES];
                    
                }
                
            }
            return;
        }
            break;
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setInitUI{
    UILabel *lblLogin = [[UILabel alloc]init];
    [lblLogin setText:@"登录"];
    [lblLogin setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(24)]];
    [lblLogin setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    [self.view addSubview:lblLogin];
    [lblLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(16));
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(221, 221, 221);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lblLogin.mas_bottom).offset(AdaptationWidth(10));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    
    //配置scrollView的属性
    self.scrollView = [[UIScrollView alloc] init];
    //    [self.scrollView setBackgroundColor:[UIColor colorWithHexString:@"#f0eff5"]];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setContentSize:CGSizeMake(ScreenWidth * 2, 0)];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(2);
        make.left.bottom.right.mas_equalTo(self.view);
    }];
    
    
    
    self.passwordView = [[UIView alloc]init];
    self.messageView  = [[UIView alloc]init];
    
    for (int i = 0; i<2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenHeight-115)];
        if (i == 0) {
            self.passwordView = view;
            [self.scrollView addSubview:self.passwordView];
        }else{
            self.messageView = view;
            [self.scrollView addSubview:self.messageView];
        }
    }
   
    [self createPasswordView];
    [self createMessageView];
}
#pragma  mark - 创建PasswordView
- (void)createPasswordView{
    _phoneTextAccount = [[XTextField alloc]init];
    _phoneTextAccount.clearButtonMode = UITextFieldViewModeAlways;
    _phoneTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"11位手机号码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_phoneTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _phoneTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _phoneTextAccount.tag = LoginTextFieldTagPhone;
    _phoneTextAccount.delegate = self;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeNumberPad;
     [_phoneTextAccount setCornerValue:AdaptationWidth(22)];
    
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    phoneImage.image = [UIImage imageNamed:@"login_phone"];
    _phoneTextAccount.leftView  = phoneImage;
    _phoneTextAccount.leftViewMode = UITextFieldViewModeAlways;
    [self.passwordView addSubview:_phoneTextAccount];
   

    
    _pwdTextAccount = [[XTextField alloc]init];
    [_pwdTextAccount setCornerValue:AdaptationWidth(22)];
    _pwdTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"8~20位数字和字母组合" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_pwdTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _pwdTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
    _pwdTextAccount.tag = LoginTextFieldTagPwd;
    _pwdTextAccount.secureTextEntry = YES;
    _pwdTextAccount.delegate = self;
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    messageImage.image = [UIImage imageNamed:@"login_pwd"];
    _pwdTextAccount.leftView  = messageImage;
    _pwdTextAccount.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *secureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secureButton.frame = CGRectMake(0, AdaptationWidth(12.5), AdaptationWidth(28), AdaptationWidth(28));
    [secureButton setImage:[UIImage imageNamed:@"hidePwd"] forState:UIControlStateNormal];
    [secureButton setImage:[UIImage imageNamed:@"lookPwd"] forState:UIControlStateSelected];
    secureButton.selected = NO;
    [secureButton addTarget:self action:@selector(securePasswordClick:) forControlEvents:UIControlEventTouchUpInside];
    _pwdTextAccount.rightView = secureButton;
    _pwdTextAccount.rightViewMode = UITextFieldViewModeAlways;
    [self.passwordView addSubview:_pwdTextAccount];
    
 
    [_phoneTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passwordView);
        make.top.mas_equalTo(self.passwordView).offset(AdaptationWidth(40));
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];

    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passwordView);
        make.top.mas_equalTo(self->_phoneTextAccount.mas_bottom).offset(AdaptationWidth(18));
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    UIButton *forgetBtn = [[UIButton alloc]init];
    [forgetBtn.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)]];
    [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:LabelShallowColor forState:UIControlStateNormal];
    forgetBtn.tag = LoginButtonTagForgetPwd;
    [forgetBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordView addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.passwordView).offset(AdaptationWidth(-67));
        make.top.mas_equalTo(self->_pwdTextAccount.mas_bottom).offset(AdaptationWidth(12));
//        make.width.mas_equalTo(AdaptationWidth(100));
    }];
    
    
    UIButton *quickLoginBtn = [[UIButton alloc]init];
    quickLoginBtn.tag = LoginButtonTagLogin;
    [quickLoginBtn setCornerValue:AdaptationWidth(22)];
    [quickLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [quickLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quickLoginBtn setBackgroundColor:AppMainColor];
    [quickLoginBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordView addSubview:quickLoginBtn];
    [quickLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passwordView);
        make.top.mas_equalTo(self->_pwdTextAccount.mas_bottom).offset(AdaptationWidth(45));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = @"验证码登录->";
    tipsLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    tipsLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [self.passwordView addSubview:tipsLab];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passwordView);
        make.top.mas_equalTo(quickLoginBtn.mas_bottom).offset(AdaptationWidth(18));
    }];
    
    UIButton *quickRegister = [[UIButton alloc]init];
    quickRegister.tag = LoginButtonTagQuickRegister;
    [quickRegister.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)]];
    [quickRegister setTitleColor:XColorWithRGB(48, 136, 255) forState:UIControlStateNormal];
    [quickRegister setTitle:@"快速注册" forState:UIControlStateNormal];
    [quickRegister setImage:[UIImage imageNamed:@"GoRegiter"] forState:UIControlStateNormal];
    [quickRegister addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.passwordView addSubview:quickRegister];
    [quickRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.passwordView);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(65));

    }];

}
#pragma  mark - 创建MessageView

-(void)createMessageView{
    _phoneTextQuick = [[XTextField alloc]init];
    _phoneTextQuick.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextQuick.backgroundColor = XColorWithRGB(244, 244, 244);
    _phoneTextQuick.borderStyle = UITextBorderStyleNone;
    _phoneTextQuick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_phoneTextQuick setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _phoneTextQuick.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    _phoneTextQuick.tag = UITextFieldTagQuickPhone;
    [_phoneTextQuick addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextQuick.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextQuick.delegate = self;
    [_phoneTextQuick setCornerValue:AdaptationWidth(22)];
    
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    phoneImage.image = [UIImage imageNamed:@"login_phone"];
    _phoneTextQuick.leftView  = phoneImage;
    _phoneTextQuick.leftViewMode = UITextFieldViewModeAlways;
    [self.messageView addSubview:_phoneTextQuick];
    
   
    
    _verificationTextQuick = [[XTextField alloc]init];
    [_verificationTextQuick setCornerValue:AdaptationWidth(22)];
    _verificationTextQuick.backgroundColor = XColorWithRGB(244, 244, 244);
    _verificationTextQuick.borderStyle = UITextBorderStyleNone;
    _verificationTextQuick.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"短信验证码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    _verificationTextQuick.font = [UIFont systemFontOfSize:AdaptationWidth(16)];
    [_verificationTextQuick addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verificationTextQuick.keyboardType = UIKeyboardTypeNumberPad;
    _verificationTextQuick.tag = UITextFieldTagQuickMessage;
    _verificationTextQuick.delegate = self;
    [_verificationTextQuick setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    [self.messageView addSubview:_verificationTextQuick];
    
    UIImageView *messageImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    messageImage.image = [UIImage imageNamed:@"login_message"];
    _verificationTextQuick.leftView  = messageImage;
    _verificationTextQuick.leftViewMode = UITextFieldViewModeAlways;
    
    XCountDownButton *getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    [self.messageView addSubview:getVerificationCodeButton];
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:AppMainColor forState:UIControlStateNormal];
    getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    getVerificationCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -AdaptationWidth(24));
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    _verificationTextQuick.rightView = getVerificationCodeButton;
    _verificationTextQuick.rightViewMode = UITextFieldViewModeAlways;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_phoneTextQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.messageView);
        make.top.mas_equalTo(self.messageView).offset(AdaptationWidth(40));
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
 
    [_verificationTextQuick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.messageView);
        make.top.mas_equalTo(self->_phoneTextQuick.mas_bottom).offset(AdaptationWidth(18));
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    UIButton *quickLoginBtn = [[UIButton alloc]init];
    quickLoginBtn.tag = LoginButtonTagQuickLogin;
    [quickLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quickLoginBtn setCornerValue:AdaptationWidth(22)];
    [quickLoginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [quickLoginBtn setBackgroundColor:AppMainColor];
    [quickLoginBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageView addSubview:quickLoginBtn];
    [quickLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.messageView);
        make.top.mas_equalTo(self->_verificationTextQuick.mas_bottom).offset(AdaptationWidth(45));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];

    UILabel *tipsLab = [[UILabel alloc] init];
    tipsLab.text = @"<-账号登录";
    tipsLab.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    tipsLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [self.messageView addSubview:tipsLab];
    [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.messageView);
        make.top.mas_equalTo(quickLoginBtn.mas_bottom).offset(AdaptationWidth(18));
    }];
    
    UIButton *quickRegister = [[UIButton alloc]init];
    quickRegister.tag = LoginButtonTagQuickRegister;
    [quickRegister.titleLabel setFont:[UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)]];
    [quickRegister setTitleColor:XColorWithRGB(48, 136, 255) forState:UIControlStateNormal];
    [quickRegister setTitle:@"快速注册" forState:UIControlStateNormal];
    [quickRegister setImage:[UIImage imageNamed:@"GoRegiter"] forState:UIControlStateNormal];
    [quickRegister addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageView addSubview:quickRegister];
    [quickRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.messageView);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(65));
       
    }];
    
}
#pragma mark - scrollView代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}
#pragma mark -UITextField 事件
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == _pwdTextAccount) {
        if (_pwdTextAccount.text.length >= 20) {
            
            _pwdTextAccount.text = [_pwdTextAccount.text substringToIndex:20];
        }
    }else if (textField == _phoneTextAccount) {
        if (_phoneTextAccount.text.length >= 11) {
            _phoneTextAccount.text = [_phoneTextAccount.text substringToIndex:11];
//            _phoneString = _phoneTextAccount.text;
        }else if (_phoneTextAccount.text.length == 0) {
            if (_pwdTextAccount.text.length > 0) {
                _pwdTextAccount.text = @"";
            }
        }
    }else if (textField == _phoneTextQuick) {
        if (_phoneTextQuick.text.length >= 11) {
            _phoneTextQuick.text = [_phoneTextQuick.text substringToIndex:11];
//            _phoneString = _phoneTextQuick.text;
        }
    }else if (textField == _verificationTextQuick) {
        if (_verificationTextQuick.text.length >= 6) {
            _verificationTextQuick.text = [_verificationTextQuick.text substringToIndex:6];
        }
    }
}
#pragma mark -btn事件
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case LoginButtonTagLogin:
            if (_phoneTextAccount.text.length == 0) {
                [self setHudWithName:@"请输入手机号码" Time:0.5 andType:3];
                return;
            }
            if (_pwdTextAccount.text.length == 0) {
                [self setHudWithName:@"请输入密码" Time:0.5 andType:3];
                return;
            }
            if (_phoneTextAccount.text.length != 11) {
                [self setHudWithName:@"请输入正确的手机号" Time:0.5 andType:3];
                return;
            }
            [self prepareDataWithCount:LoginRequestSure];
            break;
        case LoginButtonTagQuickLogin:{
            if (_phoneTextQuick.text.length == 0) {
                [self setHudWithName:@"请输入手机号码" Time:0.5 andType:3];
                return;
            }
           
            if (_phoneTextQuick.text.length != 11) {
                [self setHudWithName:@"请输入正确的手机号" Time:0.5 andType:3];
                return;
            }
            
            [self prepareDataWithCount:LoginRequestQuickSure];
        }
            break;
        case LoginButtonTagQuickRegister:
        {
            RegisterViewController *vc = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case LoginButtonTagForgetPwd:{
            ForgetPwdViewController *vc = [[ForgetPwdViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
//密码显示
- (void)securePasswordClick:(UIButton *)sender{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
        [generator prepare];
        [generator impactOccurred];
    } else {
        // Fallback on earlier versions
    }
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        _pwdTextAccount.secureTextEntry = NO;
    }else{
        _pwdTextAccount.secureTextEntry = YES;
    }
    NSString *text = _pwdTextAccount.text;
    _pwdTextAccount.text = @" ";
    _pwdTextAccount.text = text;
}
#pragma mark - 验证码事件
- (void)getVerificationCodeClick:(XCountDownButton *)sender
{
    if (_phoneTextQuick.text.length != 11) {
        [self setHudWithName:@"请输入正确的手机号码" Time:0.5 andType:0];
        return;
    }
    _getVerificationButton = sender;
    [self prepareDataWithCount:LoginRequestCodeImage];
}
- (void)beginCountDown{
    _getVerificationButton.userInteractionEnabled = NO;
    [_getVerificationButton startCountDownWithSecond:60];
    [_getVerificationButton countDownChanging:^NSString *(XCountDownButton *countDownButton,NSUInteger second){
        NSString *title = [NSString stringWithFormat:@"%@s", @(second)];
        return title;
    }];
    [_getVerificationButton countDownFinished:^NSString *(XCountDownButton *countDownButton, NSUInteger second) {
        self->_getVerificationButton.userInteractionEnabled = YES;
        return @"重新发送";
    }];
}
#pragma mark - 网络
- (void)setRequestParams{
    switch (self.requestCount) {
        case LoginRequestSure:{
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
        case LoginRequestQuickSure:{
            self.cmd = XUserLogin;
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        _phoneTextQuick.text,@"phoneNum",
                                        _verificationTextQuick.text,@"smsCode",
                                        [UserLocation sharedInstance].areaName,@"areaName",
                                        [UserLocation sharedInstance].cityName,@"cityName",
                                        [UserLocation sharedInstance].province,@"provinceName",nil];
            
            self.dict = [NSDictionary dictionaryWithDictionary:dic];
        }
            break;
        case LoginRequestCode:{
            self.cmd = XSMSCode;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:codeView.ImageTextField.text,@"imageCode",@2,@"optType",_phoneTextQuick.text,@"phoneNum", nil];
        }
            break;
        case LoginRequestCodeImage:{
            self.cmd = XImageCode;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextQuick.text,@"phoneNum", nil];
        }
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case LoginRequestSure:
        {
            [self setHudWithName:@"登录成功" Time:1.5 andType:1];
             [TalkingData onLogin:_phoneTextAccount.text type:TDAccountTypeRegistered name:AppName];
            [[UserInfo sharedInstance]savePhone:_phoneTextAccount.text password:_pwdTextAccount.text accessToken:response.data[@"token"]];
            switch (self.isFrom.integerValue) {
                case 2:
                {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[PersonViewController class]]) {
                            PersonViewController *vc = (PersonViewController*)controller;
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                    return;
                }
                    break;
                default:
                    break;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case LoginRequestQuickSure:{
            [self setHudWithName:@"登录成功" Time:1.5 andType:1];
            [TalkingData onLogin:_phoneTextAccount.text type:TDAccountTypeRegistered name:AppName];
            [[UserInfo sharedInstance]savePhone:_phoneTextQuick.text password:@"" accessToken:response.data[@"token"]];
            
            switch (self.isFrom.integerValue) {
                case 2:
                {
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[PersonViewController class]]) {
                            PersonViewController *vc = (PersonViewController*)controller;
                            [self.navigationController popToViewController:vc animated:YES];
                            
                        }
                    }
                    return;
                }
                    break;
                default:
                    break;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case LoginRequestCode:{
            [self setHudWithName:response.rspMsg Time:1.5 andType:0];
            [self beginCountDown];
        }
            break;
        case LoginRequestCodeImage:{
            //解码
            NSString *str = response.data[@"imageCodeBase64"];
            decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:[str substringFromIndex:37] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [self.view addSubview:self.alertView];
            _alertView.hidden = NO;
            [codeView creatCodeIamge:decodedImageData];
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
                    [weakSelf prepareDataWithCount:LoginRequestCode];
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
            [weakSelf prepareDataWithCount:LoginRequestCodeImage];
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
