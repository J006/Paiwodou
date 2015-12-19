//
//  PersonalProfile.m
//  TestPaiwo
//
//  Created by J006 on 15/5/18.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PersonalProfile.h"
#import "MiddleBanner.h"
#import "MiddleButtonInstance.h"
#import "PocketAndPhotoView.h"
#import "SettingView.h"
#import <RDVTabBarController.h>
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "CustomDrawLineLabel.h"
#import "CustomLabel.h"
#import "DouAPIManager.h"
#import "PersonalMainView.h"
#import "UIImage+Common.h"
#import <UIImage+BlurredFrame/UIImage+BlurredFrame.h>
#import "UIButton+Common.h"
#import "FollowAndFansView.h"
#import "ShareTotalViewController.h"
#import <GPUImage.h>

#define topViewButtonDistanceX 8
#define topViewButtonDistanceY 19
@interface PersonalProfile ()

@property (readwrite, nonatomic)BOOL                        isSelf;//是否是自己
@property (strong, nonatomic) NSString                      *currentDomain;//当前用户domain
@property (strong, nonatomic) UserInstance                  *currentUser;
@property (strong, nonatomic) NSMutableArray                *dynamicList;

@property (strong, nonatomic) UIView                        *backGroundView;//大背景
@property (strong, nonatomic) UIButton                      *settingButton;//设置按钮
@property (strong, nonatomic) UIButton                      *backButton;//后退按钮
@property (strong, nonatomic) UIButton                      *secondBackButton;//第二张页面的后退按钮:一开始隐藏
@property (strong, nonatomic) UITapImageView                *avatarImageViewTap;//头像按钮:一开始隐藏
@property (strong, nonatomic) UIButton                      *useNameButton;//名字按钮:一开始隐藏
@property (strong, nonatomic) UIButton                      *shareButton;//分享按钮
@property (strong, nonatomic) UIImageView                   *coverView;//背景cover
@property (strong, nonatomic) UIBlurEffect                  *blurEffect;//模糊cover
@property (strong, nonatomic) UIImageView                   *avatarImageView;//个人头像按钮
@property (strong, nonatomic) UILabel                       *userName;//个人名称
@property (strong, nonatomic) UIButton                      *refeshTheContentButton;//下拉刷新
@property (strong, nonatomic) CustomLabel                   *profileContent;//个人简介
@property (strong, nonatomic) UILabel                       *profileUrlLabel;//个人域名
@property (strong, nonatomic) UIButton                      *followButton;//关注按钮
@property (strong, nonatomic) UIButton                      *followNumsButton;//关注多少人按钮
@property (strong, nonatomic) UIButton                      *followerNumsButton;//粉丝多少人按钮
@property (strong, nonatomic) CustomDrawLineLabel           *topDrawLineLabel;//第一条横线
@property (strong, nonatomic) CustomDrawLineLabel           *bottomDrawLineLabel;//第二条横线
@property (strong, nonatomic) CustomDrawLineLabel           *middlewareDrawLineLabel;//中间竖线

@property (strong, nonatomic) PersonalMainView              *personalMV;//个人/他人主页
@property (strong, nonatomic) SettingView                   *settingView;

@property (readwrite, nonatomic)BOOL                        isNoNeedToBack;
@property (nonatomic, copy) void(^backAction)(id);

@property (strong, nonatomic) UISwipeGestureRecognizer      *swipGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer      *backSwipGestureRecognizer;

@property (strong, nonatomic) UIActivityIndicatorView       *activityIndicatorView;

@property (strong, nonatomic) ShareTotalViewController      *shareVC;

@property (readwrite,nonatomic) CGFloat                     moveDistance;//手势移动的距离
@property (strong, nonatomic) UIImage                       *originalCoverImage;//背景图原版
@property (readwrite,nonatomic) CGFloat                     avatarImageMoveX;//头像图像根据手势移动的X轴距离
@property (readwrite,nonatomic) CGFloat                     avatarImageMoveY;//头像图像根据手势移动的Y轴距离
@property (readwrite,nonatomic) CGFloat                     resizeRadius;//头像缩小的半径值

@end


@implementation PersonalProfile
@synthesize dragging, oldX, oldY;


#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.activityIndicatorView];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   if(weakSelf.isSelf)
                   {
                     [[DouAPIManager  sharedManager]request_GetTopUser:^(UserInstance *selfUser, NSError *error) {
                       if(!selfUser)
                         return;
                       [[DouAPIManager  sharedManager]request_GetUserProfileWithDomain :selfUser.host_domain :^(UserInstance *data, NSError *error)
                        {
                          if(data)
                          {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                              [weakSelf  initPersonalProfileWithUser :data];
                              [weakSelf.activityIndicatorView stopAnimating];
                              [weakSelf initWithTheUserInfo];
                              [weakSelf initAfterGetTheCurrentUserInfo];
                            });
                          }
                          else
                          {
                            dispatch_sync(dispatch_get_main_queue(), ^{
                              [weakSelf.activityIndicatorView stopAnimating];
                            });
                          }
                        }];
                     }];
                   }
                   else if(weakSelf.currentDomain)
                   {
                     [[DouAPIManager  sharedManager]request_GetUserProfileWithDomain :weakSelf.currentDomain :^(UserInstance *data, NSError *error)
                      {
                        if(data)
                        {
                          dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf  initPersonalProfileWithUser :data];
                            [weakSelf.activityIndicatorView stopAnimating];
                            [weakSelf  initWithTheUserInfo];
                            [weakSelf  initAfterGetTheCurrentUserInfo];
                          });
                        }
                        else
                        {
                          dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.view  addSubview:self.backButton];
                            [weakSelf.activityIndicatorView stopAnimating];
                          });
                        }
                      }];
                   }
                 });
  
}

