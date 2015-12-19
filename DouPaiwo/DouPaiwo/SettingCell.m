//
//  SettingCell.m
//  TestPaiwo
//
//  Created by J006 on 15/5/21.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SettingCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "CustomDrawLineLabel.h"
#import <Masonry.h>

#define kPaddingLeftWidth 15.0
@interface SettingCell ()

@property (strong, nonatomic) UILabel                 *titleLabel;
@property (strong, nonatomic) UILabel                 *valueLabel;
@property (strong, nonatomic) UIImageView             *avatarImageView;
@property (strong, nonatomic) NSAttributedString      *title;
@property (strong, nonatomic) NSURL                   *url;
@property (strong, nonatomic) NSString                *value;
@property (strong, nonatomic) CustomDrawLineLabel     *bottomLineLabel;
@property (strong, nonatomic) CustomDrawLineLabel     *topLineLabel;
@property (readwrite,nonatomic)BOOL                   isAddBottomLine;
@property (readwrite,nonatomic)BOOL                   isAddTopLine;
@property (readwrite,nonatomic)BOOL                   isLogOutBtn;
@end
@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    if(!_titleLabel && !_avatarImageView)
    {
      [self.contentView addSubview:self.avatarImageView];
      [self.contentView addSubview:self.titleLabel];
      [self.contentView addSubview:self.valueLabel];
      [self.contentView addSubview:self.bottomLineLabel];
      [self.contentView addSubview:self.topLineLabel];
    }
  }
  return self;
}

- (void)initSettingCellWithTitle  :(NSAttributedString*)title imageUrl:(NSURL*)imageURL
{
  self.title  = title;
  self.url    = imageURL;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _titleLabel.attributedText = _title;
  if(!_url)
  {
    [_avatarImageView removeFromSuperview];
    _titleLabel.frame = CGRectMake(kPaddingLeftWidth+10, 0, (kScreen_Width - 120), 45);
  }
  else
  {
    [_avatarImageView setFrame:CGRectMake(kPaddingLeftWidth, 15, 50, 50)];
    [_avatarImageView doCircleFrame];
    [_avatarImageView setImageWithURL:self.url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
      
    } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _titleLabel.frame = CGRectMake(kPaddingLeftWidth+50+10, 15, (kScreen_Width - 120), 45);

  }
  if(self.value)
  {
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.right.equalTo(self).mas_offset(-kPaddingLeftWidth);
    }];
    [_valueLabel sizeToFit];
    [_valueLabel setText:self.value];

  }
  if(self.isAddTopLine)
  {
    [_topLineLabel    setFrame:CGRectMake(0, 0, kScreen_Width, 1)];
  }
  if(self.isAddBottomLine)
  {
    [_bottomLineLabel setFrame:CGRectMake(0, self.bounds.size.height-1, kScreen_Width, 1)];
  }
  if(self.isLogOutBtn)
  {
    
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel  setX:kPaddingLeftWidth+10+30];
    self.accessoryType = UITableViewCellAccessoryNone;
    //[_titleLabel sizeToFit];
  }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsNeedDoAddBottomLine  :(BOOL)isAddBottomLine
{
  self.isAddBottomLine  = isAddBottomLine;
}

- (void)setIsNeedDoAddTopLine     :(BOOL)isAddTopLine
{
  self.isAddTopLine     = isAddTopLine;
}

- (void)setIsNeedLogOutBtn     :(BOOL)isLogOutBtn
{
  self.isLogOutBtn      = isLogOutBtn;
}

- (void)setTheMainValue     :(NSString*)value
{
  self.value  =value;
}

#pragma getter setter
- (UIImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView  = [[UIImageView  alloc]init];
  }
  return  _avatarImageView;
}

- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    //_titleLabel.font = [UIFont systemFontOfSize:16];
    //_titleLabel.textColor = [UIColor blackColor];
  }
  return _titleLabel;
}

- (UILabel*)valueLabel
{
  if(_valueLabel  ==  nil)
  {
    _valueLabel = [[UILabel  alloc]init];
    _valueLabel.backgroundColor = [UIColor clearColor];
    [_valueLabel setTextAlignment:NSTextAlignmentRight];
    [_valueLabel setFont:SourceHanSansNormal12];
    [_valueLabel setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
  return _valueLabel;
}

- (CustomDrawLineLabel*)bottomLineLabel
{
  if(_bottomLineLabel ==  nil)
  {
    _bottomLineLabel  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(pointLineX.x+kScreen_Width, 0);
    [_bottomLineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return  _bottomLineLabel;
}

- (CustomDrawLineLabel*)topLineLabel
{
  if(_topLineLabel ==  nil)
  {
    _topLineLabel  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(pointLineX.x+kScreen_Width, 0);
    [_topLineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return  _topLineLabel;
}

@end
