//
//  MyOrderFlowTableViewCell.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderFlowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (nonatomic ,strong) NSDictionary *dic;
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (nonatomic ,copy) NSNumber *row;
@property (nonatomic ,copy) NSNumber *num;
@end
