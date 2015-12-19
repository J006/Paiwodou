//
//  PhotoDetailPage.m
//  TestPaiwo
//
//  Created by J006 on 15/5/6.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "AlbumDetailPage.h"
#import "PhotoItemImageView.h"
#import "PhotoImageWallView.h"
#import "CustomDrawLineLabel.h"
#import "AlbumPhotoInstance.h"
#import "PhotosViewController.h"
#import "DouAPIManager.h"
#import "NSString+Common.h"
#import <Masonry.h>
#import "ShareTotalViewController.h"
#import "UINavigationController+StatusBar.h"
#import "PersonalProfile.h"
typedef NS_ENUM(NSInteger, ScrollDirection) {
  ScrollDirectionNone=0,
  ScrollDirectionRight=1,
  ScrollDirectionLeft=2,
  ScrollDirectionUp=3,
  ScrollDirectionDown=4,
  ScrollDirectionCrazy=5,
} ;
@interface AlbumDetailPage ()<PhotoImageWallViewDelegate>

@property (strong, nonatomic) UIButton                      *shareButton;//分享按钮
@property (strong, nonatomic) UIButton                      *backButton;//后退按钮
@property (strong, nonatomic) UIView                        *contenView;//底部界面,容器
@property (strong, nonatomic) UILabel                       *mainTitle;//专辑标题
@property (strong, nonatomic) UITapImageView                *avatarImage;//头像
@property (strong, nonatomic) UIButton                      *userNameButton;//用户名称
@property (strong, nonatomic) UILabel                       *contentLabel;//专辑描述内容
@property (strong, nonatomic) CustomDrawLineLabel           *lineLabelLeft;//左边直线
@property (strong, nonatomic) CustomDrawLineLabel           *lineLabelRight;//右边直线
@property (strong, nonatomic) UILabel                       *photoCounts;//照片数量
@property (strong, nonatomic) UIScrollView                  *imageScrollView;//图片墙的滚动
@property (strong, nonatomic) PhotoImageWallView            *imageWallView;//照片墙
@property (strong, nonatomic) AlbumInstance                 *album;
@property (readwrite,nonatomic)float                        imageWallViewWidth;
@property (readwrite,nonatomic)float                        imageWallViewHeight;
@property (strong, nonatomic) PhotosViewController          *photosVC;
@property (readwrite,nonatomic)NSInteger                    albumID;//当前专辑ID
@property (nonatomic, copy) void(^backAction)(id);
@property (strong, nonatomic) UISwipeGestureRecognizer      *swipGestureRecognizer;//右划后退
@property (strong, nonatomic) ShareTotalViewController      *shareVC;
@property (nonatomic,readwrite) CGFloat                     lastContentOffset;
@property (nonatomic,readwrite) ScrollDirection             scrollDirection;
@property (nonatomic,readwrite) BOOL                        isFading;//分享按钮正在动画
@property (strong, nonatomic) PersonalProfile               *ppView;


@end
@implementation AlbumDetailPage

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view              addSubview:self.imageScrollView];
  [self.imageScrollView   addSubview:self.contenView];
  [self.contenView        addSubview:self.mainTitle];
  [self.contenView        addSubview:self.avatarImage];
  [self.contenView        addSubview:self.userNameButton];
  [self.contenView        addSubview:self.contentLabel];
  [self.contenView        addSubview:self.lineLabelLeft];
  [self.contenView        addSubview:self.lineLabelRight];
  [self.contenView        addSubview:self.photoCounts];
  [self.view              addSubview:self.backButton];
  [self.view              addSubview:self.shareButton];
  [self.view              addGestureRecognizer:self.swipGestureRecognizer];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager] request_GetAlbumWithAlbumID :_albumID :^(AlbumInstance *newAlbum, NSError *error)
                    {
                      if(!newAlbum)
                        return;
                      dispatch_sync(dispatch_get_main_queue(), ^{
                        weakSelf.album = newAlbum;
                        [self initImageWallView];
                        [self.contenView  addSubview:self.imageWallView.view];
                        [weakSelf.imageWallView.view setNeedsLayout];
                      });
                    }];
  });
}

