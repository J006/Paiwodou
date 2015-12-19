//
//  PocketSingleView.m
//  TestPaiwo
//
//  Created by J006 on 15/4/23.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PocketSingleView.h"
#import "PocketFirstView.h"
#import "PocketFollowView.h"
#import "UITapImageView.h"
#import <Masonry/Masonry.h>
#import "PersonalProfile.h"
#import "DouAPIManager.h"
#import "NSString+Common.h"
@interface PocketSingleView()

@property (strong, nonatomic) UIButton                  *jumpToPocketDetailButton;//背景底部,可跳转到该Pocket详情
@property (strong, nonatomic) UITapImageView            *avatarImageView;//推荐人头像
@property (strong, nonatomic) UIButton                  *recommendedName;//推荐人名称
@property (strong, nonatomic) UILabel                   *hotLabel;//热度
@property (strong, nonatomic) UILabel                   *pocketAuthor;//原作者名称
@property (strong, nonatomic) UIScrollView              *pocketScrollView;//滚动界面容器scrollview
@property (nonatomic, strong) PocketFirstView           *pocketFirstView;//第一张界面
@property (nonatomic, strong) PocketFollowView          *pocketFollowView;//第二张关注界面
@property (nonatomic, strong) PocketItemInstance        *pockItem;
@property (nonatomic, readwrite)float                   theFitHeight;
@property (strong, nonatomic) PersonalProfile           *ppView;

@end

@implementation PocketSingleView
@synthesize photoY;
- (void)viewDidLoad
{
  self.view.backgroundColor = kColorBackGround;
  [self.view addSubview:self.jumpToPocketDetailButton];
  [self.view addSubview:self.avatarImageView];
  [self.view addSubview:self.pocketAuthor];
  [self.view addSubview:self.recommendedName];
  [self.view addSubview:self.hotLabel];
  [self.view addSubview:self.pocketScrollView];
  CGFloat theFitHeight  = [PocketSingleView heightToFitWidth:CGSizeMake(kdefaultScreen_Width, kpocketViewHeight) newWidth:kScreen_Width];
  self.theFitHeight = theFitHeight;
  [self initScrollView:_pockItem];
}

- (void)viewDidLayoutSubviews
{
  
  [self.jumpToPocketDetailButton  setFrame:self.view.bounds];
  
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.left.equalTo(self.view).with.offset(kTotalDefaultPadding);
    make.size.mas_equalTo(CGSizeMake(25, 25));
  }];
  
  [self.recommendedName mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.left.equalTo(self.avatarImageView.mas_right).with.offset(10);
    //make.size.mas_equalTo(CGSizeMake(200, 30));
  }];
  [self.recommendedName sizeToFit];
  
  [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.right.equalTo(self.view).with.offset(-kTotalDefaultPadding);
    //make.size.mas_equalTo(CGSizeMake(80, 23));
  }];
  [self.hotLabel sizeToFit];
  
  [self.pocketAuthor mas_makeConstraints:^(MASConstraintMaker *make){
    make.bottom.equalTo(self.view).with.offset(0);
    make.right.equalTo(self.view).with.offset(-kTotalDefaultPadding);
    //make.size.mas_equalTo(CGSizeMake(200, 23));
  }];
  [self.pocketAuthor sizeToFit];
  
  [self.pocketScrollView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).offset(39);
    make.left.equalTo(self.view).offset(0);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Width-kTotalDefaultPadding*2));
  }];

  CGFloat theFollowViewWidth  = [PocketSingleView widthToFitHeight:CGSizeMake(180, 270) newHeight:kScreen_Width-kTotalDefaultPadding*2];
  //设置第一张图片界面
  [self.pocketFirstView.view mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.pocketScrollView);
    make.left.equalTo(self.pocketScrollView).offset(kTotalDefaultPadding);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-kTotalDefaultPadding*2, kScreen_Width-kTotalDefaultPadding*2));
  }];
  if(!self.pockItem.is_delete)
  {
    //设置第二张点赞介绍界面
    [self.pocketFollowView.view mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.pocketFirstView.view.mas_right);
      make.top.equalTo(self.pocketScrollView);
      make.size.mas_equalTo(CGSizeMake(theFollowViewWidth, kScreen_Width-kTotalDefaultPadding*2));
    }];
    
    //设置scrollview的内容宽度
    self.pocketScrollView.contentSize  = CGSizeMake(kScreen_Width+theFollowViewWidth, kScreen_Width-2*kTotalDefaultPadding);
  }
  else
  {
    //设置scrollview的内容宽度
    self.pocketScrollView.contentSize  = CGSizeMake(kScreen_Width, kScreen_Width-2*kTotalDefaultPadding);
  }
}

