//
//  MyDataVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/12.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyDataVC.h"
#import "IdentityViewController.h"
#import "ContactViewController.h"
#import "BaseViewController.h"
#import "OperatorViewController.h"
@interface MyDataVC ()
@property (nonatomic ,strong) CreditInfoModel *creditInfoModel;
@end

@implementation MyDataVC
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self prepareDataWithCount:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资料";
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idefitier = @"MyDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idefitier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idefitier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] init];
        label.textColor = LabelAssistantColor;
        label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell);
            make.left.mas_equalTo(cell).offset(AdaptationWidth(16));
        }];
        switch (indexPath.row) {
            case 0:
                label.text = @"个人信息";
                break;
            case 1:
                 label.text = @"联系人信息";
                break;
            case 2:
                 label.text = @"基本信息";
                break;
            case 3:
                 label.text = @"运营商信息";
                break;
                
                
            default:
                break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            
            IdentityViewController *vc = [[IdentityViewController alloc]init];
            vc.creditInfoModel = self.creditInfoModel;
            vc.isFromVC = @1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            if (self.creditInfoModel.scheduleStatus.integerValue > 1) {
                ContactViewController *vc = [[ContactViewController alloc]init];
                vc.isFromVC = @1;
                [self.navigationController pushViewController:vc animated:YES];
                return;
            }
           [self setHudWithName:@"请先进行身份证认证" Time:1.5 andType:1];
        }
            break;
        case 2:
        {
            if (self.creditInfoModel.scheduleStatus.integerValue > 2) {
                BaseViewController *vc = [[BaseViewController alloc]init];
                vc.isFromVC = @1;
                [self.navigationController pushViewController:vc animated:YES];
                 return;
             }
            if (self.creditInfoModel.scheduleStatus.integerValue == 1) {
                [self setHudWithName:@"请先进行身份证认证" Time:1.5 andType:1];
            }
            if (self.creditInfoModel.scheduleStatus.integerValue == 2) {
                [self setHudWithName:@"请先进行联系人信息认证" Time:1.5 andType:1];
            }
            
        }
            break;
        case 3:
        {
            if (self.creditInfoModel.scheduleStatus.integerValue > 3) {
                OperatorViewController *vc = [[OperatorViewController alloc]init];
                vc.isFromVC = @1;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (self.creditInfoModel.scheduleStatus.integerValue == 1) {
                [self setHudWithName:@"请先进行身份证认证" Time:1.5 andType:1];
            }
            if (self.creditInfoModel.scheduleStatus.integerValue == 2) {
                [self setHudWithName:@"请先进行联系人信息认证" Time:1.5 andType:1];
            }
            if (self.creditInfoModel.scheduleStatus.integerValue == 3) {
                [self setHudWithName:@"请先进行基本信息认证" Time:1.5 andType:1];
            }
        }
            break;
            
            
        default:
            break;
    }
    
}
#pragma mark -network
- (void)setRequestParams{

            self.cmd = XGetCreditInfoVerify;
            self.dict = [NSDictionary dictionary];

}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.creditInfoModel = [CreditInfoModel mj_objectWithKeyValues:response.data];
    [self.tableView reloadData];
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
