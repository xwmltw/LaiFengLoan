//
//  LoanMainVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/1.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "LoanMainVC.h"
#import "SDCycleScrollView.h"
#import "LoginViewController.h"
#import "PersonViewController.h"
#import "LoanDetailViewController.h"
#import "IdentityViewController.h"
#import "ContactViewController.h"
#import "BaseViewController.h"
#import "OperatorViewController.h"
#import "CreditInfoModel.h"
#import "XAlertView.h"
#import "XRootWebVC.h"
#import "MyMessageVC.h"
#import "MyOrderDetailVC.h"
#import "XDeviceHelper.h"
#import "ZFBViewController.h"
typedef NS_ENUM(NSInteger, LoanMainBtnTag) {
    LoanMainBtnTagMY = 105,
    LoanMainBtnTagMessage,
    LoanMainBtnTagGetAmount,
    LoanMainBtnTagGoLoan,
};
typedef NS_ENUM(NSInteger ,LoanMainRequest) {
    LoanMainRequestCreditInfo,
    LoanMainRequestPostCreditInfo,
};
@interface LoanMainVC ()<SDCycleScrollViewDelegate>
{
    UILabel *eduLab;
    UILabel *pendPay;
    UIButton *getBtn;
    UIButton *loanBtn;
}
@property (nonatomic, strong) SDCycleScrollView *sdcycleScrollView;
@property (nonatomic, strong) NSMutableArray *scrollArry;//banner图片组
@property (nonatomic, strong) UIButton *myBtn;
@property (nonatomic, strong) UIButton *messageBtn;
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) UILabel *amountLab;
@property (nonatomic, strong) CreditInfoModel *creditInfoModel;
@property (nonatomic, strong) BannerAdList *BannerAdListModel;
@end

@implementation LoanMainVC

- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    if ([UserInfo sharedInstance].isSignIn) {
         [self prepareDataWithCount:LoanMainRequestCreditInfo];
    }else{
        [self initHeaderUI];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollArry = [NSMutableArray array];
    MyLog(@"token=%@",[[UserInfo sharedInstance]getUserInfo].accessToken);

    [self initHeaderUI];
    
//    [XNotificationCenter addObserver:self selector:@selector(notificationCreditInfo:) name:XUpdateCreditInfo object:nil];
    
    [self updataVersionInfo];
}
- (void)updataVersionInfo{
     if (self.clientGlobalInfo.versionInfo.version.integerValue > [XDeviceHelper getAppIntVersion]){
         if (self.clientGlobalInfo.versionInfo.needForceUpdate.integerValue == 1) {
             [XAlertView alertWithTitle:@"更新通知" message:self.clientGlobalInfo.versionInfo.versionDesc cancelButtonTitle:nil confirmButtonTitle:@"更新" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                 if (buttonIndex == 1) {
                     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.clientGlobalInfo.versionInfo.url]];
                 }
             }];
         }else{
             [XAlertView alertWithTitle:@"更新通知" message:self.clientGlobalInfo.versionInfo.versionDesc cancelButtonTitle:@"取消" confirmButtonTitle:@"更新" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.clientGlobalInfo.versionInfo.url]];
                }
            }];
         }
    }
}
- (void)initHeaderUI{
    [self.clientGlobalInfo.bannerAdList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        [self.scrollArry addObject:obj[@"adImgUrl"]];
    }];
    
    self.sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"Loan_headerBG"]];
    self.sdcycleScrollView.imageURLStringsGroup = self.scrollArry;
    self.sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    _sdcycleScrollView.autoScrollTimeInterval = 3;
    _sdcycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    _sdcycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdcycleScrollView.pageDotColor = XColorWithRBBA(255, 255, 255, 0.4);
    if (self.scrollArry.count == 1) {
        self.sdcycleScrollView.autoScroll = NO;
    }
    [self.view addSubview:self.sdcycleScrollView];
    [self.sdcycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(188));
    }];
    
    self.myBtn = [[UIButton alloc]init];
    self.myBtn.tag = LoanMainBtnTagMY;
    [self.myBtn setImage:[UIImage imageNamed:@"myBtn"] forState:UIControlStateNormal];
    [self.myBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myBtn];
    [self.myBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(28));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(12));
        make.width.height.mas_equalTo(40);
    }];
    
    self.messageBtn = [[UIButton alloc]init];
    self.messageBtn.tag = LoanMainBtnTagMessage;
    [self.messageBtn setImage:[UIImage imageNamed:@"messageBtn"] forState:UIControlStateNormal];
    [self.messageBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.messageBtn];
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(28));
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-12));
        make.width.height.mas_equalTo(40);
    }];
    
    self.informationView =[UIView gradientViewWithColors:@[XColorWithRGB(122, 176, 247),AppMainColor] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.informationView setCornerValue:AdaptationWidth(6)];
    [self.view addSubview:self.informationView];
    [self.informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sdcycleScrollView.mas_bottom).offset(AdaptationWidth(22));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(45));
        make.right.mas_equalTo(self.view).offset(AdaptationWidth(-45));
        make.height.mas_equalTo(AdaptationWidth(160));
    }];
    
    eduLab = [[UILabel alloc] init];
    eduLab.text = @"最高可借(元)额度";
    eduLab.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    eduLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(18)];
    [self.informationView addSubview:eduLab];
    [eduLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.informationView);
        make.top.mas_equalTo(self.informationView).offset(AdaptationWidth(26));
    }];
    
    self.amountLab = [[UILabel alloc] init];
    self.amountLab.text = self.clientGlobalInfo.notLoginShowCreditMax;
    self.amountLab.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    self.amountLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(33)];
    [self.informationView addSubview:_amountLab];
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.informationView);
        make.top.mas_equalTo(eduLab.mas_bottom).offset(AdaptationWidth(6));
    }];
    
    pendPay = [[UILabel alloc] init];
    pendPay.text = @"额度高   |  审核简单   |   放款快 ";
    pendPay.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    pendPay.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(12)];
    [self.informationView addSubview:pendPay];
    [pendPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.informationView);
        make.bottom.mas_equalTo(self.informationView.mas_bottom).offset(AdaptationWidth(-23));
    }];
    
    getBtn = [[UIButton alloc]init];
    getBtn.tag = LoanMainBtnTagGetAmount;
    [getBtn setCornerValue:AdaptationWidth(22)];
    [getBtn setTitle:@"获取额度" forState:UIControlStateNormal];
    [getBtn setBackgroundColor:AppMainColor];
    [getBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.informationView);
        make.top.mas_equalTo(self.informationView.mas_bottom).offset(AdaptationWidth(32));
        make.width.mas_equalTo(AdaptationWidth(250));
        make.height.mas_equalTo(AdaptationWidth(43));
    }];
    
    loanBtn = [[UIButton alloc]init];
    loanBtn.tag = LoanMainBtnTagGoLoan;
    [loanBtn setBorderWidth:1 andColor:AppMainColor];
    [loanBtn setCornerValue:AdaptationWidth(22)];
    [loanBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
    [loanBtn setTitle:@"我要借款" forState:UIControlStateNormal];
    [loanBtn setBackgroundColor:[UIColor whiteColor]];
    [loanBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loanBtn];
    [loanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.informationView);
        make.top.mas_equalTo(getBtn.mas_bottom).offset(AdaptationWidth(18));
        make.width.height.mas_equalTo(getBtn);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = self.clientGlobalInfo.companyCopyrightInfo;
    label3.textColor = [UIColor colorWithRed:157/255.0 green:157/255.0 blue:157/255.0 alpha:1];
    label3.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(12)];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(AdaptationWidth(-18));
    }];
    
}
- (void)notificationCreditInfo:(NSNotification *)noti{
    [self prepareDataWithCount:LoanMainRequestCreditInfo];
}
#pragma mark - sdcycscrollview delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    self.BannerAdListModel = [BannerAdList mj_objectWithKeyValues:self.clientGlobalInfo.bannerAdList[index]];
    if(!self.BannerAdListModel.adDetailUrl.length){
        return;
    }
    NSNumber *adtype = self.clientGlobalInfo.bannerAdList[index][@"adType"];
    switch (adtype.integerValue) {
        case 1:
        {
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = self.BannerAdListModel.adDetailUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
            //浏览器打开
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.BannerAdListModel.adDetailUrl]];
            break;
        case 3:
            
            break;
            
        default:
            break;
    }
}
#pragma  mark - btn事件
- (void)btnOnClick:(UIButton *)btn{

    
    switch (btn.tag) {
        case LoanMainBtnTagMY:
        {

            PersonViewController *vc = [[PersonViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case LoanMainBtnTagMessage:
        {
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            [self.messageBtn setImage:[UIImage imageNamed:@"messageBtn"] forState:UIControlStateNormal];
            MyMessageVC *vc = [[MyMessageVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case LoanMainBtnTagGetAmount:
        {
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            if (self.creditInfoModel.hasBlack.integerValue == 1) {
                [XAlertView alertWithTitle:@"通知" message:@"个人信息异常，暂时无法借款" cancelButtonTitle:nil confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                    
                }];
                return;
            }
            if (self.creditInfoModel.scheduleStatus.integerValue != 5 || self.creditInfoModel.alipayStatus.integerValue != 1) {
            
                switch (self.creditInfoModel.scheduleStatus.integerValue) {
                    case 1:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未身份认证，请先去身份认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                IdentityViewController *vc = [[IdentityViewController alloc]init];
                                vc.creditInfoModel = self.creditInfoModel;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                       
                    }
                        break;
                    case 2:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未联系人信息认证，请先去联系人信息认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                ContactViewController *vc = [[ContactViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 3:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未基本信息认证，请先去基本信息认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                BaseViewController *vc = [[BaseViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 4:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未运营商认证，请先去运营商认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                OperatorViewController *vc = [[OperatorViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 5:{
                        if (self.creditInfoModel.operatorStatus.integerValue == 1) {
                            [XAlertView alertWithTitle:@"通知" message:@"运营商认证正在认证中，请稍后" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                
                            }];
                            return;
                        }
                        if (self.creditInfoModel.operatorStatus.integerValue != 2) {
                            [XAlertView alertWithTitle:@"通知" message:@"您还未运营商认证或已过期，请先去运营商认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    OperatorViewController *vc = [[OperatorViewController alloc]init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                            return;
                        }
                        if (self.creditInfoModel.alipayStatus.integerValue != 1 && self.clientGlobalInfo.isNeedAlipayVerify.integerValue == 1) {
                            [XAlertView alertWithTitle:@"通知" message:@"您还未支付宝认证，请先去支付宝认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    ZFBViewController *vc = [[ZFBViewController alloc]init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                        }else{
                            LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                            vc.creditInfoModel = self.creditInfoModel;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                        break;
                    case 6:{
                        if (self.clientGlobalInfo.isNeedAlipayVerify.integerValue == 1) {
                            [XAlertView alertWithTitle:@"通知" message:@"您还未支付宝认证，请先去支付宝认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    ZFBViewController *vc = [[ZFBViewController alloc]init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                        }
                        else{
                            LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                            vc.creditInfoModel = self.creditInfoModel;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                    }
                        break;
                    default:
                        break;
                }
                
                return;
            }
            switch (self.creditInfoModel.creditStatus.integerValue) {
                case 0:{
//                    [self prepareDataWithCount:LoanMainRequestPostCreditInfo];
                    LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                    vc.creditInfoModel = self.creditInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:{
                    [XAlertView alertWithTitle:@"通知" message:@"正在授信中" cancelButtonTitle:@"" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        
                    }];
                }
                    break;
                case 2:{
                    if (!self.creditInfoModel.useAmt.integerValue) {
                        [XAlertView alertWithTitle:@"通知" message:@"您的可用额度不足，请调整借款金额" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            
                        }];
                        
                        return;
                    }
                    
                    LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                    vc.creditInfoModel = self.creditInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:
                {
                    [XAlertView alertWithTitle:@"通知" message:@"是否重新提交授信" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        switch (buttonIndex) {
                            case 1:
                            {
//                                OperatorViewController *vc = [[OperatorViewController alloc]init];
//                                [self.navigationController pushViewController:vc animated:YES];
                                [self prepareDataWithCount:LoanMainRequestPostCreditInfo];
                            }
                                break;

                            default:
                                break;
                        }
                    }];
                }
                    break;
                case 4:
                {
                    [XAlertView alertWithTitle:@"温馨提示" message:@"是否重新提交授信" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        switch (buttonIndex) {
                            case 1:
                            {
                                [self prepareDataWithCount:LoanMainRequestPostCreditInfo];
//                                ContactViewController *vc = [[ContactViewController alloc]init];
//                                [self.navigationController pushViewController:vc animated:YES];
                                
                            }
                                break;

                            default:
                                break;
                        }
                    }];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
            break;
        case LoanMainBtnTagGoLoan:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            if (self.creditInfoModel.hasBlack.integerValue == 1) {
                [XAlertView alertWithTitle:@"通知" message:@"个人信息异常，暂时无法借款" cancelButtonTitle:nil confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                    
                }];
                return;
            }
            if (self.creditInfoModel.scheduleStatus.integerValue != 5) {
                switch (self.creditInfoModel.scheduleStatus.integerValue) {
                    
                    case 1:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未身份认证，请先去身份认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                IdentityViewController *vc = [[IdentityViewController alloc]init];
                                vc.creditInfoModel = self.creditInfoModel;
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 2:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未联系人信息认证，请先去联系人信息认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                ContactViewController *vc = [[ContactViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 3:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未基本信息认证，请先去基本信息认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                BaseViewController *vc = [[BaseViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 4:
                    {
                        [XAlertView alertWithTitle:@"通知" message:@"您还未运营商认证，请先去运营商认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            if (buttonIndex == 1) {
                                OperatorViewController *vc = [[OperatorViewController alloc]init];
                                [self.navigationController pushViewController:vc animated:YES];
                            }
                        }];
                    }
                        break;
                    case 5:{
                        
                        if (self.creditInfoModel.operatorStatus.integerValue == 1) {
                            [XAlertView alertWithTitle:@"通知" message:@"运营商认证正在认证中，请稍后" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                
                            }];
                            return;
                        }
                        if (self.creditInfoModel.operatorStatus.integerValue != 2) {
                            [XAlertView alertWithTitle:@"通知" message:@"您还未运营商认证或已过期，请先去运营商认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    OperatorViewController *vc = [[OperatorViewController alloc]init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                            return;
                        }
                        
                        if (self.creditInfoModel.alipayStatus.integerValue != 1 && self.clientGlobalInfo.isNeedAlipayVerify.integerValue == 1) {
                            [XAlertView alertWithTitle:@"通知" message:@"您还未支付宝认证，请先去支付宝认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    ZFBViewController *vc = [[ZFBViewController alloc]init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                        }else{
                            LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                            vc.creditInfoModel = self.creditInfoModel;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                        break;
                    case 6:{
                        if (self.clientGlobalInfo.isNeedAlipayVerify.integerValue == 1) {
                            [XAlertView alertWithTitle:@"通知" message:@"您还未支付宝认证，请先去支付宝认证吧" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                                if (buttonIndex == 1) {
                                    ZFBViewController *vc = [[ZFBViewController alloc]init];
                                    [self.navigationController pushViewController:vc animated:YES];
                                }
                            }];
                        }
                        else{
                            LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                            vc.creditInfoModel = self.creditInfoModel;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                        break;
                    default:
                        break;
                }
                return;
            }
            switch (self.creditInfoModel.creditStatus.integerValue) {
                case 0:{
                    //                    [self prepareDataWithCount:LoanMainRequestPostCreditInfo];
                    LoanDetailViewController *vc = [[LoanDetailViewController alloc]init];
                    vc.creditInfoModel = self.creditInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 1:{
                    [XAlertView alertWithTitle:@"通知" message:@"您的授信正在审核中，请耐心等待" cancelButtonTitle:@"" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        
                    }];
                }
                    break;
                case 2:{
                    if (!self.creditInfoModel.waitPayAmt.doubleValue) {
                        [XAlertView alertWithTitle:@"通知" message:@"您没有需要还款的订单。" cancelButtonTitle:@"" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                            
                        }];
                        return;
                    }
                    MyOrderDetailVC *vc = [[MyOrderDetailVC alloc]init];
                    vc.title = @"待还款";
                    vc.orderState = MyOrderStateCleared;
                    [self.navigationController pushViewController:vc animated:YES];
                   
                }
                    break;
                case 3:
                {
                    [XAlertView alertWithTitle:@"通知" message:@"是否重新提交授信" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        switch (buttonIndex) {
                            case 1:
                            {
                                [self prepareDataWithCount:LoanMainRequestPostCreditInfo];
                                
                                
                            }
                                break;

                            default:
                                break;
                        }
                    }];
                }
                    break;
                case 4:
                {
                    [XAlertView alertWithTitle:@"通知" message:@"是否重新提交授信" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                        switch (buttonIndex) {
                            case 1:
                            {
                                [self prepareDataWithCount:LoanMainRequestPostCreditInfo];
                                
                            }
                                break;

                            default:
                                break;
                        }
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -network
- (void)setRequestParams{
    switch (self.requestCount) {
        case LoanMainRequestCreditInfo:
            self.cmd = XGetCreditInfoVerify;
            self.dict = [NSDictionary dictionary];
            break;
        case LoanMainRequestPostCreditInfo:{
            self.cmd = XPostCreditInfoVerify;
            self.dict = [NSDictionary dictionary];
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case LoanMainRequestCreditInfo:{
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.data];
//            self.
            if (self.creditInfoModel.mesSmallRedoint.integerValue) {
                [self.messageBtn setImage:[UIImage imageNamed:@"messageRedBtn"] forState:UIControlStateNormal];
            }else{
                [self.messageBtn setImage:[UIImage imageNamed:@"messageBtn"] forState:UIControlStateNormal];
            }
            if (self.creditInfoModel.creditStatus.integerValue != 2) {
                if (self.creditInfoModel.creditStatus.integerValue == 1) {
                    self.amountLab.text = @"资料审核中...";
                    eduLab.text = @"";
                    pendPay.text = @"系统自动审核稍等片刻，不要离开";
                }else{
                    eduLab.text = @"最高可借(元)额度";
//                    self.amountLab.text = self.clientGlobalInfo.riskCreditAmtMax;
                    self.amountLab.text = self.creditInfoModel.useAmt.description;
                    pendPay.text = @"额度高   |  审核简单   |   放款快";
                    [getBtn setTitle:@"我要借款" forState:UIControlStateNormal];
                    [loanBtn setTitle:@"立即还款" forState:UIControlStateNormal];
                    [loanBtn setBorderWidth:1 andColor:AppMainColor];
                    [loanBtn setCornerValue:AdaptationWidth(22)];
                    [loanBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
                }
            }else{
                
                self.amountLab.text = self.creditInfoModel.useAmt.integerValue ? self.creditInfoModel.useAmt.description : @"暂无可借额度";
                eduLab.text = self.creditInfoModel.useAmt.integerValue ? [NSString stringWithFormat:@"%@，你可以借",self.creditInfoModel.trueName] :[NSString stringWithFormat:@"%@，你好!",self.creditInfoModel.trueName];
                if (self.creditInfoModel.isFirstLoan.integerValue == 1) {
                    pendPay.text = [NSString stringWithFormat:@"授信总额度￥%@",self.creditInfoModel.creditAmt.description];
                }else{
                    pendPay.text = [NSString stringWithFormat:@"应还金额￥%.2f",self.creditInfoModel.waitPayAmt.doubleValue];
                }
                
                
                [getBtn setTitle:@"我要借款" forState:UIControlStateNormal];
                [loanBtn setTitle:@"立即还款" forState:UIControlStateNormal];
                if (!self.creditInfoModel.waitPayAmt.doubleValue ) {
                    [loanBtn setBorderWidth:1 andColor:LineColor];
                    [loanBtn setTitleColor:LineColor forState:UIControlStateNormal];
                }
                
            }
        }
            break;
        case LoanMainRequestPostCreditInfo:{
            switch ([response.data[@"creditStatus"] integerValue]) {
                case 1:
                    [self setHudWithName:@"审核中" Time:1 andType:1];
                    break;
                case 3:
                    {
                        OperatorViewController *vc = [[OperatorViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                case 4:
                    {
                        ContactViewController *vc = [[ContactViewController alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    break;
                case 0:{
                    [self setHudWithName:@"未审核" Time:1 andType:1];
                }
                    break;
                case 2:{
                    [self setHudWithName:@"已审核" Time:1 andType:1];
                }
                    break;
                default:
                    break;
            }
            
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
- (BannerAdList *)BannerAdListModel{
    if (!_BannerAdListModel) {
        _BannerAdListModel = [[BannerAdList alloc]init];
    }
    return _BannerAdListModel;
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
