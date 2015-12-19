//
//  PhotosViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/6/17.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "PhotosViewController.h"
#import "CustomLabel.h"
#import "PhotoImageWallView.h"
#import "CustomDrawLineLabel.h"
#import "PhotoItemImageView.h"
#import "UITapImageView.h"
#import "PhotoLikeCommentToolBar.h"
#import "AlbumDetailPage.h"
#import "ImageDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "DouAPIManager.h"
#import "PersonalProfile.h"
#import <Masonry.h>
#import "SocialUtilManager.h"
#import "AppDelegate.h"
#import "NSString+Common.h"
#import "TotalPhotoViewController.h"

typedef NS_ENUM(NSInteger, ScrollDirection) {
  ScrollDirectionNone=0,
  ScrollDirectionRight=1,
  ScrollDirectionLeft=2,
  ScrollDirectionUp=3,
  ScrollDirectionDown=4,
  ScrollDirectionCrazy=5,
} ;
@interface PhotosViewController ()

@property (nonatomic,strong)  UITapImageView            *photoImageButton;//主图片展示
@property (nonatomic, strong) UILabel                   *fromAlbumLabel;//来自相册
@property (nonatomic, strong) UIButton                  *albumNameButton;//相册名称
@property (nonatomic,strong)  UILabel                   *albumContent;//专辑简介
@property (strong, nonatomic) CustomDrawLineLabel       *lineLabelLeftAuthor;//左边直线
@property (strong, nonatomic) CustomDrawLineLabel       *lineLabelRightAuthor;//右边直线
@property (nonatomic, strong) UILabel                   *authorInforLabel;//作者信息
@property (nonatomic,strong)  UITapImageView            *theNewAvatarImage;//头像
@property (nonatomic,strong)  UIButton                  *userNameButton;//用户名称
@property (nonatomic,strong)  UIButton                  *followButton;//关注
@property (nonatomic, strong) UILabel                   *youMayBeLikeLabel;//你可能喜欢
@property (nonatomic, strong) UIScrollView              *imageScrollView;//图片墙的滚动
@property (nonatomic, strong) PhotoImageWallView        *imageWallView;//照片墙
@property (strong, nonatomic) UIView                    *contenView;//底部界面,容器
@property (strong, nonatomic) CustomDrawLineLabel       *lineLabelLeft;//左边直线
@property (strong, nonatomic) CustomDrawLineLabel       *lineLabelRight;//右边直线
@property (strong, nonatomic) PhotoLikeCommentToolBar   *photoLikeCommentToolBar;//底部工具栏
@property (strong, nonatomic) ImageDetailView           *imageDetailView;//图片预览界面

@property (strong, nonatomic) PersonalProfile           *ppView;

@property (nonatomic,readwrite)NSInteger                photoID;
@property (nonatomic,strong)  AlbumPhotoInstance        *currentAlbumPhoto;
@property (nonatomic,strong)  UserInstance              *crrUser;
@property (nonatomic,strong)  AlbumInstance             *album;
@property (nonatomic,strong)  NSMutableArray            *recommendPhotoList;

@property (readwrite,nonatomic)float                    imageWallViewWidth;
@property (readwrite,nonatomic)float                    imageWallViewHeight;
@property (nonatomic,strong)   NSMutableArray           *tempArray;

@property (strong,nonatomic)  PhotosViewController      *nextPhotosVC;

@property (nonatomic,readwrite) CGFloat                 lastContentOffset;
@property (nonatomic,readwrite) ScrollDirection         scrollDirection;

@property (nonatomic,readwrite) BOOL                    isFading;//分享按钮正在动画

@property (strong, nonatomic) UISwipeGestureRecognizer  *swipGestureRecognizer;//右划后退

@property (strong, nonatomic) UIActivityIndicatorView  *activictyIndicatorView;

@property (strong, nonatomic) TotalPhotoViewController  *topPhotoVC;

@property (nonatomic, copy) void(^backAction)(id);
@end

