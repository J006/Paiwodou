//
//  NotificationViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/7/31.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "NotificationViewController.h"
#import <Masonry.h>
@interface NotificationViewController ()

@property (strong,    nonatomic)  UIColor           *bgColor;
@property (strong,    nonatomic)  UILabel           *titleLabel;//标题
@property (strong,    nonatomic)  UIImageView       *iconImageView;//眼睛icon

@end

@implementation NotificationViewController

- (void)viewDidLoad
{
  [super  viewDidLoad];
  if(!self.bgColor)
    [self.view  setBackgroundColor:[UIColor colorWithRed:255/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
  else
    [self.view  setBackgroundColor:self.bgColor];
  [self.view  addSubview:self.iconImageView];
  [self.view  addSubview:self.titleLabel];
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  
  [self.iconImageView  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.right.equalTo(self.view.mas_centerX).offset(-40);
    make.size.mas_equalTo(CGSizeMake(18, 10));
  }];
  
  if(self.title)
    [self.titleLabel  setText:self.title];
  [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.left.equalTo(self.iconImageView.mas_right).offset(5);
    make.size.mas_equalTo(CGSizeMake(100, 15));
  }];
}

- (void)didReceiveMemoryWarning
{
  [super  didReceiveMemoryWarning];
}

#pragma init
- (void)initNotificationViewControllerWithTitle  :(NSString*)title
{
  self.title    = title;
}

- (void)confirmTheBackGroundColor :(UIColor*)color
{
  self.bgColor  = color;
}

#pragma getter setter

- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    [_titleLabel   setFont:SourceHanSansNormal14];
    [_titleLabel   setTextColor:[UIColor  whiteColor]];
    [_titleLabel   setTextAlignment:NSTextAlignmentLeft];
  }
  return _titleLabel;
}

- (UIImageView*)iconImageView
{
  if(_iconImageView ==  nil)
  {
    _iconImageView  = [[UIImageView  alloc]init];
    [_iconImageView setImage:[UIImage imageNamed:@"notificationIcon.png"]];
  }
  return _iconImageView;
}

@end
