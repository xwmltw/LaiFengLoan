//
//  XCommonHepler.h
//  QuanWangDai
//
//  Created by yanqb on 2017/11/2.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCommonHepler : NSObject
@property (nonatomic, strong) UIWebView *phoneWebView;
@property (nonatomic, copy) XBlock block;
+ (instancetype)sharedInstance;

/** 邮箱校验 */
+ (BOOL)validateEmail:(NSString*)email;

/**
 *  传入模型数组，根据key字段 获取 字母 首拼音
 *
 *  @param array model array
 *
 *  @return 排序好的 字母数组
 */
+ (NSArray*)getNoRepeatSortLetterArray:(NSArray*)array letterKey:(NSString*)letterKey;

/** 获取中文名字首字母 */
+ (NSString*)getChineseNameFirstPinyinWithName:(NSString*)name;
/** 汉子转拼音 */
+ (NSString*)hanziToPinyinWith:(NSString*)hanziStr isChineseName:(BOOL)isChineseName;

/** 根据 URL 生成二维码图片 */
+ (UIImage*)createQrImageWithUrl:(NSString*)urlStr withImgWidth:(CGFloat)imgWidth;


/** 保存网络图片到相册 */
- (void)saveImageToPhotoLibWithImageUrl:(NSString *)imageUrl;
/** 保存图片到相册 */
- (void)saveImageToPhotoLib:(UIImage*)image;


/** 打印所有字体 */
+ (void)printAllFont;

/** 识别二维码图片 */
- (void)detectQRCodeWithImageUrl:(NSString *)imgUrl resultBlock:(XBlock)block;

//打开qq
+ (void)openQQWithNumber:(NSString*)qqNumber onViewController:(UIViewController*)vc block:(XBoolBlock)block;

/** 拨打电话 */
- (void)callWithPhone:(NSString *)phone;
/** 拨打电话 -- NSURL */
- (void)callWithPhoneUrl:(NSURL *)phoneUrl;

/** 拨打电话（系统） */
- (void)makeAlertCallWithPhone:(NSString *)phone block:(XBlock)block;

- (void)makeCallWithPhone:(NSString *)phone;

/** 打开itunes */
- (void)openItunesWithUrl:(NSURL *)url;

@end
