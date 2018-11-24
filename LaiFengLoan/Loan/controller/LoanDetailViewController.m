//
//  LoanDetailViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/3.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "LoanDetailViewController.h"
#import "BankViewController.h"
#import "LoanOrderDetailVC.h"
typedef NS_ENUM(NSInteger, LoanDetailBtnTag) {
    LoanDetailBtnTagBack = 500,
    LoanDetailBtnTagLoan,
    LoanDetailBtnTagSelectMoney1,
    LoanDetailBtnTagSelectMoney2,
    LoanDetailBtnTagSelectMoney3,
    LoanDetailBtnTagSelectDate1,
    LoanDetailBtnTagSelectDate2,
};
@interface LoanDetailViewController ()

@end

@implementation LoanDetailViewController
{
    UILabel *available;
    UILabel *creditlabel;
    UISlider *slider;
    UILabel * sliderlab;
    NSNumber *statusType;
    UIButton *selectMoneyBtn;
    UIButton *selectMoneyBtn2;
    UIButton *selectMoneyBtn3;
    UIButton *selectDateBtn;
    UIButton *selectDateBtn2;
    NSString *selectMoney;
    NSString *selectDate;

}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}
- (void)initUI{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = AppMainColor;
    [self.view addSubview:headView];
    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(AdaptationWidth(160));
    }];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    [headImage setImage:[UIImage imageNamed:@"loanDetail_headbg"]];
    [headView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headView);
        make.width.mas_equalTo(AdaptationWidth(300));
        make.height.mas_equalTo(AdaptationWidth(116));
    }];
    
    UIButton *backBtn =[[UIButton alloc]init];
    backBtn.tag = LoanDetailBtnTagBack;
    [backBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"btn_whiteBack"] forState:UIControlStateNormal];
    [headView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headView).offset(10);
        make.top.mas_equalTo(headView).offset(32);
        make.width.mas_equalTo(AdaptationWidth(30));
    }];
    
    available = [[UILabel alloc]init];
    [available setText:[NSString stringWithFormat:@"可用额度：￥%@",self.creditInfoModel.useAmt.description]];
    [available setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [available setTextColor:LabelMainColor];
    [self.view addSubview:available];
    [available mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(37));
        make.top.mas_equalTo(headView.mas_bottom).offset(AdaptationWidth(14));
    }];
    
    creditlabel = [[UILabel alloc]init];
    [creditlabel setText:[NSString stringWithFormat:@"授信额度：￥%@",self.creditInfoModel.creditAmt.description]];
    [creditlabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [creditlabel setTextColor:LabelMainColor];
    [self.view addSubview:creditlabel];
    [creditlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(37));
        make.top.mas_equalTo(headView.mas_bottom).offset(AdaptationWidth(14));
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = XColorWithRGB(221, 221, 221);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headView.mas_bottom);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(AdaptationWidth(48));
    }];
    
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = XColorWithRGB(221, 221, 221);
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel * loanMoneylabel = [[UILabel alloc]init];
    [loanMoneylabel setText:[NSString stringWithFormat:@"借款金额（元）"]];
    [loanMoneylabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanMoneylabel setTextColor:LabelMainColor];
    [self.view addSubview:loanMoneylabel];
    [loanMoneylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(37));
        make.top.mas_equalTo(line2.mas_bottom).offset(AdaptationWidth(30));
    }];
    
    if (self.creditInfoModel.isFirstLoan.integerValue) {
        if (self.clientGlobalInfo.firstLoanAmtFixedType.integerValue == 2){
            statusType = @1;
        }else{
            statusType = @2;
        }
    }else{
        if (self.clientGlobalInfo.notFirstLoanAmtFixedType.integerValue == 2){
            statusType = @1;
        }else{
            statusType = @2;
        }
    }
    if (statusType.integerValue == 1) {
        
        
        slider = [[UISlider alloc]init];
        slider.minimumValue = self.creditInfoModel.isFirstLoan.integerValue ?  [self.clientGlobalInfo.firstLoanAmtMin intValue]:[self.clientGlobalInfo.notFirstLoanAmtMin intValue];
        slider.maximumValue = [self.creditInfoModel.creditAmt intValue];
        slider.value = [self.creditInfoModel.creditAmt intValue];
        [slider setContinuous:YES];
        slider.minimumTrackTintColor =XColorWithRGB(26, 169, 251);
        slider.maximumTrackTintColor = XColorWithRGB(228, 228, 228);
        [slider setThumbImage:[UIImage imageNamed:@"loanDetail_slider"] forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:slider];
        [slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loanMoneylabel.mas_bottom).offset(AdaptationWidth(15));
            make.left.mas_equalTo(loanMoneylabel);
            make.width.mas_equalTo(AdaptationWidth(302));
            make.height.mas_equalTo(AdaptationWidth(40));
        }];
        
        UILabel * minlab = [[UILabel alloc]init];
        [minlab setText:self.creditInfoModel.isFirstLoan.integerValue ? self.clientGlobalInfo.firstLoanAmtMin:self.clientGlobalInfo.notFirstLoanAmtMin ];
        [minlab setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        [minlab setTextColor:LabelMainColor];
        [self.view addSubview:minlab];
        [minlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(slider);
            make.top.mas_equalTo(slider.mas_bottom).offset(AdaptationWidth(5));
        }];
        
        UILabel * maxlab = [[UILabel alloc]init];
        [maxlab setText:self.creditInfoModel.creditAmt.description];
        [maxlab setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        [maxlab setTextColor:LabelMainColor];
        [self.view addSubview:maxlab];
        [maxlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(slider);
            make.top.mas_equalTo(slider.mas_bottom).offset(AdaptationWidth(5));
        }];
        
        sliderlab = [[UILabel alloc]init];
        [sliderlab setText:self.creditInfoModel.isFirstLoan.integerValue ? self.clientGlobalInfo.firstLoanAmtMin:self.clientGlobalInfo.notFirstLoanAmtMin ];
        [sliderlab setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        [sliderlab setTextColor:LabelMainColor];
        [self.view addSubview:sliderlab];
        [sliderlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(slider);
            make.top.mas_equalTo(line2.mas_bottom).offset(AdaptationWidth(30));
        }];
    }else{
        NSArray *btnAry = [NSArray array];
        if (self.creditInfoModel.isFirstLoan.integerValue == 1) {
           btnAry  = [self.clientGlobalInfo.firstLoanAmtFixedDesc componentsSeparatedByString:@","];
        }else{
            btnAry  = [self.clientGlobalInfo.notFirstLoanAmtFixedDesc componentsSeparatedByString:@","];
        }
        
        selectMoneyBtn = [[UIButton alloc]init];
        
        selectMoneyBtn.tag  = LoanDetailBtnTagSelectMoney1;
        [selectMoneyBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectMoneyBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        [selectMoneyBtn setTitle:btnAry[0] forState:UIControlStateNormal];
        selectMoneyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [selectMoneyBtn setImage:[UIImage imageNamed:@"loanDetail_unselect"] forState:UIControlStateNormal];
        [selectMoneyBtn setImage:[UIImage imageNamed:@"loanDetail_select"] forState:UIControlStateSelected];
        [selectMoneyBtn setTitleColor:LabelMainColor forState:UIControlStateNormal];
        
        selectMoneyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.view addSubview:selectMoneyBtn];
        [selectMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loanMoneylabel.mas_bottom).offset(AdaptationWidth(15));
            make.left.mas_equalTo(loanMoneylabel);
            make.width.mas_equalTo(AdaptationWidth(80));
        }];
        
        if (btnAry.count == 1) {
            selectMoney = selectMoneyBtn.titleLabel.text;
            selectMoneyBtn.selected = YES;
        }
        
        if (btnAry.count > 1) {
            selectMoneyBtn2 = [[UIButton alloc]init];
            selectMoneyBtn2.tag  = LoanDetailBtnTagSelectMoney2;
            [selectMoneyBtn2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [selectMoneyBtn2.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
            [selectMoneyBtn2 setTitle:btnAry[1] forState:UIControlStateNormal];
            selectMoneyBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [selectMoneyBtn2 setImage:[UIImage imageNamed:@"loanDetail_unselect"] forState:UIControlStateNormal];
            [selectMoneyBtn2 setImage:[UIImage imageNamed:@"loanDetail_select"] forState:UIControlStateSelected];
            [selectMoneyBtn2 setTitleColor:LabelMainColor forState:UIControlStateNormal];
            selectMoneyBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
            [self.view addSubview:selectMoneyBtn2];
            [selectMoneyBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(loanMoneylabel.mas_bottom).offset(AdaptationWidth(15));
                make.centerX.mas_equalTo(self.view);
                make.width.mas_equalTo(AdaptationWidth(80));
            }];
            if (btnAry.count == 2) {
                selectMoney = selectMoneyBtn2.titleLabel.text;
                selectMoneyBtn2.selected = YES;
            }
           
        }
        
        if (btnAry.count > 2) {
            selectMoneyBtn3 = [[UIButton alloc]init];
            selectMoneyBtn3.tag  = LoanDetailBtnTagSelectMoney3;
            [selectMoneyBtn3 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [selectMoneyBtn3.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
            [selectMoneyBtn3 setTitle:btnAry[2] forState:UIControlStateNormal];
            selectMoneyBtn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [selectMoneyBtn3 setImage:[UIImage imageNamed:@"loanDetail_unselect"] forState:UIControlStateNormal];
            [selectMoneyBtn3 setImage:[UIImage imageNamed:@"loanDetail_select"] forState:UIControlStateSelected];
            [selectMoneyBtn3 setTitleColor:LabelMainColor forState:UIControlStateNormal];
            selectMoneyBtn3.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            [self.view addSubview:selectMoneyBtn3];
            [selectMoneyBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(loanMoneylabel.mas_bottom).offset(AdaptationWidth(15));
                make.right.mas_equalTo(self.view).offset(AdaptationWidth(-37));
                make.width.mas_equalTo(AdaptationWidth(80));
            }];
            
            if (btnAry.count == 3) {
                selectMoney = selectMoneyBtn3.titleLabel.text;
                selectMoneyBtn3.selected = YES;
            }
        }
        
    }

    UILabel * loanDatelabel = [[UILabel alloc]init];
    [loanDatelabel setText:[NSString stringWithFormat:@"借款期限（天）"]];
    [loanDatelabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanDatelabel setTextColor:LabelMainColor];
    [self.view addSubview:loanDatelabel];
    [loanDatelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(37));
        make.top.mas_equalTo(loanMoneylabel.mas_bottom).offset(AdaptationWidth(87));
    }];
    
    selectDateBtn = [[UIButton alloc]init];
    selectDateBtn.selected = YES;
    selectDateBtn.tag  = LoanDetailBtnTagSelectDate1;
    [selectDateBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectDateBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [selectDateBtn setTitle:self.clientGlobalInfo.borrowDaysMin forState:UIControlStateNormal];
    selectDateBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectDateBtn setImage:[UIImage imageNamed:@"loanDetail_unselect"] forState:UIControlStateNormal];
    [selectDateBtn setImage:[UIImage imageNamed:@"loanDetail_select"] forState:UIControlStateSelected];
    [selectDateBtn setTitleColor:LabelMainColor forState:UIControlStateNormal];
    
    selectDateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.view addSubview:selectDateBtn];
    [selectDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(loanDatelabel.mas_bottom).offset(AdaptationWidth(15));
        make.left.mas_equalTo(loanDatelabel);
        make.width.mas_equalTo(AdaptationWidth(80));
    }];
    
    selectDate = selectDateBtn.titleLabel.text;
    
    if (![self.clientGlobalInfo.borrowDaysMin isEqualToString:self.clientGlobalInfo.borrowDaysMax]) {

        selectDateBtn2 = [[UIButton alloc]init];
        selectDateBtn2.tag  = LoanDetailBtnTagSelectDate2;
        [selectDateBtn2 addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [selectDateBtn2.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
        [selectDateBtn2 setTitle:self.clientGlobalInfo.borrowDaysMax forState:UIControlStateNormal];
        selectDateBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [selectDateBtn2 setImage:[UIImage imageNamed:@"loanDetail_unselect"] forState:UIControlStateNormal];
        [selectDateBtn2 setImage:[UIImage imageNamed:@"loanDetail_select"] forState:UIControlStateSelected];
        [selectDateBtn2 setTitleColor:LabelMainColor forState:UIControlStateNormal];
        
        selectDateBtn2.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.view addSubview:selectDateBtn2];
        [selectDateBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(loanDatelabel.mas_bottom).offset(AdaptationWidth(15));
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(AdaptationWidth(80));
        }];
    }
    

    UIButton *loanBtn = [[UIButton alloc]init];
    loanBtn.tag = LoanDetailBtnTagLoan;
    [loanBtn setBackgroundColor:AppMainColor];
    [loanBtn setCornerValue:AdaptationWidth(22)];
    [loanBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loanBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    [loanBtn setTitle:@"立即借款" forState:UIControlStateNormal];
    [loanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loanBtn];
    [loanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(selectDateBtn.mas_bottom).offset(AdaptationWidth(74));
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(AdaptationWidth(250));
        make.height.mas_equalTo(AdaptationWidth(43));
    }];
    
    UILabel * compayLab = [[UILabel alloc]init];
    [compayLab setText:self.clientGlobalInfo.companyCopyrightInfo];
    [compayLab setFont:[UIFont systemFontOfSize:AdaptationWidth(12)]];
    [compayLab setTextColor:LabelMainColor];
    [self.view addSubview:compayLab];
    [compayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-AdaptationWidth(18));
    }];
}
#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case LoanDetailBtnTagBack:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case LoanDetailBtnTagLoan:{
            if (statusType.integerValue == 1) {
                selectMoney = sliderlab.text;
            }else{
                if (!selectMoney.length) {
                    [self setHudWithName:@"请选择借款金额" Time:1 andType:1];
                    return;
                }
            }
            if (!selectDate.length) {
                [self setHudWithName:@"请选择借款期限" Time:1 andType:1];
                return;
            }
            if (sliderlab.text.integerValue <= self.creditInfoModel.useAmt.integerValue) {
                [self prepareDataWithCount:0];
            }else{
                [self setHudWithName:@"借款额度不能大于可用额度" Time:1 andType:1];
            }
            
        }
            break;
        case LoanDetailBtnTagSelectMoney1:{
            if (btn.selected == NO) {
                btn.selected = YES;
                selectMoneyBtn2.selected = NO;
                selectMoneyBtn3.selected = NO;
            }
            
        }
            break;
        case LoanDetailBtnTagSelectMoney2:{
            if (btn.selected == NO) {
                btn.selected = YES;
                selectMoneyBtn.selected = NO;
                selectMoneyBtn3.selected = NO;
            }
        }
            break;
        case LoanDetailBtnTagSelectMoney3:{
            if (btn.selected == NO) {
                btn.selected = YES;
                selectMoneyBtn2.selected = NO;
                selectMoneyBtn.selected = NO;
            }
        }
            break;
        case LoanDetailBtnTagSelectDate1:{
            if (btn.selected == NO) {
                btn.selected = YES;
                selectDateBtn2.selected = NO;
            }
        }
            break;
        case LoanDetailBtnTagSelectDate2:{
            if (btn.selected == NO) {
                btn.selected = YES;
                selectDateBtn.selected = NO;
            }
        }
            break;
        default:
            break;
    }
    switch (btn.tag) {
        case LoanDetailBtnTagSelectMoney1:
        case LoanDetailBtnTagSelectMoney2:
        case LoanDetailBtnTagSelectMoney3:
            selectMoney = btn.titleLabel.text;
            break;
        case LoanDetailBtnTagSelectDate1:
        case LoanDetailBtnTagSelectDate2:
            selectDate = btn.titleLabel.text;
        default:
            break;
    }
}
-(void)sliderValueChanged:(UISlider *)sender
{
    UISlider *slider = (UISlider *)sender;
    
    [self setNewSliderValue:slider andAccuracy:self.creditInfoModel.isFirstLoan.integerValue ? self.clientGlobalInfo.firstLoanAmtFixedDesc.integerValue :self.clientGlobalInfo.notFirstLoanAmtFixedDesc.integerValue] ;
   
//    sliderlab.text = [NSString stringWithFormat:@"%d",(int)sender.value];
 
}
-(void)setNewSliderValue:(UISlider *)slider andAccuracy:(float)accuracy
{
    // 滑动条的 宽
    float width = ScreenWidth - 2*AdaptationWidth(22.5) ;
    // 如： 用户想每滑动一次 增加100的量 每次滑块需要滑动的宽
    float slideWidth = width*accuracy/slider.maximumValue ;
    // 在滑动条中 滑块的位置 是根据 value值 显示在屏幕上的 那么 把目前滑块的宽 加上用户新滑动一次的宽 转换成value值
    // 根据当前value值 求出目前滑块的宽
    float currentSlideWidth =  slider.value/accuracy*slideWidth ;
    // 用户新滑动一次的宽加目前滑动的宽 得到新的 目前滑动的宽
    float newSlideWidth = currentSlideWidth+slideWidth ;
    // 转换成 新的 value值
    float value =  newSlideWidth/width*slider.maximumValue ;
    // 取整
    int d = (int)(value/accuracy) ;
    
    // 因为从0滑到100后在往回滑 即使滑到最左边 还是显示100 应该是算法有点问题 这里就不优化算法了 针对这种特殊情况做些改变
    if(d>2)
    {
        
        slider.value= d*accuracy ;
        sliderlab.text =  [NSString stringWithFormat:@"%li元", (long) slider.value] ;
    }
    else
    {
        if(d==0 || slider.value==0)
        {
            slider.value = 0 ;
        }
        else if(d==1)
        {
            slider.value = accuracy ;
        }
        else if(d==2)
        {
            slider.value = 2*accuracy ;
        }
        sliderlab.text =  [NSString stringWithFormat:@"%li元", (long) slider.value] ;
    }
}
- (void)setRequestParams{
    self.cmd = XGetUserBankList;
    self.dict = [NSDictionary dictionary];
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    self.dataSourceArr = response.data[@"dataRows"];
    if (self.dataSourceArr.count) {
        LoanOrderDetailVC *vc = [[LoanOrderDetailVC alloc]init];
        vc.orderAmt = [NSNumber numberWithDouble:[selectMoney doubleValue]] ;
        vc.stageTimeunitCnt = [NSNumber numberWithDouble:[selectDate doubleValue]] ;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BankViewController *vc = [[BankViewController alloc]init];
        vc.creditInfoModel = self.creditInfoModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
