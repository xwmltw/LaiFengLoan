//
//  MyMessageTableViewCell.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/17.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyMessageTableViewCell.h"
#import "DateHelper.h"
@implementation MyMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(MyMessageModel *)model{
    self.titleLab.text = model.messageTitle;
    self.detaillab.text = model.messageContent;
    self.dateLab.text = [DateHelper getDateTimeFromTimeNumber:model.createTime];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
