//
//  CommentTableViewCell.m
//  DouPaiwo
//
//  Created by J006 on 15/6/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "CommentTableViewCell.h"
#import <Masonry.h>
#import "CustomDrawLineLabel.h"
#import "CustomLabel.h"
#import "NSString+Common.h"
@interface CommentTableViewCell ()

@property (strong, nonatomic) UIButton                  *userNameButton;//用户名称
@property (strong, nonatomic) UILabel                   *commentContent;//评论内容
@property (strong, nonatomic) UITapImageView            *avatarImageView;//头像
@property (strong, nonatomic) UILabel                   *timeContent;//发送时间
//@property (strong, nonatomic) CustomDrawLineLabel       *drawLineLabel;//画线


@property (strong, nonatomic) CommentInstance           *commentInstance;

@end

@implementation CommentTableViewCell

#pragma life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.userNameButton];
    [self.contentView addSubview:self.commentContent];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.timeContent];
    //[self.contentView addSubview:self.drawLineLabel];
  }
  self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if(!self.commentInstance)
    return;
  if(self.commentInstance.comment_user_avatar)
  {
    [self.avatarImageView setSize:CGSizeMake(36, 36)];
    [self.avatarImageView  doCircleFrame];
    NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.commentInstance.comment_user_avatar]];
    [self.avatarImageView  setImageWithUrlWaitForLoadForAvatarCircle  :url placeholderImage:nil tapBlock:^(id obj){
    }];
  }
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self).offset(25);
    make.top.equalTo(self).offset(20);
    make.size.mas_equalTo(CGSizeMake(36,36));
  }];

  if(self.commentInstance.comment_user_name)
  {
    if(self.commentInstance.is_self)
      [self.userNameButton  setTitle:@"我" forState:UIControlStateNormal];
    else
      [self.userNameButton  setTitle:self.commentInstance.comment_user_name forState:UIControlStateNormal];
    [self.userNameButton  setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [self.userNameButton  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.userNameButton.titleLabel setFont:SourceHanSansMedium14];
  }
  [self.userNameButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.avatarImageView.mas_right).offset(20);
    make.top.equalTo(self).offset(20);
    make.size.mas_equalTo(CGSizeMake(120,18));
  }];
  
  if(self.commentInstance.create_time)
  {
    [self.timeContent  setText:self.commentInstance.create_time];
    [self.timeContent  setFont:SourceHanSansLight10];
    [self.timeContent  setTextColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0]];
  }
  [self.timeContent mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.userNameButton.mas_left);
    make.top.equalTo(self.userNameButton.mas_bottom);
    make.size.mas_equalTo(CGSizeMake(100,20));
  }];
  
  CGSize textSize;
  if(self.commentInstance.comment_text)
  {
    //根据计算结果重新设置UILabel的尺寸
    [self.commentContent  setText:self.commentInstance.comment_text];
    textSize = [self.commentInstance.comment_text getSizeWithFont:SourceHanSansNormal14 constrainedToSize:CGSizeMake(kScreen_Width-75-25, CGFLOAT_MAX)];
  }
  else
    textSize  = CGSizeZero;
  [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.userNameButton.mas_left);
    make.top.equalTo(self.timeContent.mas_bottom).offset(-3);
    make.size.mas_equalTo(textSize);
  }];
  
  /*
  CGPoint  pointLineX = CGPointMake(0, 0);
  CGPoint  pointLineY = CGPointMake(self.frame.size.width-50, 0);
  [self.drawLineLabel initLabel:pointLineX :pointLineY :[UIColor  lightGrayColor]];
  [self.drawLineLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self).offset(25);
    make.bottom.equalTo(self.mas_bottom).offset(0);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-50, 2));
  }];
   */
}
- (void)awakeFromNib {
    // Initialization code
}


#pragma init
- (void)initCommentTableViewCellWithComment  :(CommentInstance*)commentInstance
{
  self.commentInstance  = commentInstance;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma getter setter
- (UITapImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView  = [[UITapImageView  alloc]init];
  }
  return _avatarImageView;
}

- (UIButton*)userNameButton
{
  if(_userNameButton  ==  nil)
  {
    _userNameButton = [[UIButton alloc]init];

  }
  return _userNameButton;
}

/*
- (CustomDrawLineLabel*)drawLineLabel
{
  if(_drawLineLabel  ==  nil)
  {
    _drawLineLabel = [[CustomDrawLineLabel alloc]init];
  }
  return _drawLineLabel;
}
*/
- (UILabel*)commentContent
{
  if(_commentContent  ==  nil)
  {
    _commentContent = [[UILabel  alloc]init];
    [_commentContent  setFont:SourceHanSansNormal14];
    [_commentContent  setTextColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0]];
    [_commentContent  setNumberOfLines:10];
  }
  return _commentContent;
}

- (UILabel*)timeContent
{
  if(_timeContent ==  nil)
  {
    _timeContent  = [[UILabel  alloc]init];
    [_timeContent  setTextAlignment:NSTextAlignmentLeft];
  }
  return _timeContent;
}

@end
