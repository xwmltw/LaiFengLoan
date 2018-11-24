//
//  XCommonHepler.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/2.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XCommonHepler.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@implementation XCommonHepler
XSharedInstance(XCommonHelper);

//邮箱校验
+ (BOOL)validateEmail:(NSString*)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//传入数组，根据 key 字段 获取字母 首拼音， 返回排序好的字母数组
+ (NSArray*)getNoRepeatSortLetterArray:(NSArray*)array letterKey:(NSString*)letterKey{
    // 获取字母数组
    NSArray* tempArray = [array valueForKey:letterKey];
    
    // 去重
    NSMutableDictionary* tempDic = [[NSMutableDictionary alloc] init];
    for (NSString *letter in tempArray) {
        [tempDic setObject:letter forKey:letter];
    }
    // 排序
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray* descArray = [NSArray arrayWithObject:desc];
    NSArray* sortArray = [tempDic.allValues sortedArrayUsingDescriptors:descArray];
    
    // 拼音首字母转换为大写
    NSMutableArray* upLetterArray = [NSMutableArray array];
    for (NSString* letter in sortArray) {
        NSString* tempLetter = [NSString stringWithString:letter.uppercaseString];
        [upLetterArray addObject:tempLetter];
    }
    return upLetterArray;
}

+ (NSString*)getChineseNameFirstPinyinWithName:(NSString*)name{
    return [[self hanziToPinyinWith:name isChineseName:YES] substringToIndex:1];
}

+ (NSString*)hanziToPinyinWith:(NSString*)hanziStr isChineseName:(BOOL)isChineseName{
    if (hanziStr.length == 0) {
        return hanziStr;
    }
    
    NSMutableString* ms = [[NSMutableString alloc] initWithString:hanziStr];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);     //转拼音
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);   //去声调
    if (isChineseName) {
        if ([[(NSString*)hanziStr substringToIndex:1] compare:@"长"] == NSOrderedSame) {
            [ms replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"沈"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 4)withString:@"shen"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"厦"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 3)withString:@"xia"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"地"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 2)withString:@"di"];
        }
        if ([[(NSString *)hanziStr substringToIndex:1] compare:@"重"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
        }
    }
    
    return ms;
}




+ (UIImage*)createQrImageWithUrl:(NSString*)urlStr withImgWidth:(CGFloat)imgWidth{
    
    NSData* stringData = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = qrFilter.outputImage;
    
    CGRect extent = CGRectIntegral(ciImage.extent);
    
    CGFloat scale = MIN(imgWidth/CGRectGetWidth(extent), imgWidth/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent)* scale;
    size_t height = CGRectGetHeight(extent)* scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage* qrImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    return qrImage;
}


/** 保存网络图片到相册 */
- (void)saveImageToPhotoLibWithImageUrl:(NSString *)imageUrl{
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    UIImage* image = [UIImage imageWithData:data];
    
    if (image) {
        [self saveImageToPhotoLib:image];
    }
}

/** 保存图片到相册 */
- (void)saveImageToPhotoLib:(UIImage*)image{

    [XCommonHepler getPHAuthorization:^(id result) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    NSString* msg = nil;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
//    [UIHelper toast:msg];
}
+ (void)getPHAuthorization:(XBlock)block{
    PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
    
    switch (authorizationStatus) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getPHAuthorization:block];
                });
            }];
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            
            };
            break;
        case PHAuthorizationStatusAuthorized:{
            XBlockExec(block, nil);
        }
            break;
        default:
            break;
    }
}
/** 打印所有字体 */
+ (void)printAllFont{
    NSArray* familyNames = [[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray* fontNames;
    NSInteger indFamily, indFont;
    MyLog(@"familyNames count: %lu", (unsigned long)familyNames.count);
    for (indFamily = 0; indFamily < familyNames.count; ++indFamily) {
        MyLog(@"family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        for (indFont = 0; indFont < fontNames.count; indFont++) {
            MyLog(@"     font name:%@", [fontNames objectAtIndex:indFont]);
        }
    }
}

/** 识别二维码图片 */
- (void)detectQRCodeWithImageUrl:(NSString *)imgUrl resultBlock:(XBlock)block{
    if (!imgUrl.length) {
        XBlockExec(block, nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *dataImg = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        UIImage *image = [UIImage imageWithData:dataImg];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!image) {
                XBlockExec(block, nil);
                return;
            }
            //监测到的结果数组
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh}];
            NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
            if (features.count >=1) {
                /**结果对象 */
                CIQRCodeFeature *feature = [features objectAtIndex:0];
                NSString *scannedResult = feature.messageString;
                XBlockExec(block, scannedResult);
            }
            else{
                //        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                //        [alertView show];
                XBlockExec(block, nil);
            }
        });
    });
    
}

+ (void)openQQWithNumber:(NSString*)qqNumber onViewController:(UIViewController*)vc block:(XBoolBlock)block{
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        if (block) {
            block(NO);
        }
        return;
    }
    NSString* urlStr = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",qqNumber];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    //    webView.delegate = self;
    [vc.view addSubview:webView];
}

/** 拨打电话 */
- (void)callWithPhone:(NSString *)phone{
    if (!self.phoneWebView) {
        self.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]]]];
}

/** 拨打电话 -- NSURL */
- (void)callWithPhoneUrl:(NSURL *)phoneUrl{
    if (!self.phoneWebView) {
        self.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneWebView loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
}

/** 拨打电话（系统） */
- (void)makeAlertCallWithPhone:(NSString *)phone block:(XBlock)block{
    self.block = block;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                XBlockExec(self.block, nil);
                [[UIApplication sharedApplication] openURL:url];
            }
 
}

- (void)makeCallWithPhone:(NSString *)phone{
    [self makeAlertCallWithPhone:phone block:nil];
}

/** 打开itunes */
- (void)openItunesWithUrl:(NSURL *)url{
    if (!self.phoneWebView) {
        self.phoneWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneWebView loadRequest:[NSURLRequest requestWithURL:url]];
}


@end
