//
//  SignCell.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//
#define kPaddingLeftWidth 15.0
#import "SignAndCoverCell.h"
#import "CustomLabel.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface SignAndCoverCell ()

@property (strong, nonatomic) UILabel            *titleLabel;
@property (strong, nonatomic) UILabel            *valueLabel;
@property (strong, nonatomic) UIImageView        *coverImageView;
@property (strong, nonatomic) NSString           *title;
@property (strong, nonatomic) NSString           *value;
@property (strong, nonatomic) UIImage            *image;
@property (strong, nonatomic) NSURL              *url;

@end
@implementation SignAndCoverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(!_titleLabel)
    {
      [self.contentView addSubview:self.titleLabel];
      [self.contentView addSubview:self.coverImageView];
      [self.contentView addSubview:self.valueLabel];
    }
  }
  self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
  return self;
}

- (void)layoutSubviews{
  [super layoutSubviews];
  self.titleLabel.text = self.title;
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(kPaddingLeftWidth);
    make.centerY.equalTo(self.mas_centerY);
    make.size.mas_equalTo(CGSizeMake(100, 30));
  }];
  if(!_url)
  {
    self.valueLabel.text  = _value;
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-kPaddingLeftWidth*2-10);
      make.centerY.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(200, 30));
    }];
    
    [self.coverImageView removeFromSuperview];
  }
  else    if(!_value)
  {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-kPaddingLeftWidth*2-10);
      make.centerY.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(50, 60));
    }];
     __weak typeof(self) weakSelf = self;
    [self.coverImageView setImageWithURL:self.url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
       if(image)
       {
         image  = [image cutSizeFitFor:CGSizeMake(50, 60)];
         [weakSelf.coverImageView setImage:image];
       }
     } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.valueLabel  removeFromSuperview];
  }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitleStr:(NSString *)title
{
  self.title =  title;
}
- (void)setTextValue:(NSString *)value
{
  self.value  = value;
}
- (void)setImageURL :(NSURL*)imageURL;
{
  self.url  = imageURL;
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

- (UIImageView*)coverImageView
{
  if(_coverImageView ==  nil)
  {
    _coverImageView  = [[UIImageView  alloc]init];
    [_coverImageView  setSize:CGSizeMake(50, 60)];
  }
  return _coverImageView;
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
