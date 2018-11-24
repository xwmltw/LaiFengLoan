//
//  SecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
///将string转成带密码的data
+ (NSString*)encryptAESData:(NSString*)string;
///将带密码的data转成string
+ (NSString*)decryptAESData:(NSString*)string;

#pragma mark - md5加密
/**
 *  MD5加密, 32位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower32Bate:(NSString *)str;

/**
 *  MD5加密, 32位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper32Bate:(NSString *)str;

/**
 *  MD5加密, 16位 小写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForLower16Bate:(NSString *)str;

/**
 *  MD5加密, 16位 大写
 *
 *  @param str 传入要加密的字符串
 *
 *  @return 返回加密后的字符串
 */
+(NSString *)MD5ForUpper16Bate:(NSString *)str;


/*位异或加密*/
+(NSString *)encodeYiData:(NSString *)sourceString;
//Byte数组－>16进制数
+ (NSString *)bytesToHexString:(NSData *)data;

///字典转JSON
+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic;

///JSON转字段
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(NSString *)JSONString:(NSString *)aString;
@end