- (void)viewDidLayoutSubviews
{
  [self.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  if(!self.currentUser)
    return;
  if(self.isSelf && self.isNoNeedToBack)
  {
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.backGroundView).offset(20);
      make.top.equalTo(self.backGroundView).offset(32);
      make.size.mas_equalTo(CGSizeMake(20,20));
    }];
  }
  else
  {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.backGroundView).offset(15);
      make.top.equalTo(self.backGroundView).offset(30);
      make.size.mas_equalTo(CGSizeMake(12,20));
    }];
  }
  [self.secondBackButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.backGroundView).offset(15);
    make.top.equalTo(self.backGroundView).offset(30);
    make.size.mas_equalTo(CGSizeMake(12,20));
  }];
  
  [self.avatarImageViewTap mas_makeConstraints:^(MASConstraintMaker *make){
    make.right.equalTo(self.backGroundView.mas_centerX).offset(-43);
    make.centerY.equalTo(self.secondBackButton);
    make.size.mas_equalTo(CGSizeMake(25,25));
  }];
  
  [self.useNameButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.avatarImageViewTap.mas_right).offset(20);
    make.centerY.equalTo(self.avatarImageViewTap);
    make.size.mas_equalTo(CGSizeMake(100,25));
  }];
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.right.equalTo(self.backGroundView).offset(-20);
    make.top.equalTo(self.backGroundView).offset(30);
    make.size.mas_equalTo(CGSizeMake(14,19));
  }];

  
  [self.avatarImageView   setFrame:CGRectMake(self.view.center.x-(32+self.resizeRadius/2)+self.avatarImageMoveX, 70+self.avatarImageMoveY, 64+self.resizeRadius, 64+self.resizeRadius)];

  /*
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(self.backGroundView.mas_centerX).offset(self.avatarImageMoveX);
    make.top.equalTo(self.backGroundView).offset(70+self.avatarImageMoveY);
    make.size.mas_equalTo(CGSizeMake(64+_resizeRadius,64+_resizeRadius));
  }];
   */
  [self.avatarImageView   doCircleFrame];
  
  [self.userName mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.backGroundView).offset(142);
    make.centerX.equalTo(self.backGroundView);
    //make.size.mas_equalTo(CGSizeMake(110,30));
  }];
  [self.userName  sizeToFit];

  if(!self.isSelf)
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make){
      make.top.equalTo(self.userName.mas_bottom).offset(20);
      make.centerX.equalTo(self.backGroundView.mas_centerX);
      make.size.mas_equalTo(CGSizeMake(120,32));
    }];
  
  [self.topDrawLineLabel mas_makeConstraints:^(MASConstraintMaker *make){
    if(self.isSelf)
      make.top.equalTo(self.userName.mas_bottom).offset(20);
    else
      make.top.equalTo(self.followButton.mas_bottom).offset(20);
    make.centerX.equalTo(self.backGroundView);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-50, 1));
  }];
  
  [self.middlewareDrawLineLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.topDrawLineLabel.mas_bottom).offset(7);
    make.centerX.equalTo(self.backGroundView);
    make.size.mas_equalTo(CGSizeMake(1, 12));
  }];

  [self.followerNumsButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(self.middlewareDrawLineLabel);
    make.right.equalTo(self.middlewareDrawLineLabel.mas_left).offset(-10);
    make.size.mas_equalTo(CGSizeMake(100, 18));
  }];

  [self.followNumsButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(self.middlewareDrawLineLabel);
    make.left.equalTo(self.middlewareDrawLineLabel.mas_right).offset(10);
    make.size.mas_equalTo(CGSizeMake(100, 18));
  }];
  
  [self.bottomDrawLineLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.middlewareDrawLineLabel.mas_bottom).offset(7);
    make.centerX.equalTo(self.backGroundView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-50, 1));
  }];
  
  [self.profileContent mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.bottomDrawLineLabel.mas_bottom).offset(20);
    make.centerX.equalTo(self.backGroundView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-50, 100));
  }];
  
  [self.profileUrlLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.bottom.equalTo(self.view).offset(-100);
    make.centerX.equalTo(self.view.mas_centerX);
    //make.size.mas_equalTo(CGSizeMake(200, 15));
  }];

  [self.refeshTheContentButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.profileUrlLabel.mas_bottom).offset(10);
    make.centerX.equalTo(self.backGroundView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(21, 12));
  }];
  
  [self.personalMV.view   setFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height-64)];
}

