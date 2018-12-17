//
//  MoxieSDKOperation.m
//  MoxieSDKOCDemo
//
//  Created by shenzw on 2018/7/11.
//  Copyright © 2018年 shenzw. All rights reserved.
//

#import "MoxieSDKOperation.h"

@interface MoxieSDKOperation ()
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@end

@implementation MoxieSDKOperation
@synthesize finished = _finished, executing = _executing;

- (id)init{
    if(self = [super init]) {
    }
    return self;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isAsynchronous {
    return YES;
}

//一旦重写start方法后，就可以通过KVO的方式自主控制operation的executing和finished
-(void)start{
    self.executing = YES;
    NSLog(@"MoxieSDKOperation start");
    if (self.isCancelled) {
        self.executing = NO;
        self.finished = YES;
    }
    [self mainOperation];
}

- (void)mainOperation{
    // add event handlers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMoxieSDKResultNotifiction:) name:receiveMoxieSDKResultNotifiction object:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MoxieSDK shared].taskType = _taskType;
        [MoxieSDK shared].loginCustom = _loginCustom;
        [[MoxieSDK shared] startInMode:_runMode];
    });
}


-(void)receiveMoxieSDKResultNotifiction:(NSNotification *)notification{
    [self stopOperation];
}

// Shuts down the NSOperation
- (void)stopOperation {
    // Clear out observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.executing = NO;
    self.finished = YES;
}

-(void)dealloc{
    NSLog(@"MoxieSDKOperation dealloc...");
}
@end