@implementation PhotosViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.imageScrollView];
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self.imageScrollView   addSubview:self.contenView];
  [self.contenView        addSubview:self.photoImageButton];
  [self.contenView        addSubview:self.fromAlbumLabel];
  [self.contenView        addSubview:self.albumNameButton];
  [self.contenView        addSubview:self.albumContent];
  [self.contenView        addSubview:self.lineLabelLeftAuthor];
  [self.contenView        addSubview:self.lineLabelRightAuthor];
  [self.contenView        addSubview:self.authorInforLabel];
  [self.contenView        addSubview:self.theNewAvatarImage];
  [self.contenView        addSubview:self.userNameButton];
  [self.contenView        addSubview:self.followButton];
  [self.contenView        addSubview:self.albumContent];
  [self.contenView        addSubview:self.youMayBeLikeLabel];
  [self.contenView        addSubview:self.lineLabelLeft];
  [self.contenView        addSubview:self.lineLabelRight];
  //[self.view              addSubview:self.shareButton];
  //[self.view              addSubview:self.backButton];
  //[self.view              addGestureRecognizer:self.swipGestureRecognizer];
  __weak typeof(self) weakSelf = self;
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
   ^{
     [[DouAPIManager  sharedManager]request_GetAlbumPhotoWithPhotoID :weakSelf.photoID :^(AlbumPhotoInstance *albumPhotoInstance, NSError *error) {
       if(!albumPhotoInstance)
         return;
       weakSelf.currentAlbumPhoto  = albumPhotoInstance;
      dispatch_sync(dispatch_get_main_queue(), ^{
        [weakSelf.delegate setTheCurrenPhoto:albumPhotoInstance];
        });
       [[DouAPIManager  sharedManager]request_GetUserProfileWithDomain :albumPhotoInstance.author_domain :^(UserInstance *user, NSError *error) {
         if(!user)
           return;
         weakSelf.crrUser  = user;
         [[DouAPIManager  sharedManager]request_GetAlbumWithAlbumID:albumPhotoInstance.album_id :^(AlbumInstance *album, NSError *error) {
           if(!album)
             return;
           weakSelf.album  = album;
           [[DouAPIManager  sharedManager]request_GetPhotoRecommendWithAlbumID:album.album_id  :^(NSMutableArray *recommendPhotoList, NSError *error) {
             if(!recommendPhotoList)
               return;
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.recommendPhotoList  = recommendPhotoList;
               [weakSelf initImageWallView];
               [weakSelf.contenView  addSubview:weakSelf.imageWallView.view];
               [weakSelf.photoLikeCommentToolBar initPhotoLikeCommentToolBarWithAlbumPhoto:weakSelf.currentAlbumPhoto];
               [weakSelf.view   addSubview:weakSelf.photoLikeCommentToolBar.view];
               [weakSelf.view   setNeedsLayout];
             });
             
           }];
         }];
       }];
     }];
    });
}