- (void)viewWillAppear:(BOOL)animated
{
  [PersonalProfile setRDVTabStatusStyleDirect:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}


#pragma init
/**
 *  @author J006, 15-05-19 18:05:38
 *
 *  初始化个人/他人信息
 *
 *
 */
- (void)initPersonalProfileWithUser :(UserInstance*)currentUser;
{
  self.currentUser  = currentUser;
}

- (void)initPersonalProfileWithUserDomain :(NSString*)userDomain  isSelf:(BOOL)isSelf;
{
  self.isSelf         = isSelf;
  self.currentDomain  = userDomain;
}

- (void)initWithTheUserInfo
{
  __weak typeof(self) weakSelf = self;
  if(self.currentUser.banner_photo !=nil && ![self.currentUser.banner_photo isEqualToString:@""])
  {
    NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:self.currentUser.banner_photo] stringByAppendingString:image1d5TailUrl];
    NSURL *url = [[NSURL  alloc]initWithString:urlString];
    [self.coverView  setImageWithURL:url placeholderImage:nil  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
       if(image)
       {
         image  = [image imageWithGaussianBlur:image];
         [weakSelf.coverView  setSize:CGSizeMake(kScreen_Width, kScreen_Height)];
         image  = [image cutSizeFitFor:CGSizeMake(kScreen_Width, kScreen_Height)];
         UIImage  *twoImage = [UIImage  imageWithColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3] withFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
         image  = [image  addTwoImageToOne:image twoImage:twoImage topleft:CGPointZero];
         [weakSelf.coverView setImage:image];
         weakSelf.originalCoverImage  = image;
       }
     }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  }
  
  [self.avatarImageViewTap setImageWithUrlWaitForLoadForAvatarCircle:[[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.currentUser.host_avatar]] placeholderImage:nil tapBlock:^(id obj)
   {
   }];
  [self.avatarImageView  setImageWithURL:[[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.currentUser.host_avatar]] placeholderImage:nil  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
   {
   }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [self.userName setText:self.currentUser.host_name];
  
  if(self.currentUser && !self.isSelf)
  {
    if(self.currentUser.follow_state  ==  follow_NO || self.currentUser.follow_state  == follow_HE)
    {
      [self.followButton  setImage:[UIImage imageNamed:@"followProfileButton.png"] forState:UIControlStateNormal];
      [self.followButton  addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else  if(self.currentUser.follow_state  ==  follow_YES || self.currentUser.follow_state  == follow_EACH)
    {
      [self.followButton  setImage:[UIImage imageNamed:@"followedProfileButton.png"] forState:UIControlStateNormal];
      [self.followButton  addTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  
  [self.settingButton addTarget:self action:@selector(jumpToSettingView:) forControlEvents:UIControlEventTouchUpInside];
  
  [self.useNameButton setTitle:self.currentUser.host_name forState:UIControlStateNormal];
  [self.useNameButton addTarget:self action:@selector(touchMoveAndHideTheMainView) forControlEvents:UIControlEventTouchUpInside];
  
  NSMutableAttributedString *followString = [[NSMutableAttributedString alloc]initWithString:@"关注  "];
  [followString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0] range:NSMakeRange(0,followString.length)];
  [followString addAttribute:NSFontAttributeName value:SourceHanSansNormal12 range:NSMakeRange(0,followString.length)];
  NSString  *nums = [NSString stringWithFormat:@"%ld",self.currentUser.follow_count];
  NSMutableAttributedString *numsAttr = [[NSMutableAttributedString alloc]initWithString:nums];
  [numsAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,numsAttr.length)];
  [numsAttr addAttribute:NSFontAttributeName value:HeitiSCMedium13 range:NSMakeRange(0,numsAttr.length)];
  [followString appendAttributedString:numsAttr];
  [self.followNumsButton  addTarget:self action:@selector(jumpToFollowerOrFansView:) forControlEvents:UIControlEventTouchUpInside];
  [self.followNumsButton  setAttributedTitle:followString forState:UIControlStateNormal];
  [self.followNumsButton.titleLabel    setShadowColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:233.0/255 alpha:0.3]];
  [self.followNumsButton.titleLabel    setShadowOffset:CGSizeMake(0, 0.5)];
  self.followNumsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  
  NSMutableAttributedString *followerString = [[NSMutableAttributedString alloc]initWithString:@"粉丝  "];
  [followerString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0] range:NSMakeRange(0,followerString.length)];
  [followerString addAttribute:NSFontAttributeName value:SourceHanSansNormal12 range:NSMakeRange(0,followerString.length)];
  NSString  *followerNums = [NSString stringWithFormat:@"%ld",self.currentUser.follower_count];
  NSMutableAttributedString *followerNumsAttr = [[NSMutableAttributedString alloc]initWithString:followerNums];
  [followerNumsAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,followerNumsAttr.length)];
  [followerNumsAttr addAttribute:NSFontAttributeName value:HeitiSCMedium13 range:NSMakeRange(0,followerNumsAttr.length)];
  [followerString   appendAttributedString:followerNumsAttr];
  [self.followerNumsButton  setAttributedTitle:followerString forState:UIControlStateNormal];
  [self.followerNumsButton  addTarget:self action:@selector(jumpToFollowerOrFansView:) forControlEvents:UIControlEventTouchUpInside];
  [self.followerNumsButton.titleLabel    setShadowColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:233.0/255 alpha:0.3]];
  [self.followerNumsButton.titleLabel    setShadowOffset:CGSizeMake(0, 0.5)];
  self.followerNumsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  
  NSString  *profileString = @"";
  profileString  = self.currentUser.host_desc;
  [self.profileContent   setText:profileString];
  [self.profileContent   setLineSpacing:8];
  
  NSString  *selfUrlString = @"paiwo.co/";
  selfUrlString  = [selfUrlString stringByAppendingString:self.currentUser.host_domain];
  [self.profileUrlLabel setText:selfUrlString];
  [self.profileUrlLabel sizeToFit];
  
  [self.refeshTheContentButton  addTarget:self action:@selector(touchMoveAndShowTheMainView) forControlEvents:UIControlEventTouchUpInside];
  
  [self.personalMV  initPersonalMainViewWithUser  :self.currentUser];
  [self.personalMV.view  setUserInteractionEnabled:NO];//初始化禁用各种点击事件
}

