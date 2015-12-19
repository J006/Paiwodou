//
//  MiddleBanner.m
//  TestPaiwo
//
//  Created by J006 on 15/5/4.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "MiddleBanner.h"
#import "CustomDrawLineLabel.h"
#import "MiddleButtonInstance.h"
#import <Masonry/Masonry.h>

@interface MiddleBanner()

@property (nonatomic,strong)  CustomDrawLineLabel       *firstCustomDrowLineLabel;
@property (nonatomic,strong)  NSMutableArray            *middleButtonArray;
@property (nonatomic,strong)  NSMutableArray            *middleButtonViewArray;
@property (nonatomic,strong)  NSMutableArray            *drawLineLabelViewArray;

@end

@implementation MiddleBanner



#pragma mark  - life cycle
- (void)viewDidLoad
{
  self.view.backgroundColor = kColorBackGround;
  [self.view  addSubview:self.firstCustomDrowLineLabel];
  for (NSInteger i=0; i<[_middleButtonArray count]; i++)
  {
    UIButton  *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    CustomDrawLineLabel   *customDrawLineLabel  = [[CustomDrawLineLabel  alloc]init];
    [self.view addSubview:customDrawLineLabel];
    [self.middleButtonViewArray addObject:button];
    [self.drawLineLabelViewArray addObject:customDrawLineLabel];
  }
}

- (void)viewDidLayoutSubviews
{
  //画第一条线
  CGPoint  pointLineX = CGPointMake(0, 0);
  CGPoint  pointLineY = CGPointMake(pointLineX.x+kMiddleBannerLineDistance, 0);
  [self.firstCustomDrowLineLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(self.view);
    make.top.mas_equalTo(@10);
    make.size.mas_equalTo(CGSizeMake(kmiddleBannerWidth, 3));
  }];
  [self.firstCustomDrowLineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  UIView  *lastView = self.firstCustomDrowLineLabel;
  for (NSInteger i=0; i<[_middleButtonArray count]; i++)
  {
    MiddleButtonInstance  *buttonInstance = (MiddleButtonInstance*) [_middleButtonArray  objectAtIndex:i];
    UIButton  *button = [self.middleButtonViewArray objectAtIndex:i];
    [button setTitle:buttonInstance.buttonName forState:UIControlStateNormal];
    [button setTitleColor:kColorPocketsAndPhotosButton forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
      make.centerX.equalTo(self.view);
      make.centerY.equalTo(lastView.mas_bottom).with.offset(15);

      make.size.mas_equalTo(CGSizeMake(kmiddleBannerWidth, 3));
    }];
    lastView  = button;
    
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(pointLineX.x+kMiddleBannerLineDistance, 0);
    CustomDrawLineLabel *lineLabel  = (CustomDrawLineLabel*) [self.drawLineLabelViewArray  objectAtIndex:i];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
      make.centerX.equalTo(self.view);
      make.top.mas_equalTo(lastView.mas_bottom).with.offset(15);
      make.size.mas_equalTo(CGSizeMake(kmiddleBannerWidth, 8));
    }];
    [lineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
    lastView  = lineLabel;
  }
  
}

/**
 *  @author J006, 15-05-04 15:05:19
 *
 *  初始化middlebanner
 *
 *  @param frameMain
 *  @param backGroundColor
 *  @param middleButtonArray
 */
- (void)initMiddleBanner :(NSMutableArray*)middleButtonArray
{
  _middleButtonArray  = middleButtonArray;

}

- (CustomDrawLineLabel*)firstCustomDrowLineLabel
{
  if(_firstCustomDrowLineLabel  ==  nil)
  {
    _firstCustomDrowLineLabel = [[CustomDrawLineLabel  alloc]init];
  }
  return _firstCustomDrowLineLabel;
}

- (NSMutableArray*)middleButtonViewArray
{
  if(_middleButtonViewArray  ==  nil)
  {
    _middleButtonViewArray = [[NSMutableArray  alloc]init];
  }
  return _middleButtonViewArray;
}

- (NSMutableArray*)drawLineLabelViewArray
{
  if(_drawLineLabelViewArray  ==  nil)
  {
    _drawLineLabelViewArray = [[NSMutableArray  alloc]init];
  }
  return _drawLineLabelViewArray;
}

@end