- (void)viewDidLayoutSubviews
{
  __weak typeof(self) weakSelf = self;
  
  [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(15);
    make.top.equalTo(self.view).offset(20);
    make.size.mas_equalTo(CGSizeMake(12, 20));
  }];
  
  if(!self.album)
    return;
  
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-15);
    make.top.equalTo(self.view).offset(19);
    make.size.mas_equalTo(CGSizeMake(14, 20));
  }];
  

  [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(weakSelf.imageScrollView);
    make.width.equalTo(weakSelf.imageScrollView);
  }];

  if(self.album.album_name)
    [_mainTitle  setText:self.album.album_name];
  [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(weakSelf.contenView);
    make.top.equalTo(weakSelf.contenView).offset(117);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width, 46));
  }];
  
  if(self.album.author_name)
    [_userNameButton setTitle:self.album.author_name forState:UIControlStateNormal];
  else  if(self.album.user_name)
    [_userNameButton setTitle:self.album.user_name forState:UIControlStateNormal];
  [self.userNameButton  mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.mas_equalTo(weakSelf.mainTitle.mas_bottom).offset(10);
    make.left.mas_equalTo(self.contenView.mas_centerX).offset(-40);
    make.size.mas_equalTo(CGSizeMake(100, 25));
  }];
  if(self.album.author_domain)
    [self.userNameButton  addTarget:self action:@selector(jumpToUserProfileAction) forControlEvents:UIControlEventTouchUpInside];
     
  if(self.album.author_avatar)
  {
    NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.album.author_avatar]];
    [_avatarImage  setImageWithUrl:url  placeholderImage:nil tapBlock:^(id objc){
    }];
  }
  else  if(self.album.user_avatar)
  {
    NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.album.user_avatar]];
    [_avatarImage  setImageWithUrl:url  placeholderImage:nil tapBlock:^(id objc){
    }];
  }
  
  [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make){
    make.right.equalTo(weakSelf.userNameButton.mas_left).offset(-5);
    make.top.mas_equalTo(weakSelf.mainTitle.mas_bottom).offset(10);
    make.size.mas_equalTo(CGSizeMake(25, 25));
  }];
  [self.avatarImage  doCircleFrame];
  if(self.album.author_domain)
    [self.avatarImage addTapBlock:^(id obj) {
      [weakSelf jumpToUserProfileAction];
    }];
  
  if(self.album.album_desc)
    [_contentLabel  setText:self.album.album_desc];
  [self.contentLabel  mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(weakSelf.contenView);
    make.top.mas_equalTo(weakSelf.userNameButton.mas_bottom).offset(60);
    if(self.album.album_desc && ![self.album.album_desc isEmpty])
      make.size.mas_equalTo(CGSizeMake(kScreen_Width-2*kTotalDefaultPadding, 50));
    else
      make.size.mas_equalTo(CGSizeMake(kScreen_Width-2*kTotalDefaultPadding, 0));
  }];
  
  if(self.album.photo_count)
  {
    NSString  *photoNums  = @"照片 ";
    [_photoCounts  setText:[photoNums stringByAppendingString:[NSString stringWithFormat:@"%ld",self.album.photo_count]]];
  }
  [self.photoCounts mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(weakSelf.contenView);
    make.centerY.equalTo(weakSelf.contentLabel.mas_bottom).offset(15);
    make.size.mas_equalTo(CGSizeMake(40, 20));
  }];
  
  [self.lineLabelRight mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(weakSelf.photoCounts);
    make.right.equalTo(weakSelf.contenView).offset(-kTotalDefaultPadding);
    make.left.equalTo(self.photoCounts.mas_right).offset(10);
    make.height.mas_equalTo(1);
  }];
  CGPoint  pointLineX = CGPointMake(0, 0);
  CGPoint  pointLineY = CGPointMake(self.lineLabelRight.frame.size.width, 0);
  [self.lineLabelRight initLabel:pointLineX :pointLineY :kColorBannerLine];
  
  [self.lineLabelLeft mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerY.equalTo(weakSelf.photoCounts);
    make.left.equalTo(weakSelf.contenView).offset(kTotalDefaultPadding);
    make.right.equalTo(self.photoCounts.mas_left).offset(-10);
    make.height.mas_equalTo(1);
  }];
  [self.lineLabelLeft initLabel:pointLineX :pointLineY :kColorBannerLine];
  
  if(self.album)
  {
    [self.imageWallView.view mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(weakSelf.contenView).offset(kTotalDefaultPadding);
      make.top.mas_equalTo(weakSelf.photoCounts.mas_bottom).offset(5);
      make.size.mas_equalTo(CGSizeMake(self.imageWallViewWidth, self.imageWallViewHeight));
    }];
    [self.contenView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(weakSelf.imageWallView.view.mas_bottom);
    }];
  }
  
  self.imageScrollView.contentSize  = CGSizeMake(self.contenView.frame.size.width, self.contenView.frame.size.height+10);
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewWillAppear:(BOOL)animated
{
  [AlbumDetailPage setRDVTabStatusHidden:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
  /*
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
  {
    [[AlbumDetailPage  getNavi]setNavigationBarHidden:YES];
    [AlbumDetailPage  setRDVTabHidden:NO isAnimated:YES];
  }
   */
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}


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
    if(self.scrollDirection ==  ScrollDirectionDown)
      [UIView animateWithDuration:0.7
                            delay:0.0
                          options:UIViewAnimationOptionTransitionFlipFromBottom
                       animations:^{
                         [self.shareButton  setAlpha:0.0];
                         [self.backButton   setAlpha:0.0];
                       }completion:^(BOOL finished){
                         self.isFading  = NO;
                       }];
    else  if(self.scrollDirection ==  ScrollDirectionUp)
      [UIView animateWithDuration:0.7
                            delay:0.0
                          options:UIViewAnimationOptionTransitionFlipFromBottom
                       animations:^{
                         [self.shareButton  setAlpha:1.0];
                         [self.backButton   setAlpha:1.0];
                       }completion:^(BOOL finished){
                         self.isFading  = NO;
                       }];
  }
}

