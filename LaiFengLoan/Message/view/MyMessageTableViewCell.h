//
//  MyMessageTableViewCell.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/17.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMessageModel.h"
@interface MyMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detaillab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (nonatomic ,strong) MyMessageModel *model;
@end