- (void)initAfterGetTheCurrentUserInfo
{
  //[self initWithTheUserInfo];
  [self.view  addSubview:self.personalMV.view];
  [self.view  addSubview:self.backGroundView];
  [self.backGroundView  addSubview:self.coverView];
  if(self.isSelf && self.isNoNeedToBack)//是自己并且不需要返回
  {
    [self.backGroundView  addSubview:self.settingButton];
  }
  else  if(self.isSelf && !self.isNoNeedToBack)//是自己并且需要返回
  {
    [self.backGroundView  addSubview:self.backButton];
    [self.backGroundView  addGestureRecognizer:self.backSwipGestureRecognizer];
  }
  else  if(!self.isSelf)//不是自己
  {
    [self.backGroundView  addSubview:self.backButton];
    [self.backGroundView  addSubview:self.followButton];
    [self.backGroundView  addGestureRecognizer:self.backSwipGestureRecognizer];
  }
  [self.backGroundView  addSubview:self.secondBackButton];
  [self.backGroundView  addSubview:self.avatarImageViewTap];
  [self.backGroundView  addSubview:self.useNameButton];
  [self.backGroundView  addSubview:self.shareButton];
  [self.backGroundView  addSubview:self.avatarImageView];
  [self.backGroundView  addSubview:self.userName];
  [self.backGroundView  addSubview:self.refeshTheContentButton];
  [self.backGroundView  addSubview:self.profileContent];
  [self.backGroundView  addSubview:self.profileUrlLabel];
  [self.backGroundView  addSubview:self.followNumsButton];
  [self.backGroundView  addSubview:self.followerNumsButton];
  [self.backGroundView  addSubview:self.topDrawLineLabel];
  [self.backGroundView  addSubview:self.bottomDrawLineLabel];
  [self.backGroundView  addSubview:self.middlewareDrawLineLabel];
  //[self.view  addGestureRecognizer:self.swipGestureRecognizer];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareUserNotifiation:) name:@"ShareUserAction" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needToRefreshUserNotifiation:) name:@"refreshPersonalProfile" object:nil];
}

#pragma UIGestureRecognizerDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [touches anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  if (CGRectContainsPoint(self.view.frame, touchLocation))
  {
      dragging = YES;
      oldX = touchLocation.x;
      oldY = touchLocation.y;
  }
  [self.personalMV.view  setUserInteractionEnabled:NO];//初始化禁用各种点击事件
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  dragging = NO;
  float bottomYCoverView = ABS(self.coverView.frame.origin.y);
  if(bottomYCoverView<=kScreen_Height/2)
  {
    [self touchMoveAndHideTheMainView];
  }
  else
  {
    [self touchMoveAndShowTheMainView];
  }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint touchLocation = [touch locationInView:self.view];
  if (dragging)
  {
    CGFloat  moveDistanceY  = touchLocation.y-oldY;
    oldY  = touchLocation.y;
    self.moveDistance = moveDistanceY;
    if(self.moveDistance>=0 && self.coverView.frame.origin.y>=0)
    {
      return;
    }
    [self setbackGroundHeightNewHeightForMove:moveDistanceY];
  }
}


#pragma private methods
/**
 *  @author J006, 15-09-06
 *
 *  手势移动隐蔽主界面
 *
 */
