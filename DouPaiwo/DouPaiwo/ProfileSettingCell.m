//
//  ProfileSettingCell.m
//  DouPaiwo
//
//  Created by J006 on 15/7/28.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//
#define kPaddingLeftWidth 15.0
#import "ProfileSettingCell.h"
#import <Masonry.h>
#import "CustomDrawLineLabel.h"
@interface ProfileSettingCell ()

@property (strong, nonatomic) UILabel            *titleLabel;
@property (strong, nonatomic) UILabel            *valueLabel;
@property (strong, nonatomic) UIButton           *weiboButton;
@property (strong, nonatomic) UIButton           *QQButton;
@property (strong, nonatomic) UIButton           *weixinButton;

@property (strong, nonatomic) NSString           *title;
@property (strong, nonatomic) NSString           *value;
@property (readwrite,nonatomic)BOOL              bindTheAccount;

@end

@implementation ProfileSettingCell

#pragma life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
    [self  setWidth:kScreen_Width];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.weiboButton];
    [self.contentView addSubview:self.QQButton];
    [self.contentView addSubview:self.weixinButton];
  }
  self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  if(self.title)
  {
    self.titleLabel.text = _title;
  }
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(kPaddingLeftWidth);
    make.centerY.equalTo(self.mas_centerY);
    make.size.mas_equalTo(CGSizeMake(100, 30));
  }];
  
  if(self.value)
  {
    self.valueLabel.text  = self.value;
  }
  
  [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self).offset(-kPaddingLeftWidth*2-10);
    make.centerY.equalTo(self);
    make.size.mas_equalTo(CGSizeMake(200, 30));
  }];
  
  if(self.bindTheAccount)
  {
    self.accessoryType  = UITableViewCellAccessoryNone;
    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.mas_centerY);
      make.left.equalTo(self).offset((kScreen_Width-150)/4);
      make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.QQButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.weiboButton.mas_centerY);
      make.left.equalTo(self.weiboButton.mas_right).offset((kScreen_Width-150)/4);
      make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.weixinButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.weiboButton.mas_centerY);
      make.left.equalTo(self.QQButton.mas_right).offset((kScreen_Width-150)/4);
      make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
  }

}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

#pragma init

- (void)initProfileSettingCellWithTitile  :(NSString*)title value:(NSString*)value
{
  self.title  = title;
  self.value  = value;
}

- (void)setIsBindTheAccount :(BOOL)isBindTheAccount;
{
  self.bindTheAccount = isBindTheAccount;
}

#pragma getter setter
- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = SourceHanSansNormal15;
    _titleLabel.textColor = [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
  }
  return _titleLabel;
}

- (UILabel*)valueLabel
{
  if(_valueLabel ==  nil)
  {
    _valueLabel = [[UILabel  alloc]init];
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.font = SourceHanSansNormal13;
    _valueLabel.textColor = [UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0];
    _valueLabel.textAlignment = NSTextAlignmentRight;
  }
  return _valueLabel;
}

- (UIButton*)weiboButton
{
  if(_weiboButton== nil)
  {
    _weiboButton  = [[UIButton alloc]init];
    [_weiboButton  setImage:[UIImage  imageNamed:@"weiboIcon.png"] forState:UIControlStateNormal];
    //[_weiboButton addTarget:self action:@selector(weiboLoginAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _weiboButton;
}

- (UIButton*)QQButton
{
  if(_QQButton== nil)
  {
    _QQButton  = [[UIButton alloc]init];
    [_QQButton  setImage:[UIImage  imageNamed:@"qqIcon.png"] forState:UIControlStateNormal];
    //[_QQButton  addTarget:self action:@selector(tencentLoginAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _QQButton;
}

- (UIButton*)weixinButton
{
  if(_weixinButton== nil)
  {
    _weixinButton  = [[UIButton alloc]init];
    [_weixinButton    setImage:[UIImage  imageNamed:@"weixinIcon.png"] forState:UIControlStateNormal];
    //[_weixinButton   addTarget:self action:@selector(wechatLoginAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _weixinButton;
}

@end
