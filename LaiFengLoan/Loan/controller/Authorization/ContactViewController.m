//
//  ContactViewController.m
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/5.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import "ContactViewController.h"
#import "AuthorizationHeadView.h"
#import "ContactModel.h"
#import "XChooseBankView.h"
#import "XChooseCityView.h"
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <AddressBook/AddressBook.h>
#import <ContactsUI/ContactsUI.h>
#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, ContactTextFieldTag) {
    ContactTextFieldTagFamilyName = 1101,
    ContactTextFieldTagFamilyShip,
    ContactTextFieldTagFamilyTel,
    ContactTextFieldTagFamilyAdress,
    ContactTextFieldTagFamilyContactAddress,
    ContactTextFieldTagFriendName,
    ContactTextFieldTagFriendShip,
    ContactTextFieldTagFriendTel,
};
typedef NS_ENUM(NSInteger ,ContactRequest) {
    ContactRequestGetInfo,
    ContactRequestPostInfo,
};
@interface ContactViewController ()<XChooseCityViewDelegate,XChooseBankPickerViewDelegate,UITextFieldDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>
@property (nonatomic, strong) UITextField *cellTF;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *addressTF;
@property (nonatomic, strong) UITextField *name2TF;
@property (nonatomic ,strong) UILabel *parentLab;
@property (nonatomic ,strong) UILabel *parentTelLab;
@property (nonatomic ,strong) UILabel *parentAddressLab;
@property (nonatomic ,strong) UILabel *friendLab;
@property (nonatomic ,strong) UILabel *friendTelLab;
@property (nonatomic, strong) ContactModel *contactModel;
@property (nonatomic, strong) ImportantContactsInfo *importantContactsInfo;
@property (nonatomic, strong) ImportantContactsInfo *importantContactsInfo2;
@property (nonatomic, strong) PhoneBookInfo *phoneBookInfo;
@property (nonatomic, strong) XChooseCityView *cityView;
@property (nonatomic, strong) XChooseBankView *pickerView;
@property (nonatomic, strong) NSArray *familyshipAry;
@property (nonatomic, strong) NSArray *friendshipAry;
@property (nonatomic, strong) NSMutableArray *allContactArray;

@end

