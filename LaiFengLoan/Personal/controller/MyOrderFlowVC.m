//
//  MyOrderFlowVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyOrderFlowVC.h"
#import "MyOrderFlowTableViewCell.h"
#import "OrderDetailModel.h"
#import "XRootWebVC.h"
#import "DateHelper.h"
#import "PayAlertView.h"
#import <AlipaySDK/AlipaySDK.h>

typedef NS_ENUM(NSInteger ,MyOrderFlowRequset) {
    MyOrderFlowRequsetGetInfo,
    MyOrderFlowRequsetPay,
};

@interface MyOrderFlowVC ()<PayAlertBtnDelegate>
@property (nonatomic ,strong) OrderDetailModel *orderDetailModel;
@property (nonatomic ,strong) UIView *bgView;
@end

@implementation MyOrderFlowVC
{
    PayAlertView *alert;
    NSNumber *repayType;
    UIButton *autBtn;
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    [self prepareDataWithCount:MyOrderFlowRequsetGetInfo];
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(40), AdaptationWidth(40))];
    [rightBtn setTitle:@"合同" forState:UIControlStateNormal];
    rightBtn.tag = 102;
    [rightBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
     [XNotificationCenter addObserver:self selector:@selector(AlipayNotification:) name:XAliPaySucceed object:nil];
    
}
- (UIView *)creatHeadView{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(322));
    
    UILabel *orderID = [[UILabel alloc]init];
    [orderID setText:[NSString stringWithFormat:@"订单编号：  %@",self.orderDetailModel.orderNo]];
    [orderID setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [orderID setTextColor:LabelAssistantColor];
    [view addSubview:orderID];
    [orderID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).offset(AdaptationWidth(18));
        make.left.mas_equalTo(view).offset(AdaptationWidth(18));
    }];
    
    UILabel *loanMoney = [[UILabel alloc]init];
    [loanMoney setText:[NSString stringWithFormat:@"借款金额：  %@元",self.orderDetailModel.orderAmt.description]];
    [loanMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanMoney setTextColor:LabelAssistantColor];
    [view addSubview:loanMoney];
    [loanMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderID.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(orderID);
    }];
    
    UILabel *loanDate = [[UILabel alloc]init];
    [loanDate setText:[NSString stringWithFormat:@"借款期限：  %@天",self.orderDetailModel.stageTimeunitCnt.description]];
    [loanDate setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanDate setTextColor:LabelAssistantColor];
    [view addSubview:loanDate];
    [loanDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loanMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(loanMoney);
    }];
    
    UILabel * upMoney = [[UILabel alloc]init];
    [upMoney setText:[NSString stringWithFormat:@"到账金额：  %.2f元",self.orderDetailModel.syspayAmt.doubleValue]];
    [upMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [upMoney setTextColor:LabelAssistantColor];
    [view addSubview:upMoney];
    [upMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loanDate.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(loanDate);
    }];
    
    UILabel *upCard = [[UILabel alloc]init];
    [upCard setText:[NSString stringWithFormat:@"到账卡号： %@",self.orderDetailModel.syspayBankCardNo]];
    [upCard setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [upCard setTextColor:LabelAssistantColor];
    [view addSubview:upCard];
    [upCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(upMoney);
    }];
    
    UILabel *repayMoney = [[UILabel alloc]init];
