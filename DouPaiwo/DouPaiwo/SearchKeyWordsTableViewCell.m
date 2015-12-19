//
//  SearchKeyWordsTableViewCell.m
//  DouPaiwo
//
//  Created by J006 on 15/8/24.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchKeyWordsTableViewCell.h"
#import <Masonry.h>
#import "UITapImageView.h"
#define kPaddingLeftWidth 25.0
@interface SearchKeyWordsTableViewCell ()

@property (strong, nonatomic) UILabel            *titleLabel;//标题
@property (strong, nonatomic) UIButton           *valueButton;//内容:名字或者其他
@property (strong, nonatomic) UITapImageView     *avatarImageView;//头像

@property (strong, nonatomic) NSString           *title;
@property (strong, nonatomic) NSString           *value;
@property (strong, nonatomic) NSURL              *url;//头像连接
@property (readwrite, nonatomic) SearchKeyType   type;
@property (copy, nonatomic) void(^tapAction)(id);

@end
@implementation SearchKeyWordsTableViewCell

#pragma life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
    [self  setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessoryButton"]];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.valueButton];
  }
  //self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  CGRect accessoryViewFrame = self.accessoryView.frame;
  accessoryViewFrame.origin.x = CGRectGetWidth(self.bounds) - CGRectGetWidth(accessoryViewFrame)-kPaddingLeftWidth;
  self.accessoryView.frame = accessoryViewFrame;
  //self.accessoryView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 25);

  
  if(_title)
  {
    self.titleLabel.text = _title;
    [self.titleLabel  sizeToFit];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(kPaddingLeftWidth);
      make.centerY.equalTo(self.mas_centerY);
    }];

  }
  if(_url)
  {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self).offset(86);
      make.centerY.equalTo(self);
      make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.avatarImageView  setImageWithUrlWaitForLoadForAvatarCircle:self.url placeholderImage:nil tapBlock:self.tapAction];
  }
  else
    [self.avatarImageView  removeFromSuperview];
  if(_value)
  {
    [self.valueButton  setTitle:_value forState:UIControlStateNormal];;
    [self.valueButton mas_makeConstraints:^(MASConstraintMaker *make) {
      if(_url)
        make.left.equalTo(self.avatarImageView.mas_right).offset(5);
      else
        make.left.equalTo(self).offset(86);
      make.centerY.equalTo(self);
    }];
    [self.valueButton sizeToFit];
  }
}

#pragma init

- (void)initSearchKeyWordsTableViewCellWithType :(SearchKeyType)sType  title:(NSString*)title  avatarURL:(NSURL*)avatarURL  value:(NSString*)value;
{
  self.type   = sType;
  self.title  = title;
  self.value  = value;
  self.url    = avatarURL;
}


- (void)addUserTapBlockWithAction:(void(^)(id obj))tapAction
{
  self.tapAction  = tapAction;
}

#pragma event
- (void)jumpToUserProfile
{
  if (self.tapAction)
    self.tapAction(self);
}

#pragma getter setter
- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = SourceHanSansNormal15;
    _titleLabel.textColor = [UIColor  colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
  }
  return _titleLabel;
}

- (UITapImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView  = [[UITapImageView  alloc]init];
    [_avatarImageView  setSize:CGSizeMake(25, 25)];
    [_avatarImageView doCircleFrame];
  }
  return _avatarImageView;
}

- (UIButton*)valueButton
{
  if(_valueButton ==  nil)
  {
    _valueButton = [[UIButton  alloc]init];
    _valueButton.backgroundColor = [UIColor clearColor];
    [_valueButton.titleLabel  setFont:SourceHanSansNormal14];
    [_valueButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_valueButton  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_valueButton addTarget:self action:@selector(jumpToUserProfile) forControlEvents:UIControlEventTouchUpInside];
  }
  return _valueButton;
}
@end
