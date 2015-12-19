//
//  RegisterViewCell.m
//  DouPaiwo
//
//  Created by J006 on 15/7/1.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "RegisterViewCell.h"
#import <Masonry.h>
#import "CustomTextField.h"
#define kPaddingLeftWidth 15.0
#define timeSetOut  10
@interface RegisterViewCell ()

@property (strong, nonatomic)     CustomTextField                 *textField;
@property (readwrite, nonatomic)  NSInteger                       textfieldType;//类型
@property (strong, nonatomic)     UIButton                        *getMessageButton;//获取短信按钮
@property (strong, nonatomic)     UIImageView                     *textFieldImageView;
@property (readwrite, nonatomic)  BOOL                            isMessageCD;//读取信息cd
@property (strong, nonatomic)     NSTimer                         *nsTimer;
@property (readwrite, nonatomic)  NSInteger                       timesSet;//计数器,起始为60
@end

@implementation RegisterViewCell

#pragma life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    [self.contentView addSubview:self.textFieldImageView];
    [self.contentView addSubview:self.getMessageButton];
    [self.contentView addSubview:self.textField];
    
  }
  self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if(self.textfieldType ==  type_phone)
  {
    [_getMessageButton    removeFromSuperview];
    
    [self.textFieldImageView mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(40);
      make.top.equalTo(self).offset(0);
      make.right.equalTo(self).offset(-40);
      make.bottom.equalTo(self).offset(0);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(40);
      make.top.equalTo(self).offset(7);
      make.right.equalTo(self).offset(-40);
      make.bottom.equalTo(self).offset(-7);
    }];
    //[_textField           setFrame:CGRectMake(kPaddingLeftWidth, 7.0, kScreen_Width-kPaddingLeftWidth*2, 30)];
  }
  else  if(self.textfieldType ==  type_captcha)
  {
    CGFloat textfieldWidth  = 150*kScreen_Width/kdefaultTotalScreen_Width;
    
    [self.textFieldImageView mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(40);
      make.top.equalTo(self).offset(0);
      make.bottom.equalTo(self).offset(0);
      make.width.mas_equalTo(textfieldWidth);
    }];
    
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(40);
      make.top.equalTo(self).offset(0);
      make.bottom.equalTo(self).offset(0);
      make.width.mas_equalTo(textfieldWidth);
    }];
    
    [self.getMessageButton mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.textField.mas_right).offset(-1);
      make.top.equalTo(self).offset(0);
      make.right.equalTo(self).offset(-40);
      make.bottom.equalTo(self).offset(0);
    }];
  }
  else  if(self.textfieldType ==  type_password)
  {
    [_getMessageButton    removeFromSuperview];
    [self.textFieldImageView mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(40);
      make.right.equalTo(self).offset(-40);
      make.top.equalTo(self).offset(0);
      make.bottom.equalTo(self).offset(0);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(40);
      make.right.equalTo(self).offset(-40);
      make.top.equalTo(self).offset(0);
      make.bottom.equalTo(self).offset(0);
    }];
  }

  
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithPlaceholder:(NSString *)phStr  valueStr:(NSString *)valueStr textfieldType:(NSInteger)textfieldType;
{
  self.textField.attributedPlaceholder  = [[NSAttributedString alloc] initWithString:phStr? phStr: @"" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"B6B3AA" andAlpha: 1.0],NSFontAttributeName:SourceHanSansNormal14}];
  self.textField.placeholder            = phStr;
  self.textfieldType                    = textfieldType;
  self.textField.attributedText         = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"414141" andAlpha: 1.0],NSFontAttributeName:SourceHanSansNormal15}];
}

- (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha
{
  UIColor *color = [UIColor colorWithHexString:stringToConvert];
  return [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:alpha];
}

- (void)textValueChanged:(id)sender
{
  if (self.textValueChangedBlock)
    self.textValueChangedBlock(self.textField.text);
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
  return CGRectInset( bounds , 10 , 0 );
}

#pragma event
- (void)sendMessage:(UIButton*)button
{
  [self.getMessageButton setEnabled:NO];
  if(!self.nsTimer)
    self.timesSet = timeSetOut;
  if(!self.nsTimer)
    self.nsTimer  = [NSTimer  scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
  [self.nsTimer  fire];
}

- (void)timerFireMethod:(NSTimer *)timer
{
  self.timesSet = self.timesSet-1;
  if(self.timesSet  ==  0)
  {
    [self.nsTimer  invalidate];
    [self.getMessageButton setTitle:@"免费获取" forState:UIControlStateNormal];
    [self.getMessageButton setEnabled:YES];
    self.nsTimer  = nil;
    self.timesSet = timeSetOut;
    return;
  }
  [self.getMessageButton setTitle:[NSString stringWithFormat:@"%ld秒",self.timesSet] forState:UIControlStateNormal];
}

#pragma getter setter
- (CustomTextField*)textField
{
  if(_textField ==  nil)
  {
    _textField  = [[CustomTextField alloc]init];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = SourceHanSansNormal14;
    [_textField setTintColor:[UIColor lightGrayColor]];
    [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  }
  return  _textField;
}


- (UIButton*)getMessageButton
{
  if(_getMessageButton  ==  nil)
  {
    _getMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getMessageButton.layer setMasksToBounds:YES];
    [_getMessageButton.layer setCornerRadius:0.0];//设置矩圆角半径,数值越大圆弧越大，反之圆弧越小
    [_getMessageButton.layer setBorderWidth:1.0];//边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef      colorref = CGColorCreate(colorSpace,(CGFloat[]){ 45.0/255.0, 216.0/255.0, 136.0/255.0, 1 });;//R,G,B,alpha
    [_getMessageButton.layer setBorderColor:colorref];//边框颜色
    [_getMessageButton  setTitle:@"免费获取" forState:UIControlStateNormal];
    [_getMessageButton  setTitleColor:[UIColor colorWithRed:45.0/255.0 green:216.0/255.0 blue:136.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_getMessageButton.titleLabel setFont:SourceHanSansNormal14];
    [_getMessageButton  addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _getMessageButton;
}

- (UIImageView*)textFieldImageView
{
  if(_textFieldImageView  ==  nil)
  {
    _textFieldImageView = [[UIImageView  alloc]init];
    [_textFieldImageView setImage:[UIImage imageNamed:@"inputTextView.png"]];
  }
  return _textFieldImageView;
}

@end
