//
//  MyOrderDetailTableViewCell.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"
@interface MyOrderDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *firstLab;
@property (weak, nonatomic) IBOutlet UILabel *twoLab;
@property (weak, nonatomic) IBOutlet UILabel *threeLab;
@property (weak, nonatomic) IBOutlet UILabel *fourLab;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UIImageView *extensionImage;
@property (weak, nonatomic) IBOutlet UIButton *paybtn;
@property (weak, nonatomic) IBOutlet UIButton *nextPayBtn;
@property (weak, nonatomic) IBOutlet UILabel *faleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopLayout;
@property (nonatomic ,strong) OrderListModel *orderListModel;
@property (nonatomic ,assign) MyOrderState  orderState;
@property (nonatomic ,copy) XDoubleBlock block;
@property (nonatomic ,copy) NSNumber *row;
@end