@implementation ContactViewController
{
    NSInteger parentRow;
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
    self.title = @"联系人信息";
    [self initUI];
}
- (void)initUI{
    [self createTableViewWithFrame:CGRectZero];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    AuthorizationHeadView *headView = [[NSBundle mainBundle]loadNibNamed:@"AuthorizationHead" owner:self options:nil].lastObject;
    headView.frame = CGRectMake(0, 0, ScreenWidth, AdaptationWidth(90));
    [headView setHeadImage:@2];
    self.tableView.tableHeaderView = headView;
    self.tableView.tableFooterView = [self creatFooterView];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.allContactArray = [NSMutableArray array];
    self.familyshipAry = [NSArray arrayWithObjects:@"父母",@"配偶",@"子女",@"兄弟姐妹", nil];
    self.friendshipAry = [NSArray arrayWithObjects:@"同事",@"同学",@"朋友", nil];
    [self prepareDataWithCount:ContactRequestGetInfo];
}
- (UIView *)creatFooterView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, AdaptationWidth(100))];
    
    UIButton *autBtn = [[UIButton alloc]init];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    
    if (section == 1) {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LineColor;
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.right.mas_equalTo(view);
            make.height.mas_equalTo(8);
        }];
    }
    
    UIImageView *liveImage = [[UIImageView alloc]init];
    liveImage.image = [UIImage imageNamed:@"contactHead"];
    [view addSubview:liveImage];
    [liveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view).offset(AdaptationWidth(16));
        make.centerY.mas_equalTo(view);
        make.height.width.mas_equalTo(AdaptationWidth(20));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = section == 0 ? @"联系人1" : @"联系人2";
    label.textColor = XColorWithRGB(89, 99, 109);
    label.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(18)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(view);
        make.left.mas_equalTo(liveImage.mas_right).offset(AdaptationWidth(8));
        
    }];
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? 50 : 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return section == 0 ? 5 : 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AdaptationWidth(50);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ContactCell";
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
    
        self.cellTF = [[UITextField alloc]init];
        self.cellTF.delegate = self;
        self.cellTF.textAlignment = NSTextAlignmentRight;
        self.cellTF.textColor = LabelMainColor;
        self.cellTF.font = [UIFont fontWithName:@"PingFang SC" size:AdaptationWidth(16)];
        [cell.contentView addSubview:self.cellTF];
    
        [self.cellTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell);
            make.right.mas_equalTo(cell).offset(AdaptationWidth(-16));
            make.left.mas_equalTo(nameLab.mas_right).offset(16);
        }];
    
        if (indexPath.section == 0) {
            
            switch (indexPath.row) {
                case 1:
                {
                    nameLab.text = @"姓名";
                    UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(28), AdaptationWidth(28))];
                    self.cellTF.rightView = cellImage;
                    self.cellTF.rightViewMode = UITextFieldViewModeAlways;
                    cellImage.image = [UIImage imageNamed:@"contactCell_tel"];
                    self.cellTF.placeholder = @"请输入姓名";
                    self.cellTF.tag = ContactTextFieldTagFamilyName;
                    self.cellTF.text = self.importantContactsInfo.shipName;
                }
                    break;
                case 0:
                {
                    nameLab.text = @"关系";
                    UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(28), AdaptationWidth(28))];
                    self.cellTF.rightView = cellImage;
                    self.cellTF.rightViewMode = UITextFieldViewModeAlways;
                    cellImage.image = [UIImage imageNamed:@"contactCell_down"];
                    self.cellTF.placeholder = @"选择父母或配偶";
                    self.cellTF.tag = ContactTextFieldTagFamilyShip;
                    self.cellTF.text = self.importantContactsInfo.relationship;
                }
                    break;
                case 2:
                {
                    nameLab.text = @"电话号码";
                    
                    self.cellTF.placeholder = @"添加父母或配偶的手机号";
                    self.cellTF.tag = ContactTextFieldTagFamilyTel;
                    self.cellTF.text = self.importantContactsInfo.shipPhone;
                }
                    break;
                case 3:
                {
                    nameLab.text = @"家庭详细地址";
                    UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(28), AdaptationWidth(28))];
                    self.cellTF.rightView = cellImage;
                    self.cellTF.rightViewMode = UITextFieldViewModeAlways;
                    cellImage.image = [UIImage imageNamed:@"contactCell_down"];
                    self.cellTF.placeholder = @"请选择省市/地区";
                    self.cellTF.tag = ContactTextFieldTagFamilyAdress;
                    self.cellTF.text = self.importantContactsInfo.familyAddress;
                }
                    break;
                case 4:
                {
                    nameLab.text = @"";
                    self.cellTF.placeholder = @"请输入您的详细地址";
                    self.cellTF.tag = ContactTextFieldTagFamilyContactAddress;
                    self.cellTF.text = self.importantContactsInfo.contactAddress;
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 1:
                {
                    nameLab.text = @"姓名";
                    self.cellTF.placeholder = @"请输入姓名";
                    UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(28), AdaptationWidth(28))];
                    self.cellTF.rightView = cellImage;
                    self.cellTF.rightViewMode = UITextFieldViewModeAlways;
                    cellImage.image = [UIImage imageNamed:@"contactCell_tel"];
                    self.cellTF.tag = ContactTextFieldTagFriendName;
                    self.cellTF.text = self.importantContactsInfo2.shipName;
                }
                    break;
                case 0:
                {
                    nameLab.text = @"关系";
                    UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AdaptationWidth(28), AdaptationWidth(28))];
                    self.cellTF.rightView = cellImage;
                    self.cellTF.rightViewMode = UITextFieldViewModeAlways;
                    cellImage.image = [UIImage imageNamed:@"contactCell_down"];
                    self.cellTF.placeholder = @"选择同事或朋友";
                    self.cellTF.tag = ContactTextFieldTagFriendShip;
                    self.cellTF.text = self.importantContactsInfo2.relationship;
                }
                    break;
                case 2:
                {
                    nameLab.text = @"电话号码";
                    
                    self.cellTF.placeholder = @"添加同事或朋友的手机号";
                    self.cellTF.tag = ContactTextFieldTagFriendTel;
                    self.cellTF.text = self.importantContactsInfo2.shipPhone;
                }
                    break;
                default:
                    break;
            }
        }
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark -XChooseBankView
- (void)chooseThing:(NSString *)thing pickView:(XChooseBankView *)pickView row:(NSInteger)row{
    switch (pickView.tag) {
        case 101:
        {   
            self.importantContactsInfo.relationship = self.familyshipAry[row];
            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyShip];
            textTF.text = self.familyshipAry[row];
        }
            break;
        case 102:
        {
            self.importantContactsInfo2.relationship = self.friendshipAry[row];
            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFriendShip];
            textTF.text = self.friendshipAry[row];
        }
            break;
            
        default:
            break;
    }
}
#pragma  mark - XChooseCityView
- (void)chooseCityWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town chooseView:(XChooseCityView *)chooseView{
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", province, city, town];
    self.importantContactsInfo.familyAddress = address;
    UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyAdress];
    textTF.text = address;

}
#pragma  mark - UITextFielddelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    switch (textField.tag) {
//        case ContactTextFieldTagFamilyName:
        case ContactTextFieldTagFamilyContactAddress:
