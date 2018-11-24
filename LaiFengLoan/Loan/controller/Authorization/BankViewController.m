//
//  BankViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "BankViewController.h"
#import "XCountDownButton.h"
#import "BankModel.h"
#import "ScanningBankDetailVC.h"
typedef NS_ENUM(NSInteger ,BankTextFieldTag) {
    BankTextFieldTagScan,
    BankTextFieldTagName,
    BankTextFieldTagBankName,
    BankTextFieldTagTel,
    BankTextFieldTagCode,
    
};
typedef NS_ENUM(NSInteger ,BankRequest) {
    BankRequestGetInfo,
    BankRequestCode,
    BankRequestCodeAgain,
    BankRequestPostInfo,
    
};
@interface BankViewController ()<UITextFieldDelegate>
@property (nonatomic ,strong) BankModel *bankModel;
@end

@implementation BankViewController
{
    XCountDownButton *_getVerificationCodeButton;
    NSDictionary *_bankInfoDict;//银行卡信息
    UITextField *textTF;
    UITextField *textTF2;
    UITextField *textTF3;
    UITextField *textTF4;
    UITextField *textTF5;

}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (self.bankModel.bankName.length && self.bankModel.bankCardNo.length ) {
        textTF.text = self.bankModel.bankCardNo;
        textTF3.text = self.bankModel.bankName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡绑定";
    [self initUI];
}
- (void)initUI{
    textTF = [[UITextField alloc]init];
    textTF.delegate = self;
    textTF.tag = BankTextFieldTagScan;
    textTF.text = @"点击扫描您的银行卡";
    [textTF setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    textTF.textAlignment = NSTextAlignmentRight;
    [textTF setTextColor:AppMainColor];
    UIImageView *phoneImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(16), AdaptationWidth(16))];
    phoneImage.image = [UIImage imageNamed:@"扫描"];
    textTF.leftView  = phoneImage;
    textTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:textTF];
    [textTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(22));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"银行卡号";
    label.textColor = XColorWithRGB(89, 99, 109);
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textTF);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    UIView *line  = [[UIView alloc]init];
    line.backgroundColor = LineColor;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textTF.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    textTF2 = [[UITextField alloc]init];
    textTF2.delegate = self;
    textTF2.tag = BankTextFieldTagName;
    textTF2.text = self.creditInfoModel.trueName;
    [textTF2 setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    textTF2.textAlignment = NSTextAlignmentRight;
    [textTF2 setTextColor:LabelMainColor];
    [self.view addSubview:textTF2];
    [textTF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(line.mas_bottom).offset(AdaptationWidth(2));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"持卡人";
    label2.textColor = XColorWithRGB(89, 99, 109);
    label2.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textTF2);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    UIView *line2  = [[UIView alloc]init];
    line2.backgroundColor = LineColor;
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textTF2.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    textTF3 = [[UITextField alloc]init];
    textTF3.delegate = self;
    textTF3.tag = BankTextFieldTagBankName;
    textTF3.placeholder = @"请输入您的开户银行";
    [textTF3 setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    textTF3.textAlignment = NSTextAlignmentRight;
    [textTF3 setTextColor:LabelMainColor];
    [self.view addSubview:textTF3];
    [textTF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(line2.mas_bottom).offset(AdaptationWidth(2));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = @"开户银行";
    label3.textColor = XColorWithRGB(89, 99, 109);
    label3.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textTF3);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    UIView *line3  = [[UIView alloc]init];
    line3.backgroundColor = LineColor;
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textTF3.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    textTF4 = [[UITextField alloc]init];
    textTF4.delegate = self;
    textTF4.tag = BankTextFieldTagTel;
    textTF4.placeholder = @"请输入银行预留的手机号";
    [textTF4 setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    textTF4.textAlignment = NSTextAlignmentRight;
    [textTF4 setTextColor:LabelMainColor];
    [self.view addSubview:textTF4];
    [textTF4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(line3.mas_bottom).offset(AdaptationWidth(2));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = @"预留手机号";
    label4.textColor = XColorWithRGB(89, 99, 109);
    label4.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textTF4);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    UIView *line4  = [[UIView alloc]init];
    line4.backgroundColor = LineColor;
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textTF4.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    textTF5 = [[UITextField alloc]init];
    textTF5.delegate = self;
    textTF5.placeholder = @"请输入短信验证码";
    textTF5.tag = BankTextFieldTagCode;
    [textTF5 setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    textTF5.textAlignment = NSTextAlignmentRight;
    [textTF5 setTextColor:LabelMainColor];
    [self.view addSubview:textTF5];
    
    XCountDownButton *getVerificationCodeButton = [XCountDownButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeButton.frame = CGRectMake(0, 0, AdaptationWidth(94), AdaptationWidth(43));
    
    [getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeButton setTitleColor:AppMainColor forState:UIControlStateNormal];
    getVerificationCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //    getVerificationCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -AdaptationWidth(24));
    getVerificationCodeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)];
    textTF5.rightView = getVerificationCodeButton;
    textTF5.rightViewMode = UITextFieldViewModeAlways;
    [getVerificationCodeButton addTarget:self action:@selector(getVerificationCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [textTF5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-18));
        make.top.mas_equalTo(line4.mas_bottom).offset(AdaptationWidth(2));
        make.height.mas_equalTo(AdaptationWidth(50));
    }];
    
    UILabel *label5 = [[UILabel alloc] init];
    label5.text = @"短信验证码";
    label5.textColor = XColorWithRGB(89, 99, 109);
    label5.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(textTF5);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        
    }];
    
    UIView *line5  = [[UIView alloc]init];
    line5.backgroundColor = LineColor;
    [self.view addSubview:line5];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textTF5.mas_bottom).offset(AdaptationWidth(2));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *autBtn = [[UIButton alloc]init];
    [autBtn setBorderWidth:1 andColor:AppMainColor];
    [autBtn setCornerValue:AdaptationWidth(22)];
    [autBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    [autBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
    [autBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autBtn];
    [autBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(250));
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(40));
    }];
    
    UILabel * compayLab = [[UILabel alloc]init];
    compayLab.numberOfLines = 0;
    [compayLab setText:[NSString stringWithFormat:@"每人限定3次尝试，失败将被锁定，请填写正确的银行卡号，预留手机号以及验证码。"]];
    [compayLab setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [compayLab setTextColor:LabelShallowColor];
    [self.view addSubview:compayLab];
    [compayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(18));
        make.bottom.mas_equalTo(autBtn.mas_top).offset(-AdaptationWidth(10));
    }];
    
}
#pragma mark -btn
- (void)btnOnClick:(UIButton *)btn{
    
    if ( !textTF3.text.length) {
        [self setHudWithName:@"请扫描银行卡信息" Time:1 andType:1];
        return;
    }
    if (!textTF4.text.length) {
        [self setHudWithName:@"请输入手机号码" Time:1 andType:1];
        return;
    }
    if (!textTF5.text.length) {
        [self setHudWithName:@"请输入短信验证码" Time:1 andType:1];
        return;
    }
    self.bankModel.smsCode = textTF5.text;
    [self prepareDataWithCount:BankRequestPostInfo];
}
#pragma mark - 验证码事件
- (void)getVerificationCodeClick:(XCountDownButton *)sender
{
    _getVerificationCodeButton = sender;
    if (!textTF4.text.length) {
        [self setHudWithName:@"请输入手机号码" Time:1 andType:1];
        return;
    }
    
    self.bankModel.bankPhone = textTF4.text;
    self.bankModel.trueName = textTF2.text;
    if (self.bankModel.bankAccountId.integerValue) {
        [self prepareDataWithCount:BankRequestCodeAgain];
    }else{
        [self prepareDataWithCount:BankRequestCode];
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
#pragma  mark - UITextFielddelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case BankTextFieldTagTel:
        case BankTextFieldTagCode:
            return YES;
            break;
        case BankTextFieldTagScan:{
            [self startBankCardOCR];
        }
            break;
        default:
            break;
    }
    return NO;
}
/**
 银行卡回调
 @param bank_num 银行卡号码
 @param bank_name 银行姓名
 @param bank_orgcode 银行编码
 @param bank_class  银行卡类型(借记卡)
 @param card_name 卡名字
 */