- (void)touchMoveAndHideTheMainView
{
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                     [self.coverView setOrigin:CGPointMake(0, 0)];
                     if(self.currentUser.is_self)
                       [self.settingButton  setAlpha:1.0];
                     else
                     {
                       [self.backButton             setAlpha:1.0];
                       [self.followButton           setAlpha:1.0];
                     }
                     [self.secondBackButton         setAlpha:0.0];
                     [self.useNameButton            setAlpha:0.0];
                     //[self.avatarImageViewTap  setAlpha:1.0];
                     [self.shareButton              setAlpha:1.0];
                     [self.profileUrlLabel          setAlpha:1.0];
                     [self.userName                 setAlpha:1.0];
                     [self.refeshTheContentButton   setAlpha:1.0];
                     [self.profileContent           setAlpha:1.0];
                     [self.followNumsButton         setAlpha:1.0];
                     [self.followerNumsButton       setAlpha:1.0];
                     [self.topDrawLineLabel         setAlpha:1.0];
                     [self.bottomDrawLineLabel      setAlpha:1.0];
                     [self.middlewareDrawLineLabel  setAlpha:1.0];
                     [self.avatarImageView.image  scaledToSize:CGSizeMake(64, 64)];
                     [self.avatarImageView  setFrame:CGRectMake(kScreen_Width/2-32, 70, 64, 64)];
                     [self.avatarImageView doCircleFrame];
                   }completion:^(BOOL finished){
                     [self.personalMV.view  setUserInteractionEnabled:NO];//初始化禁用各种点击事件
                     [self.backGroundView setOrigin:CGPointMake(0, 0)];
                     [self.backGroundView setHeight:kScreen_Height];
                     self.avatarImageMoveX = 0;
                     self.avatarImageMoveY = 0;
                     self.resizeRadius     = 0;
                   }];
}

/**
 *  @author J006, 15-09-06
 *
 *  手势移动显示主界面
 *
 */
- (void)touchMoveAndShowTheMainView
{
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                     self.coverView.center = CGPointMake(kScreen_Width/2, (-kScreen_Height/2)+64);
                     if(self.currentUser.is_self)
                       [self.settingButton  setAlpha:0.0];
                     else
                     {
                       [self.followButton           setAlpha:0.0];
                       [self.backButton             setAlpha:0.0];
                     }
                     [self.secondBackButton         setAlpha:1.0];
                     [self.useNameButton            setAlpha:1.0];
                     [self.shareButton              setAlpha:0.0];
                     [self.profileUrlLabel          setAlpha:0.0];
                     [self.userName                 setAlpha:0.0];
                     [self.refeshTheContentButton   setAlpha:0.0];
                     [self.profileContent           setAlpha:0.0];
                     [self.followNumsButton         setAlpha:0.0];
                     [self.followerNumsButton       setAlpha:0.0];
                     [self.topDrawLineLabel         setAlpha:0.0];
                     [self.bottomDrawLineLabel      setAlpha:0.0];
                     [self.middlewareDrawLineLabel  setAlpha:0.0];
                     //[self.avatarImageView.image  scaledToSize:CGSizeMake(64-41, 64-41)];
                     [self.avatarImageView  setFrame:CGRectMake(kScreen_Width/2-(32-41/2)-43, 70-40, 64-41, 64-41)];
                     //[self.avatarImageView doCircleFrame];
                   }completion:^(BOOL finished){
                     [self.personalMV.view  setUserInteractionEnabled:YES];//初始化禁用各种点击事件
                     [self.backGroundView setOrigin:CGPointMake(0, 0)];
                     [self.backGroundView setHeight:64];
                     self.avatarImageMoveX = -43;
                     self.avatarImageMoveY = -40;
                     self.resizeRadius     = -41;
                     [self.view setNeedsLayout];
                   }];
}

/**
 *  @author J006, 15-09-02
 *
 *  设置背景随着手势移动,并且相关控件隐藏
 *
 *  @param moveDistance
 */
- (void)setbackGroundHeightNewHeightForMove  :(CGFloat)moveDistance
{
  CGFloat height      = self.backGroundView.frame.size.height;
  CGFloat coverViewY  = self.coverView.frame.origin.y;
  if(coverViewY+moveDistance>0)
    moveDistance  = -coverViewY;
  [self.backGroundView       setHeight:height+moveDistance];
  [self.coverView setY:self.coverView.frame.origin.y+moveDistance];

  [self checkTheCompentAndSetTheAlphaWithCompent  :self.profileUrlLabel];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.userName];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.refeshTheContentButton];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.profileContent];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.followButton];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.followNumsButton];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.followerNumsButton];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.topDrawLineLabel];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.bottomDrawLineLabel];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.middlewareDrawLineLabel];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.followButton];
  [self checkTheCompentAndSetTheAlphaWithCompent  :self.shareButton];
  [self checkTheAvatarImageMove                   :self.avatarImageView];
}

/**
 *  @author J006, 15-09-06
 *
 *  对需要随着手势移动的控件进行隐藏,改变的alpha值等同于屏幕向上移动的总距离距离 比上 控件离屏幕底部的距离
 *
 *  @param compentView
 */

- (void)checkTheCompentAndSetTheAlphaWithCompent  :(UIView*)compentView
{
  float bottomYCoverView = ABS(self.coverView.frame.origin.y);
  float compentYView     = kScreen_Height-compentView.frame.origin.y;
  double  tempAlpha = bottomYCoverView/compentYView;
  if(tempAlpha>1.0)
    [compentView setAlpha:0.0];
  else  if(bottomYCoverView==0)
    [compentView setAlpha:1.0];
  else
    [compentView setAlpha:(1-tempAlpha)];
}

