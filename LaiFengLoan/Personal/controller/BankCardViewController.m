//
//  BankCardViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/15.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "BankCardViewController.h"
#import "BankViewController.h"

@interface BankCardViewController ()

@end

@implementation BankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡列表";
    [self prepareDataWithCount:0];
    
}
- (void)initUI{
    UIView *view = [UIView gradientViewWithColors:@[XColorWithRGB(129, 178, 255),XColorWithRGB(56, 123, 230)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [view setCornerValue:15];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(20));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(339));
        make.height.mas_equalTo(AdaptationWidth(171));
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:self.dataSourceArr[0][@"bankLogo"]];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(25));
        make.left.mas_equalTo(view).offset(AdaptationWidth(23));
        make.width.height.mas_equalTo(AdaptationWidth(20));
    }];
    
    UILabel *bankName = [[UILabel alloc] init];
    bankName.text = self.dataSourceArr[0][@"bankName"];
    bankName.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    bankName.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
    [view addSubview:bankName];
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView);
        make.left.mas_equalTo(imageView.mas_right).offset(2);
    }];
    
    UILabel *bankCard = [[UILabel alloc] init];
    bankCard.text = self.dataSourceArr[0][@"bankCardNo"];
    bankCard.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    bankCard.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(26)];
    [view addSubview:bankCard];
    [bankCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView);
        make.centerY.mas_equalTo(view);
    }];
    
    UIButton *reviseBtn = [[UIButton alloc]init];
    [reviseBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [reviseBtn setTitle:@"修改" forState:UIControlStateNormal];
    [reviseBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
    [reviseBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    [self.view addSubview:reviseBtn];
    [reviseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view);
        make.top.mas_equalTo(view.mas_bottom).offset(AdaptationWidth(12));
    }];
}
- (void)btnOnClick:(UIButton *)btn{
    BankViewController *vc = [[BankViewController alloc]init];
    vc.creditInfoModel = self.creditInfoModel;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setRequestParams{
    self.cmd = XGetUserBankList;
    self.dict = [NSDictionary dictionary];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.dataSourceArr = response.data[@"dataRows"];
    if (self.dataSourceArr.count) {
        [self initUI];
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