//        case ContactTextFieldTagFriendName:
        {
            return YES;
        }
            break;
        case ContactTextFieldTagFamilyShip:
        {
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.tag = 101;
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = self.familyshipAry;
            [self.pickerView showView];
        }
            break;
        case ContactTextFieldTagFamilyName:
//        case ContactTextFieldTagFamilyTel:
        {
            parentRow = ContactTextFieldTagFamilyName;
            [self getContactPermission];
        }
            break;
        case ContactTextFieldTagFamilyAdress:
        {
            self.cityView = [[XChooseCityView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.cityView.delegate = self;
            [self.cityView showView];
        }
            break;
        case ContactTextFieldTagFriendShip:{
            self.pickerView  = [[XChooseBankView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.pickerView.tag = 102;
            self.pickerView.delegate = self;
            self.pickerView.chooseThings = self.friendshipAry;
            [self.pickerView showView];
        }
            break;
        case ContactTextFieldTagFriendName:
//        case ContactTextFieldTagFriendTel:
        {
            parentRow = ContactTextFieldTagFriendName;
            [self getContactPermission];
        }
            break;
        default:
            break;
    }
    return NO;
}
#pragma mark - btn
- (void)btnOnClick:(UIButton *)btn{
    
    if (!self.importantContactsInfo.relationship.length) {
        [self setHudWithName:@"请选择联系人关系" Time:1.5 andType:1];
        return;
    }
    if (!self.importantContactsInfo.shipName.length) {
        [self setHudWithName:@"请填写联系人1姓名" Time:1.5 andType:1];
        return;
    }
    
    UITextField *contactAddress =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyContactAddress];
    if (!contactAddress.text.length || !self.importantContactsInfo.familyAddress.length) {
        [self setHudWithName:@"请填写详细地址" Time:1.5 andType:1];
        return;
    }
    self.importantContactsInfo.contactAddress = contactAddress.text;
    
    if (!self.importantContactsInfo2.relationship.length) {
        [self setHudWithName:@"请选择联系人2关系" Time:1.5 andType:1];
        return;
    }
    if (!self.importantContactsInfo2.shipName.length) {
        [self setHudWithName:@"请填写联系人2姓名" Time:1.5 andType:1];
        return;
    }

    
    [self prepareDataWithCount:ContactRequestPostInfo];
}
#pragma mark - network
- (void)setRequestParams{
    
    switch (self.requestCount) {
        case ContactRequestGetInfo:
            self.cmd = XGetContactVerify;
            self.dict = [NSDictionary dictionary];
            break;
        case ContactRequestPostInfo:
            self.cmd = XPostContactVerify;
            self.dict = [self.contactModel mj_keyValues];
            break;
            
        default:
            break;
    }
}
- (void)requestSuccessWithDictionary:(XResponse *)response{
    switch (self.requestCount) {
        case ContactRequestGetInfo:{
            ContactModel *model = [ContactModel mj_objectWithKeyValues:response.data];
            if (model.contactList.count) {
                self.contactModel = model;
                self.importantContactsInfo = self.contactModel.contactList[0];
                self.importantContactsInfo2 = self.contactModel.contactList[1];
            }
            [self.tableView reloadData];
        }
            break;
        case ContactRequestPostInfo:{
            [self setHudWithName:@"提交成功" Time:1.5 andType:1];
            if (self.isFromVC.integerValue) {
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            BaseViewController *vc = [[BaseViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -lan
- (ContactModel *)contactModel{
    if (!_contactModel) {
        _contactModel = [[ContactModel alloc]init];
        _contactModel.contactList = [NSArray arrayWithObjects:self.importantContactsInfo,self.importantContactsInfo2, nil];
        _contactModel.phoneBookList = [NSArray arrayWithObjects:self.phoneBookInfo, nil];
    }
    return _contactModel;
}
- (ImportantContactsInfo *)importantContactsInfo{
    if (!_importantContactsInfo) {
        _importantContactsInfo = [[ImportantContactsInfo alloc]init];
        self.importantContactsInfo.shipType = @1;
    }
    return _importantContactsInfo;
}
- (ImportantContactsInfo *)importantContactsInfo2{
    if (!_importantContactsInfo2) {
        _importantContactsInfo2 = [[ImportantContactsInfo alloc]init];
        self.importantContactsInfo2.shipType = @2;
    }
    return _importantContactsInfo2;
}
- (PhoneBookInfo *)phoneBookInfo{
//    if (!_phoneBookInfo) {
        _phoneBookInfo = [[PhoneBookInfo alloc]init];
//    }
    return _phoneBookInfo;
}

#pragma  mark - 获取本地联系方式
- (void)getContactPermission{
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
                ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
                nav.peoplePickerDelegate = self;
                nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook];
            ABPeoplePickerNavigationController *nav = [[ABPeoplePickerNavigationController alloc] init];
            nav.peoplePickerDelegate = self;
            nav.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
            [self presentViewController:nav animated:YES completion:nil];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->通讯录按钮"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                        [[UIApplication sharedApplication] openURL:url];
                    }else {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                        
                    }
                }
            }];
            
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果尚未决定是否授权,在程序第一次启动的时候请求授权
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            
            [contactStore requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求授权失败,error:%@",error);
                    return ;
                }
                NSLog(@"请求授权成功!");
                [self presentContactController];
            }];
        }else {
            [self presentContactController];
        }
    }
}

