//
//  UIView+XWMExtension.h
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/10/25.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XWMExtension)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
/*!< 渐变属性*/
@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;
@property CGPoint startPoint;
@property CGPoint endPoint;
+ (UIView *_Nullable)gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;    /*!< 渐变色view*/



- (void)setCornerValue:(CGFloat)value;/*!< 圆角*/
- (void)setCorner;
- (void)setToCircle;
- (void)setCornerWithCorners:(UIRectCorner)corners cornerRadii:(CGSize)size;

- (void)setBorderWidth:(CGFloat)width andColor:(UIColor*)color; /*!< 边框*/
- (void)setBorderColor:(UIColor*)color;

- (void)removeAllSubviews;


@end