//    MyLog(@"%@",self.orderDetailModel.dueRepayAmt.description);
    [repayMoney setText:[NSString stringWithFormat:@"到期还款：  %.2f元",[self decimalNumberWithDouble:self.orderDetailModel.dueRepayAmt].doubleValue]];
    [repayMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [repayMoney setTextColor:LabelAssistantColor];
    [view addSubview:repayMoney];
    [repayMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(upCard.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(upCard);
    }];
    
    UILabel *repayDate = [[UILabel alloc]init];
    [repayDate setText:[NSString stringWithFormat:@"还款日期：  %@", [DateHelper getDateFromTimeNumber:self.orderDetailModel.dueRepayDate withFormat:@"yyyy-M-d"]]];
    [repayDate setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [repayDate setTextColor:LabelAssistantColor];
    [view addSubview:repayDate];
    [repayDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repayMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(repayMoney);
    }];
    
    if (self.orderDetailModel.overDueDays.integerValue) {
        UILabel *overDueDays = [[UILabel alloc]init];
        [overDueDays setText:[NSString stringWithFormat:@"已逾期%@天",self.orderDetailModel.overDueDays.description]];
//        [overDueDays setText:[NSString stringWithFormat:@"已逾期2天"]];
        [overDueDays setFont:[UIFont systemFontOfSize:AdaptationWidth(12)]];
        [overDueDays setTextColor:XColorWithRGB(255, 70, 70)];
        [overDueDays setBackgroundColor:XColorWithRGB(255, 238, 238)];
        [view addSubview:overDueDays];
        [overDueDays mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(repayDate);
            make.left.mas_equalTo(repayDate.mas_right).offset(10);
        }];
    }

    UILabel *breakMoney = [[UILabel alloc]init];
    [breakMoney setText:[NSString stringWithFormat:@"违约金额：  %.2f元",self.orderDetailModel.overDueAmt.doubleValue]];
    [breakMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [breakMoney setTextColor:LabelAssistantColor];
    [view addSubview:breakMoney];
    [breakMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repayDate.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(repayDate);
    }];
    
    UILabel *payMoney = [[UILabel alloc]init];
    [payMoney setText:[NSString stringWithFormat:@"应还总额：  %.2f元",[self decimalNumberWithDouble:self.orderDetailModel.repayAmt].doubleValue ]];
    [payMoney setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [payMoney setTextColor:LabelAssistantColor];
    [view addSubview:payMoney];
    [payMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(breakMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(breakMoney);
    }];
    
    UILabel *successDate = [[UILabel alloc]init];
    [successDate setText:[NSString stringWithFormat:@"还款成功时间：  %@",[DateHelper getDateFromTimeNumber:self.orderDetailModel.repayTime withFormat:@"yyyy-M-d"]]];
    [successDate setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [successDate setTextColor:LabelAssistantColor];
    [view addSubview:successDate];
    [successDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payMoney.mas_bottom).offset(AdaptationWidth(10));
        make.left.mas_equalTo(payMoney);
    }];
    
    
    switch (self.orderState) {
        case MyOrderStateAuditing:
        case MyOrderStatePendPay:
        case MyOrderStateClose:
        case MyOrderStatePendMoney:
        {
            repayDate.hidden = YES;
            breakMoney.hidden = YES;
            payMoney.hidden = YES;
            successDate.hidden = YES;
            view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(202));
        }
            break;
        case MyOrderStateCleared:
        {
            successDate.hidden = YES;
            view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(292));
        }
            break;
        case MyOrderStateRefuse:
        {
            view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(322));
        }
            break;
//        case MyOrderStatePendMoney:
//        {
//            [repayDate setText:[NSString stringWithFormat:@"订单进度：  20181111519000（合同号）"]];
//            breakMoney.hidden = YES;
//            payMoney.hidden = YES;
//            successDate.hidden = YES;
//            view.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(232));
//        }
//            break;
        
        default:
            break;
    }
    return view;
    
}
- (UIView *)creatFoooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(126))];
    autBtn = [[UIButton alloc]init];
    autBtn.tag = 101;
    
    [autBtn setCornerValue:AdaptationWidth(22)];
    if (self.orderDetailModel.repayStatus.integerValue == 4) {
        [autBtn setTitle:@"还款中" forState:UIControlStateNormal];
        [autBtn setBackgroundColor:LineColor];
        [autBtn setBorderWidth:1 andColor:LineColor];
        autBtn.enabled = NO;
    }else{
        autBtn.enabled = YES;
        [autBtn setTitle:@"立即还款" forState:UIControlStateNormal];
        [autBtn setBackgroundColor:AppMainColor];
        [autBtn setBorderWidth:1 andColor:AppMainColor];
    }
    [autBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:autBtn];
    [autBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(250));
    }];
    return view;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.orderDetailModel.orderNodeInfoList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LineColor;
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(view);
        make.height.mas_equalTo(0.5);
    }];
    
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellHead"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(18));
        make.centerY.mas_equalTo(view);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"订单进度";
    label.textColor = LabelAssistantColor;
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(14)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(image.mas_right).offset(4);
        make.centerY.mas_equalTo(image);
    }];
    
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OrderFlowCell";
    MyOrderFlowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderFlowTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dic = self.orderDetailModel.orderNodeInfoList[indexPath.row];
        cell.num = @(self.orderDetailModel.orderNodeInfoList.count);
        cell.row = @(indexPath.row);
        
    }
    return cell;
}
#pragma mark - 通知
- (void)AlipayNotification:(NSNotification *)notification{
    NSString *str = notification.userInfo[@"success"];
    if ([str isEqualToString:@"支付成功"]) {
        [self setHudWithName:@"支付成功" Time:2 andType:1];
        [self prepareDataWithCount:MyOrderFlowRequsetGetInfo];
        return;
    }
    [self setHudWithName:@"支付失败" Time:2 andType:1];
}
#pragma mark -btn
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
            self.bgView.hidden = NO;
        }
            break;
        case 102:
        {
             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.orderDetailModel.eleContractPreviewUrl]];

        }
            break;
        default:
            break;
    }
    
}


