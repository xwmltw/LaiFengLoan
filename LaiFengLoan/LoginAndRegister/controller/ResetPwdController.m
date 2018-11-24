//
//  ResetPwdController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/3.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ResetPwdController.h"
#import "XTextField.h"
#import "LoginViewController.h"
@interface ResetPwdController ()<UITextFieldDelegate>

@end

@implementation ResetPwdController
{
    XTextField *_newPwdTextAccount;
    XTextField *_pwdTextAccount;
  
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInitUI];
}
- (void)setInitUI{
    UILabel *lblLogin = [[UILabel alloc]init];
    [lblLogin setText:@"重置密码"];
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
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
    
    _newPwdTextAccount = [[XTextField alloc]init];
    _newPwdTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _newPwdTextAccount.borderStyle = UITextBorderStyleNone;
    _newPwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入新密码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_newPwdTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _newPwdTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
//    _phoneTextAccount.tag = RegisterTextFileTagPhone;
    _newPwdTextAccount.delegate = self;
    [_newPwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _newPwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    [_newPwdTextAccount setCornerValue:AdaptationWidth(22)];
    
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    phoneImage.image = [UIImage imageNamed:@"login_pwd"];
    _newPwdTextAccount.leftView  = phoneImage;
    _newPwdTextAccount.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_newPwdTextAccount];
    [_newPwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(40));
        make.width.mas_equalTo(line);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.centerX.mas_equalTo(line);
    }];
    
    
    _pwdTextAccount = [[XTextField alloc]init];
    _pwdTextAccount.backgroundColor = XColorWithRGB(244, 244, 244);
    _pwdTextAccount.borderStyle = UITextBorderStyleNone;
    _pwdTextAccount.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"再次输入新密码" attributes:@{NSForegroundColorAttributeName:XColorWithRBBA(157, 157, 157, 1)}];
    [_pwdTextAccount setTextColor:XColorWithRBBA(22, 28, 42, 1)];
    _pwdTextAccount.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)];
//    _pwdTextAccount.tag = RegisterTextFileTagPhone;
    _pwdTextAccount.delegate = self;
    [_pwdTextAccount addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _pwdTextAccount.keyboardType = UIKeyboardTypeASCIICapable;
    [_pwdTextAccount setCornerValue:AdaptationWidth(22)];
    
    UIImageView *phoneImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(AdaptationWidth(16), AdaptationWidth(16), AdaptationWidth(28), AdaptationWidth(28))];
    phoneImage2.image = [UIImage imageNamed:@"login_pwd"];
    _pwdTextAccount.leftView  = phoneImage2;
    _pwdTextAccount.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:_pwdTextAccount];
    [_pwdTextAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self->_newPwdTextAccount.mas_bottom).offset(AdaptationWidth(40));
        make.width.mas_equalTo(line);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.centerX.mas_equalTo(line);
    }];
    
    UIButton *sureBtn = [[UIButton alloc]init];
//    registerBtn.tag = RegisterBtnTagRegist;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setCornerValue:AdaptationWidth(22)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:AppMainColor];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(line);
        make.top.mas_equalTo(self->_pwdTextAccount.mas_bottom).offset(AdaptationWidth(45));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(273));
    }];
}
#pragma  mark -UITextField事件
- (void)textFieldDidChange:(UITextField *)textField{
  
        if (textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
        }
    
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    if (_newPwdTextAccount.text.length == 0){
        [self setHudWithName:@"请输入新密码" Time:0.5 andType:3];
        return;
    }
    if (_newPwdTextAccount.text.length<8) {
        [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:0.5 andType:3];
        return;
    }
    
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:_newPwdTextAccount.text]){
        
    }else{
        [self setHudWithName:@"密码必须设置为8~20位数字和字母" Time:0.5 andType:3];
        return;
    }
    if(![_pwdTextAccount.text isEqualToString:_newPwdTextAccount.text]){
        [self setHudWithName:@"新密码和确认不一致！" Time:0.5 andType:3];
        return;
    }
    [self prepareDataWithCount:0];
}
- (void)setRequestParams{
    self.cmd = XModifyPassword;
    self.dict = [NSDictionary dictionaryWithObjectsAndKeys:_newPwdTextAccount.text,@"newPwd",self.phoneNum,@"phoneNum",self.codeNum,@"smsCode", nil];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    [self setHudWithName:@"修改成功" Time:1.5 andType:1];
    MyLog(@"%@",self.navigationController.viewControllers);
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginViewController class]]) {
            LoginViewController *vc = (LoginViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
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
