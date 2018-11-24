//
//  SCCaptureSessionManager.h
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-16.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SCDefines.h"
#include "Globaltypedef.h"
#define MAX_PINCH_SCALE_NUM   3.f
#define MIN_PINCH_SCALE_NUM   1.f

@protocol SCCaptureSessionManager;

typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);

@interface SCCaptureSessionManager : NSObject


@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *output;
//@property (nonatomic, strong) UIImage *stillImage;
@property(nonatomic,assign)CGPoint  beginPoint;
@property(nonatomic,assign)CGPoint endPoint;
@property (nonatomic, assign) id SCCaptureSessionDelegate;
//pinch
@property (nonatomic, assign) CGFloat preScaleNum;
@property (nonatomic, assign) CGFloat scaleNum;
@property (nonatomic, assign) TCARD_TYPE iCardType;
@property (nonatomic, assign) TIDC_REC_MODE ScanMode;       /*身份证是否为扫描模式 默认拍照模式*/
@property (nonatomic, assign) BOOL isRun1;
@property (nonatomic, assign) id <SCCaptureSessionManager> delegate;



- (void)configureWithParentLayer:(UIView*)parent previewRect:(CGRect)preivewRect;

- (void)takePicture:(DidCapturePhotoBlock)block;
- (void)switchCamera:(BOOL)isFrontCamera;
- (void)pinchCameraViewWithScalNum:(CGFloat)scale;
- (void)pinchCameraView:(UIPinchGestureRecognizer*)gesture;
- (void)switchFlashMode:(UIButton*)sender;
- (void)focusInPoint:(CGPoint)devicePoint;
- (void)switchGrid:(BOOL)toShow;
- (CGRect) calcRect:(CGSize)imageSize cropRect:(CGRect) cpRect;
- (void)SetValuePoint:(CGPoint)begin End:(CGPoint)end;
- (void)SetCardType:(TCARD_TYPE) iCardType Mode:(BOOL)mode;
@end


@protocol SCCaptureSessionManager <NSObject>

@optional
- (void)didCapturePhoto:(UIImage*)Image rect:(CGRect)rect;

@end
