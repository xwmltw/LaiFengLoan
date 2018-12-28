//
//  ZFBViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/12/25.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ZFBViewController.h"
#import "AuthorizationHeadView.h"
#import "XChooseBankView.h"
#import "ContactViewController.h"
#import "BaseViewController.h"
#import "OperatorViewController.h"
#import "MoxieSDK.h"
#import "LoanDetailViewController.h"
#import "LoanMainVC.h"
#import "XAlertView.h"
@interface ZFBViewController ()<XChooseBankPickerViewDelegate,MoxieSDKDelegate>
@property (nonatomic, strong) XChooseBankView *pickerView;
@property (nonatomic, copy) NSString *taskId;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end

@implementation ZFBViewController
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
    [self  prepareDataWithCount:2];
    
    [self initUI];
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
    yysLab.text = @"支付宝认证";
    yysLab.textColor = LabelMainColor;
    yysLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(18)];
    [self.view addSubview:yysLab];
    [yysLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.top.mas_equalTo(headView.mas_bottom).offset(AdaptationWidth(22));
        
    }];
    
    
    
    
    UIButton *autBtn = [[UIButton alloc]init];
    autBtn.tag = 101;
    [autBtn setBorderWidth:1 andColor:AppMainColor];
    [autBtn setCornerValue:AdaptationWidth(22)];
    [autBtn setTitle:@"进行支付宝认证" forState:UIControlStateNormal];
    [autBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
    [autBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autBtn];
    [autBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yysLab).offset(AdaptationWidth(72));
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
        case 2:{
            OperatorViewController *vc = [[OperatorViewController alloc]init];
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
            
            [MoxieSDK shared].taskType = @"alipay";
            [[MoxieSDK shared] start];
            
        }
            break;
        case 102:
        {
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = @[@"联系人信息",@"基本信息",@"运营商认证"];
            [self.pickerView showView];
        }
            break;
        default:
            break;
    }
    
}
#pragma MoxieSDK Status Delegate
//魔蝎SDK --- 回调任务进行进度情况
-(void)receiveMoxieSDKStatus:(NSDictionary *)statusDictionary{
    NSLog(@"receive statusDictionary:%@",statusDictionary);
}
#pragma MoxieSDK Result Delegate
-(void)receiveMoxieSDKResult:(NSDictionary*)resultDictionary{
    //任务Id
    self.taskId = resultDictionary[@"taskId"];
    int code = [resultDictionary[@"code"] intValue];
    BOOL loginDone = [resultDictionary[@"loginDone"] boolValue];
    if(code == 2 && loginDone == false){
        [self setHudWithName:@"正在登录中" Time:1.5 andType:1];

    }
    //【采集中】假如code是2且loginDone为true，已经登录成功，正在采集中
    else if(code == 2 && loginDone == true){
        [self setHudWithName:@"登录成功，正在采集中" Time:1.5 andType:1];

    }
    //【采集成功】假如code是1则采集成功（不代表回调成功）
    else if(code == 1){
        
        [self prepareDataWithCount:3];

    }
    //【未登录】假如code是-1则用户未登录
    else if(code == -1){
        [self setHudWithName:@"支付宝授权失败" Time:1.5 andType:1];

    }
    //【任务失败】该任务按失败处理，可能的code为0，-2，-3，-4
    else{
        [self setHudWithName:@"支付宝授权失败" Time:1.5 andType:1];
    }
}
- (void)setRequestParams{
    switch (self.requestCount) {
        
        case 0:
            self.cmd = XGetAlipayParam;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedInstance].accessToken,@"accessToken", nil];
            break;
        case 1:
            self.cmd = XPostAlipayParam;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedInstance].accessToken,@"accessToken",self.taskId,@"taskId", nil];
            break;
        case 2:{
            self.cmd = XGetIdentityInfo;
            self.dict = [NSDictionary dictionary];
        }
            break;
        case 3:{
            self.cmd = XGetCreditInfoVerify;
            self.dict = [NSDictionary dictionary];
        }
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
            
        case 0:
        {
            /***必须配置的基本参数*/
            [MoxieSDK shared].delegate = self;
            [MoxieSDK shared].userId = response.data[@"userId"];
            [MoxieSDK shared].apiKey = response.data[@"aliKey"];
            [MoxieSDK shared].fromController = self;
            //自定义三要素信息（运营商认证会自动进行参数的预填）
            [MoxieSDK shared].phone = [UserInfo sharedInstance].phoneName;
            [MoxieSDK shared].name = self.dataDic[@"trueName"];
            [MoxieSDK shared].idcard = self.dataDic[@"idCardNo"];
        }
            break;
        case 1:
        {
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
            break;
        case 2:{
            self.dataDic = [NSDictionary dictionaryWithDictionary:response.data];
            [self prepareDataWithCount:0];
        }
            break;
        case 3:{
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.data];
            [self prepareDataWithCount:1];
        }
            break;
        default:
            break;
    }
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