#pragma init

- (void)initAlbumDetailPageWithAlbumID :(NSInteger)albumID
{
  _albumID  = albumID;
}

/**
 *  @author J006, 15-05-07 10:05:54
 *
 *  初始化图片栏
 */
- (void)  initImageWallView
{
  NSMutableArray  *tempArray   =  [[NSMutableArray alloc]init];
  NSMutableArray  *albumPhotoArray  = self.album.photo_list;
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
    PhotoItemImageView  *itemImageView =  [[PhotoItemImageView alloc]init];
    NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:albumPhoto.photo_path]stringByAppendingString:imageSquareTailUrl];
    NSURL *url = [[NSURL  alloc]initWithString:urlString];
    [itemImageView  setImageWithUrlWaitForLoad:url placeholderImage:nil tapBlock:^(id obj)
     {
       [weakSelf jumpToAlbumPhotoDetailButtonAction:i];
     }];
    [itemImageView setSize:CGSizeMake(frameSizeWidth, frameSizeHeight)];
    [tempArray  addObject:itemImageView];
  }
  [self.imageWallView  initPhotoImageWall:tempArray  :YES];
  self.imageWallView.view.backgroundColor = [UIColor  whiteColor];
}

#pragma PhotoImageWallViewDelegate

- (void)finishInitTheView:(PhotoImageWallView *)photoImageWallView photoImageWallHeight:(CGFloat)photoImageWallHeight photoImageWallWidth:(CGFloat)photoImageWallWidth
{
  [self.imageWallView.view setSize:CGSizeMake(photoImageWallWidth, photoImageWallHeight)];
  [self.view  setNeedsLayout];
}

#pragma private methods
- (void)jumpToAlbumPhotoDetailButtonAction  :(NSInteger)currentAlbumPhotoInstace
{
  AlbumPhotoInstance  *albumPhoto = [self.album.photo_list objectAtIndex:currentAlbumPhotoInstace];
  PhotosViewController  *photosVC = [[PhotosViewController alloc]init];
  [photosVC initPhotoViewControllerWithPhotoID:albumPhoto.photo_id];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [AlbumDetailPage  naviPushViewController:photosVC];
}

#pragma event
- (void)backToLastViewAction  :(id)sender
{
  if(self.backAction)
    self.backAction(self);
  else
    [[AlbumDetailPage getNavi]popViewControllerAnimated:YES];
}

