//
//  CustomUIControl.m
//  DouPaiwo
//
//  Created by J006 on 15/9/10.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "CustomUIControl.h"
@interface CustomUIControl ()

@property(strong, nonatomic)  UIImage   *activeImage;
@property(strong, nonatomic)  UIImage   *inactiveImage;

@end

@implementation CustomUIControl
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    _activeImage    =   [UIImage  imageNamed:@"pageControlSelect.png"];
    _inactiveImage  =   [UIImage  imageNamed:@"pageControlNormal.png"];
  }
  return  self;
}

- (void) updateDots
{
  self.pageIndicatorTintColor = [UIColor clearColor];
  self.currentPageIndicatorTintColor = [UIColor clearColor];
  for (int i = 0; i < [self.subviews count]; i++)
  {
    UIImageView * dot = [self imageViewForSubview:  [self.subviews objectAtIndex: i]];
    if (i == self.currentPage)
      dot.image = _activeImage;
    else
      dot.image = _inactiveImage;
  }
}


- (UIImageView *) imageViewForSubview: (UIView *) view
{
  UIImageView * dot = nil;
  if ([view isKindOfClass: [UIView class]])
  {
    for (UIView* subview in view.subviews)
    {
      if ([subview isKindOfClass:[UIImageView class]])
      {
        dot = (UIImageView *)subview;
        break;
      }
    }
    if (dot == nil)
    {
      dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, view.frame.size.width, view.frame.size.height)];
      [view addSubview:dot];
    }
  }
  else
  {
    dot = (UIImageView *) view;
  }
  
  return dot;
}
- (void)setCurrentPage:(NSInteger)currentPage
{
  [super setCurrentPage:currentPage];
  [self updateDots];
}

@end