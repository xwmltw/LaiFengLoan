//
//  BaseViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "BaseViewController.h"
#import "AuthorizationHeadView.h"
#import "XChooseBankView.h"
#import "XChooseCityView.h"
#import "BaseModel.h"
#import "OperatorViewController.h"
#import "ContactViewController.h"
typedef NS_ENUM(NSInteger ,BaseTextFieldTag) {
    BaseTextFieldTagMarry = 1201,
    BaseTextFieldTagHomeCity,
    BaseTextFieldTagHomeAdress,
    BaseTextFieldTagCompanyName,
    BaseTextFieldTagCompanyAdress,
    BaseTextFieldTagCompanyPhone,
    BaseTextFieldTagCompanyPayDay,
};
typedef NS_ENUM(NSInteger ,BaseRequest) {
    BaseRequestGetInfo,
    BaseRequestPostInfo,
};
@interface BaseViewController ()<XChooseCityViewDelegate,XChooseBankPickerViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) XChooseCityView *cityView;
@property (nonatomic, strong) XChooseBankView *pickerView;
@property (nonatomic, strong) BaseModel *baseModel;
@property (nonatomic, strong) NSArray *marryAry;
@property (nonatomic, strong) NSArray *dateAry;
@property (nonatomic, strong) NSArray *blackAry;
@end

