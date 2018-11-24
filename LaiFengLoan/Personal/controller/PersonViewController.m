//
//  PersonViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/3.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "PersonViewController.h"
#import "MyOrderViewController.h"
#import "BankCardViewController.h"
#import "BankViewController.h"
#import "AboutUsViewController.h"
#import "FeedbackViewController.h"
#import "ModifyPwdViewController.h"
#import "LoginViewController.h"
#import "XCacheHelper.h"
#import "QUestionsViewController.h"
#import "MyDataVC.h"
#import "MyOrderDetailVC.h"
typedef NS_ENUM(NSInteger,PersonalBtnTag) {
    PersonalBtnTagBack = 400,
    PersonalBtnTagLogin,
    PersonalBtnTagMyData,
    PersonalBtnTagMyOrder,
    PersonalBtnTagQuickPay,
    PersonalBtnTagBank,
    PersonalBtnTagGetOut,
};
typedef NS_ENUM(NSInteger, PersonalRequest) {
    PersonalRequestLogout,
    PersonalRequestcredit,
    PersonalRequestBank,
};
@interface PersonViewController ()
@property (nonatomic , strong) NSMutableArray *sectionArry;
@property (nonatomic, strong) NSArray *cellTitleAry;
@property (nonatomic, strong) NSMutableArray *btnAry;
@end

