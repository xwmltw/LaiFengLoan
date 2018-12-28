//
//  OperatorViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "OperatorViewController.h"
#import "AuthorizationHeadView.h"
#import "OperatorModel.h"
#import "OperatorDetailVC.h"
#import "XAlertView.h"
#import "LoanMainVC.h"
#import "XChooseBankView.h"
#import "ContactViewController.h"
#import "BaseViewController.h"
#import "CreditInfoModel.h"
#import "LoanDetailViewController.h"
#import "OperatorBQSModel.h"
#import "ZFBViewController.h"
typedef NS_ENUM(NSInteger, OperatorRequest) {
    OperatorRequestGetInfo,
    OperatorRequestPostInfo,
    OperatorRequestCreditInfo,
    OperatorRequestBQSLogin,
    OperatorRequestBQSSendAuthSMS,
    OperatorRequestBQSSendLoginSMS,
    OperatorRequestBQSVerifyAuthSMS,
};
@interface OperatorViewController ()<XChooseBankPickerViewDelegate>
@property (nonatomic, strong) OperatorModel *operatorModel;
@property (nonatomic, strong) XChooseBankView *pickerView;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@property (nonatomic ,strong) OperatorBQSModel *operatorBQSModel;
@end

@implementation OperatorViewController
{
    UITextField *telTF;
    UITextField *pwdTF;
}
-(void)BarbuttonClick:(UIButton *)button{
    if (self.isFromVC.integerValue) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"授信认证";
    [self initUI];
    if (self.clientGlobalInfo.decisionType.integerValue == 0) {
        [self prepareDataWithCount:OperatorRequestGetInfo];
    }else{
        telTF.text  = [UserInfo sharedInstance].phoneName;
    }
    
    
}
- (void)initUI{
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(80), AdaptationWidth(40))];
    [rightBtn setTitle:@"修改资料" forState:UIControlStateNormal];
    rightBtn.tag = 102;
    [rightBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:LabelMainColor forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    AuthorizationHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"AuthorizationHead" owner:self options:nil].lastObject;
    headView.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(90));
    [headView setHeadImage:@4];
    [self.view addSubview:headView];

    
    UILabel *yysLab = [[UILabel alloc] init];
    yysLab.text = @"运营商认证";
    yysLab.textColor = LabelMainColor;
    yysLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(18)];
    [self.view addSubview:yysLab];
    [yysLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.top.mas_equalTo(headView.mas_bottom).offset(AdaptationWidth(22));
 
    }];
    
    
    telTF = [[UITextField alloc]init];
  
    telTF.enabled = NO;
    telTF.placeholder = @"请输入您的手机号码";
    telTF.text = self.operatorModel.operatorPhone;
    [telTF setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    telTF.textAlignment = NSTextAlignmentRight;
    [telTF setTextColor:LabelMainColor];
    [self.view addSubview:telTF];
    [telTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(yysLab.mas_bottom).offset(AdaptationWidth(22));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"手机号";
    label.textColor = XColorWithRGB(89, 99, 109);
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(telTF);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    
    
    UIView *line  = [[UIView alloc]init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(telTF.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    pwdTF = [[UITextField alloc]init];
    [pwdTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    pwdTF.text = self.operatorModel.operatorPassword;
    pwdTF.keyboardType = UIKeyboardTypeNumberPad;
    [pwdTF setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    pwdTF.placeholder = @"请输入该手机号的服务密码";
    pwdTF.textAlignment = NSTextAlignmentRight;
    [pwdTF setTextColor:LabelMainColor];
    [self.view addSubview:pwdTF];
    [pwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(2));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"服务密码";
    label2.textColor = XColorWithRGB(89, 99, 109);
    label2.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pwdTF);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    UIView *line2  = [[UIView alloc]init];
    line2.backgroundColor = LineColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pwdTF.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *autBtn = [[UIButton alloc]init];
    autBtn.tag = 101;
    [autBtn setBorderWidth:1 andColor:AppMainColor];
    [autBtn setCornerValue:AdaptationWidth(22)];
    [autBtn setTitle:@"提交" forState:UIControlStateNormal];
    [autBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
    [autBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autBtn];
    [autBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line2).offset(AdaptationWidth(72));
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(250));
    }];
    
    
   
}
#pragma mark -XChooseBankView
- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row{
    switch (row) {
        case 0:
        {
            ContactViewController *vc = [[ContactViewController alloc]init];
            vc.isFromVC = @1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            BaseViewController *vc = [[BaseViewController alloc]init];
            vc.isFromVC = @1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
            if (!telTF.text.length) {
                [self setHudWithName:@"请输入手机号码" Time:1 andType:1];
                return;
            }
            if (!pwdTF.text.length) {
                [self setHudWithName:@"请输入服务密码" Time:1 andType:1];
                return;
            }
            if (self.clientGlobalInfo.decisionType.integerValue == 0) {
                self.operatorModel.operatorPhone = telTF.text;
                self.operatorModel.operatorPassword = pwdTF.text;
            }else{
                self.operatorBQSModel.operatorPhone = telTF.text;
                self.operatorBQSModel.operatorPassword = pwdTF.text;
            }
            
            [self prepareDataWithCount:OperatorRequestCreditInfo];
            
            
        }
            break;
        case 102:
        {
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = @[@"联系人信息",@"基本信息"];
            [self.pickerView showView];
        }
            break;
        default:
            break;
    }
  
}
- (void)textFieldDidChange:(UITextField *)text{
        if (text.text.length >= 8) {
            text.text = [text.text substringToIndex:8];
        }
}
- (void)setRequestParams{
    switch (self.requestCount) {
        case OperatorRequestGetInfo:
            self.cmd = XGetOperatorVerify;
            self.dict = [NSDictionary dictionary];
            break;
        case OperatorRequestPostInfo:{
            self.cmd = XPostOperatorVerify;
            self.operatorModel.captcha = @"";
            self.operatorModel.type = @"";
            self.dict = [self.operatorModel mj_keyValues];
        }
            break;
        case OperatorRequestCreditInfo:{
            self.cmd = XGetCreditInfoVerify;
            self.dict = [NSDictionary dictionary];
        }
            break;
        case OperatorRequestBQSLogin:{
            self.cmd = XOperatorLogin;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:telTF.text,@"operatorPhone",pwdTF.text,@"operatorPassword", nil];
        }
            break;
        default:
            break;
    }
   
}

- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case OperatorRequestGetInfo:
            self.operatorModel = [OperatorModel mj_objectWithKeyValues:response.data];
            telTF.text = self.operatorModel.operatorPhone;
            pwdTF.text = self.operatorModel.operatorPassword;
            break;
        case OperatorRequestPostInfo:{
            
            switch ([response.data[@"process_code"] integerValue]) {
                case 10008:
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
//                    if (self.creditInfoModel.hasCreateOrder.integerValue == 1) {
//                        [XAlertView alertWithTitle:@"通知" message:@"您的授信资料已收到，我们会尽快完成授信审核。" cancelButtonTitle:@"" confirmButtonTitle:@"返回首页" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
//                            for (UIViewController *controller in self.navigationController.viewControllers) {
//                                if ([controller isKindOfClass:[LoanMainVC class]]) {
//                                    LoanMainVC *vc = (LoanMainVC *)controller;
//                                    [self.navigationController popToViewController:vc animated:YES];
//                                }
//                            }
//                        }];
//                    }else{
//                        LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
//                        vc.creditInfoModel = self.creditInfoModel;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
                    
                    return;
                }
                    break;
                case 10001:
                case 10004:
                case 10006:
                case 10002:{
                    OperatorDetailVC *vc = [[OperatorDetailVC alloc]init];
                    vc.model = self.operatorModel;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
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
        case OperatorRequestCreditInfo:{
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.data];
            switch (self.creditInfoModel.operatorStatus.integerValue) {
                case 1:
                    [self setHudWithName:@"运营商正在认证中，请耐心等待" Time:1.5 andType:1];
                    return;
                    break;
                    
                default:
                    break;
            }
            if (self.clientGlobalInfo.decisionType.integerValue == 0) {
                [self prepareDataWithCount:OperatorRequestPostInfo];
            }else{
                [self prepareDataWithCount:OperatorRequestBQSLogin];
            }
            
        }
            break;
        case OperatorRequestBQSLogin:{
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
        default:
            break;
    
    }
}
- (void)requestFaildWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case OperatorRequestBQSLogin:
        {
            self.operatorBQSModel.reqId = response.rspMsg;
            switch (response.rspCode.integerValue) {
                case 11004:
                case 11005:
                {
                    OperatorDetailVC *vc = [[OperatorDetailVC alloc]init];
                    vc.BQSmodel = self.operatorBQSModel;
                    vc.BQSStatus = response.rspCode;
                    vc.creditInfoModel = self.creditInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;

                case 11008:
//                    [self setHudWithName:response.rspMsg Time:2 andType:1];
                    break;
                    
                default:
                    break;
            }
            return;
        }
            break;
            
        default:
            break;
    }
    [self setHudWithName:response.rspMsg Time:2 andType:1];
}
- (OperatorModel *)operatorModel{
    if (!_operatorModel) {
        _operatorModel = [[OperatorModel alloc]init];
    }
    return _operatorModel;
}
- (OperatorBQSModel *)operatorBQSModel{
    if (!_operatorBQSModel) {
        _operatorBQSModel = [[OperatorBQSModel alloc]init];
    }
    return _operatorBQSModel;
}
- (CreditInfoModel *)creditInfoModel{
    if (!_creditInfoModel) {
        _creditInfoModel = [[CreditInfoModel alloc]init];
    }
    return _creditInfoModel;
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
