//
//  ShareTotalViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/7/23.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "ShareTotalViewController.h"
#import "CustomDrawLineLabel.h"
#import "NSString+Common.h"
#import <Masonry.h>
#import "UITapImageView.h"
#import "SocialUtilManager.h"
@interface ShareTotalViewController ()

@property (strong,nonatomic)  UITapImageView      *maskView;//背景蒙版带高斯模糊
@property (strong,nonatomic)  UIView              *mainView;//主界面
@property (strong,nonatomic)  UIButton            *cancelButton;//取消按钮

@property (strong,nonatomic)  UILabel             *shareLabel;//分享至...
@property (strong,nonatomic)  UIButton            *shareToWeChatButton;//分享到微信好友
@property (strong,nonatomic)  UILabel             *shareToWeChatLabel;
@property (strong,nonatomic)  UIButton            *shareToWeChatFriendsButton;//分享到微信朋友圈
@property (strong,nonatomic)  UILabel             *shareToWeChatFriendsLabel;
@property (strong,nonatomic)  UIButton            *shareToWeiboButton;//分享到微博
@property (strong,nonatomic)  UILabel             *shareToWeiboLabel;
@property (strong,nonatomic)  UIButton            *shareToQQButton;//分享到QQ好友
@property (strong,nonatomic)  UILabel             *shareToQQLabel;
@property (strong,nonatomic)  CustomDrawLineLabel *lineLabel;

@property (strong,nonatomic)  UIImage             *mainBlurImage;
@property (strong,nonatomic)  UIImageView         *mainBlurImageView;

@property (strong,nonatomic)  AlbumInstance       *album;
@property (strong,nonatomic)  AlbumPhotoInstance  *albumPhoto;
@property (strong,nonatomic)  PocketItemInstance  *pocket;
@property (strong,nonatomic)  UserInstance        *shareUser;

@property (readwrite,nonatomic)ShareContentType   contentType;

@property (readwrite,nonatomic)BOOL               isNeedToSetRDVShow;

@end

@implementation ShareTotalViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  setBackgroundColor:[UIColor clearColor]];
  _mainBlurImage   = [_mainBlurImage imageWithGaussianBlur:_mainBlurImage];
  [self.view            addSubview:self.mainBlurImageView];
  [self.view            addSubview:self.maskView];
  [self.view            addSubview:self.mainView];
  [self.mainView        addSubview:self.shareLabel];
  [self.mainView        addSubview:self.shareToWeChatButton];
  [self.mainView        addSubview:self.shareToWeChatLabel];
  [self.mainView        addSubview:self.shareToWeChatFriendsButton];
  [self.mainView        addSubview:self.shareToWeChatFriendsLabel];
  [self.mainView        addSubview:self.shareToWeiboButton];
  [self.mainView        addSubview:self.shareToWeiboLabel];
  [self.mainView        addSubview:self.shareToQQButton];
  [self.mainView        addSubview:self.shareToQQLabel];
  [self.mainView        addSubview:self.lineLabel];
  [self.mainView        addSubview:self.cancelButton];
  [self.mainView setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, 220)];
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                     self.mainView.center = CGPointMake(kScreen_Width/2, (kScreen_Height-110));
                   }completion:^(BOOL finished){
                   }];
  

}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.view  setBackgroundColor:[UIColor clearColor]];
  [self.maskView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  
  [self.mainView  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
    make.height.mas_equalTo(220);
  }];
  
  [self.shareLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.mainView).offset(20);
    make.centerX.equalTo(self.mainView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(65, 25));
  }];
  
  [self.shareToWeiboButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareLabel.mas_bottom).offset(30);
    make.left.equalTo(self.mainView).offset((kScreen_Width-180)/5);
    make.size.mas_equalTo(CGSizeMake(45, 45));
  }];
  
  [self.shareToWeiboLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareToWeiboButton.mas_bottom).offset(5);
    make.centerX.equalTo(self.shareToWeiboButton);
    make.size.mas_equalTo(CGSizeMake(60, 25));
  }];
  
  [self.shareToWeChatButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareLabel.mas_bottom).offset(30);
    make.left.equalTo(self.shareToWeiboButton.mas_right).offset((kScreen_Width-180)/5);
    make.size.mas_equalTo(CGSizeMake(45, 45));
  }];
  
  [self.shareToWeChatLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareToWeChatButton.mas_bottom).offset(5);
    make.centerX.equalTo(self.shareToWeChatButton);
    make.size.mas_equalTo(CGSizeMake(60, 25));
  }];
  
  [self.shareToWeChatFriendsButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareLabel.mas_bottom).offset(30);
    make.left.equalTo(self.shareToWeChatLabel.mas_right).offset((kScreen_Width-180)/5);
    make.size.mas_equalTo(CGSizeMake(45, 45));
  }];
  
  [self.shareToWeChatFriendsLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareToWeChatFriendsButton.mas_bottom).offset(5);
    make.centerX.equalTo(self.shareToWeChatFriendsButton);
    make.size.mas_equalTo(CGSizeMake(60, 25));
  }];
  
  [self.shareToQQButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareLabel.mas_bottom).offset(30);
    make.left.equalTo(self.shareToWeChatFriendsButton.mas_right).offset((kScreen_Width-180)/5);
    make.size.mas_equalTo(CGSizeMake(45, 45));
  }];
  
  [self.shareToQQLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.shareToQQButton.mas_bottom).offset(5);
    make.centerX.equalTo(self.shareToQQButton);
    make.size.mas_equalTo(CGSizeMake(60, 25));
  }];
  
  [self.lineLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.mainView).offset(-46);
    make.centerX.equalTo(self.mainView);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width, 1));
  }];
  
  [self.cancelButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.lineLabel.mas_bottom).offset(10);
    make.centerX.equalTo(self.mainView);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width, 25));
  }];
  
}

