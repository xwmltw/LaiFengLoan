//
//  MyOrderFlowTableViewCell.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/6.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyOrderFlowTableViewCell.h"
#import "DateHelper.h"
@implementation MyOrderFlowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setRow:(NSNumber *)row{
    self.line1.hidden = NO;
    self.line2.hidden = NO;
    if (row.integerValue == 0) {
        self.line1.hidden = YES;
    }
    if (row.integerValue == (self.num.integerValue -1)) {
        self.line2.hidden = YES;
    }
}
- (void)setDic:(NSDictionary *)dic{
    self.titleLab.text = dic[@"nodeTitle"];
    self.detailLab.text = dic[@"nodeDesc"];
    self.dateLab.text = [DateHelper getDateFromTimeNumber:dic[@"nodeTime"] withFormat:@"yyyy-M-d, HH:mm"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
