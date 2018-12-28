//
//  LoanOrderDetailVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/15.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "LoanOrderDetailVC.h"
#import "OrderPreviewModel.h"
#import "XAlertView.h"
#import "MyOrderFlowVC.h"
#import "XRootWebVC.h"
#import "CreditInfoModel.h"
typedef NS_ENUM(NSInteger ,LoanOrderRequest) {
    LoanOrderRequestPreview,
    LoanOrderRequestPost,
    LoanOrderRequestPostNocredit,
    LoanOrderRequestGetCredit,
};
@interface LoanOrderDetailVC ()
@property (nonatomic ,strong) OrderPreviewModel *orderPreviewModel;
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end

@implementation LoanOrderDetailVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = AppMainColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName :[UIFont systemFontOfSize:AdaptationWidth(17)]}];
}
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_whiteBack"]];
    imageV.frame = CGRectMake(0, 8, 12, 22);
    imageV.userInteractionEnabled = YES;
    [view addSubview:imageV];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 64, 44);
    button.tag = 9999;
    [button addTarget:self action:@selector(BarbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单确认";
    [self prepareDataWithCount:LoanOrderRequestPreview];
    
}
- (void)initUI{
    UILabel *orderID = [[UILabel alloc]init];
    [orderID setText:[NSString stringWithFormat:@"订单编号：  %@",self.orderPreviewModel.orderNo]];
    [orderID setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [orderID setTextColor:LabelAssistantColor];
    [self.view addSubview:orderID];
    [orderID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(18));
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(18));
    }];
    
    UILabel *loanMoney = [[UILabel alloc]init];
    [loanMoney setText:[NSString stringWithFormat:@"借款金额：  %@",self.orderPreviewModel.orderAmt.description]];
    [loanMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanMoney setTextColor:LabelAssistantColor];
    [self.view addSubview:loanMoney];
    [loanMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderID.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(orderID);
    }];
    
    UILabel *loanDate = [[UILabel alloc]init];
    [loanDate setText:[NSString stringWithFormat:@"借款期限：  %@",self.orderPreviewModel.stageTimeunitCnt]];
    [loanDate setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanDate setTextColor:LabelAssistantColor];
    [self.view addSubview:loanDate];
    [loanDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loanMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(loanMoney);
    }];
    
    UILabel * upMoney = [[UILabel alloc]init];
    [upMoney setText:[NSString stringWithFormat:@"到账金额：  %@",self.orderPreviewModel.syspayAmt.description]];
    [upMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [upMoney setTextColor:LabelAssistantColor];
    [self.view addSubview:upMoney];
    [upMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loanDate.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(loanDate);
    }];
    
    UILabel *upCard = [[UILabel alloc]init];
    [upCard setText:[NSString stringWithFormat:@"到账卡号：  %@",self.orderPreviewModel.syspayBankCardNo]];
    [upCard setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [upCard setTextColor:LabelAssistantColor];
    [self.view addSubview:upCard];
    [upCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(upMoney);
    }];
    
    UILabel *repayMoney = [[UILabel alloc]init];
    [repayMoney setText:[NSString stringWithFormat:@"到期还款：  %@",[self decimalNumberWithDouble:self.orderPreviewModel.dueRepayAmt]]];
    [repayMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [repayMoney setTextColor:LabelAssistantColor];
    [self.view addSubview:repayMoney];
    [repayMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upCard.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(upCard);
    }];
    
    UILabel *repayDate = [[UILabel alloc]init];
    [repayDate setText:[NSString stringWithFormat:@"合同：        我已同意签订"]];
    [repayDate setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [repayDate setTextColor:LabelAssistantColor];
    [self.view addSubview:repayDate];
    [repayDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repayMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(repayMoney);
    }];
    
    UIButton *heTong = [[UIButton alloc]init];
    heTong.tag = 101;
    [heTong setTitleColor:AppMainColor forState:UIControlStateNormal];
    [heTong setTitle:[NSString stringWithFormat:@"《订单合同》"] forState:UIControlStateNormal];
    [heTong.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [heTong addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:heTong];
    [heTong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(repayDate);
        make.left.mas_equalTo(repayDate.mas_right).offset(AdaptationWidth(5));
    }];
    
    UIButton *selectBtn = [[UIButton alloc]init];
    selectBtn.tag = 102;
    [selectBtn setImage:[UIImage imageNamed:@"合同未打钩"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"合同打钩"] forState:UIControlStateSelected];
    [selectBtn setSelected:YES];
    [selectBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(repayDate);
        make.left.mas_equalTo(heTong.mas_right).offset(AdaptationWidth(3));
    }];
    
    
    UIButton *sureBtn = [[UIButton alloc]init];
    sureBtn.tag = 103;
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setCornerValue:AdaptationWidth(22)];
    [sureBtn setTitle:@"已阅读合同与协议，申请提现" forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(17)]];
    [sureBtn setBackgroundColor:AppMainColor];
    [sureBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(repayDate.mas_bottom).offset(AdaptationWidth(126));
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(290));
    }];
}
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
            XRootWebVC *vc = [[XRootWebVC alloc]init];
            vc.url = self.orderPreviewModel.eleContractPreviewUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 102:
            btn.selected = !btn.selected;
            break;
        case 103:{
            UIButton *selectbtn = (UIButton *) [self.view viewWithTag:102];
            if (selectbtn.selected != YES) {
                [self setHudWithName:@"若无异议请先勾选合同" Time:1 andType:1];
                return;
            }
            [self prepareDataWithCount:LoanOrderRequestGetCredit];
           
        }
            break;
            
        default:
            break;
    }
}
- (void)setRequestParams{
    switch (self.requestCount) {
        case LoanOrderRequestPreview:
            self.cmd = XGetPreviewOrder;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.orderAmt,@"orderAmt",self.stageTimeunitCnt,@"stageTimeunitCnt", nil];
            
            break;
        case LoanOrderRequestPost:
            self.cmd = XPostConfirmOrder;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.orderPreviewModel.orderAmt,@"orderAmt",self.orderPreviewModel.orderNo,@"orderNo",self.orderPreviewModel.stageTimeunitCnt,@"stageTimeunitCnt", nil];
            break;
        case LoanOrderRequestGetCredit:{
            self.cmd = XGetCreditInfoVerify;
            self.dict = [NSDictionary dictionary];
        }
            break;
        case LoanOrderRequestPostNocredit:{
            self.cmd = XPostConfirmOrderNocredit;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.orderPreviewModel.orderAmt,@"orderAmt",self.orderPreviewModel.orderNo,@"orderNo",self.orderPreviewModel.stageTimeunitCnt,@"stageTimeunitCnt", nil];
        }
            break;
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case LoanOrderRequestPreview:
            self.orderPreviewModel = [OrderPreviewModel mj_objectWithKeyValues:response.data];
            [self initUI];
            break;
        case LoanOrderRequestPost:
        {
            [XAlertView alertWithTitle:@"通知" message:@"您的提现申请已收到，审核通过后我们会尽快为您放款。" cancelButtonTitle:@"返回首页" confirmButtonTitle:@"查看订单" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    MyOrderFlowVC *vc = [[MyOrderFlowVC alloc]init];
                    vc.orderNo = self.orderPreviewModel.orderNo;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
            break;
        case LoanOrderRequestGetCredit:{
            self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.data];
            if (self.creditInfoModel.creditStatus.integerValue == 2) {
                [self prepareDataWithCount:LoanOrderRequestPost];
            }else{
                [self prepareDataWithCount:LoanOrderRequestPostNocredit];
            }
        }
            break;
        case LoanOrderRequestPostNocredit:{
            
        }
            break;
        default:
            break;
    }
}
- (OrderPreviewModel *)orderPreviewModel{
    if (!_orderPreviewModel) {
        _orderPreviewModel = [[OrderPreviewModel alloc]init];
    }
    return _orderPreviewModel;
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
