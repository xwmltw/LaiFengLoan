//
//  XCodeImageView.m
//  QuanWangDai
//
//  Created by yanqb on 2017/11/13.
//  Copyright © 2017年 kizy. All rights reserved.
//

#import "XCodeImageView.h"
#import "XRedrawLabel.h"

#define ARC4RAND_MAX 0x100000000

@interface XCodeImageView()
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) UIView  *bgView;

@end
@implementation XCodeImageView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)freshVerCode{
    [self changeCodeStr];
    [self initImageCodeView];
}

- (void)changeCodeStr{
    self.textArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    for(NSInteger i = 0; i < 4; i++)
    {
        NSInteger index = arc4random() % ([self.textArray count] - 1);
        NSString *oneText = [self.textArray objectAtIndex:index];
        self.imageCodeStr = (i==0)?oneText:[self.imageCodeStr stringByAppendingString:oneText];
    }
    if (self.bolck) {
        self.bolck(self.imageCodeStr);
    }
}
-(void)initImageCodeView{
    
    if (_bgView) {
        [_bgView removeFromSuperview];
    }
    _bgView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:_bgView];
    //    _bgView.backgroundColor = CCXBackColor;
    _bgView.backgroundColor = [UIColor whiteColor];
    
    
    CGSize textSize = [@"W" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    int randWidth = (self.frame.size.width)/self.imageCodeStr.length - textSize.width;
    int randHeight = self.frame.size.height - textSize.height;
    
    for (int i = 0; i<self.imageCodeStr.length; i++) {
        
        CGFloat px = arc4random()%randWidth + i*(self.frame.size.width-3)/self.imageCodeStr.length;
        CGFloat py = arc4random()%randHeight;
        //        WQRedrawLabel
        XRedrawLabel * label = [[XRedrawLabel alloc] initWithFrame: CGRectMake(px+3, py, textSize.width, textSize.height)];
        label.text = [NSString stringWithFormat:@"%C",[self.imageCodeStr characterAtIndex:i]];
        label.font = [UIFont systemFontOfSize:16];
        if (self.isRotation) {
            double r = (double)arc4random() / ARC4RAND_MAX * 2 - 1.0f;//随机-1到1
            if (r>0.3) {
                r=0.3;
            }else if(r<-0.3){
                r=-0.3;
            }
            label.transform = CGAffineTransformMakeRotation(r);
        }
        
        [_bgView addSubview:label];
    }
    for (int i = 0; i<10; i++) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat pX = arc4random() % (int)CGRectGetWidth(self.frame);
        CGFloat pY = arc4random() % (int)CGRectGetHeight(self.frame);
        [path moveToPoint:CGPointMake(pX, pY)];
        CGFloat ptX = arc4random() % (int)CGRectGetWidth(self.frame);
        CGFloat ptY = arc4random() % (int)CGRectGetHeight(self.frame);
        [path addLineToPoint:CGPointMake(ptX, ptY)];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.lineWidth = 1.0f;
        layer.strokeEnd = 1;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = path.CGPath;
        [_bgView.layer addSublayer:layer];
    }
    
}

@end
