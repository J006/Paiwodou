//
//  CustomKeyWordButton.m
//  DouPaiwo
//
//  Created by J006 on 15/8/27.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "CustomKeyWordButton.h"
#import <Masonry.h>
@interface  CustomKeyWordButton ()

@property (strong,  nonatomic)  UIButton    *delButton;
@property (copy,    nonatomic)  void(^tapAction)(id);
@property (strong,  nonatomic)  NSString    *btnString;
@property (copy, nonatomic) void(^editTapAction)(id);
@property (copy, nonatomic) void(^cancelTapAction)(id);
@end

@implementation CustomKeyWordButton

#pragma life cycle

- (void)layoutSubviews
{
  [super  layoutSubviews];
  if(_btnString)
  {
    [[self layer] setBorderWidth:0.5];//画线的宽度
    [[self layer] setBorderColor:[UIColor clearColor].CGColor];//颜色
    [[self layer]setCornerRadius:4.0];//圆角
    [self setBackgroundColor:[UIColor colorWithRed:0/255.0 green:197/255.0 blue:85/255.0 alpha:1.0]];
    UIFont  *font = SourceHanSansLight12;
    NSDictionary  *tdic       =   [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize  size  = CGSizeMake(0, 23);
    CGSize        actualsize  =   [self.btnString  boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    [self setTitle:self.btnString forState:UIControlStateNormal];
    [self.titleLabel  setFont:font];
    [self.titleLabel sizeToFit];
    self.titleEdgeInsets  =  UIEdgeInsetsMake(0, 5, 0, 0);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleLabel  setFont:SourceHanSansLight12];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    CGSize actualsize2                =   CGSizeMake(actualsize.width+30, 25);
    [self setSize:actualsize2];
    if(_delButton)
      [self.delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.right.equalTo(self).offset(-5);
      }];
  }
}

#pragma init
- (void)initCustomKeyWordButtonWithBtnString  :(NSString*)btnString
{
  self.btnString  = btnString;
  [self  addSubview:self.delButton];
}

- (void)addEditTapBlock:(void(^)(id obj))tapAction
{
  self.editTapAction  = tapAction;
  [self  addTarget:self action:@selector(editTheKeyWordAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addCancelTapBlock:(void(^)(id obj))tapAction
{
  self.cancelTapAction  = tapAction;
  [self.delButton  addTarget:self action:@selector(cancelTheKeyWordAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma private methords
- (void)editTheKeyWordAction
{
  if(self.editTapAction)
    self.editTapAction(self);
}

- (void)cancelTheKeyWordAction
{
  if(self.cancelTapAction)
  {
    self.cancelTapAction(self);
    [self  removeFromSuperview];
  }
}

#pragma getter setter
- (UIButton*)delButton
{
  if(_delButton ==  nil)
  {
    _delButton  = [[UIButton alloc]init];
    [_delButton  setImage:[UIImage imageNamed:@"keywordCancel"] forState:UIControlStateNormal];
  }
  return _delButton;
}

@end