- (void)viewDidLayoutSubviews
{
  __weak typeof(self) weakSelf = self;
  
  /*
  [self.backButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.view).offset(10);
    make.top.equalTo(self.view).offset(10);
    make.size.mas_equalTo(CGSizeMake(40,40));
  }];
   */
  
  if(!self.recommendPhotoList)
    return;
  
  [self.imageScrollView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-50)];
  
  [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.imageScrollView);
    make.width.equalTo(self.imageScrollView);
  }];
  
  if(self.currentAlbumPhoto)
  {
    NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:self.currentAlbumPhoto.photo_path] stringByAppendingString:image1d5TailUrl];
    NSURL *url = [[NSURL  alloc]initWithString:urlString];
    [_photoImageButton  setImageAndChangeSizeWithUrl:url placeholderImage:nil tapBlock:^(id obj) {
      NSURL   *originalURL  = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:weakSelf.currentAlbumPhoto.photo_path]];
      [weakSelf jumpToImageDetailView:originalURL];
      
    } newHeight:0 newWidth:kScreen_Width];
  }
  if(self.photoImageButton.image!=nil)
  {
    CGSize  newSize =CGSizeMake(kScreen_Width, kScreen_Width *self.photoImageButton.image.size.height/self.photoImageButton.image.size.width);
    [self.photoImageButton.image scaledToSize:newSize];
    [self.photoImageButton setFrame:CGRectMake(0, 0, kScreen_Width, newSize.height)];
  }
  else
    [self.photoImageButton setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
  
  [weakSelf.fromAlbumLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(weakSelf.photoImageButton.mas_bottom).offset(20);
    make.centerX.equalTo(weakSelf.contenView.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(200, 20));
  }];
  
  if(self.album.album_name)
  {
    [_albumNameButton setTitle:self.album.album_name forState:UIControlStateNormal];
    [_albumNameButton addTarget:self action:@selector(jumpToAlbumDetailAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  [weakSelf.albumNameButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.fromAlbumLabel.mas_bottom).offset(10);
    make.centerX.equalTo(self.contenView.mas_centerX);
    //make.size.mas_equalTo(CGSizeMake(kScreen_Width-2*kTotalDefaultPadding, 25));
  }];
  [_albumNameButton  sizeToFit];
  
  if(self.album.album_desc)
    [_albumContent  setText:self.album.album_desc];
  [weakSelf.albumContent  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(weakSelf.contenView).offset(kTotalDefaultPadding);
    make.right.equalTo(weakSelf.contenView).offset(-kTotalDefaultPadding);
    make.top.mas_equalTo(weakSelf.albumNameButton.mas_bottom).offset(10);
    if(self.album.album_desc && ![self.album.album_desc isEmpty] )
      make.height.mas_equalTo(54);
    else
      make.height.mas_equalTo(1);
  }];
  
  [weakSelf.authorInforLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(weakSelf.contenView.mas_centerX);
    make.top.equalTo(weakSelf.albumContent.mas_bottom).offset(5);
    make.size.mas_equalTo(CGSizeMake(55, 18));
  }];
  
  [weakSelf.lineLabelLeftAuthor mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(weakSelf.authorInforLabel);
    make.left.equalTo(weakSelf.contenView).offset(kTotalDefaultPadding);
    make.right.equalTo(self.authorInforLabel.mas_left).offset(-10);
    make.height.mas_equalTo(1);
  }];
  CGPoint  pointLineX = CGPointMake(0, 0);
  CGPoint  pointLineY = CGPointMake(self.lineLabelLeftAuthor.frame.size.width, 0);
  [self.lineLabelLeftAuthor initLabel:pointLineX :pointLineY :kColorBannerLine];
  
  [weakSelf.lineLabelRightAuthor mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(weakSelf.authorInforLabel);
    make.right.equalTo(weakSelf.contenView).offset(-kTotalDefaultPadding);
    make.left.equalTo(self.authorInforLabel.mas_right).offset(10);
    make.height.mas_equalTo(1);
  }];
  [self.lineLabelRightAuthor initLabel:pointLineX :pointLineY :kColorBannerLine];
  
  if(self.crrUser.host_avatar)
  {
    NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.crrUser.host_avatar]];
    [_theNewAvatarImage  setImageWithUrl:url  placeholderImage:nil tapBlock:^(id obj){
      [weakSelf jumpToAuthorPageAction];
    }];
  }
  [weakSelf.theNewAvatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(weakSelf.contenView.mas_centerX);
    make.top.equalTo(weakSelf.authorInforLabel.mas_bottom).offset(10);
    make.size.mas_equalTo(CGSizeMake(60, 60));
  }];
  
  if(self.crrUser.host_name)
  {
    [_userNameButton setTitle:self.crrUser.host_name forState:UIControlStateNormal];
    [_userNameButton addTarget:self action:@selector(jumpToAuthorPageAction)  forControlEvents:UIControlEventTouchUpInside];
  }
  [weakSelf.userNameButton  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(weakSelf.contenView);
    make.top.equalTo(weakSelf.theNewAvatarImage.mas_bottom).offset(0);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-2*kTotalDefaultPadding, 25));
  }];
  
  if(self.crrUser.follow_state == follow_NO && self.crrUser)
  {
    [_followButton  setImage:[UIImage imageNamed:@"followButton.png"] forState:UIControlStateNormal];
    [_followButton  addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  else  if(self.crrUser)
  {
    [_followButton  setImage:[UIImage  imageNamed:@"followSuccessButton.png"] forState:UIControlStateNormal];
    [_followButton  addTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  [weakSelf.followButton    mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(weakSelf.contenView.mas_centerX);
    make.top.equalTo(weakSelf.userNameButton.mas_bottom).offset(0);
    make.size.mas_equalTo(CGSizeMake(40, 40));
  }];
  
  [weakSelf.youMayBeLikeLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(weakSelf.contenView);
    make.top.equalTo(weakSelf.followButton.mas_bottom).offset(25);
    make.size.mas_equalTo(CGSizeMake(65, 18));
  }];
  
  [weakSelf.lineLabelLeft mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(weakSelf.youMayBeLikeLabel);
    make.right.equalTo(weakSelf.youMayBeLikeLabel.mas_left).offset(-10);
    make.left.equalTo(weakSelf.contenView).offset(kTotalDefaultPadding);
    make.height.mas_equalTo(1);
  }];
  
  CGPoint  pointLineX2 = CGPointMake(0, 0);
  CGPoint  pointLineY2 = CGPointMake(self.lineLabelLeft.frame.size.width, 0);
  [self.lineLabelLeft initLabel:pointLineX2 :pointLineY2 :kColorBannerLine];
  
  [weakSelf.lineLabelRight mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(weakSelf.youMayBeLikeLabel);
    make.right.equalTo(weakSelf.contenView).offset(-kTotalDefaultPadding);
    make.left.equalTo(self.authorInforLabel.mas_right).offset(10);
    make.height.mas_equalTo(1);
  }];
  [self.lineLabelRight initLabel:pointLineX :pointLineY :kColorBannerLine];

  
  if(self.recommendPhotoList)
  {
    [weakSelf.imageWallView.view mas_makeConstraints:^(MASConstraintMaker *make){
      make.centerX.equalTo(weakSelf.view.mas_centerX);
      make.top.equalTo(weakSelf.youMayBeLikeLabel.mas_bottom).offset(5);
      make.size.mas_equalTo(CGSizeMake(self.imageWallViewWidth, self.imageWallViewHeight));
    }];
    
    [weakSelf.contenView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(weakSelf.imageWallView.view.mas_bottom).offset(5);
    }];
  }
  
  self.imageScrollView.contentSize  = self.contenView.frame.size;
  
  if(self.currentAlbumPhoto)
    [weakSelf.photoLikeCommentToolBar.view mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.right.bottom.equalTo(weakSelf.view);
      make.height.mas_equalTo(50);
    }];
  /*
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.right.equalTo(self.view).offset(-10);
    make.top.equalTo(self.view).offset(10);
    make.size.mas_equalTo(CGSizeMake(40,40));
  }];
   */
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewWillAppear:(BOOL)animated
{
  [[PhotosViewController getNavi] setNavigationBarHidden:YES];
  [[PhotosViewController getNavi].interactivePopGestureRecognizer setDelegate:nil];//由于setNavigationBarHidden后,自带的手势将会被删除,该代码还原了之前的代码
  [PhotosViewController setRDVTabStatusHidden:YES];
}



