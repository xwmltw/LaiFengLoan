//
//  QustionsCell.m
//  QuanWangDai
//
//  Created by 余文灿 on 2018/5/3.
//  Copyright © 2018年 kizy. All rights reserved.
//

#import "QustionsCell.h"

@implementation QustionsCell
{
    UILabel *titlelabel;
    UILabel *disctiplabel;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        titlelabel = [[UILabel alloc]init];
//        titlelabel.numberOfLines = 2;
        [titlelabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(16)]];
        [titlelabel setTextColor:XColorWithRBBA(34, 58, 80, 0.8)];
        [self.contentView addSubview:titlelabel];
        
        disctiplabel = [[UILabel alloc]init];
        disctiplabel.numberOfLines = 0;
        disctiplabel.hidden = YES;
        [disctiplabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:AdaptationWidth(13)]];
        [disctiplabel setTextColor:XColorWithRBBA(149, 161, 171, 1)];
        [self.contentView addSubview:disctiplabel];
        
        _tipButton = [[UIButton alloc]init];
        [_tipButton setBackgroundImage:[UIImage imageNamed:@"questions_unselect"] forState:UIControlStateNormal];
        [_tipButton setBackgroundImage:[UIImage imageNamed:@"questions_select"] forState:UIControlStateSelected];
        _tipButton.userInteractionEnabled = NO;
        [_tipButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_tipButton];
        
        UIView *lineView = [[UIView alloc]init];
        [lineView setBackgroundColor:XColorWithRGB(240, 240, 240)];
        [self.contentView addSubview:lineView];
        
        [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(AdaptationWidth(24));
            make.top.mas_equalTo(self).offset(AdaptationWidth(20));
            make.right.mas_equalTo(_tipButton.mas_left).offset(-AdaptationWidth(10));
        }];
        [disctiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(AdaptationWidth(24));
            make.top.mas_equalTo(titlelabel.mas_bottom).offset(AdaptationWidth(8));
            make.right.mas_equalTo(self).offset(-AdaptationWidth(24));
        }];
        [_tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-AdaptationWidth(24));
            make.top.mas_equalTo(self).offset(AdaptationWidth(17));
            make.height.width.mas_equalTo(AdaptationWidth(28));
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(AdaptationWidth(24));
            make.right.mas_equalTo(self).offset(-AdaptationWidth(24));
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
    return self;
}
-(void)setModel:(QuestsModel *)model{

    titlelabel.text =[NSString stringWithFormat:@"%@",model.question];
    if (model.isExpand == YES) {
        disctiplabel.hidden = NO;
        NSMutableAttributedString * artical_main_text = [[NSMutableAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@",model.answer] dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        disctiplabel.attributedText = artical_main_text;
        _tipButton.selected = YES;
    }else{
        disctiplabel.hidden = YES;
        _tipButton.selected = NO;
    }
}
-(void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(isSelectedOrNot:)]) {
        [self.delegate isSelectedOrNot:button];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
