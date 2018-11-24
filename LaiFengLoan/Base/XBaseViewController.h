//
//  XBaseViewController.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/10/31.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XControllerViewHelper.h"
#import "Enum.h"
#import "XResponse.h"
#import "ParamModel.h"
#import "UserInfo.h"
@interface XBaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//创建一个全局变量数组
@property (nonatomic, assign) int requestCount;/*!<   标记同一个控制器中的多次网络请求 */
@property (nonatomic, copy)NSString *cmd;/*!< 用于标示网络请求的接口类型 */
@property (nonatomic) NSDictionary *dict; /*!< 网络请求参数*/
@property (nonatomic, strong) ClientGlobalInfo *clientGlobalInfo;
/**
 创建返回按钮
 */
-(void)setBackNavigationBarItem;
/**
 导航栏按钮的点击事件
 
 @param button 被点击的导航栏按钮 tag：9999 表示返回按钮
 */
-(void)BarbuttonClick:(UIButton *)button;
/**
 hud展示
 
 @param name hud展示的内容
 @param time hud持续的时间
 @param type 0:加载成功 1.加载失败 2.提醒警告 3.提示语
 */
-(void)setHudWithName:(NSString *)name Time:(float)time andType:(int)type;

/** 创建tableView
 *  frame:tableView的尺寸
 */
-(void)createTableViewWithFrame:(CGRect )frame;
/**
 tableView的上拉刷新事件
 */
-(void)headerRefresh;

/**
 tableView的下拉加载事件
 */
-(void)footerRefresh;

/**
 设置网络请求参数cmd,params,供子类重写
 */
-(void)setRequestParams;

/**  准备网络请求的参数,供子类调用重写
 *  count:用于表示多次网络请求的标识(0:表示tableView的数据创建)
 */
-(void)prepareDataWithCount:(int)count;

/**
 网络操作成功
 
 @param response 成功之后的数据detail
 */
-(void)requestSuccessWithDictionary:(XResponse *)response;
/**
 网络操作失败
 
 @param response 失败之后的数据object
 */
-(void)requestFaildWithDictionary:(XResponse *)response;
/**
 是否 登录
 */
- (void)getBlackLogin:(UIViewController *)controller;
/**
 
  此方法把double －－－> NSString
 
  */

- (NSString *)decimalNumberWithDouble:(NSNumber *)conversionValue;
@end