@implementation BaseViewController
{
    UITextField *detailTF;
}
-(void)BarbuttonClick:(UIButton *)button{
    if (self.isFromVC.integerValue) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基本信息填写";
    [self initUI];
    [self prepareDataWithCount:BaseRequestGetInfo];
    
    
}
- (void)initUI{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    AuthorizationHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"AuthorizationHead" owner:self options:nil].lastObject;
    headView.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(90));
    [headView setHeadImage:@3];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [self creatFooterView];
    self.marryAry = [NSArray arrayWithObjects:@"未婚",@"已婚", nil];
    self.dateAry = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",nil];
    self.blackAry = [NSArray arrayWithObjects:@"联系人信息",@"",@"", nil];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(80), AdaptationWidth(40))];
    [rightBtn setTitle:@"修改资料" forState:UIControlStateNormal];
    rightBtn.tag = 102;
    [rightBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:LabelMainColor forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:AdaptationWidth(14)]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (UIView *)creatFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(100))];
    
    UIButton *autBtn = [[UIButton alloc]init];
    autBtn.tag = 101;
    [autBtn setBorderWidth:1 andColor:AppMainColor];
    [autBtn setCornerValue:AdaptationWidth(22)];
    [autBtn setTitle:@"提交" forState:UIControlStateNormal];
    [autBtn setBackgroundColor:XColorWithRGB(56, 123, 230)];
    [autBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:autBtn];
    [autBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(view);
        make.height.mas_equalTo(AdaptationWidth(43));
        make.width.mas_equalTo(AdaptationWidth(250));
    }];
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"BaseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.textColor = XColorWithRGB(89, 99, 109);
        nameLab.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
        [cell.contentView addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell);
            make.left.mas_equalTo(cell).offset(AdaptationWidth(16));
            
        }];
        
        
        UIImageView *cellImage = [[UIImageView alloc]init];
        [cell.contentView addSubview:cellImage];
        [cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell).offset(AdaptationWidth(-16));
            make.centerY.mas_equalTo(cell);
            make.height.width.mas_equalTo(AdaptationWidth(28));
        }];
        
        detailTF  = [[UITextField alloc]init];
        detailTF.delegate = self;
        detailTF.textAlignment = NSTextAlignmentRight;
        detailTF.textColor = LabelMainColor;
        detailTF.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
        [cell addSubview:detailTF];
        
        switch (indexPath.row) {
            case 0:{
                nameLab.text = @"婚姻状况";
                detailTF.placeholder = @"请选择";
                detailTF.tag = BaseTextFieldTagMarry;
                detailTF.text = self.baseModel.isMarry;
                cellImage.image = [UIImage imageNamed:@"contactCell_down"];
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cellImage.mas_left).offset(AdaptationWidth(2));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
            case 1:{
                nameLab.text = @"现居住地址";
                detailTF.tag = BaseTextFieldTagHomeCity;
                detailTF.placeholder = @"请选择省市/地区";
                detailTF.text =self.baseModel.homeCity.length ? [NSString stringWithFormat:@"%@ %@ %@",self.baseModel.homeCity,self.baseModel.homeProvince,self.baseModel.homeTown] : @"";
                cellImage.image = [UIImage imageNamed:@"contactCell_down"];
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cellImage.mas_left).offset(AdaptationWidth(2));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
            case 2:{
                nameLab.text = @"";
                detailTF.tag = BaseTextFieldTagHomeAdress;
                detailTF.placeholder = @"请输入您的详细地址";
                detailTF.text = self.baseModel.homeAddr;
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cell).offset(AdaptationWidth(-16));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
            case 3:{
                nameLab.text = @"公司名称";
                detailTF.text = self.baseModel.companyName;
                detailTF.tag = BaseTextFieldTagCompanyName;
                detailTF.placeholder = @"请输入公司名称";
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cell).offset(AdaptationWidth(-16));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
            case 4:{
                nameLab.text = @"公司地址";
                detailTF.text = self.baseModel.companyAddr;
                detailTF.tag = BaseTextFieldTagCompanyAdress;
                detailTF.placeholder = @"请输入公司地址";
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cell).offset(AdaptationWidth(-16));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
            case 5:{
                nameLab.text = @"公司电话";
                detailTF.text = self.baseModel.companyPhone;
                detailTF.tag = BaseTextFieldTagCompanyPhone;
                detailTF.placeholder = @"请输入公司电话";
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cell).offset(AdaptationWidth(-16));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
            case 6:{
                nameLab.text = @"发薪日";
                detailTF.placeholder = @"请选择";
                detailTF.text = self.baseModel.companyPayDay;
                detailTF.tag = BaseTextFieldTagCompanyPayDay;
                cellImage.image = [UIImage imageNamed:@"contactCell_down"];
                [detailTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(cellImage.mas_left).offset(AdaptationWidth(2));
                    make.left.mas_equalTo(nameLab.mas_right).offset(16);
                }];
            }
                break;
                
            default:
                break;
        }
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma  mark - UITextFielddelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (textField.tag) {
        case BaseTextFieldTagHomeAdress:
        case BaseTextFieldTagCompanyName:
        case BaseTextFieldTagCompanyAdress:
        case BaseTextFieldTagCompanyPhone:{
            return YES;
        }
            break;
        case BaseTextFieldTagMarry:{
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.tag = 101;
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = self.marryAry;
            [self.pickerView showView];
        }
            break;
        case BaseTextFieldTagHomeCity:{
            self.cityView = [[XChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.cityView.delegate = self;
            [self.cityView showView];
        }
            break;
        case BaseTextFieldTagCompanyPayDay:{
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.tag = 102;
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = self.dateAry;
            [self.pickerView showView];
        }
            break;
        default:
            break;
    }
    return NO;
}
#pragma mark -XChooseBankView
- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row{
    switch (pickView.tag) {
        case 101:
        {
            self.baseModel.isMarry = self.marryAry[row];
            UITextField *text =(UITextField *)[self.view viewWithTag:BaseTextFieldTagMarry];
            text.text = self.marryAry[row];
        }
            break;
        case 102:
        {
            self.baseModel.companyPayDay = self.dateAry[row];
            UITextField *text =(UITextField *)[self.view viewWithTag:BaseTextFieldTagCompanyPayDay];
            text.text = self.dateAry[row];
        }
            break;
        case 103:{
            ContactViewController *vc = [[ContactViewController alloc]init];
            vc.isFromVC = @1;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma  mark - XChooseCityView
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(XChooseCityView *)chooseView{
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", province, city, town];
    self.baseModel.homeCity = city;
    self.baseModel.homeProvince = province;
    self.baseModel.homeTown = town;
    UITextField *text =(UITextField *)[self.view viewWithTag:BaseTextFieldTagHomeCity];
    text.text = address;
    
}
#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 101:
        {
            UITextField *homeAdress =(UITextField *)[self.view viewWithTag:BaseTextFieldTagHomeAdress];
            self.baseModel.homeAddr = homeAdress.text;
            
            UITextField *companyName =(UITextField *)[self.view viewWithTag:BaseTextFieldTagCompanyName];
            self.baseModel.companyName = companyName.text;
            
            UITextField *companyAdr =(UITextField *)[self.view viewWithTag:BaseTextFieldTagCompanyAdress];
            self.baseModel.companyAddr = companyAdr.text;
            
            UITextField *companyPhone =(UITextField *)[self.view viewWithTag:BaseTextFieldTagCompanyPhone];
            self.baseModel.companyPhone = companyPhone.text;
            
            if (!self.baseModel.isMarry.length) {
                [self setHudWithName:@"请选择婚姻状况" Time:1.5 andType:1];
                return;
            }
            if (!self.baseModel.homeAddr.length || !self.baseModel.homeCity.length) {
                [self setHudWithName:@"请填写现居住地址" Time:1.5 andType:1];
                return;
            }
            if (!self.baseModel.companyName.length) {
                [self setHudWithName:@"请填写公司名称" Time:1.5 andType:1];
                return;
            }
            if (!self.baseModel.companyAddr.length) {
                [self setHudWithName:@"请填写公司地址" Time:1.5 andType:1];
                return;
            }
            if (!self.baseModel.companyPhone.length) {
                [self setHudWithName:@"请填写公司电话号码" Time:1.5 andType:1];
                return;
            }
            if (!self.baseModel.companyPayDay.length) {
                [self setHudWithName:@"请选择发薪日" Time:1.5 andType:1];
                return;
            }
            [self prepareDataWithCount:BaseRequestPostInfo];
        }
            break;
        case 102:{
            
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.tag = 103;
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = @[@"联系人信息"];
            [self.pickerView showView];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - network
- (void)setRequestParams{
    
    switch (self.requestCount) {
        case BaseRequestGetInfo:
            self.cmd = XGetBaseVerify;
            self.dict = [NSDictionary dictionary];
            break;
        case BaseRequestPostInfo:
            self.cmd = XPostBaseVerify;
            self.dict = [self.baseModel mj_keyValues];
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case BaseRequestGetInfo:
            self.baseModel = [BaseModel mj_objectWithKeyValues:response.data];
            [self.tableView reloadData];
            break;
        case BaseRequestPostInfo:{
            [self setHudWithName:@"提交成功" Time:1.5 andType:1];
            if (self.isFromVC.integerValue) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            OperatorViewController *vc = [[OperatorViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (BaseModel *)baseModel{
    if (!_baseModel) {
        _baseModel = [[BaseModel alloc]init];
    }
    return _baseModel;
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