- (void)presentContactController
{
    if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusAuthorized) {
        CNContactPickerViewController *contactPickerVc = [CNContactPickerViewController new];
        
        contactPickerVc.delegate = self;
        
        [self presentViewController:contactPickerVc animated:YES completion:^{
            [self getAllContactsAuthorization];
        }];
    }else if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusDenied) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"请打开系统设置->隐私->通讯录按钮"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
            
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if([[UIApplication sharedApplication] canOpenURL:url]) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIDevice currentDevice].systemVersion doubleValue] < 10.0) {
                    [[UIApplication sharedApplication] openURL:url];
                }else {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    
                }
            }
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)getAllContactsAuthorization
{
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 9.0) {
        ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
        
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
                
                CFErrorRef *error1 = NULL;
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error1);
                [self copyAddressBook:addressBook];
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
            
            CFErrorRef *error = NULL;
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
            [self copyAddressBook:addressBook];
        }
    }else {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        //如果尚未决定是否授权,在程序第一次启动的时候请求授权
        if (status == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [CNContactStore new];
            
            [contactStore requestAccessForEntityType:0 completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"请求授权失败,error:%@",error);
                    return ;
                }
                NSLog(@"请求授权成功!");
                [self getAllContacts];
            }];
        }else {
            [self getAllContacts];
        }
    }
}

- (void)getAllContacts
{
    if (_allContactArray.count > 0) {
        return;
    }
    [_allContactArray removeAllObjects];
    if ([CNContactStore authorizationStatusForEntityType:0] == CNAuthorizationStatusAuthorized) {
        //如果被授权访问通讯录,进行访问相关操作
        CNContactStore *contactStore = [CNContactStore new];
        
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey]];
        
        NSError *error = nil;
        
        BOOL result = [contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            NSString *phoneName = [NSString stringWithFormat:@"%@%@", contact.familyName, contact.givenName];
            //            NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
            NSCharacterSet *allowedCharacters =  [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）￥「」＂、[]{}#%-*+=_\\|~＜＞$€^·'@#$%^&*()_+'"];
            phoneName = [phoneName stringByTrimmingCharactersInSet:allowedCharacters];
            NSString *phone = @"";
            int i = 0;
            for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
                ++i;
                if (i<contact.phoneNumbers.count) {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@,", [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue]]];
                }else {
                    CNPhoneNumber *phoneNumber = labeledValue.value;
                    phone = [phone stringByAppendingString:[NSString stringWithFormat:@"%@", [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue]]];
                }
                
            }
            if (phoneName.length && phone.length) {
//                NSDictionary *contactDict = @{@"phone_name":phoneName, @"phone":phone};
                self.phoneBookInfo.phoneName =phoneName;
                _phoneBookInfo.phoneNum =phone;
                [_allContactArray addObject:_phoneBookInfo];
            }
            
        }];
        
        if (!result) {
            NSLog(@"读取失败,error:%@",error);
            return;
        }
        NSLog(@"读取成功");
        self.contactModel.phoneBookList = _allContactArray;
    }
}

