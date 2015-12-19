//
//  SettingAccountCell.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//
#define kPaddingLeftWidth 15.0
#import "SettingAccountCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface SettingAccountCell ()

@property (strong, nonatomic) UILabel            *titleLabel;
@property (strong, nonatomic) UILabel            *valueLabel;
@property (strong, nonatomic) UIImageView        *avatarImageView;
@property (strong, nonatomic) NSString           *title;
@property (strong, nonatomic) NSString           *value;
@property (strong, nonatomic) UIImage            *image;
@property (strong, nonatomic) NSURL              *url;

@end
@implementation SettingAccountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
    //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(!_titleLabel && !_avatarImageView)
    {
      [self.contentView addSubview:self.titleLabel];
      [self.contentView addSubview:self.avatarImageView];
      [self.contentView addSubview:self.valueLabel];
    }
  }
  //self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  if(self.title)
  {
    self.titleLabel.text = _title;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(kPaddingLeftWidth);
      make.centerY.equalTo(self.mas_centerY);
      make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
  }

  if(!_url)
  {
    self.valueLabel.text  = _value;
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-kPaddingLeftWidth*2-10);
      make.centerY.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    [self.avatarImageView removeFromSuperview];
  }
  else    if(!_value)
  {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-kPaddingLeftWidth*2-10);
      make.centerY.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.avatarImageView setImageWithURL:self.url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
       
     } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.valueLabel  removeFromSuperview];
  }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setImageURL :(NSURL*)imageURL
{
  self.url  = imageURL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)title
{
  self.title = title;
}

- (void)setTextValue:(NSString *)value
{
  self.value = value;
}

- (void)setAvatarImage :(UIImage*)image
{
  self.image  = image;
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

- (UIImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView  = [[UIImageView  alloc]init];
    [_avatarImageView  setSize:CGSizeMake(50, 50)];
    [_avatarImageView doCircleFrame];
  }
  return _avatarImageView;
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

@end
