//
//  BankViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "IdentityViewController.h"
#import "AuthorizationHeadView.h"
#import "UDIDSafeAuthEngine.h"
#import "UDIDSafeDataDefine.h"
#import "IdentifyModel.h"
#import "ContactViewController.h"
#import "XAlertView.h"
typedef NS_ENUM(NSInteger,IdentityRequest) {
    IdentityRequestGetInfo,
    IdentityRequestPostInfo,
    IdentityRequestGet,
};
@interface IdentityViewController ()<UDIDSafeAuthDelegate>
@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSString * partnerOrderId;
@property (nonatomic, strong) NSString * signTime;
@property (nonatomic, strong) IdentifyModel *identifyModel;
@property (nonatomic, strong) UIView *informationView;
@property (nonatomic, strong) NSDictionary *userDic;
@property (nonatomic, copy) NSNumber *redCode;
@end

@implementation IdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"身份证认证";
    if (self.creditInfoModel.scheduleStatus.integerValue == 1) {
        [self initUI];
    }else{
        [self prepareDataWithCount:IdentityRequestGet];
    }
}
- (void)overUI{
    
    self.informationView =[UIView gradientViewWithColors:@[XColorWithRGB(122, 176, 247),XColorWithRGB(56, 123, 230)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self.informationView setCornerValue:AdaptationWidth(6)];
    [self.view addSubview:self.informationView];
    [self.informationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(22));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(285));
        make.height.mas_equalTo(AdaptationWidth(160));
    }];
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"姓名：%@",self.userDic[@"trueName"]];
    label.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [self.informationView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.informationView).offset(AdaptationWidth(55));
        make.top.mas_equalTo(self.informationView).offset(AdaptationWidth(26));
    }];
    
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"Identify_Image"];
    [self.informationView addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(AdaptationWidth(14));
        make.centerY.mas_equalTo(label);
        make.width.mas_equalTo(AdaptationWidth(28));
        make.height.mas_equalTo(AdaptationWidth(11));
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = [NSString stringWithFormat:@"性别：%@",self.userDic[@"sex"]];
    label2.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    label2.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [self.informationView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.informationView).offset(AdaptationWidth(55));
        make.top.mas_equalTo(label.mas_bottom).offset(AdaptationWidth(24));
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = [NSString stringWithFormat:@"身份证号：%@", [self.userDic[@"idCardNo"] stringByReplacingCharactersInRange:NSMakeRange(3, 11) withString:@"***********"]];
    label3.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    label3.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [self.informationView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.informationView).offset(AdaptationWidth(55));
        make.top.mas_equalTo(label2.mas_bottom).offset(AdaptationWidth(24));
    }];
}
- (void)initUI{
    AuthorizationHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"AuthorizationHead" owner:self options:nil].lastObject;
    headView.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(90));
    [headView setHeadImage:@1];
    [self.view addSubview:headView];

    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"将您的身份证正、反面通过扫描即可完成认证";
    label.textColor = LabelMainColor;
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom).offset(AdaptationWidth(15));
        make.centerX.mas_equalTo(self.view);
    }];
    
    UIImageView *faceImage = [[UIImageView alloc]init];
    faceImage.image = [UIImage imageNamed:@"bank_face"];
    [self.view addSubview:faceImage];
    [faceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(AdaptationWidth(40));
        make.centerX.mas_equalTo(self.view).multipliedBy(0.5);
        make.height.mas_equalTo(AdaptationWidth(100));
        make.width.mas_equalTo(AdaptationWidth(159));
    }];
    
    UILabel *faceLab = [[UILabel alloc] init];
    faceLab.text = @"身份证正面";
    faceLab.textColor = LabelShallowColor;
    faceLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(12)];
    [self.view addSubview:faceLab];
    [faceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(faceImage.mas_bottom).offset(AdaptationWidth(13));
        
        make.left.mas_equalTo(faceImage);
    }];
    
    UIImageView *backImage = [[UIImageView alloc]init];
    backImage.image = [UIImage imageNamed:@"bank_back"];
    [self.view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(AdaptationWidth(40));
        make.centerX.mas_equalTo(self.view).multipliedBy(1.5);
        make.height.mas_equalTo(AdaptationWidth(100));
        make.width.mas_equalTo(AdaptationWidth(159));
    }];
    
    UILabel *backLab = [[UILabel alloc] init];
    backLab.text = @"身份证反面";
    backLab.textColor = LabelShallowColor;
    backLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(12)];
    [self.view addSubview:backLab];
    [backLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImage.mas_bottom).offset(AdaptationWidth(13));
        make.left.mas_equalTo(backImage);
    }];
    
    UIButton *autBtn = [[UIButton alloc]init];
    [autBtn setBorderWidth:1 andColor:AppMainColor];
    [autBtn setCornerValue:AdaptationWidth(22)];
    [autBtn setTitle:@"开始认证" forState:UIControlStateNormal];
    [autBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
    [autBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:autBtn];
    [autBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(AdaptationWidth(-85));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(250));
    }];
}

