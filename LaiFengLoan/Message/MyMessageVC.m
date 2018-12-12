//
//  MyMessageVC.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/17.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyMessageVC.h"
#import "MyMessageTableViewCell.h"
#import "PageQueryModel.h"
#import "MyMessageModel.h"
#import "XRootWebVC.h"
#import "MyOrderFlowVC.h"
#import "OperatorViewController.h"
@interface MyMessageVC ()
@property (nonatomic ,strong) PageQueryModel *pageQueryModel;
@property (nonatomic ,strong) MyMessageModel *myMessageModel;
@end

@implementation MyMessageVC
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
    self.title = @"订单消息";
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self prepareDataWithCount:0];
}
- (UIView *)creatFootView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noData"]];
    [view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view).offset(-40);
        make.centerX.mas_equalTo(view);
    }];
    UILabel *lab = [[UILabel alloc]init];
    [lab setFont:[UIFont systemFontOfSize:AdaptationWidth(16)]];
    [lab setText:@"暂无数据"];
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
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idetifier = @"MyMessageCell";
    MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idetifier];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MyMessageTableViewCell" owner:nil options:nil].lastObject;
        cell.model = [MyMessageModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.myMessageModel = [MyMessageModel mj_objectWithKeyValues:self.dataSourceArr[indexPath.row]];
    if (self.myMessageModel.optType.integerValue == 1) {
        switch (self.myMessageModel.appModuleId.integerValue) {
            case 1:
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
                break;
            case 2:
            {
                MyOrderFlowVC *vc = [[MyOrderFlowVC alloc]init];
                vc.orderNo = self.myMessageModel.orderCode;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3:
            {
                OperatorViewController *vc = [[OperatorViewController alloc]init];
                vc.isFromVC = @1;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
                
            default:
                break;
        }
    }else if(self.myMessageModel.optType.integerValue == 2){
        XRootWebVC *vc = [[XRootWebVC alloc]init];
        vc.url = self.myMessageModel.targetUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}
- (void)setRequestParams{
    self.cmd = XGetMessageList;
    self.dict = [NSDictionary dictionaryWithObjectsAndKeys:[self.pageQueryModel mj_keyValues],@"pageQueryReq", nil];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    [self.dataSourceArr addObjectsFromArray: response.data[@"dataRows"]];
    self.tableView.tableFooterView = nil;
    if (!self.dataSourceArr.count) {
        self.tableView.tableFooterView = [self creatFootView];
    }
    [self.tableView reloadData];
}
- (PageQueryModel *)pageQueryModel{
    if (!_pageQueryModel) {
        _pageQueryModel = [[PageQueryModel alloc]init];
    }
    return _pageQueryModel;
}
- (MyMessageModel *)myMessageModel{
    if (!_myMessageModel) {
        _myMessageModel = [[MyMessageModel alloc]init];
    }
    return _myMessageModel;
}
- (void)headerRefresh{
    [self.dataSourceArr removeAllObjects];
    self.pageQueryModel.page = @(1);
    [self prepareDataWithCount:0];
}
- (void)footerRefresh{
    self.pageQueryModel.page = @(self.pageQueryModel.page.integerValue +1);
    [self prepareDataWithCount:0];
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
