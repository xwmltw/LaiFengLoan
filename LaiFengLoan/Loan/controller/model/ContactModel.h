//
//  contactModel.h
//  LaiFengLoan
//
//  Created by yanqb on 2018/11/8.
//  Copyright © 2018年 xwm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ImportantContactsInfo ,PhoneBookInfo;
@interface ContactModel : NSObject
@property (nonatomic, strong) NSArray <ImportantContactsInfo *> *contactList;
@property (nonatomic, strong) NSArray <PhoneBookInfo *> *phoneBookList;
@end

@interface ImportantContactsInfo :NSObject
@property (nonatomic, copy) NSString *contactAddress;
@property (nonatomic, copy) NSString *familyAddress;
@property (nonatomic, copy) NSString *relationship;
@property (nonatomic, copy) NSString *shipName;
@property (nonatomic, copy) NSString *shipPhone;
@property (nonatomic, copy) NSNumber *shipType;
@end

@interface PhoneBookInfo :NSObject
@property (nonatomic, copy) NSString *phoneName;
@property (nonatomic, copy) NSString *phoneNum;
@end
//contactList*    [
//                 重要联系人列表
//
//                 ImportantContactsInfo{
//                 description:
//                     重要联系信息结构
//
//                     contactAddress    string
//                     联系人详细地址,例：江苏省睢宁县睢城镇南关社区杨二组454号
//
//                     familyAddress    string
//                     联系人地址(省市县),例：江苏省 徐州市 睢宁县
//
//                     relationship*    string
//                     联系人关系名称,例: 配偶,父亲,母亲,同事
//
//                     shipName*    string
//                     联系人姓名,例:陈某某
//
//                     shipPhone*    string
//                     联系电话,例:15912345678
//                     shipType*    integer($int32)
//                     联系人类型,1第一联系人,2第二联系人
//
//                 }]
//phoneBookList*    [
//                   通信录列表
//                   PhoneBookInfo{
//                   description:
//                       通信录信息结构
//                       phoneName*    string
//                       联系人姓名
//                       phoneNum*    string
//                       联系人号码
//
//                   }]