-(void)launchUDSDKWithDictionary:(NSDictionary *)dict{
    
        UDIDSafeAuthEngine * engine = [[UDIDSafeAuthEngine alloc]init];
        engine.delegate = self;
        //秘钥
        engine.authKey = [dict objectForKey:@"authKey"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"authKey"]] : @"";;
        // 订单号
        engine.outOrderId = [dict objectForKey:@"partnerOrderId"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"partnerOrderId"]] : @"";
        //回调地址
        engine.notificationUrl =[dict objectForKey:@"notifyUrl"] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"notifyUrl"]] : @"";
        engine.showInfo = YES;
        //需要传入当前的 UIViewController
        [engine startIdSafeWithUserName:@"" IdentityNumber:@"" InViewController:self];
    
    
}
- (void)idSafeAuthFinishedWithResult:(UDIDSafeAuthResult)result UserInfo:(id)userInfo{
    MyLog(@"Finish");
    MyLog(@"result-->%lu",(unsigned long)result);
    MyLog(@"userinfo-->%@",userInfo);


    if (result == UDIDSafeAuthResult_Done) {
        NSString *auth = [userInfo objectForKey:@"result_auth"];
        if ([auth isEqualToString:@"F"]) {
            [self setHudWithName:@"身份认证失败，请重新认证！" Time:1.0 andType:0];
            return;
        }
        NSNumber *score =  self.dataDic[@"score"];
        NSNumber *idcard = [userInfo objectForKey:@"be_idcard"];
        if ([idcard doubleValue] >= [score doubleValue] ) {
            
            self.identifyModel = [IdentifyModel mj_objectWithKeyValues:userInfo];
            [self prepareDataWithCount:IdentityRequestPostInfo];
        }else{
            [self setHudWithName:@"身份认证失败，请重新认证！" Time:1.0 andType:0];
        }


    }else{
        [self setHudWithName:@"身份认证失败，请重新认证！" Time:1.0 andType:0];
    }
}
- (void)btnOnClick:(UIButton *)btn{
    if (self.redCode.integerValue == 1002) {
        [XAlertView alertWithTitle:@"通知" message:@"个人信息异常，暂时无法认证。" cancelButtonTitle:nil confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
            
        }];
        return;
    }
    [self prepareDataWithCount:IdentityRequestGetInfo];
}
-(void)BarbuttonClick:(UIButton *)button{
    if (self.isFromVC.integerValue) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
#pragma mark - network
- (void)setRequestParams{
    switch (self.requestCount) {
        case IdentityRequestGetInfo:
            self.cmd = XGetIdentityVerify;
            self.dict = [NSDictionary dictionary];
            break;
        case IdentityRequestPostInfo:
            self.cmd = XPostIdentityVerify;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.identifyModel.id_no,@"idCardNo",self.identifyModel.flag_sex,@"sex",self.identifyModel.id_name,@"trueName", nil];
            break;
        case IdentityRequestGet:{
            self.cmd = XGetIdentityInfo;
            self.dict = [NSDictionary dictionary];
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case IdentityRequestGetInfo:
            self.dataDic = [NSDictionary dictionaryWithDictionary:response.data];
             [self launchUDSDKWithDictionary:response.data];
            break;
        case IdentityRequestPostInfo:{
            [self setHudWithName:@"身份证认证成功" Time:0.5 andType:3];
            if (self.isFromVC.integerValue) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            ContactViewController *vc = [[ContactViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case IdentityRequestGet:{
            self.userDic = [NSDictionary dictionaryWithDictionary:response.data];
                [self overUI];
            
        }
            break;
        default:
            break;
    }
}
-(void)requestFaildWithDictionary:(XResponse *)response{
    if (response.rspCode.integerValue == 1002 && self.requestCount == IdentityRequestPostInfo) {
        self.redCode = @(1002);
        [XAlertView alertWithTitle:@"通知" message:@"个人信息异常，暂时无法认证。" cancelButtonTitle:nil confirmButtonTitle:@"确定" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
            
        }];
        return;
    }
    [self setHudWithName:response.rspMsg Time:2 andType:1];
}
- (IdentifyModel *)identifyModel{
    if (!_identifyModel) {
        _identifyModel = [[IdentifyModel alloc]init];
    }
    return _identifyModel;
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