#pragma init

- (void)initPhotoViewControllerWithPhotoID :(NSInteger)photoID
{
  _photoID = photoID;
}

#pragma private method
- (void)  initImageWallView
{
  self.tempArray   =  [[NSMutableArray alloc]init];
  NSMutableArray  *albumPhotoArray  = _recommendPhotoList;
  __weak typeof(self) weakSelf = self;
  NSInteger albumArrayCount  = [albumPhotoArray count];
  CGFloat  frameSizeHeight  = 0;
  CGFloat  frameSizeWidth   = 0;
  if(albumArrayCount<=kmaxImageNumsForChangeLine)
  {
    frameSizeWidth   =  kScreen_Width-kTotalDefaultPadding*2;
    frameSizeHeight  =  kScreen_Width-kTotalDefaultPadding*2;
    self.imageWallViewWidth   = frameSizeWidth;
    self.imageWallViewHeight  = frameSizeHeight*albumArrayCount+(albumArrayCount-1)*10;
  }
  else
  {
    frameSizeWidth   =  (kScreen_Width-kTotalDefaultPadding*2-10)/2;
    frameSizeHeight  =  (kScreen_Width-kTotalDefaultPadding*2-10)/2;
    self.imageWallViewWidth   = kScreen_Width-kTotalDefaultPadding*2;
    NSInteger rows  = albumArrayCount/2+albumArrayCount%2;
    self.imageWallViewHeight  = frameSizeHeight*rows+(rows-1)*10;
  }
  
  for (NSInteger i =0; i<albumArrayCount; i++)
  {
    AlbumPhotoInstance  *albumPhoto = [albumPhotoArray objectAtIndex:i];
    PhotoItemImageView  *itemImageViewTemp =  [[PhotoItemImageView alloc]init];
    NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:albumPhoto.photo_path] stringByAppendingString:imageSquareTailUrl];
    NSURL *url = [[NSURL  alloc]initWithString:urlString];
    float imageWidth  = frameSizeWidth;
    UIImage *image  = [[UIImage  alloc]init];
    image = [image  randomSetPreLoadImageWithSize:CGSizeMake(imageWidth, imageWidth)];
    [itemImageViewTemp  setImageWithUrlWaitForLoad:url placeholderImage:image tapBlock:^(id obj)
     {
       [weakSelf jumpToAnotherPhotoDetailWithAlbumPhoto:albumPhoto];
     }];
    
    [itemImageViewTemp setSize:CGSizeMake(frameSizeWidth, frameSizeHeight)];
    [self.tempArray  addObject:itemImageViewTemp];
  }
  [self.imageWallView  initPhotoImageWall:self.tempArray  :YES];
  self.imageWallView.view.backgroundColor = [UIColor  whiteColor];

  
}

