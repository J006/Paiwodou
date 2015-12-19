//
//  SearchBackGroundViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/6/12.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchBackGroundViewController.h"
#import <Masonry/Masonry.h>
#import "CustomDrawLineLabel.h"

#define kSearchBackGroundViewSmallFontSize 12
#define kSearchBackGroundViewBigFontSize 16
@interface SearchBackGroundViewController ()

@property (strong   ,nonatomic)  UIView                   *backGroundView;//背景view
@property (strong   ,nonatomic)  UILabel                  *mainTitle;//搜索你喜欢的...
@property (strong   ,nonatomic)  UILabel                  *subTitle;//用户,兜,照片,活动,公会
@property (strong   ,nonatomic) CustomDrawLineLabel       *lineLabel;
@property (copy, nonatomic) void(^tapAction)(id);
@end

@implementation SearchBackGroundViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  setBackgroundColor:[UIColor  blackColor]];
  [self.view  setAlpha:0.0];
  [self.view  addSubview:self.mainTitle];
  [self.view  addSubview:self.lineLabel];
  [self.view  addSubview:self.subTitle];
}

- (void)viewDidLayoutSubviews
{
  [self addTapBlock];
  
  [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(self.view);
    make.centerY.equalTo(self.view).offset(-50);
    make.size.mas_equalTo(CGSizeMake(200, 24));
  }];

  
  [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.mas_equalTo(self.mainTitle.mas_bottom).offset(10);
    make.centerX.equalTo(self.view);
    make.size.mas_equalTo(CGSizeMake(200, 1));
  }];
  CGPoint  pointLineX = CGPointMake(0, 0);
  CGPoint  pointLineY = CGPointMake(pointLineX.x+200, 0);
  [self.lineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  
  [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(10);
    make.centerX.equalTo(self.view);
    make.size.mas_equalTo(CGSizeMake(200, 20));
  }];
  [self.subTitle  setText:@"用户     图文     照片"];
  [self.subTitle  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  [self.subTitle  setTextAlignment:NSTextAlignmentCenter];
  [self.subTitle  setFont:SourceHanSansNormal12];
}

#pragma init
-(void)initSearchBackGroundView  :(void(^)(id))tapAction
{
  self.tapAction  = tapAction;
}

#pragma private methods
- (void)tap
{
  if (self.tapAction)
    self.tapAction(self);
}

- (void)addTapBlock
{
  if (![self.view gestureRecognizers])
  {
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
  }
}

#pragma getter setter
- (UILabel*)subTitle
{
  if(_subTitle ==  nil)
  {
    _subTitle  = [[UILabel  alloc]init];
  }
  return _subTitle;
}

- (CustomDrawLineLabel*)lineLabel
{
  if(_lineLabel ==  nil)
  {
    _lineLabel  = [[CustomDrawLineLabel  alloc]init];
  }
  return _lineLabel;
}

- (UILabel*)mainTitle
{
  if(_mainTitle ==  nil)
  {
    _mainTitle  = [[UILabel  alloc]init];
    [_mainTitle  setText:@"搜索你喜欢的..."];
    [_mainTitle  setTextAlignment:NSTextAlignmentCenter];
    [_mainTitle  setTextColor:[UIColor  colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_mainTitle  setFont:SourceHanSansNormal24];
  }
  return _mainTitle;
}

@end
