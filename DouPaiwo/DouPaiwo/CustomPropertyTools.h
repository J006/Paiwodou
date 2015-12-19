//
//  CustomPropertyTools.h
//  TestPaiwo
//
//  Created by J006 on 15/4/21.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomPropertyTools : NSObject
+ (instancetype)customTools;

- (void)  drawLine:(CGPoint)pointX  :(CGPoint)pointY  :(UIColor*)lineColor;
- (UILabel*)  drawLineLabel:(CGPoint)pointX  :(CGPoint)pointY  :(UIColor*)lineColor;


@end
