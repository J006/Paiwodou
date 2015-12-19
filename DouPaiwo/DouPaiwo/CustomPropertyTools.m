//
//  CustomPropertyTools.m
//  TestPaiwo
//
//  Created by J006 on 15/4/21.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "CustomPropertyTools.h"

@implementation CustomPropertyTools

/**
 *  @author J006, 15-05-13 10:05:48
 *
 *  获取该类的静态实例对象
 *
 *  @return
 */
+ (instancetype)customTools
{
  static CustomPropertyTools *tools = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    tools = [[self alloc] init];
  });
  return tools;
}

/**
 *  @author J006, 15-04-27 12:04:39
 *
 *  画直线
 *
 *  @param pointX    初始坐标
 *  @param pointY    结束坐标
 *  @param lineColor 直线颜色
 */
- (void)  drawLine:(CGPoint)pointX  :(CGPoint)pointY  :(UIColor*)lineColor
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
  CGPoint aPoints[2];//坐标点
  aPoints[0] =pointX;//坐标1
  aPoints[1] =pointY;//坐标2
  //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
  //points[]坐标数组，和count大小
  CGContextAddLines(context, aPoints, 2);//添加线
  CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

- (UILabel*)  drawLineLabel:(CGPoint)pointX  :(CGPoint)pointY  :(UIColor*)lineColor
{
  UILabel *label  = [[UILabel alloc]init];

    return label;
}

@end