- (void)viewWillAppear:(BOOL)animated
{
  [[ShareTotalViewController getNavi]setNavigationBarHidden:YES animated:NO];
  [ShareTotalViewController setRDVTabStatusHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init

- (void)initSharePhotoAndAlbumWithSnapshot  :(UIImage*)image  albumPhoto:(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album  shareContentType:(ShareContentType)ShareContentType
{
  self.mainBlurImage  = image;
  self.album          = album;
  self.albumPhoto     = albumPhoto;
  self.contentType    = ShareContentType;
}

- (void)initSharePocketWithSnapshot  :(UIImage*)image  pocket:(PocketItemInstance*)pocket shareContentType:(ShareContentType)ShareContentType
{
  self.pocket         = pocket;
  self.mainBlurImage  = image;
  self.contentType    = ShareContentType;
}

- (void)initShareUserWithSnapshot           :(UIImage*)image  shareUser:(UserInstance*)shareUser shareContentType:(ShareContentType)ShareContentType
{
  self.mainBlurImage  = image;
  self.shareUser      = shareUser;
  self.contentType    = ShareContentType;
}

- (void)confirmIsNeedToSetRDVShow :(BOOL)isNeedToSetRDVShow
{
  self.isNeedToSetRDVShow = isNeedToSetRDVShow;
}

#pragma event

- (void)backgroundTapped
{
  
  [UIView animateWithDuration:0.3
                        delay:0.0
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                     self.mainView.center = CGPointMake(kScreen_Width/2, (kScreen_Height+110));
                   }completion:^(BOOL finished){
                        [self.navigationController popViewControllerAnimated:NO];
                        if(_isNeedToSetRDVShow)
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareUserAction" object:nil  userInfo:nil];
                   }];
}

- (void)shareThePhotoWeChatToSingleFriendAction
{
  if(self.contentType ==  ShareContentTypePhotoAndAlbum)
    [[SocialUtilManager  sharedManager]shareWechatActionWithAlbumPhoto:self.albumPhoto album:self.album isText:NO type:WXSceneSession];
  else  if(self.contentType ==  ShareContentTypePocket)
    [[SocialUtilManager  sharedManager]shareWechatActionWithPocket:self.pocket type:WXSceneSession];
  else  if(self.contentType ==  ShareContentTypeUser)
    [[SocialUtilManager  sharedManager]shareWechatActionWithUser:self.shareUser type:WXSceneSession];
}

- (void)shareThePhotoWeiboAction
{
  if(self.contentType ==  ShareContentTypePhotoAndAlbum)
    [[SocialUtilManager  sharedManager]shareWeiboActionWithAlbumPhoto:self.albumPhoto album:self.album :^(BOOL isSuccess)
     {
       
     }];
  else  if(self.contentType ==  ShareContentTypePocket)
    [[SocialUtilManager  sharedManager]shareWeiboActionWithPocket:self.pocket];
  else  if(self.contentType ==  ShareContentTypeUser)
    [[SocialUtilManager  sharedManager]shareWeiboActionWithUser:self.shareUser];
}

- (void)shareThePhotoWeChatToFriendsAction
{
  if(self.contentType ==  ShareContentTypePhotoAndAlbum)
    [[SocialUtilManager  sharedManager]shareWechatActionWithAlbumPhoto:self.albumPhoto album:self.album isText:NO type:WXSceneTimeline];
  else  if(self.contentType ==  ShareContentTypePocket)
    [[SocialUtilManager  sharedManager]shareWechatActionWithPocket:self.pocket type:WXSceneTimeline];
  else  if(self.contentType ==  ShareContentTypeUser)
    [[SocialUtilManager  sharedManager]shareWechatActionWithUser:self.shareUser type:WXSceneTimeline];
}

- (void)shareThePhotoTencenterToFriendAction
{
  if(self.contentType ==  ShareContentTypePhotoAndAlbum)
    [[SocialUtilManager  sharedManager]shareTencenterActionWithAlbumPhoto:self.albumPhoto album:self.album];
  else if (self.contentType ==  ShareContentTypePocket)
    [[SocialUtilManager  sharedManager]shareTencenterActionWithPocket:self.pocket];
  else  if(self.contentType ==  ShareContentTypeUser)
    [[SocialUtilManager  sharedManager]shareTencenterActionWithUser:self.shareUser];
}

#pragma getter setter
- (UITapImageView*)maskView
{
  if(_maskView  ==  nil)
  {
    _maskView   = [[UITapImageView alloc]init];
    UIImage *image  = [UIImage  imageWithColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3]];
    [_maskView  setImage:image];
    __weak typeof(self) weakSelf = self;
    [_maskView  addTapBlock:^(id obj) {
      [weakSelf  backgroundTapped];
    }];
  }
  return _maskView;
}

- (UIView*)mainView
{
  if(_mainView  ==  nil)
  {
    _mainView = [[UIView alloc]init];
    [_mainView setBackgroundColor:[UIColor whiteColor]];
  }
  return _mainView;
}

- (UIButton*)cancelButton
{
  if(_cancelButton  ==  nil)
  {
    _cancelButton = [[UIButton alloc]init];
    [_cancelButton  setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:SourceHanSansNormal14];
    [_cancelButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelButton  addTarget:self action:@selector(backgroundTapped) forControlEvents:UIControlEventTouchUpInside];
  }
  return _cancelButton;
}

- (UILabel*)shareLabel
{
  if(_shareLabel  ==  nil)
  {
    _shareLabel = [[UILabel  alloc]init];
    [_shareLabel  setText:@"分享至..."];
    [_shareLabel  setTextAlignment:NSTextAlignmentCenter];
    [_shareLabel  setFont:SourceHanSansNormal14];
    [_shareLabel  setTextColor:[UIColor  darkGrayColor]];
  }
  return _shareLabel;
}

- (UIButton*)shareToWeChatButton
{
  if(_shareToWeChatButton ==  nil)
  {
    _shareToWeChatButton  = [[UIButton alloc]init];
    [_shareToWeChatButton setImage:[UIImage  imageNamed:@"weixinIcon.png"] forState:UIControlStateNormal];
    [_shareToWeChatButton addTarget:self action:@selector(shareThePhotoWeChatToSingleFriendAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareToWeChatButton;
}

- (UILabel*)shareToWeChatLabel
{
  if(_shareToWeChatLabel  ==  nil)
  {
    _shareToWeChatLabel = [[UILabel  alloc]init];
    [_shareToWeChatLabel  setText:@"微信好友"];
    [_shareToWeChatLabel  setFont:SourceHanSansNormal12];
    [_shareToWeChatLabel  setTextAlignment:NSTextAlignmentCenter];
    [_shareToWeChatLabel  setFont:[UIFont systemFontOfSize:kShareTotalViewControllerSmallFontSize]];
    [_shareToWeChatLabel  setTextColor:[UIColor  lightGrayColor]];
  }
  return _shareToWeChatLabel;
}

- (UIButton*)shareToWeChatFriendsButton
{
  if(_shareToWeChatFriendsButton  ==  nil)
  {
    _shareToWeChatFriendsButton  = [[UIButton alloc]init];
    [_shareToWeChatFriendsButton setImage:[UIImage  imageNamed:@"wechatFriendsIcon.png"] forState:UIControlStateNormal];
    [_shareToWeChatFriendsButton addTarget:self action:@selector(shareThePhotoWeChatToFriendsAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareToWeChatFriendsButton;
}

- (UILabel*)shareToWeChatFriendsLabel
{
  if(_shareToWeChatFriendsLabel ==  nil)
  {
    _shareToWeChatFriendsLabel = [[UILabel  alloc]init];
    [_shareToWeChatFriendsLabel  setText:@"朋友圈"];
    [_shareToWeChatFriendsLabel  setFont:SourceHanSansNormal12];
    [_shareToWeChatFriendsLabel  setTextAlignment:NSTextAlignmentCenter];
    [_shareToWeChatFriendsLabel  setFont:[UIFont systemFontOfSize:kShareTotalViewControllerSmallFontSize]];
    [_shareToWeChatFriendsLabel  setTextColor:[UIColor  lightGrayColor]];
  }
  return _shareToWeChatFriendsLabel;
}

- (UIButton*)shareToWeiboButton
{
  if(_shareToWeiboButton  ==  nil)
  {
    _shareToWeiboButton  = [[UIButton alloc]init];
    [_shareToWeiboButton setImage:[UIImage  imageNamed:@"weiboIcon.png"] forState:UIControlStateNormal];
    [_shareToWeiboButton addTarget:self action:@selector(shareThePhotoWeiboAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareToWeiboButton;
}

- (UILabel*)shareToWeiboLabel
{
  if(_shareToWeiboLabel ==nil)
  {
    _shareToWeiboLabel = [[UILabel  alloc]init];
    [_shareToWeiboLabel  setText:@"新浪微博"];
    [_shareToWeiboLabel  setFont:SourceHanSansNormal12];
    [_shareToWeiboLabel  setTextAlignment:NSTextAlignmentCenter];
    [_shareToWeiboLabel  setFont:[UIFont systemFontOfSize:kShareTotalViewControllerSmallFontSize]];
    [_shareToWeiboLabel  setTextColor:[UIColor  lightGrayColor]];
  }
  return _shareToWeiboLabel;
}

- (UIButton*)shareToQQButton
{
  if(_shareToQQButton ==nil)
  {
    _shareToQQButton  = [[UIButton alloc]init];
    [_shareToQQButton setImage:[UIImage  imageNamed:@"qqIcon.png"] forState:UIControlStateNormal];
    [_shareToQQButton addTarget:self action:@selector(shareThePhotoTencenterToFriendAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareToQQButton;
}

- (UILabel*)shareToQQLabel
{
  if(_shareToQQLabel  ==nil)
  {
    _shareToQQLabel = [[UILabel  alloc]init];
    [_shareToQQLabel  setText:@"QQ"];
    [_shareToQQLabel  setFont:SourceHanSansNormal12];
    [_shareToQQLabel  setTextAlignment:NSTextAlignmentCenter];
    [_shareToQQLabel  setFont:[UIFont systemFontOfSize:kShareTotalViewControllerSmallFontSize]];
    [_shareToQQLabel  setTextColor:[UIColor  lightGrayColor]];
  }
  return _shareToQQLabel;
}

- (CustomDrawLineLabel*)lineLabel
{
  if(_lineLabel ==  nil)
  {
    _lineLabel  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(kScreen_Width, 0);
    [_lineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _lineLabel;
}

- (UIImageView*)mainBlurImageView
{
  if(_mainBlurImageView ==  nil)
  {
    _mainBlurImageView  = [[UIImageView  alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [_mainBlurImageView  setImage:self.mainBlurImage];
  }
  return _mainBlurImageView;
}

@end