- (void)checkTheAvatarImageMove  :(UIView*)avatarImageView
{
  float bottomYCoverView      = ABS(self.coverView.frame.origin.y);
  float avatarImageViewY      = kScreen_Height-avatarImageView.frame.origin.y;
  double  tempPropotion = bottomYCoverView/avatarImageViewY;
  if(tempPropotion>=1.0)
  {
    self.avatarImageMoveX = -43;
    self.avatarImageMoveY = -40;
    self.resizeRadius     = -41;
  }
  else  if(bottomYCoverView==0)
  {
    self.avatarImageMoveX = 0;
    self.avatarImageMoveY = 0;
    self.resizeRadius     = 0;
  }
  else
  {
    self.avatarImageMoveX = -tempPropotion*43;
    self.avatarImageMoveY = -tempPropotion*40;
    self.resizeRadius     = -tempPropotion*41;
  }
  [self.view setNeedsLayout];
}

#pragma event method
/**
 *  @author J006, 15-06-25 16:06:10
 *
 *  跳转到个人/他人主页详细
 *
 *  @param sender
 */
- (void)jumpToPersonalMainView:(id)sender
{
  [self.swipGestureRecognizer setEnabled:NO];
  if(_backSwipGestureRecognizer)
    [_backSwipGestureRecognizer setEnabled:NO];

  [[PersonalProfile presentingVC].navigationController   setNavigationBarHidden:YES];
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                     self.personalMV.view.center = CGPointMake(kScreen_Width/2, (kScreen_Height/2)+32);
                     if(self.currentUser.is_self)
                       [self.settingButton  setAlpha:0.0];
                     else
                       [self.backButton setAlpha:0.0];
                     [self.secondBackButton setAlpha:1.0];
                     [self.useNameButton setAlpha:1.0];
                     [self.avatarImageViewTap  setAlpha:1.0];
                   }completion:^(BOOL finished){
                   }];

}

/**
 *  @author J006, 15-05-19 18:05:03
 *
 *  返回上层
 *
 *  @param sender
 */
- (void)backToLastView:(id)sender
{
  if(self.backAction)
      self.backAction(self);
  else
    [[PersonalProfile  getNavi]popViewControllerAnimated:YES];
}

/**
 *  @author J006, 15-05-19 20:05:02
 *
 *  跳转到设置界面
 *
 *  @param sender
 */
- (void)jumpToSettingView:(id)sender
{
  _settingView  = [[SettingView  alloc]init];
  [_settingView  initSettingView  :_currentUser];
  [[PersonalProfile  getNavi] setNavigationBarHidden:NO animated:NO];
  [PersonalProfile  setRDVTabHidden:YES isAnimated:NO];
  _settingView.view.frame  = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
  [PersonalProfile  naviPushViewController:_settingView];
}

- (void)addBackBlock:(void(^)(id obj))backAction
{
  self.backAction = backAction;
  [self.backButton  addTarget:self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  @author J006, 15-06-29 14:06:21
 *
 *  关注对方
 *
 *  @param sender
 */
- (void)followAction  :(id)sender
{
  NSInteger   host_id  = self.currentUser.host_id;
  [[DouAPIManager  sharedManager]request_FollowWithFollowID:host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      [self.followButton             setImage:[UIImage imageNamed:@"followedProfileButton"] forState:UIControlStateNormal];
      [self.followButton             removeTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.followButton             addTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.currentUser              setFollow_state:follow_state];
    }
  }];
}

- (void)unFollowAction  :(id)sender
{
  NSInteger   host_id  = self.currentUser.host_id;
  [[DouAPIManager  sharedManager]request_UnFollowWithFollowID:host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      [self.followButton             setImage:[UIImage imageNamed:@"followProfileButton.png"] forState:UIControlStateNormal];
      [self.followButton             removeTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.followButton             addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.currentUser              setFollow_state:follow_state];
    }
  }];
}

- (void)jumpToFollowerOrFansView  :(UIButton*)button
{
  FollowAndFansView *followAndFansView  = [[FollowAndFansView  alloc]init];
  if([button isEqual:self.followNumsButton])
    [followAndFansView  initFollowAndFansViewWithUserDomain:self.currentUser.host_domain withTitle:@"关注列表" withType:follow];
  else  if([button isEqual:self.followerNumsButton])
    [followAndFansView  initFollowAndFansViewWithUserDomain:self.currentUser.host_domain withTitle:@"粉丝列表" withType:fans];
  [[PersonalProfile  getNavi] setNavigationBarHidden:NO animated:NO];
  [PersonalProfile  naviPushViewController:followAndFansView];
}

- (void)shareTheCurrentUserAction
{
  self.shareVC  = [[ShareTotalViewController alloc]init];
  UIImage *image  = [[UIImage  alloc]init];
  image = [image  takeSnapshotOfView:self.view];
  [self.shareVC  initShareUserWithSnapshot:image shareUser:self.currentUser shareContentType:ShareContentTypeUser];
  [self.shareVC .view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height+pageToolBarHeight)];
  if(![PersonalProfile  checkRDVTabIsHidden])
  {
    [self.shareVC  confirmIsNeedToSetRDVShow:YES];
    [PersonalProfile setRDVTabHidden:YES isAnimated:NO];
  }
  //[self.view   removeGestureRecognizer:self.swipGestureRecognizer];
  //self.swipGestureRecognizer  = nil;
  [self.swipGestureRecognizer  setEnabled:NO];
  if(_backSwipGestureRecognizer)
    [_backSwipGestureRecognizer setEnabled:NO];
  [PersonalProfile naviPushViewControllerWithNoAniation:self.shareVC];
}