-(void)sendBankCardInfo:(NSString *)bank_num BANK_NAME:(NSString *)bank_name BANK_ORGCODE:(NSString *)bank_orgcode BANK_CLASS:(NSString *)bank_class CARD_NAME:(NSString *)card_name
{
//    MyLog(@"%s", __func__);
//    _bankInfoDict = @{@"bank_num":bank_num,
//                      @"bank_name":bank_name
//                      };
    self.bankModel.bankCardNo = bank_num;
    self.bankModel.bankName = bank_name;
    self.bankModel.bankCode = bank_orgcode;
  
}

/**
 @param BankCardImage 银行卡卡号扫描图片
 */
-(void)sendBankCardImage:(UIImage *)BankCardImage
{
    
    ScanningBankDetailVC *vc = [[ScanningBankDetailVC alloc]init];
    vc.model = self.bankModel;
    vc.bankImage = BankCardImage;

    vc.block = ^(NSString *bankName, NSString *bankNumer , NSString *bankCode) {
        self.bankModel.bankName = bankName;
        self.bankModel.bankCardNo =[bankNumer stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.bankModel.bankCode = bankCode;
        
    };

    [self.navigationController pushViewController:vc animated:YES];
    NSLog(@"%s", __func__);
    
}
#pragma mark -network
- (void)setRequestParams{
    switch (self.requestCount) {
        case BankRequestGetInfo:
            self.cmd = XGetUserBankList;
            self.dict = [NSDictionary dictionary];
            break;
        case BankRequestCode:
            self.cmd = XGetValidCode;
            self.dict = [self.bankModel mj_keyValues];
            break;
        case BankRequestCodeAgain:
            self.cmd = XGetValidCodeAgain;
            self.dict = [self.bankModel mj_keyValues];
            break;
        case BankRequestPostInfo:
            self.cmd = XPostBankCard;
            self.dict = [self.bankModel mj_keyValues];
            break;
            
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case BankRequestGetInfo:
            
            break;
        case BankRequestCode:
            [self beginCountDown];
            [self setHudWithName:@"发送成功"Time:1 andType:1];
            
            self.bankModel.bankAccountId = response.data[@"bankAccountId"];
            break;
        case BankRequestCodeAgain:
            [self beginCountDown];
            [self setHudWithName:@"发送成功"Time:1 andType:1];
            self.bankModel.bankAccountId = response.data[@"bankAccountId"];
            break;
        case BankRequestPostInfo:
            [self setHudWithName:@"认证成功"Time:1 andType:1];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
            
        default:
            break;
    }
}
- (BankModel *)bankModel{
    if (!_bankModel) {
        _bankModel = [[BankModel alloc]init];
    }
    return _bankModel;
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