- (void)  initPocketSingleView:(PocketItemInstance*)pockItem
{
  _pockItem = pockItem;
}

/**
 *  @author J006, 15-04-23 13:04:34
 *
 *  滚动界面容器初始化:包括第一张和第二张界面的初始化
 *
 *  @param pocketItem
 */
- (void)  initScrollView:(PocketItemInstance*)pocketItem
{
  [self initFirstView:pocketItem];
  [self.pocketScrollView addSubview:self.pocketFirstView.view];
  if(pocketItem.is_delete)
    return;
  [self initFollowView:pocketItem];
  [self.pocketScrollView addSubview:self.pocketFollowView.view];
}

/**
 *  @author J006, 15-04-23 13:04:55
 *
 *  第一张pocket界面初始化
 *
 *  @param pocketItem
 *
 *  @return
 */
- (void)  initFirstView:(PocketItemInstance*)pocketItem
{
  [self.pocketFirstView initPocketFirstView:pocketItem];
}

/**
 *  @author J006, 15-04-23 14:04:08
 *
 *  第二张关注界面初始化
 *
 *  @param pocketItem
 */
- (void)  initFollowView:(PocketItemInstance*)pocketItem
{
  [self.pocketFollowView  initPocketFollowView  :pocketItem];
}

- (void)  scrollViewDidScroll:(UIScrollView *)scrollView
{
  
  
}

- (void)jumpToUserProfileView :(NSString*)content_author_domain;
{
  self.ppView = [[PersonalProfile  alloc]init];
  [self.ppView  initPersonalProfileWithUserDomain:content_author_domain isSelf:NO];
  [self.ppView.view setFrame:kScreen_Bounds];
  [PocketSingleView naviPushViewController:self.ppView];
}

- (void)jumpToUserProfileViewByRecommendName
{
  NSString  *content_author_domain;
  if(!_pockItem.user_name || [_pockItem.user_name isEmpty])
    return;
  content_author_domain = _pockItem.user_domain;
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([content_author_domain isEqualToString:currentDomain])
    isSelf  = YES;
  self.ppView = [[PersonalProfile  alloc]init];
  [self.ppView  initPersonalProfileWithUserDomain:content_author_domain isSelf:isSelf];
  [self.ppView.view setFrame:kScreen_Bounds];
  [PocketSingleView naviPushViewController:self.ppView];
}

#pragma getter setter
- (UIButton*)jumpToPocketDetailButton
{
  if(_jumpToPocketDetailButton  ==  nil)
  {
    _jumpToPocketDetailButton = [[UIButton  alloc]init];
  }
  return  _jumpToPocketDetailButton;
}

- (UITapImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView = [[UITapImageView  alloc]init];
    [_avatarImageView setSize:CGSizeMake(25, 25)];
    if(self.pockItem.user_avatar)
    {
      __weak typeof(self) weakSelf = self;
      NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:weakSelf.pockItem.user_avatar]];
      [_avatarImageView  setImageWithUrl:url placeholderImage:nil tapBlock:^(id obj)
       {
         [weakSelf  jumpToUserProfileView:weakSelf.pockItem.user_domain];
       }];
    }
    [_avatarImageView  doCircleFrame];
  }
  return  _avatarImageView;
}

