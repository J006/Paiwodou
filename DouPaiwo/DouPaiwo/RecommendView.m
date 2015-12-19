//
//  RecommendView.m
//  DouPaiwo
//
//  Created by J006 on 15/7/13.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "RecommendView.h"
#define kdefaultRecommendImageViewHeight  425
#define kdefaultRecommendImageViewWidth   250
@interface RecommendView ()

@property (strong,    nonatomic)  UILabel           *titleLabel;//标题内容
@property (strong,    nonatomic)  UIButton          *passButton;//跳过按钮


@end

@implementation RecommendView

#pragma life cycle
- (void)viewDidLoad
{
  [super            viewDidLoad];
  [self.view        setBackgroundColor:[UIColor blackColor]];
  
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init

- (void)initRecommendView
{

}

- (UIView*)confTheRecommendPhotoView
{
  UIView      *view = [[UIView alloc]init];
  [view       setBackgroundColor:[UIColor whiteColor]];
  CGFloat     viewWidth     = self.view.frame.size.height-70;
  CGFloat     viewHeight    = [RecommendView  heightToFitWidth:CGSizeMake(kdefaultRecommendImageViewWidth, kdefaultRecommendImageViewHeight) newWidth:viewWidth];
  [view       setSize:CGSizeMake(viewWidth, viewHeight)];
  // UIImageView *imageView    = [[UIImageView  alloc]init];
  
  
  return view;
}

#pragma event
- (void)passToTheNextRecommendView  :(UIButton*)button
{

}

#pragma getter setter
- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    [_titleLabel  setFont:[UIFont systemFontOfSize:kRecommendViewMiddleFontSize]];
    [_titleLabel  setTextColor:[UIColor whiteColor]];
    [_titleLabel  setText:@"选择你喜欢的照片"];
  }
  return _titleLabel;
}

- (UIButton*)passButton
{
  if(_passButton  ==  nil)
  {
    _passButton = [[UIButton alloc]init];
    [_passButton setTitle:@"跳过" forState:UIControlStateNormal];
    [_passButton.titleLabel setTextColor:[UIColor grayColor]];
    [_passButton.titleLabel setFont:[UIFont systemFontOfSize:kRecommendViewSmallFontSize]];
    [_passButton addTarget:self action:@selector(passToTheNextRecommendView:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _passButton;
}

@end
