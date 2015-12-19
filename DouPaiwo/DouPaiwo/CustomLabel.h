//
//  CustomLabel.h
//  TestPaiwo
//
//  Created by J006 on 15/5/5.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
  VerticalAlignmentTop = 0, // default
  VerticalAlignmentMiddle,
  VerticalAlignmentBottom,
} VerticalAlignment;

@interface CustomLabel : UILabel

@property (nonatomic, readwrite) VerticalAlignment verticalAlignment;

- (void)setLineSpacing  :(CGFloat)lineSpacing;

@end