#pragma mark - alert delegate
- (void)payBtnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 601:
            self.bgView.hidden = YES;
            break;
        case 602:
        {
            if (btn.selected == NO) {
                btn.selected = YES;
                UIButton *zfb = (UIButton *)[self.view viewWithTag:603];
                zfb.selected = NO;
            }
        }
            break;
        case 603:
            if (btn.selected == NO) {
                btn.selected = YES;
                UIButton *bank = (UIButton *)[self.view viewWithTag:602];
                bank.selected = NO;
            }
            break;
        case 604:{
            UIButton *zfb = (UIButton *)[self.view viewWithTag:603];
            UIButton *bank = (UIButton *)[self.view viewWithTag:602];
            if (zfb.selected == NO && bank.selected == NO) {
                [self setHudWithName:@"请选择支付方式" Time:1.5 andType:1];
                return;
            }
            if (zfb.selected == YES) {
                repayType = @2;
            }else{
                repayType = @1;
            }
            [self prepareDataWithCount:MyOrderFlowRequsetPay];
            self.bgView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}
- (void)setRequestParams{
    switch (self.requestCount) {
        case MyOrderFlowRequsetGetInfo:
            self.cmd = XGetOrderDetail;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderNo", nil];
            break;
        case MyOrderFlowRequsetPay:{
            self.cmd = XRepayOrder;
            self.dict  = [NSDictionary dictionaryWithObjectsAndKeys:self.orderDetailModel.orderNo,@"orderNo",repayType,@"repayChnnlType",self.orderDetailModel.repayPlanId,@"repayPlanId", nil];
        }
            break;
        default:
            break;
    }
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case MyOrderFlowRequsetGetInfo:
            {
                self.orderDetailModel  = [OrderDetailModel mj_objectWithKeyValues:response.data];
                if (self.orderDetailModel.orderStatus.integerValue == 9) {
                    self.orderState = MyOrderStateCleared;
                }else if (self.orderDetailModel.orderStatus.integerValue == 99){
                    self.orderState = MyOrderStateRefuse;
                }else{
                    self.orderState = MyOrderStateAuditing;
                }
                
                self.tableView.tableHeaderView = [self creatHeadView];
                self.tableView.tableFooterView = nil;
                if (self.orderState == MyOrderStateCleared) {
                    
                    self.tableView.tableFooterView = [self creatFoooterView];
                }
                
                [self.tableView reloadData];
            }
            break;
        case MyOrderFlowRequsetPay:{
            if (repayType.integerValue == 2) {
                [[AlipaySDK defaultService]payOrder:response.data[@"prepayInf"] fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
                    NSString *stauts = resultDic[@"resultStatus"];
                    if ([stauts isEqualToString:@"9000"]) {
                        [self setHudWithName:@"支付成功" Time:2 andType:1];
                        
                        [self prepareDataWithCount:MyOrderFlowRequsetGetInfo];
                        
                        return;
                    }
                    
                    [self setHudWithName:@"支付失败" Time:2 andType:1];
                }];
                return;
            }
            
            [self setHudWithName:@"提交成功" Time:2 andType:1];
            [self prepareDataWithCount:MyOrderFlowRequsetGetInfo];
        }
            break;
        default:
            break;
    }
    
}
- (OrderDetailModel*)orderDetailModel{
    if (!_orderDetailModel) {
        _orderDetailModel = [[OrderDetailModel alloc]init];
    }
    return _orderDetailModel;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_bgView];
        _bgView.backgroundColor = XColorWithRBBA(34, 58, 80, 0.5);

        alert = [[PayAlertView alloc]initWithFrame:CGRectZero];
        alert.backgroundColor = [UIColor whiteColor];
        [alert setCornerValue:10];
        alert.delegate = self;
        [_bgView addSubview:alert];
        [alert mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_bgView);
            make.centerY.mas_equalTo(_bgView).offset(-30);
            make.width.mas_equalTo(270);
            make.height.mas_equalTo(193);
        }];
        
    }
    return _bgView;
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
