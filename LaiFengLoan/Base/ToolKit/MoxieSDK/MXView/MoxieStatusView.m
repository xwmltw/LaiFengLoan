//
//  MXStatusView.m
//  MoxieSDK
//
//  Created by shenzw on 6/27/16.
//  Copyright © 2016 shenzw. All rights reserved.
//

#import "MoxieStatusView.h"

#define TAGDEFAULT 1000
#define TAGDEFAULT2 500
//显示最近的几条状态
#define MAX_MESSAGE 3

/**
 *  设备信息
 */
#define kScreenWidth     [UIScreen mainScreen].bounds.size.width  //设备的宽度
#define kScreenHeight    [UIScreen mainScreen].bounds.size.height //设备的高度

@interface MoxieCenterCircleView : UIView
@property (nonatomic, assign) CGFloat          lineWidth;  // 圆的线宽
@property (nonatomic, assign) CFTimeInterval   sec;        // 秒
@property (nonatomic, assign) CGFloat          percent;    // 百分比
@property (nonatomic, strong) NSArray         *colors;     // 颜色组(CGColor)
@property (nonatomic, strong) CAShapeLayer *circleLayer;
- (void)startAnimation;
- (void)endAnimation;
@end

@interface MoxieWaterRippleView : UIView
@property (strong,nonatomic) UIColor *themeColor;
@end

@interface MoxieStatusView ()
{
    UIColor *_currentWaterColor;
    float _currentLinePointY;
    float a;
    float b;
    BOOL jia;
}
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *accountLabel;
@property (nonatomic,strong) NSMutableArray * statusDataArr;
@property (nonatomic,strong) UILabel * percentageLabel;
@property (nonatomic,copy) NSString *lastMsg;
@property (nonatomic,assign) double lastPercent;
@property (nonatomic,copy) NSString *loadingViewText;
@property (nonatomic,strong) UIColor * themeColor;

@property (nonatomic, strong) MoxieCenterCircleView *circleView;

@end

@implementation MoxieStatusView

- (MoxieStatusView*)initWithFrame:(CGRect)frame themeColor:(UIColor *)themeColor{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        a = 1.5;
        b = 0;
        jia = NO;
        _loadingViewText = nil;
        _themeColor = themeColor;
        if(_themeColor == nil){
            _themeColor = [UIColor colorWithRed:88/255.0f green:181/255.0f blue:235/255.0f alpha:1];
        }
        //测试颜色
        //        _themeColor = [UIColor redColor];
        //上部水纹图
        MoxieWaterRippleView *rippleView = [[MoxieWaterRippleView alloc]initWithFrame:CGRectMake((kScreenWidth-125.f/667.f*kScreenHeight)/2, 86.f/667.f*kScreenHeight, 125.f/667.f*kScreenHeight, 125.f/667.f*kScreenHeight)];
        rippleView.themeColor = _themeColor;
        [self addSubview:rippleView];
        //上部中间转圈图
        _circleView           = [[MoxieCenterCircleView alloc] initWithFrame:CGRectMake(0, 0, 125.f/667.f*kScreenHeight, 125.f/667.f*kScreenHeight)];
        _circleView.lineWidth = 3.f;
        _circleView.sec       = 2.f;
        _circleView.colors    = @[(id)[UIColor whiteColor].CGColor,
                                  (id)_themeColor.CGColor];
        _circleView.percent = 0.8f;
        _circleView.center    = rippleView.center;
        [self addSubview:_circleView];
        [_circleView startAnimation];
        if(_loadingViewText){
            UILabel * textLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, kScreenHeight - 240.f/667.f*kScreenHeight+30.f/667.f*kScreenHeight, kScreenWidth-60, 120.f/667.f*kScreenHeight)];
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.textColor = [UIColor whiteColor];
            textLabel.text = _loadingViewText;
            textLabel.font = [UIFont systemFontOfSize:15];
            textLabel.numberOfLines = 0;
            [self addSubview:textLabel];
        }else{
            //最近状态
            for (int i = 0; i<MAX_MESSAGE; i++) {
                UIView *staView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 240.f/667.f*kScreenHeight+30.f*i/667.f*kScreenHeight, kScreenWidth, 24.f/667.f*kScreenHeight)];
                UILabel *stateLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 24)];
                stateLabel.textAlignment = NSTextAlignmentCenter;
                stateLabel.font = [UIFont systemFontOfSize:15];
                stateLabel.textColor=[UIColor colorWithRed:0xff/255.0f green:0xff/255.0f blue:0xff/255.0f alpha:1];
                stateLabel.tag = TAGDEFAULT2+2;
                [staView addSubview:stateLabel];
                staView.tag=i+TAGDEFAULT;
                [self addSubview:staView];
            }
        }
        //百分比Label
        _percentageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90,30)];
        _percentageLabel.center = rippleView.center;
        _percentageLabel.textColor = [UIColor colorWithRed:0xff/255.0f green:0x95/255.0f blue:0x00/255.0f alpha:1.0f];;
        _percentageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_percentageLabel];
        
        //账号显示
        self.accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 308.f/667.f*kScreenHeight, kScreenWidth, 20)];
        self.accountLabel.textColor = [UIColor colorWithRed:0xa0/255.0f green:0xa0/255.0f blue:0xa0/255.0f alpha:1.0f];
        self.accountLabel.font = [UIFont systemFontOfSize:15];
        self.accountLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.accountLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 105)/2, 333.f/667.f*kScreenHeight, 105, 18)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"精彩马上呈现";
        _timeLabel.textColor = [UIColor colorWithRed:0xa0/255.0f green:0xa0/255.0f blue:0xa0/255.0f alpha:1.0f];
        _timeLabel.font =[UIFont systemFontOfSize:12];
        _timeLabel.layer.borderWidth = 1;
        _timeLabel.layer.borderColor = ([UIColor grayColor].CGColor);
        _timeLabel.layer.cornerRadius = 10;
        _timeLabel.layer.masksToBounds = YES;
        [self addSubview:self.timeLabel];
        
        
        _statusDataArr = [[NSMutableArray alloc]init];
        //下部波浪图
        _currentWaterColor = _themeColor;
        _currentLinePointY = [UIScreen mainScreen].bounds.size.height-279.f/667.f*kScreenHeight;
        [self animateWave];
    }
    return self;
}

