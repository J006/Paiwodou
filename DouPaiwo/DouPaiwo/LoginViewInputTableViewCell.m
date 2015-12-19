//
//  LoginViewInputTableViewCell.m
//  DouPaiwo
//  登录界面输入框cell
//  Created by J006 on 15/6/30.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "LoginViewInputTableViewCell.h"
#import "CustomTextField.h"
#define kPaddingLeftWidth 40.0
@interface LoginViewInputTableViewCell ()

@property (strong, nonatomic)     UIImageView                     *textFieldImageView;
@property (strong, nonatomic)     CustomTextField                 *textField;
@property (readwrite,nonatomic)   BOOL                            isSecure;

@end
@implementation LoginViewInputTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.accessoryType = UITableViewCellAccessoryNone;
    [self.contentView addSubview:self.textFieldImageView];
    [self.contentView addSubview:self.textField];
  }
  self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self.textFieldImageView  setFrame:CGRectMake(kPaddingLeftWidth, 0, kScreen_Width-kPaddingLeftWidth*2, 40)];
  [self.textField           setFrame:CGRectMake(kPaddingLeftWidth+5, 0, kScreen_Width-kPaddingLeftWidth*2-5, 40)];
  [self.textField           setSecureTextEntry:self.isSecure];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

#pragma init

- (void)configWithPlaceholder:(NSString *)phStr valueStr:(NSString *)valueStr secureTextEntry:(BOOL)isSecure;
{
  self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:phStr? phStr: @"" attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0x999999" andAlpha: 0.5]}];
  self.textField.text = valueStr;
  self.isSecure = isSecure;
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

#pragma getter setter
- (CustomTextField*)textField
{
  if(_textField ==  nil)
  {
    _textField  = [[CustomTextField alloc] initWithFrame:CGRectMake(kPaddingLeftWidth+5, 7.0, kScreen_Width-kPaddingLeftWidth*2-5, 30)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = SourceHanSansNormal14;
    [_textField setTintColor:[UIColor lightGrayColor]];
    [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  }
  return  _textField;
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