#pragma event
- (void)jumpToAnotherPhotoDetailWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto
{
  /*
  self.nextPhotosVC = [[PhotosViewController alloc]init];
  [self.nextPhotosVC initPhotoViewControllerWithPhotoID:albumPhoto.photo_id];
  [self.nextPhotosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [TotalPhotoViewController  naviPushViewController:self.nextPhotosVC];
  */
  
  self.topPhotoVC = [[TotalPhotoViewController alloc]init];
  [self.topPhotoVC initTotalPhotoViewControllerWithAlbum:nil selectPhotoID:albumPhoto.photo_id];
  [self.topPhotoVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [PhotosViewController  naviPushViewController:self.topPhotoVC];
}

- (void)jumpToAuthorPageAction
{
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([self.crrUser.host_domain isEqualToString:currentDomain])
    isSelf  = YES;
  [self.ppView initPersonalProfileWithUserDomain:self.crrUser.host_domain isSelf:isSelf];
  [PhotosViewController naviPushViewController:self.ppView];
}

- (void)jumpToImageDetailView :(NSURL*)imageURL
{
  self.imageDetailView  = [[ImageDetailView  alloc]init];
  [self.imageDetailView initImageDetailViewWithURL:imageURL defaultImage:self.photoImageButton.image];
  [PhotosViewController naviPushViewController:self.imageDetailView];
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
  NSInteger   host_id  = self.currentAlbumPhoto.author_id;
  [[DouAPIManager  sharedManager]request_FollowWithFollowID :host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      [self.followButton             setImage:[UIImage imageNamed:@"followSuccessButton.png"] forState:UIControlStateNormal];
      [self.followButton             removeTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.followButton             addTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.crrUser                  setFollow_state:follow_state];
    }
  }];
}

