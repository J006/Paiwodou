//
//  SearchProjectButton.m
//  TestPaiwo
//
//  Created by J006 on 15/4/29.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SearchProjectCell.h"
#import <Masonry.h>
@interface SearchProjectCell ()

@property (strong, nonatomic) NSString           *value;
@property (strong, nonatomic) UIImage            *image;
@property (strong, nonatomic) UILabel            *valueLabel;
@property (strong, nonatomic) UITapImageView     *tapImageView;
@property (copy, nonatomic) void(^tapAction)(id);
@end

@implementation SearchProjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(!_valueLabel)
    {
      _tapImageView = [[UITapImageView alloc]init];
      [self.contentView addSubview:_tapImageView];
      [_tapImageView  mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(0, kTotalDefaultPadding, 0, kTotalDefaultPadding));
      }];
     
      _valueLabel = [[UILabel  alloc]init];
      [self.contentView addSubview:_valueLabel];
      [_valueLabel  mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(self);
      }];
      _valueLabel.backgroundColor = [UIColor clearColor];
      _valueLabel.font = SourceHanSansLight21;
      _valueLabel.textColor = [UIColor  colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
      _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
  }
  self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if(_value)
    self.valueLabel.text  = _value;
  if(_image)
  {
    self.tapImageView.image = _image;
    /*
    CALayer * layer = [_tapImageView layer];
    layer.borderColor =[[UIColor whiteColor] CGColor];
    layer.borderWidth = 5.0f;
    //添加四个边阴影
    _tapImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    _tapImageView.layer.shadowOffset = CGSizeMake(0, 0);
    _tapImageView.layer.shadowOpacity = 0.5;
    _tapImageView.layer.shadowRadius = 10.0;//给_tapImageView添加阴影和边框
     */
  }
  if(_tapAction)
    [_tapImageView addTapBlock:_tapAction];
}

- (void)initSearchProjectCell:(NSString *)value setBackGroundImage :(UIImage*)backGroundImage tapAction:(void(^)(id obj))tapAction
{
  self.value  = value;
  self.image  = backGroundImage;
  self.tapAction  = tapAction;
}

- (void)setTextValue:(NSString *)value
{
  self.value = value;
}

- (void)setBackGroundImage :(UIImage*)image
{
  self.image  = image;
}
@end