@implementation PersonViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    if ([[UserInfo sharedInstance]isSignIn]) {
         [self prepareDataWithCount:PersonalRequestcredit];
        self.tableView.tableFooterView = [self createFooterView];
    }else{
        self.tableView.tableFooterView = nil;
        self.tableView.tableHeaderView = [self createHeaderView];
        [self.tableView reloadData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setData];
    
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.tableHeaderView = [self createHeaderView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}
- (void)setData{
    self.cellTitleAry = [NSArray arrayWithObjects:@"修改密码",@"常见问题",@"意见反馈",@"关于我们",@"联系客服", nil];
//    self.btnAry = [NSMutableArray arrayWithObjects:@(PersonalBtnTagMyData),@(PersonalBtnTagMyOrder),@(PersonalBtnTagQuickPay),@(PersonalBtnTagBank), nil];
    self.btnAry = [NSMutableArray array];
    [self.btnAry addObject:@(PersonalBtnTagMyData)];
     [self.btnAry addObject:@(PersonalBtnTagMyOrder)];
     [self.btnAry addObject:@(PersonalBtnTagQuickPay)];
     [self.btnAry addObject:@(PersonalBtnTagBank)];

    
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{

    return YES;
}

- (UIView *)createHeaderView{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *blueView = [UIView gradientViewWithColors:@[XColorWithRGB(129, 178, 255),XColorWithRGB(56, 123, 230)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    blueView.frame = CGRectMake(0, 0, self.tableView.width, AdaptationWidth(260));
    [view addSubview:blueView];

    UIView *whileView = [[UIView alloc]init];
    whileView.backgroundColor = [UIColor whiteColor];
    [view addSubview:whileView];

    if ([[UserInfo sharedInstance]isSignIn]) {
        view.frame = CGRectMake(0, 0, self.tableView.width, AdaptationWidth(340));
        [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(view);
            make.height.mas_equalTo(AdaptationWidth(260));
        }];
        [whileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(view);
            make.height.mas_equalTo(AdaptationWidth(80));
        }];
    }else{
        view.frame = CGRectMake(0, 0, self.tableView.width, AdaptationWidth(260));
        [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(view);
            make.height.mas_equalTo(AdaptationWidth(220));
        }];
        [whileView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(view);
            make.height.mas_equalTo(AdaptationWidth(40));
        }];
        
    
    }
    
    UIButton *backBtn =[[UIButton alloc]init];
    backBtn.tag = PersonalBtnTagBack;
    [backBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"btn_whiteBack"] forState:UIControlStateNormal];
    [view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(10);
        make.top.mas_equalTo(view).offset(32);
        make.width.height.mas_equalTo(AdaptationWidth(40));
    }];
    
    UIButton *loginBtn =[[UIButton alloc]init];
    loginBtn.tag = PersonalBtnTagLogin;
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(20)]];
    [loginBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.top.mas_equalTo(view).offset(AdaptationWidth(81));
        make.width.mas_equalTo(AdaptationWidth(79));
        make.height.mas_equalTo(AdaptationWidth(35));
    }];
    
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [view addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(AdaptationWidth(5));
    }];
    
    if ([[UserInfo sharedInstance]isSignIn]) {
        nameLab.text = [[UserInfo sharedInstance].getUserInfo.phoneName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        [loginBtn setTitle:self.creditInfoModel.trueName.length ? self.creditInfoModel.trueName : @"你好" forState:UIControlStateNormal];
    }else{
        [loginBtn setBorderWidth:1 andColor:[UIColor whiteColor]];
        [loginBtn setCornerValue:4];
        [loginBtn setTitle:@"请登录" forState:UIControlStateNormal];
    }
    
    UIImageView *dataImage = [[UIImageView alloc]init];
    dataImage.userInteractionEnabled = YES;
    [dataImage setImage:[UIImage imageNamed:@"personal_headbg"]];
    [view addSubview:dataImage];
    if ([[UserInfo sharedInstance]isSignIn]) {
        UILabel *creditMoney = [[UILabel alloc] init];
        creditMoney.text = self.creditInfoModel.creditAmt.description.length ?  self.creditInfoModel.creditAmt.description : @"0";
        creditMoney.textColor = XColorWithRGB(250, 131, 67);
        creditMoney.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(25)];
        [dataImage addSubview:creditMoney];
        [creditMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(dataImage).multipliedBy(0.5);
            make.top.mas_equalTo(dataImage).offset(AdaptationWidth(21));
        }];
        
        UILabel *creditLab = [[UILabel alloc] init];
        creditLab.text = @"授信总额";
        creditLab.textColor = LabelMainColor;
        creditLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
        [dataImage addSubview:creditLab];
        [creditLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(creditMoney);
            make.top.mas_equalTo(creditMoney.mas_bottom).offset(AdaptationWidth(4));
        }];
        
        UILabel *amtMoney = [[UILabel alloc] init];
        amtMoney.text = self.creditInfoModel.useAmt.description.length ? self.creditInfoModel.useAmt.description : @"0";
        amtMoney.textColor = XColorWithRGB(250, 131, 67);
        amtMoney.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(25)];
        [dataImage addSubview:amtMoney];
        [amtMoney mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(dataImage).multipliedBy(1.5);
            make.top.mas_equalTo(dataImage).offset(AdaptationWidth(21));
        }];
        
        UILabel *amtLab = [[UILabel alloc] init];
        amtLab.text = @"可用额度";
        amtLab.textColor = LabelMainColor;
        amtLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
        [dataImage addSubview:amtLab];
        [amtLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(amtMoney);
            make.top.mas_equalTo(amtMoney.mas_bottom).offset(AdaptationWidth(4));
        }];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LineColor;
        [dataImage addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(dataImage);
            make.width.mas_equalTo(AdaptationWidth(310));
            make.height.mas_equalTo(AdaptationWidth(1));
            make.top.mas_equalTo(amtLab.mas_bottom).offset(AdaptationWidth(8));
        }];
        
        [dataImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(view);
            make.height.mas_equalTo(AdaptationWidth(195));
        }];
        
    }else{
        [dataImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(view);
            make.height.mas_equalTo(AdaptationWidth(130));

        }];
    }

    
    NSArray *titleAry = @[@"我的资料",@"我的订单",@"快速还款",@"银行卡"];
    NSArray *imageAry = @[@"personal_mydata",@"personal_myorder",@"personal_pay",@"personal_bank"];
    for (int i =0; i< 4; i++) {
//        UIButton *dataBtn = [[UIButton alloc]initWithFrame:CGRectMake(AdaptationWidth(22)+((ScreenWidth-44)/4*i), AdaptationWidth(30), (ScreenWidth-44)/4, AdaptationWidth(80))];
        UIButton *dataBtn = [[UIButton alloc]init];
        dataBtn.tag = [self.btnAry[i] integerValue];
        [dataBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        [dataBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [dataBtn setImage:[UIImage imageNamed:imageAry[i]] forState:UIControlStateNormal];
        [dataBtn setTitle:titleAry[i] forState:UIControlStateNormal];
        [dataBtn setTitleColor:LabelMainColor forState:UIControlStateNormal];
        CGSize imageSize = dataBtn.currentImage.size;
        dataBtn.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height+8, -imageSize.width, 0, 0);
        dataBtn.imageEdgeInsets = UIEdgeInsetsMake(-20, 15, 8,0 );
        [dataImage addSubview:dataBtn];
        [dataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dataImage).offset(AdaptationWidth(22)+((ScreenWidth-44)/4*i));
            make.bottom.mas_equalTo(dataImage).offset(AdaptationWidth(-25));
            make.width.mas_equalTo((ScreenWidth-44)/4);
            make.height.mas_equalTo(AdaptationWidth(70));
        }];

    }

    return view;
}
- (UIView *)createFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(60))];
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"personal_headbg"];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(10);
        make.left.right.bottom.mas_equalTo(view);
    }];

    UIButton *btn = [[UIButton alloc]init];
    btn.tag = PersonalBtnTagGetOut;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"退出账号" forState:UIControlStateNormal];
    [btn setTitleColor:LabelMainColor forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(10);
        make.left.right.bottom.mas_equalTo(view);
    }];
    
    return view;
}
#pragma  mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cellTitleAry.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(48);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if ([[UserInfo sharedInstance]isSignIn]) {
//        return AdaptationWidth(105);
//    }
//    return AdaptationWidth(40);
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PersonalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        cell.textLabel.text = self.cellTitleAry[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LineColor;
        [cell.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell).offset(AdaptationWidth(15));
            make.right.mas_equalTo(cell).offset(AdaptationWidth(-15));
            make.bottom.mas_equalTo(cell);
            make.height.mas_equalTo(0.5);
        }];
        
        if (indexPath.row == 4) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *cantactLab = [[UILabel alloc]init];
            [cantactLab setText:self.clientGlobalInfo.customerContact];
            [cantactLab setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
            [cell.contentView addSubview:cantactLab];
            [cantactLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.textLabel);
                make.right.mas_equalTo(cell).offset(AdaptationWidth(-18));
            }];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            ModifyPwdViewController *vc = [[ModifyPwdViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            QUestionsViewController *vc = [[QUestionsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            FeedbackViewController *vc = [[FeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            AboutUsViewController *vc = [[AboutUsViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{
            [self setHudWithName:@"复制成功" Time:1.5 andType:1];
            UIPasteboard *pasterd = [UIPasteboard generalPasteboard];
            pasterd.string = self.clientGlobalInfo.customerContact;
            
        }
            break;
        default:
            break;
    }
//    MyOrderViewController *vc = [[MyOrderViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark - btn
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case PersonalBtnTagLogin:{

            if (![[UserInfo sharedInstance]isSignIn]) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case PersonalBtnTagBack:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case PersonalBtnTagMyData:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            MyDataVC *vc = [[MyDataVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PersonalBtnTagMyOrder:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            MyOrderViewController *vc = [[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PersonalBtnTagQuickPay:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            if (self.creditInfoModel.waitPayAmt.doubleValue) {
                MyOrderDetailVC *vc = [[MyOrderDetailVC alloc]init];
                vc.title = @"待还款";
                vc.orderState = MyOrderStateCleared;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
            [self setHudWithName:@"暂时未有需要还款的订单" Time:1.5 andType:1];
        }
            break;
        case PersonalBtnTagBank:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
            [self prepareDataWithCount:PersonalRequestBank];
            
        }
            break;
        case PersonalBtnTagGetOut:{
            if (![[UserInfo sharedInstance]isSignIn]) {
                [self getBlackLogin:self];
            }
//            BankCardViewController *vc = [[BankCardViewController alloc]init];
//            vc.creditInfoModel = self.creditInfoModel;
//            [self.navigationController pushViewController:vc animated:YES];
            [self prepareDataWithCount:PersonalRequestLogout];
        }
            break;
        default:
            break;
    }
}
- (void)setRequestParams{
    switch (self.requestCount) {
        case PersonalRequestLogout:
            self.cmd = XUserlogout;
            self.dict = [NSDictionary dictionary];
            break;
        case PersonalRequestcredit:{
            self.cmd = XGetCreditInfoVerify;
            self.dict = [NSDictionary dictionary];
        }
            break;
        case PersonalRequestBank:{
            self.cmd = XGetUserBankList;
            self.dict = [NSDictionary dictionary];
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case PersonalRequestLogout:
        {
            [self setHudWithName:@"退出成功" Time:1 andType:3];
            [XCacheHelper clearCacheFolder];
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case PersonalRequestcredit:{
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.data];
            self.tableView.tableHeaderView = [self createHeaderView];
            
            [self.tableView reloadData];
        }
            break;
        case PersonalRequestBank:{
            self.dataSourceArr = response.data[@"dataRows"];
            if (self.creditInfoModel.scheduleStatus.integerValue > 1) {
                if (self.dataSourceArr.count) {
                    BankCardViewController *vc = [[BankCardViewController alloc]init];
                    vc.creditInfoModel = self.creditInfoModel;
                    [self.navigationController pushViewController:vc animated:YES];
                    return;
                }
                BankViewController *vc = [[BankViewController alloc]init];
                vc.creditInfoModel = self.creditInfoModel;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self setHudWithName:@"请先进行身份证认证" Time:1.5 andType:1];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - 懒加载
-(NSMutableArray *)sectionArry{
    if (!_sectionArry) {
        _sectionArry = [NSMutableArray array];
    }
    return _sectionArry;
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
