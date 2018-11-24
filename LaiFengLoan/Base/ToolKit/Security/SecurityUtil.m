//
//  SecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import "SecurityUtil.h"
#import "GTMBase64.h"
#import "NSData+AES.h"
#import <CommonCrypto/CommonCrypto.h>
//#define Iv          @"number1Mochouhua" //偏移量,可自行修改
//#define KEY         @"mochouhuaNumber1" //key，可自行修改
#define Iv          @"quanwang2017dai1" //偏移量,可自行修改
#define KEY         @"2017quanwangdai1" //key，可自行修改

 //位异或对应的key,与后台确定

@implementation SecurityUtil

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input { 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [GTMBase64 encodeData:data]; 
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
    
}

+ (NSString*)decodeBase64String:(NSString * )input { 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    data = [GTMBase64 decodeData:data]; 
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
} 

+ (NSString*)encodeBase64Data:(NSData *)data {
	data = [GTMBase64 encodeData:data]; 
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
	data = [GTMBase64 decodeData:data]; 
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	return base64String;
}

#pragma mark - AES加密
//将string转成带密码的data
+(NSString*)encryptAESData:(NSString*)string
{
    //将nsstring转化为nsdata
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    //使用密码对nsdata进行加密
    NSData *encryptedData = [data AES128EncryptWithKey:KEY gIv:Iv];
    //返回进行base64进行转码的加密字符串
   NSString *base64String = [self encodeBase64Data:encryptedData];
    
    return [self encodeYiData:base64String];
}

#pragma mark - AES解密
//将带密码的data转成string
+(NSString*)decryptAESData:(NSString *)string
{
    //异或
    NSString *changeString = [self encodeYiData:string];
//    MyLog(@"change-->%@",changeString);
    //base64解密
    NSData *decodeBase64Data=[GTMBase64 decodeString:changeString];
    //使用密码对data进行解密
    NSData *decryData = [decodeBase64Data AES128DecryptWithKey:KEY gIv:Iv];
    //将解了密码的nsdata转化为nsstring
    NSString *str = [[NSString alloc] initWithData:decryData encoding:NSUTF8StringEncoding];
    return str;
}

#pragma mark - md5 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - md5 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
//    CC_MD5(input, (unsigned int) [str lengthOfBytesUsingEncoding:NSUTF8StringEncoding], result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - md5 16位 大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - md5 16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}



#pragma mark -- 位异或

/**
 *  异或加密算法
 *
 *
 *  @return 加密后的字节流
 */
+(NSString *)encodeYiData:(NSString *)sourceString{
    NSData *sourceData = [sourceString dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *keyData = [WEIYIHUOKEY dataUsingEncoding:NSUTF8StringEncoding];
//    Byte *keyBytes = (Byte *)[keyData bytes];   //取关键字的Byte数组, keyBytes一直指向头部
    
    Byte *sourceDataPoint = (Byte *)[sourceData bytes];  //取需要加密的数据的Byte数组
    
//    for (long i = 0; i < [sourceData length]; i++) {
//        sourceDataPoint[i] = sourceDataPoint[i] ^ keyBytes[(i % [keyData length])]; //然后按位进行异或运算
//    }
    
    for (long i = 0; i < [sourceData length]; i++) {
        sourceDataPoint[i] = sourceDataPoint[i] ^ 7; //然后按位进行异或运算
    }

    
    NSString *string = [[NSString alloc]initWithData:sourceData encoding:NSUTF8StringEncoding];
    
    return string;
}

//Byte数组－>16进制数
+ (NSString *)bytesToHexString:(NSData *)data{
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for (NSUInteger i = 0; i < data.length; i++){
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    //    ELog(@"bytes 的16进制数为:%@",hexStr);
    return hexStr;
}


///字典转JSON
+ (NSString*)dictionaryToJson:(NSMutableDictionary *)dic {
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

///JSON转字段
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}
//字符串转json
//+(NSString *) jsonStringWithString:(NSString *) string{
//    return [NSString stringWithFormat:@"%@",[[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"" withString:@"\\"]
//            ];
//}
+ (NSString *)JSONString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}
@end