#pragma mark - 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty{
    
    CNContact *contact = contactProperty.contact;
    
    if ([contactProperty.value isKindOfClass:[NSString class]]) {
        return;
    }
    CNPhoneNumber *phoneNumber = contactProperty.value;
    
    switch (parentRow) {
        case ContactTextFieldTagFamilyName:
        {
            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyName];
            textTF.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            
            UITextField *textTF2 =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyTel];
            textTF2.text = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];

            self.importantContactsInfo.shipName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            self.importantContactsInfo.shipPhone = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
        }
            break;
        case ContactTextFieldTagFriendName:
        {
            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFriendName];
            textTF.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            
            UITextField *textTF2 =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFriendTel];
            textTF2.text = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
            self.importantContactsInfo2.shipName = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            self.importantContactsInfo2.shipPhone = [self phoneStringWithNoSpaceAndDash:phoneNumber.stringValue];
        }
            break;
            
        default:
            break;
    }
    

}

- (NSString *)phoneStringWithNoSpaceAndDash:(NSString *)string
{
    NSCharacterSet *charSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filteredStr = [[string componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
    if(filteredStr.length == 13 ){//去除86开头
        filteredStr = [filteredStr substringFromIndex:2];
    }
    return filteredStr;
}

- (BOOL)phoneStringWithNSPredicate:(NSString *)string{
    if (string.length == 11) {
        NSString *str = [string substringToIndex:1];
        if ([str isEqualToString:@"1"]) {
            return YES;
        }
        return NO;
    }
    return NO;
}
#pragma mark - 支持iOS9以下获取通讯录
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
    NSString *phoneName = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
    
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
    
    //获取联系人名称和电话号码
   
//    switch (parentRow) {
//        case ContactTextFieldTagFamilyName:
//        {
//            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyTel];
//            textTF.text = [self phoneStringWithNoSpaceAndDash:phoneNO];
//            //            self.parentModel.ship_name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
//            self.importantContactsInfo.shipPhone = [self phoneStringWithNoSpaceAndDash:phoneNO];
//        }
//            break;
//        case ContactTextFieldTagFriendName:
//        {
//            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFriendTel];
//            textTF.text = [self phoneStringWithNoSpaceAndDash:phoneNO];
//            //            self.contactModel.ship_name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
//            self.importantContactsInfo2.shipPhone = [self phoneStringWithNoSpaceAndDash:phoneNO];
//        }
//            break;
//
//        default:
//            break;
//    }
    
    switch (parentRow) {
        case ContactTextFieldTagFamilyName:
        {
            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyName];
            textTF.text = [NSString stringWithFormat:@"%@%@",firstName,lastName];
            
            UITextField *textTF2 =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFamilyTel];
            textTF2.text = [self phoneStringWithNoSpaceAndDash:phoneNO];
            
            self.importantContactsInfo.shipName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
            self.importantContactsInfo.shipPhone = [self phoneStringWithNoSpaceAndDash:phoneNO];
        }
            break;
        case ContactTextFieldTagFriendName:
        {
            UITextField *textTF =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFriendName];
            textTF.text = [NSString stringWithFormat:@"%@%@",firstName,lastName];
            
            UITextField *textTF2 =(UITextField *)[self.view viewWithTag:ContactTextFieldTagFriendTel];
            textTF2.text = [self phoneStringWithNoSpaceAndDash:phoneNO];
            self.importantContactsInfo2.shipName = [NSString stringWithFormat:@"%@%@",firstName,lastName];
            self.importantContactsInfo2.shipPhone = [self phoneStringWithNoSpaceAndDash:phoneNO];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person
{
    ABPersonViewController *personViewController = [[ABPersonViewController alloc] init];
    personViewController.displayedPerson = person;
    [peoplePicker pushViewController:personViewController animated:YES];
}

- (void)copyAddressBook:(ABAddressBookRef)addressBook
{
    CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    [_allContactArray removeAllObjects];
    for ( int i = 0; i < numberOfPeople; i++){
        ABRecordRef person = CFArrayGetValueAtIndex(people, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(person, kABPersonLastNameProperty));
        NSString *phoneName = [NSString stringWithFormat:@"%@%@", lastName?lastName:@"", firstName?firstName:@""];
        
        //读取电话多值
        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *phoneString = @"";
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            
            if (k < ABMultiValueGetCount(phone)-1) {
                phoneString = [phoneString stringByAppendingString:[NSString stringWithFormat:@"%@,", [self phoneStringWithNoSpaceAndDash:personPhone]]];
            }else {
                phoneString = [phoneString stringByAppendingString:[NSString stringWithFormat:@"%@", [self phoneStringWithNoSpaceAndDash:personPhone]]];
            }
            
        }
        if (phoneName.length && phoneString.length) {
            self.phoneBookInfo.phoneName =phoneName;
            _phoneBookInfo.phoneNum =phoneString;
            [_allContactArray addObject:_phoneBookInfo];
        }
       
        
    }
   self.contactModel.phoneBookList = _allContactArray;
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