- (void)shareTheCurrentPhotoAction
{
  self.shareVC  = [[ShareTotalViewController alloc]init];
  UIImage *image  = [[UIImage  alloc]init];
  image = [image  takeSnapshotOfView:self.view];
  [self.shareVC  initSharePhotoAndAlbumWithSnapshot:image albumPhoto:[self.album.photo_list objectAtIndex:0] album:self.album shareContentType:ShareContentTypePhotoAndAlbum];
  [self.shareVC .view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [AlbumDetailPage naviPushViewControllerWithNoAniation:self.shareVC];
  //[self.view  addSubview:self.shareVC .view];
}

- (void)addBackBlock:(void(^)(id obj))backAction
{
  self.backAction = backAction;
  [self.backButton  addTarget:self action:@selector(backToLastViewAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpToUserProfileAction
{
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([self.album.author_domain isEqualToString:currentDomain])
    isSelf  = YES;
  [self.ppView initPersonalProfileWithUserDomain:self.album.author_domain isSelf:isSelf];
  [PhotosViewController naviPushViewController:self.ppView];
}

#pragma getter setter
- (UIView*)contenView
{
  if(_contenView ==  nil)
  {
    _contenView  = [[UIView  alloc]init];
  }
  return _contenView;
}

- (UIButton*)shareButton
{
  if(_shareButton ==  nil)
  {
    _shareButton = [[UIButton alloc] init];
    [_shareButton   setImage:[UIImage imageNamed:@"shareNoCircleBlackButton"] forState:UIControlStateNormal];
    [_shareButton   setAdjustsImageWhenHighlighted:NO];
    [_shareButton   addTarget:self action:@selector(shareTheCurrentPhotoAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareButton;
}

- (UILabel*)mainTitle
{
  if(_mainTitle ==  nil)
  {
    _mainTitle  = [[UILabel  alloc]init];
    [_mainTitle  setFont:SourceHanSansLight36];
    [_mainTitle  setTextColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0]];
    [_mainTitle  setTextAlignment:NSTextAlignmentCenter];
  }
  return _mainTitle;
}

- (UITapImageView*)avatarImage
{
  if(_avatarImage ==  nil)
  {
    _avatarImage  = [[UITapImageView alloc]init];
  }
  return _avatarImage;
}

- (UIButton*)userNameButton
{
  if(_userNameButton  ==  nil)
  {
    _userNameButton = [[UIButton alloc]init];
    [_userNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _userNameButton.contentHorizontalAlignment  = UIControlContentHorizontalAlignmentLeft;
    [_userNameButton.titleLabel setFont:SourceHanSansMedium14];
  }
  return _userNameButton;
}

- (UILabel*)contentLabel
{
  if(_contentLabel  ==  nil)
  {
    _contentLabel = [[UILabel  alloc]init];
    [_contentLabel  setTextColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0]];
    [_contentLabel  setTextAlignment:NSTextAlignmentCenter];
    [_contentLabel  setNumberOfLines:2];
    [_contentLabel  setFont:SourceHanSansNormal12];
  }
  return _contentLabel;
}

- (UIScrollView*)imageScrollView
{
  if(_imageScrollView ==  nil)
  {
    _imageScrollView  = [[UIScrollView alloc]init];
    _imageScrollView.backgroundColor  = [UIColor  whiteColor];
    _imageScrollView.delegate = self;
    _imageScrollView.scrollEnabled  = YES;
    [_imageScrollView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  }
  return _imageScrollView;
}

- (PhotoImageWallView*)imageWallView
{
  if(_imageWallView ==  nil)
  {
    _imageWallView  = [[PhotoImageWallView alloc]init];
    _imageWallView.delegate = self;
  }
  return _imageWallView;
}

- (CustomDrawLineLabel*)lineLabelLeft
{
  if(_lineLabelLeft ==  nil)
  {
    _lineLabelLeft  = [[CustomDrawLineLabel  alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(pointLineX.x+100, 0);
    [_lineLabelLeft initLabel:pointLineX :pointLineY :kColorBannerLine];
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

- (UILabel*)photoCounts
{
  if(_photoCounts ==  nil)
  {
    _photoCounts  = [[UILabel  alloc]init];
    [_photoCounts  setFont:SourceHanSansNormal12];
    [_photoCounts  setTextAlignment:NSTextAlignmentCenter];
    [_photoCounts  setTextColor:[UIColor  colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
  return _photoCounts;
}

- (UIButton*)backButton
{
  if(_backButton  ==  nil)
  {
    _backButton = [[UIButton alloc] init];
    [_backButton  setImage:[UIImage imageNamed:@"photoBackButton"] forState:UIControlStateNormal];
    [_backButton  addTarget:self action:@selector(backToLastViewAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _backButton;
}

- (UISwipeGestureRecognizer*)swipGestureRecognizer
{
  if(_swipGestureRecognizer ==  nil)
  {
    _swipGestureRecognizer  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastViewAction:)];
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
@end