- (UILabel*)pocketAuthor
{
  if(_pocketAuthor  ==  nil)
  {
    _pocketAuthor = [[UILabel  alloc]init];
    [_pocketAuthor  setTextAlignment:NSTextAlignmentRight];
    if(_pockItem.pocket_type ==  publish_pocket)
    {
      [_pocketAuthor  setText:@""];
    }
    else
    {
      NSMutableAttributedString *origAuthor = [[NSMutableAttributedString alloc]initWithString:@"原作者  |  "];
      [origAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0] range:NSMakeRange(0,origAuthor.length)];
      [origAuthor addAttribute:NSFontAttributeName value:SourceHanSansNormal12 range:NSMakeRange(0,origAuthor.length)];
      if(_pockItem.author_name && ![_pockItem.author_name isEmpty])
      {
        NSString  *content  = _pockItem.author_name;
        NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
        [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
        [string_content addAttribute:NSFontAttributeName value:SourceHanSansMedium12 range:NSMakeRange(0,string_content.length)];
        [origAuthor appendAttributedString:string_content];
        [_pocketAuthor  setAttributedText:origAuthor];
      }
      else  if(_pockItem.user_name && ![_pockItem.user_name isEmpty])
      {
        NSString  *content  = _pockItem.user_name;
        NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
        [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
        [string_content addAttribute:NSFontAttributeName value:SourceHanSansMedium12 range:NSMakeRange(0,string_content.length)];
        [origAuthor appendAttributedString:string_content];
        [_pocketAuthor  setAttributedText:origAuthor];
      }
      else
        [_pocketAuthor  setText:@""];
    }
      return _pocketAuthor;
  }
  return  _pocketAuthor;
}

- (UIButton*)recommendedName
{
  if(_recommendedName ==  nil)
  {
    _recommendedName = [[UIButton  alloc]init];
    if(!_pockItem.user_name || [_pockItem.user_name isEmpty])
      return  _recommendedName;
    [_recommendedName   setTitle:_pockItem.user_name forState:UIControlStateNormal];
    [_recommendedName   setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recommendedName   setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_recommendedName.titleLabel  setFont:SourceHanSansMedium14];
    [_recommendedName   addTarget:self action:@selector(jumpToUserProfileViewByRecommendName) forControlEvents:UIControlEventTouchUpInside];
  }
  return  _recommendedName;
}

- (UILabel*)hotLabel
{
  if(_hotLabel ==  nil)
  {
    _hotLabel = [[UILabel  alloc]init];
    [_hotLabel  setTextColor:[UIColor lightGrayColor]];
    [_hotLabel  setTextAlignment:NSTextAlignmentRight];
    //NSString  *hot  = @"热度";
    //self.pockItem.hot = @"1,212";
    //if(self.pockItem.hot)
      //[self.hotLabel  setText:[hot stringByAppendingString:self.pockItem.hot]];
    [self.hotLabel  setFont:[UIFont systemFontOfSize:kpocketSmallFontSize]];
  }
  return  _hotLabel;
}

- (UIScrollView*)pocketScrollView
{
  if(_pocketScrollView ==  nil)
  {
    _pocketScrollView = [[UIScrollView  alloc]init];
    [_pocketScrollView  setBackgroundColor:kColorBackGround];
    _pocketScrollView.delegate  = self;
    [_pocketScrollView setShowsHorizontalScrollIndicator:NO];
  }
  return  _pocketScrollView;
}

- (PocketFirstView*)pocketFirstView
{
  if(_pocketFirstView ==  nil)
  {
    _pocketFirstView  = [[PocketFirstView  alloc]init];
  }
    return  _pocketFirstView;
}

- (PocketFollowView*)pocketFollowView
{
  if(_pocketFollowView ==  nil)
  {
    _pocketFollowView  = [[PocketFollowView  alloc]init];
  }
  return  _pocketFollowView;
}

@end