-(void)setThemeColor:(UIColor *)themeColor{
    _themeColor = themeColor;
}

/**
 * 下部波浪图
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //画水
    CGContextSetLineWidth(context, 1);
    CGContextSetFillColorWithColor(context, [_currentWaterColor CGColor]);
    
    float y=_currentLinePointY;
    CGPathMoveToPoint(path, NULL, 0, y);
    for(float x=0;x<= [UIScreen mainScreen].bounds.size.width ;x++){
        y= a * sin( x/180*M_PI + 4*b/M_PI ) * 5 + _currentLinePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, [UIScreen mainScreen].bounds.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, _currentLinePointY);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

- (void)animateWave
{
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    if (a<=1) {
        jia = YES;
    }
    if (a>=1.5) {
        jia = NO;
    }
    b+=0.1;
    [self setNeedsDisplay];
    
    // Repeat it in 2.0 seconds
    __weak typeof(self) weakSelf = self;
    double delayInSeconds = 0.02;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf animateWave];
    });
}



-(void)updateProgress:(NSDictionary*)progressDictionary{
    //提示语
    NSString *message = progressDictionary[@"message"];
    //账号信息
    NSString *account = progressDictionary[@"account"];
    //进度百分比【目前电商业务有】
    NSString *percent = progressDictionary[@"percent"];
    //是否已经完成登录
    BOOL loginDone = [progressDictionary[@"loginDone"] boolValue];
    [self updateMessage:message];
    [self updateAccount:account];
    if(percent){
        [self updatePercent:[percent doubleValue]];
    }
}

/**
 * 更新5条最新消息
 */
-(void)updateMessage:(NSString*)message{
    if(_lastMsg != nil && [_lastMsg isEqualToString:message]){
        return;
    }
    if(message !=nil && [message isEqualToString:@""]){
        return;
    }
    if(_loadingViewText!=nil){
        return;
    }
    _lastMsg = message;
    NSMutableArray *statusArray = [_statusDataArr mutableCopy];
    if(statusArray.count==MAX_MESSAGE){
        [statusArray removeObjectAtIndex:0];
    }
    [statusArray addObject:message];
    _statusDataArr = [statusArray mutableCopy];
    for(int i=0;i<_statusDataArr.count;i++){
        UIView *cellView = [self viewWithTag:i+TAGDEFAULT];
        if(!cellView){
            continue;
        }
        UILabel *cellLabel = (UILabel *)[cellView viewWithTag:TAGDEFAULT2+2];
        if(!cellLabel){
            continue;
        }
        cellLabel.text = _statusDataArr[i];
        cellLabel.textColor = [UIColor colorWithRed:0xff/255.0f green:0xff/255.0f blue:0xff/255.0f alpha:1.0f * (i+1)/_statusDataArr.count];;
    }
}

/**
 * 更新账号信息
 */
-(void)updateAccount:(NSString*)account{
    self.accountLabel.text = [NSString stringWithFormat:@"%@",account];
}

/**
 * 更新百分比信息
 */