- (void)unFollowAction  :(id)sender
{
  NSInteger   host_id  = self.currentAlbumPhoto.author_id;
  [[DouAPIManager  sharedManager]request_UnFollowWithFollowID :host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      [self.followButton             setImage:[UIImage imageNamed:@"followButton.png"] forState:UIControlStateNormal];
      [self.followButton             removeTarget:self action:@selector(unFollowAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.followButton             addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.crrUser                  setFollow_state:follow_state];
    }
  }];
}

- (void)jumpToAlbumDetailAction :(UIButton*)button
{
  AlbumDetailPage     *albumDetailPage  = [[AlbumDetailPage  alloc]init];
  [albumDetailPage initAlbumDetailPageWithAlbumID:self.album.album_id];
  [PhotosViewController naviPushViewController:albumDetailPage];
}

- (void)backToLastViewAction
{
  if(self.backAction)
    self.backAction(self);
  else
    [[PhotosViewController  getNavi] popViewControllerAnimated:YES];
}

#pragma private method
- (void)addBackBlock:(void(^)(id obj))backAction
{
  if(backAction)
  {
    [self.photoLikeCommentToolBar addBackBlock:backAction];
    self.backAction = backAction;
  }
}

- (void)shareTheCurrentPhotoAction
{
  /*
  self.shareVC  = [[ShareTotalViewController alloc]init];
  UIImage *image  = [[UIImage  alloc]init];
  image = [image  takeSnapshotOfView:self.view];
  [self.shareVC  initSharePhotoAndAlbumWithSnapshot:image albumPhoto:self.currentAlbumPhoto album:self.album shareContentType:ShareContentTypePhotoAndAlbum];
  [self.shareVC .view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [PhotosViewController naviPushViewControllerWithNoAniation:self.shareVC];
   */
}

/*
- (void)shareThePhotoWeChatToSingleFriendAction
{
  [[SocialUtilManager  sharedManager]shareWechatActionWithAlbumPhoto:self.currentAlbumPhoto album:self.album isText:NO type:WXSceneSession];
}

- (void)shareThePhotoWeiboAction
{
  [[SocialUtilManager  sharedManager]shareWeiboActionWithAlbumPhoto:self.currentAlbumPhoto album:self.album :^(BOOL isSuccess) {
    
  }];
}

- (void)shareThePhotoWeChatToFriendsAction
{
  [[SocialUtilManager  sharedManager]shareWechatActionWithAlbumPhoto:self.currentAlbumPhoto album:self.album isText:NO type:WXSceneTimeline];
}

- (void)shareThePhotoTencenterToFriendAction
{
  [[SocialUtilManager  sharedManager]shareTencenterActionWithAlbumPhoto:self.currentAlbumPhoto album:self.album];
}
 */

#pragma UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat   height          = scrollView.frame.size.height;
  CGFloat   contentYoffset  = scrollView.contentOffset.y;
  CGFloat   distanceFromBottom  = scrollView.contentSize.height-contentYoffset;
  if(distanceFromBottom<=height || contentYoffset<=0)
    return;
  if (self.lastContentOffset > scrollView.contentOffset.y)
    self.scrollDirection = ScrollDirectionUp;
  else if (self.lastContentOffset < scrollView.contentOffset.y)
    self.scrollDirection = ScrollDirectionDown;
  self.lastContentOffset = scrollView.contentOffset.y;
  
  if(!self.isFading)
  {
    
    if (_delegate && [_delegate respondsToSelector:@selector(setTheShareButtonAndBackToAnimationMoveWithAlpha:albumPhoto:)])
    {
      
      if(self.scrollDirection ==  ScrollDirectionDown)
        [self.delegate setTheShareButtonAndBackToAnimationMoveWithAlpha:0.0 albumPhoto:self.currentAlbumPhoto ];
      else  if(self.scrollDirection ==  ScrollDirectionUp)
        [self.delegate setTheShareButtonAndBackToAnimationMoveWithAlpha:1.0 albumPhoto:self.currentAlbumPhoto ];
      self.isFading  = NO;
    }
  }
     
}

