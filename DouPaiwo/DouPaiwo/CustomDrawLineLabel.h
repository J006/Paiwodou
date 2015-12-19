//
//  CustomDrawLineLabel.h
//  TestPaiwo
//
//  Created by J006 on 15/4/27.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDrawLineLabel : UILabel

@property (nonatomic,readwrite) CGPoint       pointX;
@property (nonatomic,readwrite) CGPoint       pointY;
@property (nonatomic,strong)    UIColor       *lineColor;

- (void)initLabel :(CGPoint)pointX  :(CGPoint)pointY  :(UIColor*)lineColor;

@end
