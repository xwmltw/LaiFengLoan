//
//  ModifyPwdViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "XTextField.h"
#import "XWMCodeImageView.h"
#import "XCountDownButton.h"
#import "LoginViewController.h"
#import "XCacheHelper.h"
#import "XAlertView.h"
typedef NS_ENUM(NSInteger ,ModifyPwdRequest) {
    ModifyPwdRequestCodeImage,
    ModifyPwdRequestCode,
    ModifyPwdRequestSuccess,
    ModifyPwdRequestLogout,
};
@interface ModifyPwdViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong)UIView *alertView;
@end

@implementation ModifyPwdViewController
{
    XTextField *_phoneTextAccount;
    XTextField *_verificationText;
    XTextField *_imageText;
    XCountDownButton *_getVerificationCodeButton;
    NSData *decodedImageData;
    XWMCodeImageView *codeView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitUI];
}
- (void)setInitUI{
    
    UILabel *lblLogin = [[UILabel alloc]init];
    [lblLogin setText:@"修改密码"];
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
    
    _phoneTextAccount = [[XTextField alloc]init];
    _phoneTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _phoneTextAccount.borderStyle = UITextBorderStyleNone;
    _phoneTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新的密码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_phoneTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _phoneTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
//    _phoneTextAccount.tag = ForgetPwdTextFileTagPhone;
    _phoneTextAccount.delegate = self;
    [_phoneTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
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
//    _verificationText.tag = ForgetPwdTextFileTagMessage;
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
    [_verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self->_phoneTextAccount.mas_bottom).offset(AdaptationWidth(18));
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    
    UIButton *ForgetPwdBtn = [[UIButton alloc]init];
//    ForgetPwdBtn.tag = ForgetPwdBtnTagNext;
    [ForgetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ForgetPwdBtn setCornerValue:AdaptationWidth(22)];
    [ForgetPwdBtn setTitle:@"确认" forState:UIControlStateNormal];
    [ForgetPwdBtn setBackgroundColor:AppMainColor];
    [ForgetPwdBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ForgetPwdBtn];
    [ForgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line);
        make.top.mas_equalTo(self->_verificationText.mas_bottom).offset(AdaptationWidth(45));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    
}
#pragma  mark -UITextField事件
- (void)textFieldDidChange:(UITextField *)text{
    
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    
    if (_verificationText.text.length == 0) {
        [self setHudWithName:@"请输入新的密码" Time:0.5 andType:3];
        return;
    }
    if (_phoneTextAccount.text.length == 0){
        [self setHudWithName:@"请输入手机号码" Time:0.5 andType:3];
        return;
    }
    [self prepareDataWithCount:ModifyPwdRequestSuccess];
    
}
#pragma mark - 验证码事件
- (void)getVerificationCodeClick:(XCountDownButton *)sender
{
    _getVerificationCodeButton = sender;
    [self prepareDataWithCount:ModifyPwdRequestCodeImage];
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
- (void)setRequestParams{
    switch (self.requestCount) {
        case ModifyPwdRequestCodeImage:
            self.cmd = XImageCode;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedInstance].getUserInfo.phoneName,@"phoneNum", nil];
            break;
        case ModifyPwdRequestCode:
            self.cmd = XSMSCode;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:codeView.ImageTextField.text,@"imageCode",@3,@"optType",[UserInfo sharedInstance].getUserInfo.phoneName,@"phoneNum", nil];
            break;
        case ModifyPwdRequestSuccess:
            self.cmd = XModifyPassword;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_phoneTextAccount.text,@"newPwd",[UserInfo sharedInstance].getUserInfo.phoneName,@"phoneNum",_verificationText.text,@"smsCode", nil];
            break;
        case ModifyPwdRequestLogout:
            self.cmd = XUserlogout;
            self.dict = [NSDictionary dictionary];
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ModifyPwdRequestCodeImage:{
            //解码
            NSString *str = response.data[@"imageCodeBase64"];
            decodedImageData = [[NSData alloc]
                                initWithBase64EncodedString:[str substringFromIndex:37] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            [self.view addSubview:self.alertView];
            _alertView.hidden = NO;
            [codeView creatCodeIamge:decodedImageData];
        }
            break;
        case ModifyPwdRequestCode:
        {
            [self setHudWithName:response.rspMsg Time:1.5 andType:0];
            [self beginCountDown];
        }
            break;
        case ModifyPwdRequestSuccess:
        {
            [XAlertView alertWithTitle:@"温馨提示" message:@"修改密码成功" cancelButtonTitle:nil confirmButtonTitle:@"前往登录页" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                [self prepareDataWithCount:ModifyPwdRequestLogout];
            }];
            
            
        }
            break;
        case ModifyPwdRequestLogout:
        {
            [XCacheHelper clearCacheFolder];
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.isFrom = @2;
            [self.navigationController pushViewController:vc animated:YES];
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
                    [weakSelf prepareDataWithCount:ModifyPwdRequestCode];
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
            [weakSelf prepareDataWithCount:ModifyPwdRequestCodeImage];
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