#pragma getter setter

-(UIButton*)albumNameButton
{
  if(_albumNameButton ==  nil)
  {
    _albumNameButton = [[UIButton  alloc]init];
    NSString  *stringAlbumName = @"";
    [_albumNameButton  setTitle:stringAlbumName forState:UIControlStateNormal];
    [_albumNameButton.titleLabel  setTextAlignment:NSTextAlignmentCenter];
    [_albumNameButton.titleLabel  setFont:SourceHanSansNormal19];
    [_albumNameButton  setTitleColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0] forState:UIControlStateNormal];
  }
  return _albumNameButton;
}

- (CustomDrawLineLabel*)lineLabelLeftAuthor
{
  if(_lineLabelLeftAuthor ==  nil)
  {
    _lineLabelLeftAuthor  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(pointLineX.x+100, 0);
    [_lineLabelLeftAuthor initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _lineLabelLeftAuthor;
}

- (CustomDrawLineLabel*)lineLabelRightAuthor
{
  if(_lineLabelRightAuthor ==  nil)
  {
    _lineLabelRightAuthor  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(pointLineX.x+100, 0);
    [_lineLabelRightAuthor initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _lineLabelRightAuthor;
}

- (UILabel*)authorInforLabel
{
  if(_authorInforLabel  ==  nil)
  {
    _authorInforLabel = [[UILabel  alloc]init];
    NSString  *stringAuthorInfor = @"作者信息";
    [_authorInforLabel  setText:stringAuthorInfor];
    [_authorInforLabel  setTextAlignment:NSTextAlignmentCenter];
    [_authorInforLabel  setFont:SourceHanSansNormal12];
    [_authorInforLabel  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
  return _authorInforLabel;
}

- (UILabel*)fromAlbumLabel
{
  if(_fromAlbumLabel  ==  nil)
  {
    _fromAlbumLabel = [[UILabel  alloc]init];
    NSString  *stringFromAlbum  = @"来自相册.";
    [_fromAlbumLabel  setText:stringFromAlbum];
    [_fromAlbumLabel  setTextAlignment:NSTextAlignmentCenter];
    [_fromAlbumLabel  setFont:SourceHanSansNormal12];
    [_fromAlbumLabel  setTextColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0]];
  }
  return _fromAlbumLabel;
}

- (UIView*)contenView
{
  if(_contenView ==  nil)
  {
    _contenView  = [[UIView  alloc]init];
  }
  return _contenView;
}

- (UIScrollView*)imageScrollView
{
  if(_imageScrollView ==  nil)
  {
    _imageScrollView  = [[UIScrollView alloc]init];
    _imageScrollView.backgroundColor  = [UIColor  whiteColor];
    _imageScrollView.delegate = self;
    _imageScrollView.scrollEnabled  = YES;
    _imageScrollView.showsVerticalScrollIndicator = NO;
  }
  return _imageScrollView;
}

- (UITapImageView*)photoImageButton
{
  if(_photoImageButton  ==  nil)
  {
    _photoImageButton = [[UITapImageView alloc]init];
  }
  return _photoImageButton;
}

- (UITapImageView*)theNewAvatarImage
{
  if(_theNewAvatarImage  ==  nil)
  {
    _theNewAvatarImage = [[UITapImageView alloc]init];
    [_theNewAvatarImage  setSize:CGSizeMake(60, 60)];
    [_theNewAvatarImage  doCircleFrame];
  }
  return _theNewAvatarImage;
}

- (UIButton*)userNameButton
{
  if(_userNameButton  ==  nil)
  {
    _userNameButton = [[UIButton alloc]init];
    [_userNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_userNameButton.titleLabel setFont:SourceHanSansMedium14];
  }
  return _userNameButton;
}
- (UIButton*)followButton
{
  if(_followButton  ==  nil)
  {
    _followButton = [[UIButton alloc]init];

  }
  return _followButton;
}

- (UILabel*)albumContent
{
  if(_albumContent ==  nil)
  {
    _albumContent  = [[UILabel  alloc]init];
    /*
    NSMutableAttributedString *string_title = [[NSMutableAttributedString alloc]initWithString:@"简介: "];
    [string_title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,string_title.length)];
    if(self.crrUser.host_desc && ![self.crrUser.host_desc  isEqualToString:@""])
    {
      NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:self.crrUser.host_desc];
      [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0,self.crrUser.host_desc.length)];
      [string_title appendAttributedString:string_content];
    }
    [_albumContent  setAttributedText:string_title];
     */
    [_albumContent  setTextAlignment:NSTextAlignmentCenter];
    [_albumContent  setTextColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0]];
    [_albumContent  setNumberOfLines:3];
    [_albumContent  setFont:SourceHanSansNormal12];
  }
  return _albumContent;
}

- (CustomDrawLineLabel*)lineLabelLeft
{
  if(_lineLabelLeft ==  nil)
  {
    _lineLabelLeft  = [[CustomDrawLineLabel  alloc]init];
  }
  return _lineLabelLeft;
}

- (CustomDrawLineLabel*)lineLabelRight
{
  if(_lineLabelRight ==  nil)
  {
    _lineLabelRight  = [[CustomDrawLineLabel  alloc]init];
  }
  return _lineLabelRight;
}

- (UILabel*)youMayBeLikeLabel
{
  if(_youMayBeLikeLabel ==  nil)
  {
    _youMayBeLikeLabel  = [[UILabel  alloc]init];
    NSString  *stringYouMayBe  = @"你可能喜欢";
    [_youMayBeLikeLabel  setText:stringYouMayBe];
    [_youMayBeLikeLabel  setTextAlignment:NSTextAlignmentCenter];
    [_youMayBeLikeLabel  setFont:SourceHanSansNormal12];
    [_youMayBeLikeLabel  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
  return _youMayBeLikeLabel;
}

- (PhotoImageWallView*)imageWallView
{
  if(_imageWallView ==  nil)
  {
    _imageWallView  = [[PhotoImageWallView alloc]init];
  }
  return _imageWallView;
}

- (PhotoLikeCommentToolBar*)photoLikeCommentToolBar
{
  if(_photoLikeCommentToolBar ==  nil)
  {
    _photoLikeCommentToolBar  = [[PhotoLikeCommentToolBar alloc]init];
  }
  return _photoLikeCommentToolBar;
}

- (ImageDetailView*)imageDetailView
{
  if(_imageDetailView ==  nil)
  {
    _imageDetailView  = [[ImageDetailView alloc]init];
  }
  return _imageDetailView;
}

- (UISwipeGestureRecognizer*)swipGestureRecognizer
{
  if(_swipGestureRecognizer ==  nil)
  {
    _swipGestureRecognizer  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastViewAction)];
    [_swipGestureRecognizer   setDirection:UISwipeGestureRecognizerDirectionRight];
  }
  return _swipGestureRecognizer;
}

- (PersonalProfile*)ppView
{
  if(_ppView  ==  nil)
  {
    _ppView = [[PersonalProfile  alloc]init];
  }
  return _ppView;
}

- (UIActivityIndicatorView*)activictyIndicatorView
{
  if(_activictyIndicatorView  ==  nil)
  {
    _activictyIndicatorView = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activictyIndicatorView  setCenter:self.view.center];
    [_activictyIndicatorView  startAnimating];
  }
  return _activictyIndicatorView;
}

@end
