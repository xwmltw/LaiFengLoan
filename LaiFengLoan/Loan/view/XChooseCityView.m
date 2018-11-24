//
//  XChooseCityView.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/27.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XChooseCityView.h"


@interface XChooseCityView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;

/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

@property (nonatomic, strong) UIPickerView *pick;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;

@end

@implementation XChooseCityView
{
    UIView *buttonView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupData];
    [self setupView];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 animations:^{
        _pick.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 216);
        buttonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - data
- (void)setupData
{
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj[@"name"]];
    }];
    
    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"districts"]];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj[@"name"]];
    }];
    
    self.arrayArea = [citys firstObject][@"districts"];
    
    self.province = self.arrayProvince[0];
    self.city = self.arrayCity[0];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[0][@"name"];
    }else{
        self.area = @"";
    }
    
}


- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
        
//        NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
//        _arrayRoot = [[NSArray alloc]initWithContentsOfFile:path];
        NSString *path = [[NSBundle mainBundle]pathForResource:@"content" ofType:@"json"];
//        NSData *data = [[NSData alloc]initWithContentsOfFile:path];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableLeaves error:nil];

        _arrayRoot = [NSArray arrayWithArray:dic[@"districts"][0][@"districts"]];
//        MyLog(@"%@",_arrayRoot);
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
        _arrayProvince = [NSMutableArray array];
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
        _arrayCity = [NSMutableArray array];
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
        _arrayArea = [NSMutableArray array];
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row][@"name"];
        }else{
            text =  @"";
        }
    }
    return text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.arraySelected = self.arrayRoot[row][@"districts"];
        
        [self.arrayCity removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"name"]];
        }];
        
        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"districts"]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            self.arraySelected = [self.arrayRoot firstObject][@"districts"];
        }
        
        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"districts"]];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else{
    }
    
    [self reloadData];
    
}

- (void)reloadData
{
    NSInteger index0 = [self.pick selectedRowInComponent:0];
    NSInteger index1 = [self.pick selectedRowInComponent:1];
    NSInteger index2 = [self.pick selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.city = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2][@"name"];
    }else{
        self.area = @"";
    }
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
        _pick.frame = CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216);
        buttonView.frame = CGRectMake(0, ScreenHeight-216-50, ScreenWidth, 50);
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

- (void)cancleButtonPressed
{
    [UIView animateWithDuration:0.3 animations:^{
        _pick.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 216);
        buttonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sureButtonPressed
{
    [UIView animateWithDuration:0.3 animations:^{
        _pick.frame = CGRectMake(0, ScreenHeight , ScreenWidth, 216);
        buttonView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseCityWithProvince:city:town:chooseView:)]) {
        [_delegate chooseCityWithProvince:self.province city:self.city town:self.area chooseView:self];
    }
    
}

- (void)showView
{
    [[[UIApplication sharedApplication]keyWindow] addSubview:self];
}
@end
