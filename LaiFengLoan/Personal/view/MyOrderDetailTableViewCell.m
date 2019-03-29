//
//  MyOrderDetailTableViewCell.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "MyOrderDetailTableViewCell.h"
#import "DateHelper.h"

@implementation MyOrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOrderListModel:(OrderListModel *)orderListModel{
    self.firstLab.text = [NSString stringWithFormat:@"借款金额：%@元",orderListModel.orderAmt.description];
    self.fourLab.text = [NSString stringWithFormat:@"订单编号：%@",orderListModel.orderNo];
    [self.paybtn setCornerValue:5];
    [self.nextPayBtn setCornerValue:5];
    if(orderListModel.repayStatus.integerValue == 3){
        self.faleLab.hidden = NO;;
    }else{
        self.faleLab.hidden = YES;
    }
    switch (self.orderState) {
        case 1:
        case 2:
        case 6:
        case 3:
        case 5:
        {
            self.twoLab.text = [NSString stringWithFormat:@"借款期限：%@",orderListModel.stageTimeunitCnt.description];
            self.threeLab.hidden = YES;
            self.paybtn.hidden = YES;
            self.nextPayBtn.hidden = YES;
            self.orderTopLayout.constant = 70;
            self.lineTopLayout.constant = 65;
            self.extensionImage.hidden = YES;
        }
            break;
        case 4:
        {
            self.orderTopLayout.constant = 81.5;
            self.lineTopLayout.constant = 110;
            self.threeLab.hidden = NO;
            self.paybtn.hidden = NO;
        
            if (orderListModel.repayStatus.integerValue == 4) {
                [self.paybtn setBackgroundColor:LineColor];
                [self.paybtn setTitle:@"还款中" forState:UIControlStateNormal];
                self.paybtn.enabled = NO;
            }else{
                self.paybtn.enabled = YES;
                [self.paybtn setBackgroundColor:AppMainColor];
                [self.paybtn setTitle:@"立即还款" forState:UIControlStateNormal];
            }
            if (orderListModel.extensionStatus.integerValue == 1 ||orderListModel.extensionStatus.integerValue == 2 ||orderListModel.extensionStatus.integerValue == 4 || orderListModel.repayStatus.integerValue == 4 ||  orderListModel.overDueDays.integerValue > 0  || orderListModel.hasPartRepay.integerValue == 1) {
                [self.nextPayBtn setBackgroundColor:LineColor];
//                self.nextPayBtn.userInteractionEnabled = NO;
            }else{
                [self.nextPayBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
//                self.nextPayBtn.userInteractionEnabled = YES;
            }
            if (orderListModel.overDueDays.integerValue) {
                if (orderListModel.overDueDays.integerValue < 4) {
                    if (self.clientGlobalInfo.overdue3dayHasExtension.integerValue == 1) {
                        [self.nextPayBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
                    }
                }
            }
            if (orderListModel.hasExtension.integerValue == 1) {
                self.extensionImage.hidden = NO;
            }else{
                self.extensionImage.hidden = YES;
            }
            
            self.twoLab.text = [NSString stringWithFormat:@"还款日期：%@",[DateHelper getDateFromTimeNumber:orderListModel.dueRepayDate withFormat:@"yyyy-MM-dd"]];
            self.threeLab.text = [NSString stringWithFormat:@"待还金额：%@元",orderListModel.waitingAmt.description];
        }
            break;
            
        default:
            break;
    }
    
    switch (self.orderState) {
        case 1:
        {
            self.stateImage.image = [UIImage imageNamed:@"审核中-state"];
        }
            break;
        case 2:
        {
            self.stateImage.image = [UIImage imageNamed:@"已拒绝-state"];
        }
            break;
        case 6:
        {
            self.stateImage.image = [UIImage imageNamed:@"已关闭-state"];
        }
            break;
        case 4:
        {
            
            if (orderListModel.overDueDays.integerValue) {
                self.stateImage.image = [UIImage imageNamed:@"已逾期-state"];
            }else{
                
                if (orderListModel.repayStatus.integerValue == 4) {
                    self.faleLab.hidden = YES;
                    
                }
                    self.stateImage.image = [UIImage imageNamed:@"正常-state"];
                
            }
            
        }
            break;
        case 5:
        {
           self.stateImage.image = [UIImage imageNamed:@"已结清-state"];
        }
            break;
        case 3:
        {
           self.stateImage.image = [UIImage imageNamed:@"待放款-state"];
        }
            break;
            
        default:
            break;
    }
    
    
}
- (IBAction)payBtnOnClick:(UIButton *)sender {
    if (self.block) {
        self.block(self.row, sender);
    }
}
- (ClientGlobalInfo *)clientGlobalInfo{
    if (!_clientGlobalInfo) {
        _clientGlobalInfo = [ClientGlobalInfo getClientGlobalInfoModel];
    }
    return _clientGlobalInfo;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
