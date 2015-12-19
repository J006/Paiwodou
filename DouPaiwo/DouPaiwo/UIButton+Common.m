//
//  UIButton+Common.m
//  DouPaiwo
//
//  Created by J006 on 15/7/9.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
  CGRect bounds = self.bounds;
  //若原热区小于44x44，则放大热区，否则保持原大小不变
  CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
  CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
  bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
  return CGRectContainsPoint(bounds, point);
}

@end
