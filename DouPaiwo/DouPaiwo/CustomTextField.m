//
//  CutomTextField.m
//  DouPaiwo
//
//  Created by J006 on 15/8/3.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds;
{
  return CGRectInset( bounds , 10 , 0 );
}
- (CGRect)editingRectForBounds:(CGRect)bounds;
{
  return CGRectInset( bounds , 10 , 0 );
}

@end
