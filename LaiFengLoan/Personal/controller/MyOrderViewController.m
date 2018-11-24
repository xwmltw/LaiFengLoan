//
//  MyOrderViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderDetailVC.h"
#import "MyOrderCntModel.h"
@interface MyOrderViewController ()
@property (nonatomic, strong) MyOrderCntModel *myOrderCntModel;
@end

@implementation MyOrderViewController
static NSString *identifier = @"myDataCell";

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
    self.title = @"我的订单";
    [self initUI];
    [self prepareDataWithCount:0];
}
- (void)initUI{
    [self createTableViewWithFrame:CGRectZero];
//    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"personal_headbg"]];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 53;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *image = [[UIImageView alloc]init];
        [cell.contentView addSubview:image];
        
        UILabel *nameLab = [[UILabel alloc]init];
        nameLab.textAlignment = NSTextAlignmentCenter;
        [nameLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(18)]];
        [nameLab setTextColor:LabelMainColor];
        [cell.contentView addSubview:nameLab];
        
        UILabel *numLab = [[UILabel alloc]init];
        [numLab setCornerValue:AdaptationWidth(9)];
        numLab.textAlignment = NSTextAlignmentCenter;
        [numLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(12)]];
        [numLab setTextColor:[UIColor whiteColor]];
        [numLab setBackgroundColor:XColorWithRGB(251, 86, 10)];
        [cell.contentView addSubview:numLab];
     
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell);
            make.left.mas_equalTo(cell).offset(AdaptationWidth(30));
        }];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell);
            make.left.mas_equalTo(image.mas_right).offset(AdaptationWidth(8));
        }];
        
        [numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell);
            make.right.mas_equalTo(cell).offset(AdaptationWidth(-62));
            make.width.height.mas_equalTo(AdaptationWidth(18));
        }];
        
        
        
//    }
    switch (indexPath.row) {
        case 1:
            nameLab.text = @"审核中";
            image.image = [UIImage imageNamed:@"审核中"];
            if (self.myOrderCntModel.auditOrderCnt.integerValue) {
                numLab.text = self.myOrderCntModel.auditOrderCnt.description;
            }else{
                numLab.hidden = YES;
            }
            
            break;
        case 2:
            nameLab.text = @"待放款";
            image.image = [UIImage imageNamed:@"待放款"];
            if (self.myOrderCntModel.waitPayOrderCnt.integerValue) {
                numLab.text = self.myOrderCntModel.waitPayOrderCnt.description;
            }else{
                numLab.hidden = YES;
            }
            break;
        case 0:
            nameLab.text = @"待还款";
            image.image = [UIImage imageNamed:@"待还款"];
 
            if (self.myOrderCntModel.waitRepayOrderCnt.integerValue) {
                numLab.text = self.myOrderCntModel.waitRepayOrderCnt.description;
            }else{
                numLab.hidden = YES;
            }
            break;
        case 3:
            nameLab.text = @"已结清";
            image.image = [UIImage imageNamed:@"已结清"];
        
            if (self.myOrderCntModel.completedOrderCnt.integerValue) {
                numLab.text = self.myOrderCntModel.completedOrderCnt.description;
            }else{
                numLab.hidden = YES;
            }
            break;
        case 4:
            numLab.hidden = YES;
            nameLab.text = @"已拒绝";
            image.image = [UIImage imageNamed:@"已拒绝"];
            
            break;
        case 5:
            numLab.hidden = YES;
            nameLab.text = @"已关闭";
            image.image = [UIImage imageNamed:@"已关闭"];
            break;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyOrderDetailVC *vc = [[MyOrderDetailVC alloc]init];
    switch (indexPath.row) {
        case 1:
            vc.title = @"审核中";
            vc.orderState = MyOrderStateAuditing;
            break;
        case 2:
            vc.title = @"待放款";
            vc.orderState = MyOrderStatePendPay;
            break;
        case 0:
            vc.title = @"待还款";
            vc.orderState = MyOrderStateCleared;
            break;
        case 3:
            vc.title = @"已结清";
            vc.orderState = MyOrderStateRefuse;
            break;
        case 4:
            vc.title = @"已拒绝";
            vc.orderState = MyOrderStatePendMoney;
            break;
        case 5:
            vc.title = @"已关闭";
            vc.orderState = MyOrderStateClose;
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setRequestParams{
    self.cmd = XGetOrderCntInf;
    self.dict = [NSDictionary dictionary];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.myOrderCntModel = [MyOrderCntModel mj_objectWithKeyValues:response.data];
    [self.tableView reloadData];
}
- (MyOrderCntModel *)myOrderCntModel{
    if (!_myOrderCntModel) {
        _myOrderCntModel = [[MyOrderCntModel alloc]init];
    }
    return _myOrderCntModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)headerRefresh{
    [self prepareDataWithCount:0];
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