- (void)shareUserNotifiation :(NSNotification *) notification
{
  if ([[notification name] isEqualToString:@"ShareUserAction"])
  {
    [PersonalProfile setRDVTabHidden:NO isAnimated:NO];
    [self.swipGestureRecognizer   setEnabled:YES];
    if(_backSwipGestureRecognizer)
      [_backSwipGestureRecognizer setEnabled:YES];
  }
}

- (void)needToRefreshUserNotifiation :(NSNotification *) notification
{
  if ([[notification name] isEqualToString:@"refreshPersonalProfile"])
  {
    [self initWithTheUserInfo];
  }
}

#pragma getter setter

- (void)setValueIsNoNeedToBack :(BOOL)isNoNeedToBack
{
  self.isNoNeedToBack = isNoNeedToBack;
}

- (UIButton*)settingButton
{
  if(_settingButton ==nil)
  {
    _settingButton  = [[UIButton alloc]init];
    [_settingButton setImage:[UIImage imageNamed:@"settingButton"] forState:UIControlStateNormal];
  }
  return _settingButton;
}

- (UIButton*)backButton
{
  if(_backButton  ==  nil)
  {
    _backButton  = [[UIButton alloc]init];
    [_backButton setImage:[UIImage imageNamed:@"profileBackButton"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _backButton;
}

- (UIButton*)shareButton
{
  if(_shareButton  ==  nil)
  {
    _shareButton  = [[UIButton alloc]init];
    [_shareButton setImage:[UIImage imageNamed:@"shareNoCircleWhiteButton"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareTheCurrentUserAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareButton;
}

- (UIImageView*)coverView
{
  if(_coverView  ==  nil)
  {
    _coverView  = [[UIImageView alloc]init];
    UIImage   *image  = [UIImage imageNamed:@"profileCover.png"];
    image  = [image imageWithGaussianBlur:image];
    image  = [image cutSizeFitFor:CGSizeMake(kScreen_Width, kScreen_Height)];
    [_coverView  setImage:image];
    [_coverView  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  }
  return  _coverView;
}

- (UIImageView*)avatarImageView
{
  if(_avatarImageView  ==  nil)
  {
    _avatarImageView  = [[UIImageView alloc]init];
    [_avatarImageView  setSize:CGSizeMake(64, 64)];
    [_avatarImageView  doCircleFrame];
  }
  return  _avatarImageView;
}

- (UILabel*)userName
{
  if(_userName  ==  nil)
  {
    _userName = [[UILabel  alloc]init];
    NSString  *nameString = @"";
    [_userName    setFont:SourceHanSansMedium18];
    //[_userName    setShadowColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
    //[_userName    setShadowOffset:CGSizeMake(0, 0)];
    [_userName    setTextColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]];
    [_userName    setText:nameString];
    [_userName    setTextAlignment:NSTextAlignmentCenter];
  }
  return _userName;
}

- (UIButton*)refeshTheContentButton
{
  if(_refeshTheContentButton  ==  nil)
  {
    _refeshTheContentButton = [[UIButton alloc]init];
    [_refeshTheContentButton  setImage:[UIImage imageNamed:@"downRefreshProfileButton.png"] forState:UIControlStateNormal];
  }
  return _refeshTheContentButton;
}

- (CustomLabel*)profileContent
{
  if(_profileContent  ==  nil)
  {
    _profileContent =   [[CustomLabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-50, 100)];
    NSString  *profileString = @"";
    [_profileContent    setFont:SourceHanSansLight12];
    [_profileContent    setText:profileString];
    [_profileContent    setNumberOfLines:16];
    [_profileContent    setTextColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    
  }
  return _profileContent;
}

- (UILabel*)profileUrlLabel
{
  if(_profileUrlLabel  ==  nil)
  {
    _profileUrlLabel = [[UILabel  alloc]init];
    NSString  *urlString = @"paiwo.co/";
    [_profileUrlLabel    setFont:SourceHanSansLight13];
    [_profileUrlLabel    setText:urlString];
    //[_profileUrlLabel    setTextColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1.0]];
    //[_profileUrlLabel    setShadowColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:0.5]];
    //[_profileUrlLabel    setShadowOffset:CGSizeMake(0, 1)];
    [_profileUrlLabel    setTextColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    [_profileUrlLabel    setTextAlignment:NSTextAlignmentCenter];
  }
  return _profileUrlLabel;
}

- (UIButton*)followButton
{
  if(_followButton  ==  nil)
  {
    _followButton = [[UIButton alloc]init];
  }
  return _followButton;
}

- (UIButton*)followNumsButton
{
  if(_followNumsButton  ==  nil)
  {
    _followNumsButton = [[UIButton alloc]init];
    NSString  *followString = @"关注  ";
    [_followNumsButton  setTitle:followString forState:UIControlStateNormal];
    [_followNumsButton.titleLabel setTextColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:233.0/255 alpha:1.0]];
    //[_followNumsButton.titleLabel    setShadowColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:233.0/255 alpha:0.3]];
    //[_followNumsButton.titleLabel    setShadowOffset:CGSizeMake(0, 0.5)];
    [_followNumsButton.titleLabel setFont:SourceHanSansMedium12];
  }
  return _followNumsButton;
}

- (UIButton*)followerNumsButton
{
  if(_followerNumsButton  ==  nil)
  {
    _followerNumsButton = [[UIButton alloc]init];
    NSString  *followerString = @"粉丝  ";
    [_followerNumsButton  setTitle:followerString forState:UIControlStateNormal];
    [_followerNumsButton.titleLabel     setTextColor:[UIColor colorWithRed:223/255.0 green:223/255.0 blue:233.0/255 alpha:1.0]];
    //[_followerNumsButton.titleLabel     setShadowColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3]];
    //[_followerNumsButton.titleLabel     setShadowOffset:CGSizeMake(0, 0.5)];
    [_followerNumsButton.titleLabel     setFont:SourceHanSansMedium12];
  }
  return _followerNumsButton;
}

- (CustomDrawLineLabel*)topDrawLineLabel
{
  if(_topDrawLineLabel  ==  nil)
  {
    _topDrawLineLabel  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(kScreen_Width-50, 0);
    [_topDrawLineLabel    setShadowColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5]];
    [_topDrawLineLabel    setShadowOffset:CGSizeMake(0, 0.5)];
    [_topDrawLineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _topDrawLineLabel;
}

- (CustomDrawLineLabel*)bottomDrawLineLabel
{
  if(_bottomDrawLineLabel  ==  nil)
  {
    _bottomDrawLineLabel  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(kScreen_Width-50, 0);
    [_bottomDrawLineLabel    setShadowColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5]];
    [_bottomDrawLineLabel    setShadowOffset:CGSizeMake(0, 1)];
    [_bottomDrawLineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _bottomDrawLineLabel;
}

- (CustomDrawLineLabel*)middlewareDrawLineLabel
{
  if(_middlewareDrawLineLabel  ==  nil)
  {
    _middlewareDrawLineLabel  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(0, 12);
    [_middlewareDrawLineLabel    setShadowColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.5]];
    [_middlewareDrawLineLabel    setShadowOffset:CGSizeMake(0, 1)];
    [_middlewareDrawLineLabel    initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _middlewareDrawLineLabel;
}

- (PersonalMainView*)personalMV
{
  if(_personalMV  ==  nil)
  {
    _personalMV = [[PersonalMainView alloc]init];
  }
  return _personalMV;
}

- (UIButton*)secondBackButton
{
  if(_secondBackButton  ==  nil)
  {
    _secondBackButton  = [[UIButton alloc]init];
    [_secondBackButton setImage:[UIImage imageNamed:@"profileBackButton"] forState:UIControlStateNormal];
    [_secondBackButton addTarget:self action:@selector(touchMoveAndHideTheMainView) forControlEvents:UIControlEventTouchUpInside];
    [_secondBackButton setAlpha:0.0];
  }
  return _secondBackButton;
}

- (UIButton*)useNameButton
{
  if(_useNameButton  ==  nil)
  {
    _useNameButton  = [[UIButton alloc]init];
    [_useNameButton.titleLabel setTextColor:[UIColor whiteColor]];
    _useNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_useNameButton.titleLabel setFont:SourceHanSansNormal17];
    [_useNameButton setAlpha:0.0];
  }
  return _useNameButton;
}

- (UITapImageView*)avatarImageViewTap
{
  if(_avatarImageViewTap ==  nil)
  {
    _avatarImageViewTap  = [[UITapImageView alloc]init];
    [_avatarImageViewTap setSize: CGSizeMake(25,25)];
    [_avatarImageViewTap doCircleFrame];
    [_avatarImageViewTap  setAlpha:0.0];
  }
  return _avatarImageViewTap;
}

- (UIActivityIndicatorView*)activityIndicatorView
{
  if(_activityIndicatorView ==  nil)
  {
    _activityIndicatorView  = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView setCenter:self.view.center];
    [_activityIndicatorView startAnimating];
  }
  return _activityIndicatorView;
}


- (UISwipeGestureRecognizer*)backSwipGestureRecognizer
{
  if(_backSwipGestureRecognizer ==  nil)
  {
    _backSwipGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView:)];
    [_backSwipGestureRecognizer   setDirection:UISwipeGestureRecognizerDirectionRight];
  }
  return _backSwipGestureRecognizer;
}

- (UIView*)backGroundView
{
  if(_backGroundView  ==  nil)
  {
    _backGroundView = [[UIView alloc]init];
    [_backGroundView  setBackgroundColor:[UIColor whiteColor]];
    [_backGroundView  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  }
  return _backGroundView;
}


@end
