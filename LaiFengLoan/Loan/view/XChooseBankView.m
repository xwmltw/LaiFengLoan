//
//  XChooseBankView.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/28.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XChooseBankView.h"
@interface XChooseBankView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pick;
@end
@implementation XChooseBankView
{
    NSString *_chooseThing;
    NSInteger _row;
    UIView *buttonView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)setChooseThings:(NSArray *)chooseThings
{
    _chooseThings = chooseThings;
    _chooseThing = _chooseThings[0];
    [self setupView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(userCancelPick:)]) {
        [_delegate userCancelPick:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self->_pick.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 216);
        self->buttonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    } completion:^(BOOL finished) {
//        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//        statusBar.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
}

#pragma mark - view
- (void)setupView
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    _pick = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 216)];
    _pick.delegate = self;
    _pick.dataSource = self;
    _pick.backgroundColor = [UIColor whiteColor];
    
    
    buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 50)];
    buttonView.backgroundColor = [UIColor whiteColor];
    
    // 浮现
    [UIView animateWithDuration:0.3 animations:^{
        self->_pick.frame = CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216);
        self->buttonView.frame = CGRectMake(0, ScreenHeight-216-50, ScreenWidth, 50);
    } completion:^(BOOL finished) {
    }];
    [self addSubview:_pick];
    [self addSubview:buttonView];
    
    UIButton *cancleButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 40)];
    cancleButton.backgroundColor = [UIColor whiteColor];
    [cancleButton setTitleColor:LabelShallowColor forState:UIControlStateNormal];
    [cancleButton addTarget: self action:@selector(cancleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [buttonView addSubview:cancleButton];
    
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-10-60, 5, 60, 40)];
    [sureButton addTarget: self action:@selector(sureButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:AppMainColor forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [buttonView addSubview:sureButton];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _chooseThings.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _chooseThings[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _chooseThing = _chooseThings[row];
    _row = row;;
}

- (void)showView{
   [self showInView:[[UIApplication sharedApplication]keyWindow]];

}
//添加弹出移除的动画效果
- (void)showInView:(UIView *)view{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    statusBar.backgroundColor = [UIColor clearColor];
    [view addSubview:self];
}
- (void)cancleButtonPressed
{
    if (_delegate && [_delegate respondsToSelector:@selector(userCancelPick:)]) {
        [_delegate userCancelPick:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self->_pick.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 216);
        self->buttonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)sureButtonPressed
{
    [UIView animateWithDuration:0.3 animations:^{
        self->_pick.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 216);
        self->buttonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    } completion:^(BOOL finished) {
//        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
//        statusBar.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseThing:pickView:row:)]) {
        [_delegate chooseThing:_chooseThing pickView:self row:_row];
    }
    
}


@end
