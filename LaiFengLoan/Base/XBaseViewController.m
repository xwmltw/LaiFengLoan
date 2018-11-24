//
//  XBaseViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/10/31.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "XBaseViewController.h"
#import "SecurityUtil.h"
#import "XAlertView.h"
#import "LoginViewController.h"
@interface XBaseViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIView *bgView;
@end

@implementation XBaseViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 解决多级页面返回到第二页无法返回的问题
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
#ifdef DEBUG
    UIViewController *viewCtrl = [XControllerViewHelper getTopViewController];
    NSLog(@"栈顶控制器为%@\n当前显示控制器为%@", [viewCtrl class], [self class]);
#endif
        NSString *title = self.title.length ? self.title : NSStringFromClass([self class]);
        [TalkingData trackPageBegin:title];
}
#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    MyLog(@"<<<<========%@控制器滑动返回",[self class]);
    if(self.navigationController && self.navigationController.childViewControllers.count == 1 ){
        return NO;
    }
    return YES;
}
#pragma mark - setup view
#ifdef __IPHONE_7_0
- (UIRectEdge)edgesForExtendedLayout {
    return UIRectEdgeNone;
}
#endif
- (void)setupControllerNavigation{
    self.navigationController.navigationBar.translucent = NO;//导航栏底色会闪一下，是黑色一闪而过
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :LabelMainColor,NSFontAttributeName :[UIFont systemFontOfSize:AdaptationWidth(17)]}];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

/**
 *  点击屏幕空白区域，放弃桌面编辑状态
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {//适配
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupControllerNavigation];
    
    [self setBackNavigationBarItem];
}
/**
 创建返回按钮
 */
-(void)setBackNavigationBarItem{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
    view.userInteractionEnabled = YES;
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"btn_back"]];
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
//    UIView *ringhtV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 64, 44)];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:ringhtV];
//    self.navigationItem.rightBarButtonItem = rightItem;
}
/**
 导航栏按钮的点击事件
 
 @param button 被点击的导航栏按钮 tag：9999 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 hud展示
 
 @param name hud展示的内容
 @param time hud持续的时间
 @param type 0:加载成功 1.加载失败 2.提醒警告 3.提示语
 */
-(void)setHudWithName:(NSString *)name Time:(float)time andType:(int)type{
    //记录当前的self.navigationController.view，当回到主线程且页面消失，当前的self.navigationController.view可能会消失
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = topWindow.rootViewController;
    UIView *superView = appRootVC.view;
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        hud.delegate = self;
        if (type == 4) {
            hud.offset = CGPointMake(0, AdaptationWidth(150));
        }
        hud.mode = MBProgressHUDModeCustomView;
        hud.detailsLabel.text = name;
        // 如果不写就会导致指示器的背景永远都会有一层透明度为0.5的背景 hud.bezelView.style
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.contentColor = XColorWithRBBA(255, 255, 255, 1);
        hud.bezelView.backgroundColor = XColorWithRBBA(0, 0, 0, 1);
        [hud hideAnimated:YES afterDelay:time];
    });
}
#pragma mark- MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark - tablkView
/** 创建tableView
 *  frame:tableView的尺寸
 */
-(void)createTableViewWithFrame:(CGRect )frame{
    self.tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = XColorWithRGB(255, 255, 255);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    /***
     在iOS11中如果不实现 -tableView: viewForHeaderInSection:和-tableView: viewForFooterInSection: ，则-tableView: heightForHeaderInSection:和- tableView: heightForFooterInSection:不会被调用，导致它们都变成了默认高度，这是因为tableView在iOS11默认使用Self-Sizing，tableView的estimatedRowHeight、estimatedSectionHeaderHeight、 estimatedSectionFooterHeight三个高度估算属性由默认的0变成了UITableViewAutomaticDimension,就是实现对应方法或把这三个属性设为0。
     ***/
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    _tableView.mj_footer = footer;
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    footer.stateLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(12)];
    footer.stateLabel.textColor = XColorWithRBBA(34, 58, 80, 0.32);
//    _tableView.mj_footer.hidden = YES;
    [self.view addSubview:_tableView];
}
/**
 *  返回分区数目(默认为1)
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 *  返回每个分区的个数
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0.1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

/**
 tableView的上拉刷新事件
 */
