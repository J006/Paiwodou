//
//  CustomDrawLineLabel.m
//  TestPaiwo
//
//  Created by J006 on 15/4/27.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "CustomDrawLineLabel.h"

@implementation CustomDrawLineLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
  CGPoint aPoints[2];//坐标点
  aPoints[0] =self.pointX;//坐标1
  aPoints[1] =self.pointY;//坐标2
  //CGContextAddLines(CGContextRef c, const CGPoint points[],size_t count)
  //points[]坐标数组，和count大小
  CGContextAddLines(context, aPoints, 2);//添加线
  CGContextDrawPath(context, kCGPathStroke); //根据坐标绘制路径
}

- (void)initLabel :(CGPoint)pointX  :(CGPoint)pointY  :(UIColor*)lineColor
{
  self.pointX = pointX;
  self.pointY = pointY;
  self.lineColor  = lineColor;
}


@end
