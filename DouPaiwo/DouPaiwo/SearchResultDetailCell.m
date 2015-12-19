//
//  SearchResultDetailCell.m
//  DouPaiwo
//
//  Created by J006 on 15/6/23.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchResultDetailCell.h"
#import "CustomDrawLineLabel.h"
#import "DouAPIManager.h"
#import "PersonalProfile.h"
#import "NSString+Common.h"
#import <Masonry.h>
@interface SearchResultDetailCell ()

@property (strong, nonatomic) UIButton                  *userNameLabel;//用户名称
@property (strong, nonatomic) UILabel                   *userDescraLabel;//签名描述
@property (strong, nonatomic) UITapImageView            *avatarImageView;//头像
@property (strong, nonatomic) UIButton                  *followButton;//关注按钮
@property (strong, nonatomic) CustomDrawLineLabel       *drawLineLabel;//画线
@property (strong, nonatomic) PersonalProfile           *ppView;
@property (strong, nonatomic) UINavigationController    *navi;

@property (strong, nonatomic) UserInstance              *userInstance;

@end
@implementation SearchResultDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.userDescraLabel];
    [self.contentView addSubview:self.followButton];
    [self.contentView addSubview:self.drawLineLabel];

  }
  self.accessoryType  = UITableViewCellAccessoryNone;
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  if(self.userInstance)
  {
    NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.userInstance.host_avatar]];
    __weak typeof(self) weakSelf = self;
    [_avatarImageView  setImageWithUrlWaitForLoadForAvatarCircle  :url placeholderImage:nil tapBlock:^(id obj){
      [weakSelf jumpToUserProfileView];
    }];
    [_userDescraLabel   setText:self.userInstance.host_desc];
    [_userNameLabel     setTitle:self.userInstance.host_name forState:UIControlStateNormal];
    if(self.userInstance.follow_state ==  follow_NO || self.userInstance.follow_state ==  follow_HE || self.userInstance.follow_state ==  0)
    {
      [_followButton setImage:[UIImage  imageNamed:@"followButton.png"] forState:UIControlStateNormal];
      [_followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
      [_followButton  setImage:[UIImage  imageNamed:@"followSuccessButton.png"] forState:UIControlStateNormal];
      [_followButton  addTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(25);
      make.centerY.equalTo(self.mas_centerY);
      make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    
    if(self.userInstance.host_desc  && ![self.userInstance.host_desc isEmpty])
    {
      [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.avatarImageView.mas_right).offset(25);
        make.top.equalTo(self).offset(5);
      }];
      [self.userNameLabel  sizeToFit];
      
      [self.userDescraLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.avatarImageView.mas_right).offset(25);
        make.top.equalTo(self.userNameLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(200,23));
      }];
    }
    
    else
    {
      [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.avatarImageView.mas_right).offset(25);
        make.centerY.equalTo(self.avatarImageView.mas_centerY);
      }];
      [self.userNameLabel  sizeToFit];
    }
    
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make){
      make.right.equalTo(self).offset(-25);
      make.centerY.equalTo(self.mas_centerY);
      make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(self.frame.size.width-50, 0);
    [self.drawLineLabel initLabel:pointLineX :pointLineY :[UIColor  lightGrayColor]];
    [self.drawLineLabel mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self).offset(25);
      make.top.equalTo(self.avatarImageView.mas_bottom).offset(10);
      make.size.mas_equalTo(CGSizeMake(self.frame.size.width-50, 2));
    }];
  }
}

- (void)jumpToUserProfileView
{
  self.ppView = [[PersonalProfile  alloc]init];
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([self.userInstance.host_domain isEqualToString:currentDomain])
    isSelf  = YES;
  [self.ppView initPersonalProfileWithUserDomain:self.userInstance.host_domain isSelf:NO];
  [self.ppView  addBackBlock:^(id obj){
    [[PersonalProfile getNavi] popViewControllerAnimated:YES];
    [[PersonalProfile getNavi] setNavigationBarHidden:NO animated:NO];
  }];
  [self.navi setNavigationBarHidden:YES animated:NO];
  [self.ppView.view  setFrame:kScreen_Bounds];
  [self.navi pushViewController:self.ppView animated:YES];
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

- (void)initSearchResultDetailCellWithUserInstance  :(UserInstance*)userInstance  :(UINavigationController*)navi
{
  self.userInstance = userInstance;
  self.navi         = navi;
}

#pragma self function

/**
 *  @author J006, 15-06-29 14:06:21
 *
 *  关注对方
 *
 *  @param sender
 */
- (void)followAction  :(id)sender
{
  NSInteger   host_id  = self.userInstance.host_id;
  [[DouAPIManager  sharedManager]request_FollowWithFollowID :host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      [self.followButton             setImage:[UIImage imageNamed:@"followButton.png"] forState:UIControlStateNormal];
      [self.followButton             removeTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.followButton             addTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.userInstance             setFollow_state:follow_state];
    }
  }];
  [self setNeedsLayout];
}

- (void)unFollowAction  :(id)sender
{
  NSInteger   host_id  = self.userInstance.host_id;
  [[DouAPIManager  sharedManager]request_UnFollowWithFollowID :host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      [self.followButton             setImage:[UIImage imageNamed:@"followSuccessButton.png"] forState:UIControlStateNormal];
      [self.followButton             removeTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.followButton             addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.userInstance             setFollow_state:follow_state];
    }
  }];
  [self setNeedsLayout];
}

#pragma getter setter
- (UIButton*)userNameLabel
{
  if(_userNameLabel ==  nil)
  {
    _userNameLabel  = [[UIButton  alloc]init];
    [_userNameLabel   setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_userNameLabel.titleLabel  setFont:SourceHanSansMedium14];
    _userNameLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_userNameLabel addTarget:self action:@selector(jumpToUserProfileView) forControlEvents:UIControlEventTouchUpInside];
    //[_userNameLabel   setTextColor:[UIColor blackColor]];
    //[_userNameLabel   setFont:SourceHanSansMedium14];


  }
  return _userNameLabel;
}

- (UILabel*)userDescraLabel
{
  if(_userDescraLabel ==  nil)
  {
    _userDescraLabel  = [[UILabel  alloc]init];
    [_userDescraLabel   setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_userDescraLabel   setFont:SourceHanSansMedium11];
    [_userDescraLabel   setTextAlignment:NSTextAlignmentLeft];
  }
  return _userDescraLabel;
}

- (UITapImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView  = [[UITapImageView  alloc]init];
  }
  return _avatarImageView;
}

- (UIButton*)followButton
{
  if(_followButton  ==  nil)
  {
    _followButton = [[UIButton alloc]init];
  }
  return _followButton;
}

- (CustomDrawLineLabel*)drawLineLabel
{
  if(_drawLineLabel  ==  nil)
  {
    _drawLineLabel = [[CustomDrawLineLabel alloc]init];
  }
  return _drawLineLabel;
}

@end
