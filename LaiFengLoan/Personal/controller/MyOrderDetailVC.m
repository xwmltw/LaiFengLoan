//
//  MyOrderDetailVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyOrderDetailVC.h"
#import "MyOrderDetailTableViewCell.h"
#import "MyOrderFlowVC.h"
#import "PageQueryModel.h"
#import "PayAlertView.h"
#import <AlipaySDK/AlipaySDK.h>

typedef NS_ENUM(NSInteger ,MyOrderDetailRequest) {
    MyOrderDetailRequestList,
    MyOrderDetailRequestPay,
};
@interface MyOrderDetailVC ()<PayAlertBtnDelegate>
@property (nonatomic ,strong) PageQueryModel *pageQueryModel;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) OrderListModel *orderListModel;
@end

@implementation MyOrderDetailVC
{
    PayAlertView *alert;
    NSNumber *repayType;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = AppMainColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName :[UIFont systemFontOfSize:AdaptationWidth(17)]}];
    
    [self.dataSourceArr removeAllObjects];
    self.pageQueryModel.page = @(1);
    [self prepareDataWithCount:MyOrderDetailRequestList];
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

    [self initUI];
    
    
}
- (void)initUI{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    
}
- (UIView *)creatFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noOrder"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view).offset(-40);
        make.centerX.mas_equalTo(view);
    }];
    UILabel *lab = [[UILabel alloc]init];
    [lab setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    [lab setText:@"暂无订单消息~"];
    [lab setTextColor:LabelMainColor];
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(image.mas_bottom).offset(10);
        make.centerX.mas_equalTo(image);
    }];
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (self.orderState) {
        case MyOrderStateCleared:
            return 128;
            break;
            
        default:
            break;
    }
    return 108;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"PersonalCell";
    MyOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyOrderDetailTableViewCell" owner:nil options:nil].lastObject;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.orderState = self.orderState;
        cell.orderListModel = [OrderListModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
        cell.row = @(indexPath.row);
        WEAKSELF
//        [OrderListModel mj_objectWithKeyValues:self.dataSourceArr[0]];
        cell.block = ^(NSNumber *row) {
            weakSelf.bgView.hidden = NO;
            weakSelf.orderListModel = [OrderListModel mj_objectWithKeyValues:self.dataSourceArr[row.integerValue]];
        };
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyOrderFlowVC *vc = [[MyOrderFlowVC alloc]init];
    vc.orderNo = self.dataSourceArr[indexPath.row][@"orderNo"];
    vc.orderState = self.orderState;
    [self.navigationController pushViewController:vc animated:YES];
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
            [self prepareDataWithCount:MyOrderDetailRequestPay];
            self.bgView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - 通知
- (void)AlipayNotification:(NSNotification *)notification{
    NSString *str = notification.userInfo[@"success"];
    if ([str isEqualToString:@"支付成功"]) {
        [self setHudWithName:@"支付成功" Time:2 andType:1];
        [self.dataSourceArr removeAllObjects];
        self.pageQueryModel.page = @(1);
        [self prepareDataWithCount:MyOrderDetailRequestList];
        return;
    }
    [self setHudWithName:@"支付失败" Time:2 andType:1];
}
#pragma mark -network
- (void)setRequestParams{
    switch (self.requestCount) {
        case MyOrderDetailRequestList:
            self.cmd = XGetOrderList;
            self.dict = [NSDictionary dictionaryWithObjectsAndKeys:@(self.orderState),@"orderListType",[self.pageQueryModel mj_keyValues],@"pageQueryReq", nil];
            break;
        case MyOrderDetailRequestPay:{
            self.cmd = XRepayOrder;
            self.dict  = [NSDictionary dictionaryWithObjectsAndKeys:self.orderListModel.orderNo,@"orderNo",repayType,@"repayChnnlType",self.orderListModel.repayPlanId,@"repayPlanId", nil];
        }
            break;
        default:
            break;
    }
    
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case MyOrderDetailRequestList:
            [self.dataSourceArr addObjectsFromArray: response.data[@"dataRows"]];
            self.tableView.tableFooterView = nil;
            if (!self.dataSourceArr.count) {
                self.tableView.tableFooterView = [self creatFootView];
            }
            
            [self.tableView reloadData];
            break;
        case MyOrderDetailRequestPay:{
            if (repayType.integerValue == 2) {
                [[AlipaySDK defaultService]payOrder:response.data[@"prepayInf"] fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
                    NSString *stauts = resultDic[@"resultStatus"];
                    if ([stauts isEqualToString:@"9000"]) {
                        [self setHudWithName:@"支付成功" Time:2 andType:1];
                        [self.dataSourceArr removeAllObjects];
                        self.pageQueryModel.page = @(1);
                        [self prepareDataWithCount:MyOrderDetailRequestList];
                        
                        return;
                    }
                    
                    [self setHudWithName:@"支付失败" Time:2 andType:1];
                }];
                return;
            }
            [self setHudWithName:@"提交成功" Time:2 andType:1];
            [self.dataSourceArr removeAllObjects];
            self.pageQueryModel.page = @(1);
            [self prepareDataWithCount:MyOrderDetailRequestList];
        }
            break;
        default:
            break;
    }
   
}
- (PageQueryModel *)pageQueryModel{
    if (!_pageQueryModel) {
        _pageQueryModel = [[PageQueryModel alloc]init];
    }
    return _pageQueryModel;
}
- (OrderListModel *)orderListModel{
    if (!_orderListModel) {
        _orderListModel = [[OrderListModel alloc]init];
    }
    return _orderListModel;
}
- (UIView *)bgView{
    if (!_bgView) {
        [XNotificationCenter addObserver:self selector:@selector(AlipayNotification:) name:XAliPaySucceed object:nil];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_bgView];
        _bgView.backgroundColor = XColorWithRBBA(34, 58, 80, 0.5);
        
        alert = [[PayAlertView alloc]initWithFrame:CGRectZero];
        alert.backgroundColor = [UIColor whiteColor];
        [alert setCornerValue:10];
        alert.delegate = self;
        [_bgView addSubview:alert];
        NSArray *arry = [NSArray array];
        arry = [self.clientGlobalInfo.repaymentMethod componentsSeparatedByString:@","];
        if (arry.count == 1) {
            NSString *str = arry[0];
            if ([str isEqualToString:@"1"]) {
                alert.zfbBtn.hidden = YES;
                alert.zfbLab.hidden = YES;
                alert.zfbImage.hidden = YES;
            }else{
                alert.bankLab.hidden = YES;
                alert.bankImage.hidden = YES;
                alert.threeBtn.hidden = YES;
            }
            [alert mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bgView);
                make.centerY.mas_equalTo(_bgView).offset(-30);
                make.width.mas_equalTo(270);
                make.height.mas_equalTo(143);
            }];
        }else{
            [alert mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_bgView);
                make.centerY.mas_equalTo(_bgView).offset(-30);
                make.width.mas_equalTo(270);
                make.height.mas_equalTo(193);
            }];
        }
        
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)headerRefresh{
    [self.dataSourceArr removeAllObjects];
    self.pageQueryModel.page = @(1);
    [self prepareDataWithCount:MyOrderDetailRequestList];
}
- (void)footerRefresh{
    self.pageQueryModel.page = @(self.pageQueryModel.page.integerValue +1);
    [self prepareDataWithCount:MyOrderDetailRequestList];
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
