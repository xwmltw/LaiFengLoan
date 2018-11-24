//
//  QustionsCell.h
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/3.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestsModel.h"
@protocol QustionsCellDelegate <NSObject>

- (void)isSelectedOrNot:(UIButton *)button;

@end
@interface QustionsCell : UITableViewCell
@property (nonatomic,strong) QuestsModel *model;
@property (nonatomic,strong) UIButton *tipButton;
@property (nonatomic, weak) id<QustionsCellDelegate> delegate;
@end
