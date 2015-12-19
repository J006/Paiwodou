//
//  SettingTextViewCell.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SettingTextViewCell.h"
#define kPaddingLeftWidth 15.0
@interface SettingTextViewCell ()

@property (readwrite, nonatomic) NSInteger            stringMaxLimitNums;
@property (readwrite, nonatomic) NSInteger            stringMinLimitNums;

@end
@implementation SettingTextViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    if (!_textField) {
      _textField = [[UITextField alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, 7,kScreen_Width- 2*kPaddingLeftWidth, 30)];
      _textField.backgroundColor = [UIColor clearColor];
      _textField.font = SourceHanSansNormal15;
      _textField.textColor = [UIColor blackColor];
      _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
      _textField.placeholder = @"未填写";
      _textField.delegate = self;
      [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
      [self.contentView addSubview:_textField];
      _textView = [[UITextView alloc] initWithFrame:CGRectMake(kPaddingLeftWidth, 7,kScreen_Width- 2*kPaddingLeftWidth, 150)];
      _textView.backgroundColor = [UIColor clearColor];
      _textView.font = SourceHanSansNormal15;
      _textView.textColor = [UIColor blackColor];
      _textView.delegate  = self;
      [self.contentView addSubview:_textView];
    }
  }
  return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
  [super layoutSubviews];
  if(_isTextField)
  {
    _textField.text = _textValue;
    [_textView  removeFromSuperview];
  }
  else
  {
    _textView.text = _textValue;
    [_textField  removeFromSuperview];
  }
}

#pragma init
- (void)setTextValue:(NSString *)textValue isTextField :(BOOL)isTextField andTextChangeBlock:(void(^)(NSString *textValue))block
{
  _isTextField  = isTextField;
  if(isTextField)
  {
    [_textField becomeFirstResponder];
  }
  else
  {
    [_textView becomeFirstResponder];
  }

  if ([textValue isEqualToString:@"未填写"])
  {
    _textValue = @"";
  }
  else  if(!textValue || [textValue isEqualToString:@""])
  {
    _textValue = @"";
  }
  else
    _textValue  = textValue;
  _textChangeBlock = block;
}

- (void)setTextStringMaxLimit  :(NSInteger)limit;
{
  self.stringMaxLimitNums  = limit;
}

- (void)setTextStringMinLimit  :(NSInteger)limit
{
  self.stringMinLimitNums  = limit;
}

#pragma UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{

}
/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  replacementText:(NSString *)text
{
  if(range.length + range.location > textView.text.length)
  {
    return NO;
  }
  
  NSUInteger newLength = [textView.text length] + [text length] - range.length;
  return newLength <= self.stringMaxLimitNums && newLength >= self.stringMinLimitNums ;
}
*/
- (void)textViewDidChange:(UITextView *)textView
{
  [self textValueChanged:textView];
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

/*
- (BOOL)textField:(UITextField *)textField  shouldChangeCharactersInRange:(NSRange)range  replacementString:(NSString *)string
{
  if(range.length + range.location > textField.text.length)
  {
    return NO;
  }
  
  NSUInteger newLength = [textField.text length] + [string length] - range.length;
  return newLength <= self.stringMaxLimitNums && newLength >= self.stringMinLimitNums ;
}
 */

#pragma private method
- (void)textValueChanged:(id)sender
{
  if(_isTextField)
  {
    _textValue = [((UITextField*)sender).text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  else
  {
    _textValue = [((UITextView*)sender).text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  }
  if (_textChangeBlock) {
    _textChangeBlock(_textValue);
  }
}

@end