-(void)headerRefresh{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

/**
 tableView的下拉加载事件
 */
-(void)footerRefresh{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark -网络请求
/**
 网络请求数据的处理,供子类调用
 @param count 标示数据请求的
 */
-(void)prepareDataWithCount:(int)count{
    self.requestCount = count;
    [self setRequestParams];
    [self prepareDataGetUrlWithModel:self.cmd andparmeter:self.dict];
}
/**
 设置网络请求参数cmd,params,供子类重写
 */
-(void)setRequestParams{}
/**  网络请求成功之后调用,子类重写
 *   object 是网络请求的结果
 */
-(void)getDataSourceWithObject:(XResponse *)response {
    if (response.rspCode.integerValue == 0) {
        [self requestSuccessWithDictionary:response];
    }else{
        [self requestFaildWithDictionary:response];
    }
}
/**
 网络操作成功
 @param response 成功之后的数据
 */
-(void)requestSuccessWithDictionary:(XResponse *)response{}
/**
 网络操作失败
 @param response 失败之后的数据
 */
-(void)requestFaildWithDictionary:(XResponse *)response{
    
    if (response.rspCode.integerValue == 1011) {
        [XAlertView alertWithTitle:@"温馨提示" message:response.rspMsg cancelButtonTitle:@"取消" confirmButtonTitle:@"去登录" viewController:self completion:^(UIAlertAction *action, NSInteger buttonIndex) {

            if (buttonIndex == 1) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        return;
    }
    [self setHudWithName:response.rspMsg Time:2 andType:1];
}

/**  网络请求
 *   string:表示请求的cmd dict:表示请求的参数
 */
-(void)prepareDataGetUrlWithModel:(id)model andparmeter:(NSDictionary *)dict{
    MBProgressHUD *hud = nil;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = topWindow.rootViewController;
    hud = [MBProgressHUD showHUDAddedTo:appRootVC.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    
    NSMutableDictionary *params = [[[BaseInfoPM alloc]init] mj_keyValues];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];

    if(dict.count){
        [content addEntriesFromDictionary:dict];
    }
    [params setObject:[UserInfo sharedInstance].accessToken.length > 0 ? [UserInfo sharedInstance].accessToken :@"" forKey:@"accessToken"];
    [params setObject:content forKey:@"data"];
    AFHTTPSessionManager *requestManager = [AFHTTPSessionManager manager];
    requestManager.requestSerializer = [AFJSONRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *changeString = [NSString dictionaryToJson:params];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVICEURL,model]]];
//    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://restapi.amap.com/v3/config/district?key=efb36fcfea0e9941e201260a4087e236&subdistrict=3"]];
    [request setHTTPBody: [changeString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];//请求格式
    [request setHTTPMethod:@"POST"];
    NSURLSessionDataTask * tesk = [requestManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (hud) {
            [hud hideAnimated:YES];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self requestErrorWith:error];
            
        }else{
            NSString *base64String = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
             MyLog(@"网络请求成功返回数据%@",base64String);
            XResponse *response = [XResponse mj_objectWithKeyValues:[NSString dictionaryWithJsonString:base64String]];
            [self getDataSourceWithObject:response];
        }
    }];
    [tesk resume];
}
-(void)requestErrorWith:(NSError *)error{
    MyLog(@"网络请求失败返回数据%@",error);
    if (!(_bgView == nil)) {
        _bgView.hidden = YES;
        [_bgView removeFromSuperview];
    }
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titlelabel = [[UILabel alloc]init];
    [titlelabel setText:@"咦, 网络似乎断了"];
    titlelabel.textColor = XColorWithRBBA(34, 58, 80, 0.8);
    titlelabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(30)];
    titlelabel.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Unconneted"]];
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.layer.cornerRadius = 4;
    refreshButton.clipsToBounds = YES;
    refreshButton.backgroundColor = AppMainColor;
    [refreshButton setTitle:@"刷新试试" forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshButton  setTitleColor:XColorWithRBBA(255, 255, 255, 0.4) forState:UIControlStateHighlighted];
    refreshButton.titleLabel.font = [UIFont systemFontOfSize:AdaptationWidth(17)];
    [refreshButton addTarget:self action:@selector(refreshButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_bgView addSubview:titlelabel];
    [_bgView addSubview:imageView];
    [_bgView addSubview:refreshButton];
    [self.view addSubview:_bgView];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self.view);
    }];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bgView).offset(AdaptationWidth(128));
        make.left.mas_equalTo(_bgView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(_bgView).offset(-AdaptationWidth(24));
        make.height.mas_equalTo(AdaptationWidth(42));
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AdaptationWidth(161));
        make.left.mas_equalTo(_bgView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(_bgView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(titlelabel.mas_bottom).offset(AdaptationWidth(32));
    }];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(AdaptationWidth(48));
        make.left.mas_equalTo(_bgView).offset(AdaptationWidth(24));
        make.right.mas_equalTo(_bgView).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(imageView.mas_bottom).offset(AdaptationWidth(48));
    }];
}
-(void)refreshButtonClick{
    [self prepareDataWithCount:self.requestCount];
    _bgView.hidden = YES;
    [_bgView removeFromSuperview];
}
/**
 是否 登录
 */
- (void)getBlackLogin:(UIViewController *)controller{
    [XAlertView alertWithTitle:@"提示" message:@"您还没有登录唷~请前往登录!" cancelButtonTitle:@"取消" confirmButtonTitle:@"登录" viewController:controller completion:^(UIAlertAction *action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    return;
}
/**
 
  此方法把double －－－> NSString

 */

- (NSString *)decimalNumberWithDouble:(NSNumber *)conversionValue
{
    NSString *doubleString = [NSString stringWithFormat:@"%lf", [conversionValue doubleValue]];
    NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
  
}

#pragma mark 懒加载
/**
 数据数组的全局变量
 
 @return 数据数组
 */
-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray new];
    }
    return _dataSourceArr;
}
- (ClientGlobalInfo *)clientGlobalInfo{
    if (!_clientGlobalInfo) {
        _clientGlobalInfo = [ClientGlobalInfo getClientGlobalInfoModel];
    }
    return _clientGlobalInfo;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [XNotificationCenter removeObserver:self];
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