-  (void)updatePercent:(double)percent
{
    //如果小于该百分比不更新
    if(percent <= _lastPercent){
        return;
    }
    //如果大于99.9显示99.9
    if(percent>=99.9){
        percent = 99.9;
    }
    //显示从lastPercent到percent的动画,待改
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.1f%%",percent]];
    [str addAttribute:NSForegroundColorAttributeName value:_themeColor range:NSMakeRange(0,str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:30.0] range:NSMakeRange(0, str.length-1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:9.0] range:NSMakeRange(str.length-1, 1)];
    _percentageLabel.attributedText = str;
    _lastPercent = percent;
}

-(void)dealloc{
    NSLog(@"dealloc MoxieStatusView");
}
@end


/***
 以下为上部中间的圈
 ***/
@implementation MoxieCenterCircleView
#pragma mark - 将当前view的layer替换成渐变色layer
+ (Class)layerClass
{
    return [CAGradientLayer class];
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _circleLayer = [CAShapeLayer layer];
    }
    return self;
}

#pragma mark - 配置颜色
- (void)setupMulticolor
{
    // 获取当前的layer
    CAGradientLayer *gradientLayer = (CAGradientLayer *)[self layer];
    
    // 创建颜色数组
    NSMutableArray *colors = [NSMutableArray array];
    
    // 如果自定义颜色为空
    if (_colors == nil)
    {
        for (NSInteger hue = 0; hue <= 360; hue += 10)
        {
            [colors addObject:(id)[UIColor colorWithHue:1.0*hue/360.0
                                             saturation:1.0
                                             brightness:1.0
                                                  alpha:1.0].CGColor];
        }
        
        // 给渐变色layer设置颜色
        [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    }
    else
    {
        // 给渐变色layer设置颜色
        [gradientLayer setColors:_colors];
    }
}

#pragma mark - 配置圆形
- (CAShapeLayer *)produceCircleShapeLayer
{
    // 生产出一个圆的路径
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(self.bounds),
                                       CGRectGetMidY(self.bounds));
    
    CGFloat circleRadius = 0;
    
    if (_lineWidth == 0)
    {
        circleRadius = self.bounds.size.width/2.0 - 2;
    }
    else
    {
        circleRadius = self.bounds.size.width/2.0 - 2*_lineWidth;
    }
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:circleCenter
                                                              radius:circleRadius
                                                          startAngle:M_PI
                                                            endAngle:-M_PI
                                                           clockwise:NO];
    
    // 生产出一个圆形路径的Layer
    _circleLayer.path          = circlePath.CGPath;
    _circleLayer.strokeColor   = [UIColor whiteColor].CGColor;
    _circleLayer.fillColor     = [[UIColor clearColor] CGColor];
    
    if (_lineWidth == 0)
    {
        _circleLayer.lineWidth     = 1;
    }
    else
    {
        _circleLayer.lineWidth     = _lineWidth;
    }
    
    // 可以设置出圆的完整性
    _circleLayer.strokeStart = 0;
    _circleLayer.strokeEnd = 0.8f;
    
    return _circleLayer;
}

#pragma mark - Animation

- (void)startAnimation
{
    // 设置渐变layer以及其颜色值
    [self setupMulticolor];
    
    // 生产一个圆形路径并设置成遮罩
    self.layer.mask = [self produceCircleShapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    if (_sec == 0)
    {
        animation.duration = 5;
    }
    else
    {
        animation.duration = _sec;
    }
    
    animation.repeatCount       = MAXFLOAT;
    animation.fromValue         = [NSNumber numberWithDouble:0];
    animation.toValue           = [NSNumber numberWithDouble:M_PI*2];
    [self.layer addAnimation:animation forKey:nil];
}

@synthesize percent = _percent;
-(CGFloat)percent
{
    return _percent;
}

- (void)setPercent:(CGFloat)percent
{
    if (_circleLayer)
    {
        _circleLayer.strokeEnd = percent;
    }
}

- (void)endAnimation
{
    [self.layer removeAllAnimations];
}
@end


/***
 以下为上部扩散水纹
 ***/
@implementation MoxieWaterRippleView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIColor *color = [UIColor whiteColor];
    [color setFill];
    UIRectFill(rect);
    if(!_themeColor){
        _themeColor = [UIColor colorWithRed:245/255.0f green:232/255.0f blue:212/255.0f alpha:0.7f];
    }
    NSInteger pulsingCount = 3;
    double animationDuration = 3;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [_themeColor colorWithAlphaComponent:0.7f].CGColor;
        pulsingLayer.borderWidth = 2;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.4;
        scaleAnimation.toValue = @2.2;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        opacityAnimation.fillMode = kCAFillModeForwards;
        opacityAnimation.removedOnCompletion = NO;
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
}

@end