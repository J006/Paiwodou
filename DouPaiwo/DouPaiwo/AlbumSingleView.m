//
//  PhotoSingleView.m
//  TestPaiwo
//
//  Created by J006 on 15/4/23.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//
#import "AlbumSingleView.h"
#import "PhotoItemImageView.h"
#import "AlbumFirstView.h"
#import "AlbumDetailPage.h"
#import "AlbumPhotoInstance.h"
#import "DouAPIManager.h"
#import <Masonry/Masonry.h>
#import "PersonalProfile.h"
#import "NSString+Common.h"
#import "PhotosViewController.h"
#import "AlbumSecondViewController.h"
#import "TotalPhotoViewController.h"
@interface AlbumSingleView ()<PhotoImageWallViewDelegate>

@property (strong, nonatomic)   UIButton                  *jumpToPhotoDetailButton;
@property (strong, nonatomic)   UITapImageView            *avatarImageView;//推荐人头像
@property (strong, nonatomic)   UIButton                  *recommendedName;//推荐人名称
@property (strong, nonatomic)   UILabel                   *hotLabel;//热度
@property (strong, nonatomic)   UIButton                  *photoAuthor;//原作者名称
@property (strong, nonatomic)   UIButton                  *albumNameLabel;//专辑名称
@property (strong, nonatomic)   UIScrollView              *photoScrollView;//滚动界面容器scrollview
@property (nonatomic, strong)   AlbumInstance             *album;
@property (nonatomic, strong)   AlbumFirstView            *albumFirstView;
@property (strong, nonatomic)   PersonalProfile           *ppView;
@property (nonatomic, readwrite)float                     theFitHeight;
@property (readwrite,nonatomic) CGFloat                   imageViewWidth;
@property (readwrite,nonatomic) CGFloat                   imageViewHeight;
@property (strong, nonatomic)   UILabel                   *deleteInfo;//原内容已被删除
@property (readwrite, nonatomic)NSInteger                 currentTapPhotoID;//当前点击的图片ID
@property (strong, nonatomic)   AlbumSecondViewController *albumSecondView;
@property (strong, nonatomic)   UIImageView               *deleteImageBackGroud;
@property (strong, nonatomic)   UIImageView               *deleteImage;
@end

@implementation AlbumSingleView
@synthesize photoY;
- (void)viewDidLoad
{
  self.view.backgroundColor = kColorBackGround;
  [self.view addSubview:self.jumpToPhotoDetailButton];
  [self.view addSubview:self.avatarImageView];
  [self.view addSubview:self.photoAuthor];
  [self.view addSubview:self.recommendedName];
  [self.view addSubview:self.hotLabel];
  [self.view addSubview:self.albumNameLabel];
  [self.view addSubview:self.photoScrollView];
  if(self.album.is_delete)
  {
    [self.view addSubview:self.deleteImageBackGroud];
    [self.view addSubview:self.deleteImage];
    [self.view addSubview:self.deleteInfo];
  }
  [self initFirstView:self.album];
  [self.photoScrollView addSubview:self.albumFirstView.view];
  [self.photoScrollView addSubview:self.albumSecondView.view];
}

- (void)viewDidLayoutSubviews
{
  [self.jumpToPhotoDetailButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view);
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
  
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.left.equalTo(self.view).with.offset(kTotalDefaultPadding);
    make.size.mas_equalTo(CGSizeMake(25, 25));
  }];
  [self.avatarImageView doCircleFrame];
  
  [self.recommendedName mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.left.equalTo(self.avatarImageView.mas_right).with.offset(10);
    //make.size.mas_equalTo(CGSizeMake(200, 30));
  }];
  [self.recommendedName sizeToFit];

  [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(7);
    make.right.equalTo(self.view).with.offset(-kTotalDefaultPadding);
    //make.size.mas_equalTo(CGSizeMake(80, 23));
  }];
  [self.hotLabel  setTextColor:[UIColor lightGrayColor]];
  [self.hotLabel  setTextAlignment:NSTextAlignmentRight];
  [self.hotLabel  sizeToFit];
  
  [self.photoAuthor mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.photoScrollView.mas_bottom).offset(0);
    make.right.equalTo(self.view).with.offset(-kTotalDefaultPadding);
  }];
  [self.photoAuthor sizeToFit];
  
  [self.albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.photoScrollView.mas_bottom).offset(0);
    make.left.equalTo(self.view).with.offset(kTotalDefaultPadding);
    //make.size.mas_equalTo(CGSizeMake(200, 30));
  }];
  
  [self.photoScrollView mas_makeConstraints:^(MASConstraintMaker *make){
    make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(40, 0, 39 , 0));
  }];

  [self.albumFirstView.view mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.photoScrollView);
    make.left.equalTo(self.photoScrollView).offset(kTotalDefaultPadding);
  }];
  
  if(self.album.is_delete ==YES)
  {
    [self.deleteInfo mas_makeConstraints:^(MASConstraintMaker *make){
      make.centerX.equalTo(self.view);
      make.top.equalTo(self.deleteImage.mas_bottom).offset(10);
    }];
    [self.deleteInfo sizeToFit];
    
    [self.deleteImageBackGroud mas_makeConstraints:^(MASConstraintMaker *make){
      make.top.equalTo(self.photoScrollView);
      make.left.equalTo(self.photoScrollView);
      make.top.equalTo(self.photoScrollView);
      make.bottom.equalTo(self.photoScrollView);
    }];
    
    [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make){
      make.center.equalTo(self.deleteImageBackGroud);
    }];
    [self.deleteImage   sizeToFit];
  }

  else  if(!self.album.is_delete)
  {
    CGFloat theFollowViewWidth  = [AlbumSingleView widthToFitHeight:CGSizeMake(240, 335) newHeight:self.theFitHeight-45-34];
    [self.albumSecondView.view mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.albumFirstView.view.mas_right).offset(10);
      make.top.equalTo(self.photoScrollView);
      make.size.mas_equalTo(CGSizeMake(theFollowViewWidth, self.theFitHeight-45-34));
    }];
  }
}

#pragma init
- (void)  initAlbumSingleView :(AlbumInstance*)album;
{
  _album  = album;
  _theFitHeight = [AlbumSingleView heightToFitWidth:CGSizeMake(kdefaultScreen_Width, kphotoSingleViewHeight) newWidth:kScreen_Width];
  if(album.is_delete)
    return;
  [self.albumSecondView  initAlbumSecondViewControllerWithAlbum:album];
}

/**
 *  @author J006, 15-04-28 17:04:41
 *
 *  照片墙
 *
 *  @param photoItem 
 */
- (void)  initFirstView:(AlbumInstance*)album
{
  NSMutableArray  *tempArray   =  [[NSMutableArray alloc]init];
  NSMutableArray  *albumPhotoArray  = album.photo_list;
  __weak typeof(self) weakSelf = self;
  NSInteger albumArrayCount  = [albumPhotoArray count];
  CGFloat  frameSizeHeight  = 0;
  CGFloat  frameSizeWidth   = 0;
  if(albumArrayCount<=kmaxImageNumsForChangeLine)
  {
    frameSizeWidth          =  self.theFitHeight-45-34;
    frameSizeHeight         =  self.theFitHeight-45-34;
    self.imageViewHeight    = frameSizeHeight;
    self.imageViewWidth     = frameSizeWidth*albumArrayCount+(albumArrayCount-1)*10;
  }
  else
  {
    frameSizeWidth   =  (self.theFitHeight-10-45-34)/2;
    frameSizeHeight  =  (self.theFitHeight-10-45-34)/2;
    self.imageViewHeight    = self.theFitHeight;
    self.imageViewWidth     = frameSizeWidth*albumArrayCount+(albumArrayCount-1)*10;
  }
  for (NSInteger i =0; i<albumArrayCount; i++)
  {
    AlbumPhotoInstance  *albumPhoto = [albumPhotoArray objectAtIndex:i];
    PhotoItemImageView  *itemImageView =  [[PhotoItemImageView alloc]init];
    [itemImageView  setSize:CGSizeMake(frameSizeWidth, frameSizeHeight)];
    NSString    *the1d5ImageURL = [[defaultImageHeadUrl stringByAppendingString:albumPhoto.photo_path]  stringByAppendingString:image1d5TailUrl];
    NSURL       *url = [[NSURL  alloc]initWithString:the1d5ImageURL];
    [itemImageView  setImageAndChangeSizeWithUrl:url placeholderImage:nil tapBlock:^(id obj)
     {
       weakSelf.currentTapPhotoID = albumPhoto.photo_id;
       [weakSelf jumpToSinglePhotoDetailButtonAction];
     } newHeight:frameSizeHeight newWidth:0];
    [tempArray  addObject:itemImageView];
  }
  [self.albumFirstView  initPhotoImageWall:tempArray  :NO];
}

#pragma PhotoImageWallViewDelegate

- (void)finishInitTheView:(PhotoImageWallView *)photoImageWallView photoImageWallHeight:(CGFloat)photoImageWallHeight photoImageWallWidth:(CGFloat)photoImageWallWidth
{
  if(!self.album.is_delete)
  {
    [self.albumSecondView.view setX:photoImageWallWidth+30];
  }
  self.photoScrollView.contentSize  = CGSizeMake(photoImageWallWidth+10+25+self.albumSecondView.view.frame.size.width+20, 0);
}

#pragma event
/**
 *  @author J006, 15-05-11 15:05:16
 *
 *  跳转到影集详细页面
 *
 *  @param sender 按钮
 */
- (void)jumpToPhotoDetailButtonActionTool:(id)sender
{
  AlbumDetailPage   *albumDetail  = [[AlbumDetailPage  alloc]init];
  [albumDetail  initAlbumDetailPageWithAlbumID :self.album.album_id];
  [albumDetail.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  if(![AlbumDetailPage checkRDVTabIsHidden])
    [albumDetail   addBackBlock:^(id objc){
      [[AlbumDetailPage  getNavi]setNavigationBarHidden:YES animated:NO];
      [AlbumDetailPage   setRDVTabHidden:NO isAnimated:NO];
      [[AlbumDetailPage  getNavi]popViewControllerAnimated:YES];
    }];
  else
    [albumDetail   addBackBlock:^(id objc){
      [[AlbumDetailPage  getNavi]setNavigationBarHidden:YES animated:NO];
      [[AlbumDetailPage  getNavi]popViewControllerAnimated:YES];
    }];
  [[AlbumDetailPage  getNavi]  setNavigationBarHidden:YES animated:NO];
  [AlbumSingleView  setRDVTabHidden:YES  isAnimated:NO];
  [AlbumSingleView  naviPushViewController:albumDetail];
}
/**
 *  @author J006, 15-08-28 15:05:16
 *
 *  跳转到单张图片详细界面
 *
 *  @param sender 按钮
 */
- (void)jumpToSinglePhotoDetailButtonAction
{
  /*
  PhotosViewController  *photosVC = [[PhotosViewController alloc]init];
  [photosVC initPhotoViewControllerWithPhotoID:self.currentTapPhotoID];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  if(![AlbumSingleView checkRDVTabIsHidden])
    [photosVC   addBackBlock:^(id objc){
      [[PhotosViewController  getNavi]setNavigationBarHidden:YES];
      [PhotosViewController   setRDVTabHidden:NO isAnimated:NO];
      [[PhotosViewController  getNavi]popViewControllerAnimated:YES];
    }];
  else
    [photosVC   addBackBlock:^(id objc){
      [[PhotosViewController  getNavi]setNavigationBarHidden:YES];
      [[PhotosViewController  getNavi]popViewControllerAnimated:YES];
    }];
  [AlbumSingleView  setRDVTabHidden:YES  isAnimated:NO];
  [AlbumSingleView  naviPushViewController:photosVC];
   */
  TotalPhotoViewController  *photosVC = [[TotalPhotoViewController alloc]init];
  [photosVC initTotalPhotoViewControllerWithAlbum:self.album selectPhotoID:self.currentTapPhotoID];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  if(![AlbumSingleView checkRDVTabIsHidden])
    [photosVC   addBackBlock:^(id objc){
      [[TotalPhotoViewController  getNavi]setNavigationBarHidden:YES];
      [TotalPhotoViewController   setRDVTabHidden:NO isAnimated:NO];
      [[TotalPhotoViewController  getNavi]popViewControllerAnimated:YES];
    }];
  else
    [photosVC   addBackBlock:^(id objc){
      [[TotalPhotoViewController  getNavi]setNavigationBarHidden:YES];
      [[TotalPhotoViewController  getNavi]popViewControllerAnimated:YES];
    }];
  [AlbumSingleView  setRDVTabHidden:YES  isAnimated:NO];
  [AlbumSingleView  naviPushViewController:photosVC];
}

- (void)jumpToUserProfileView :(NSString*)content_author_domain;
{
  self.ppView = [[PersonalProfile  alloc]init];
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([content_author_domain isEqualToString:currentDomain])
    isSelf  = YES;
  [self.ppView  initPersonalProfileWithUserDomain:content_author_domain isSelf:isSelf];
  [self.ppView.view setFrame:kScreen_Bounds];
  [AlbumSingleView naviPushViewController:self.ppView];
}

- (void)jumpToUserProfileViewByRecommendName
{
  NSString  *content_author_domain;
  if(![self.album.author_name isEmpty])
    content_author_domain = self.album.author_domain;
  else  if(![self.album.user_name isEmpty])
    content_author_domain = self.album.user_domain;
  else
    return;
  self.ppView = [[PersonalProfile  alloc]init];
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([content_author_domain isEqualToString:currentDomain])
    isSelf  = YES;
  [self.ppView  initPersonalProfileWithUserDomain:content_author_domain isSelf:isSelf];
  [self.ppView.view setFrame:kScreen_Bounds];
  [AlbumSingleView naviPushViewController:self.ppView];
}

#pragma mark - getters and setters
- (UIButton*)jumpToPhotoDetailButton
{
  if(_jumpToPhotoDetailButton ==  nil)
  {
    _jumpToPhotoDetailButton = [[UIButton alloc] init];
    _jumpToPhotoDetailButton.backgroundColor  = kColorBackGround;
    //if(self.album.is_delete ==NO)
      //[_jumpToPhotoDetailButton addTarget:self action:@selector(jumpToPhotoDetailButtonActionTool:) forControlEvents:UIControlEventTouchUpInside];
    //else
      if(self.album.is_delete ==YES)
      [_jumpToPhotoDetailButton setImage:[UIImage imageNamed:@"DeleteCover.png"] forState:UIControlStateNormal];
  }
  return _jumpToPhotoDetailButton;
}

- (UITapImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView = [[UITapImageView alloc] init];
    [_avatarImageView setSize:CGSizeMake(25, 25)];
    if(self.album.author_avatar)
    {
      __weak typeof(self) weakSelf = self;
      NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:weakSelf.album.author_avatar]];
      [_avatarImageView  setImageWithUrlWaitForLoadForAvatarCircle :url placeholderImage:nil tapBlock:^(id obj)
       {
         [weakSelf  jumpToUserProfileView:weakSelf.album.author_domain];
       }];
    }
    else   if(self.album.user_avatar)
    {
      __weak typeof(self) weakSelf = self;
      NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:weakSelf.album.user_avatar]];
      [_avatarImageView  setImageWithUrlWaitForLoadForAvatarCircle :url placeholderImage:nil tapBlock:^(id obj)
       {
         [weakSelf  jumpToUserProfileView:weakSelf.album.user_domain];
       }];
    }
  }
  return _avatarImageView;
}

#pragma getter setter
- (UIButton*)photoAuthor
{
  if(_photoAuthor ==  nil)
  {
    _photoAuthor = [[UIButton alloc] init];
    [_photoAuthor  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    NSMutableAttributedString *origAuthor = [[NSMutableAttributedString alloc]initWithString:@"原作者  |  "];
    [origAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0] range:NSMakeRange(0,origAuthor.length)];
    [origAuthor addAttribute:NSFontAttributeName value:SourceHanSansNormal12 range:NSMakeRange(0,origAuthor.length)];
    if(![self.album.author_name isEmpty])
    {
      NSString  *content  = self.album.author_name;
      NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
      [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
      [string_content addAttribute:NSFontAttributeName value:SourceHanSansMedium12 range:NSMakeRange(0,string_content.length)];
      [origAuthor appendAttributedString:string_content];
      [_photoAuthor  setAttributedTitle:origAuthor forState:UIControlStateNormal];
      [_photoAuthor   addTarget:self action:@selector(jumpToUserProfileViewByRecommendName) forControlEvents:UIControlEventTouchUpInside];
    }
    else  if(![self.album.user_name isEmpty])
    {
      NSString  *content  = self.album.user_name;
      NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
      [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
      [string_content addAttribute:NSFontAttributeName value:SourceHanSansMedium12 range:NSMakeRange(0,string_content.length)];
      [origAuthor appendAttributedString:string_content];
      [_photoAuthor  setAttributedTitle:origAuthor forState:UIControlStateNormal];
      [_photoAuthor   addTarget:self action:@selector(jumpToUserProfileViewByRecommendName) forControlEvents:UIControlEventTouchUpInside];     
    }
    else
      [_photoAuthor  setTitle:@"" forState:UIControlStateNormal];
  }
  return _photoAuthor;
}
- (UIButton*)recommendedName
{
  if(_recommendedName==  nil)
  {
    _recommendedName = [[UIButton alloc] init];
    if(![self.album.author_name isEmpty])
    {
      [_recommendedName   setTitle:self.album.author_name forState:UIControlStateNormal];
      [_recommendedName   addTarget:self action:@selector(jumpToUserProfileViewByRecommendName) forControlEvents:UIControlEventTouchUpInside];
    }
    else  if(![self.album.user_name isEmpty])
    {
      [_recommendedName   setTitle:self.album.user_name forState:UIControlStateNormal];
      [_recommendedName   addTarget:self action:@selector(jumpToUserProfileViewByRecommendName) forControlEvents:UIControlEventTouchUpInside];
    }
    else
      [_recommendedName  setTitle:@"" forState:UIControlStateNormal];
    [_recommendedName  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recommendedName  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_recommendedName.titleLabel  setFont:SourceHanSansMedium14];
  }
  return _recommendedName;
}

- (UILabel*)hotLabel
{
  if(_hotLabel  ==  nil)
  {
    _hotLabel = [[UILabel alloc] init];
    [_hotLabel  setFont:[UIFont systemFontOfSize:kalbumSmallFontSize]];
    /*
    NSString  *hot  = @"热度";
    NSString  *temp_hot = @"1,212";
    if(self.album.hot)
      [self.hotLabel  setText:[hot stringByAppendingString:self.album.hot]];
    else
      [self.hotLabel  setText:[hot stringByAppendingString:temp_hot]];
     */
  }
  return _hotLabel;
}

- (UIScrollView*)photoScrollView
{
  if(_photoScrollView  ==  nil)
  {
    _photoScrollView = [[UIScrollView alloc] init];
    _photoScrollView.delegate  = self;
    [_photoScrollView setBackgroundColor:kColorBackGround];
    [_photoScrollView setShowsHorizontalScrollIndicator:NO];
  }
  return _photoScrollView;
}

- (AlbumFirstView*)albumFirstView
{
  if(_albumFirstView ==  nil)
  {
    _albumFirstView = [[AlbumFirstView alloc] init];
    _albumFirstView.delegate  = self;
  }
  return _albumFirstView;
}

- (UIButton*)albumNameLabel
{
  if(_albumNameLabel ==  nil)
  {
    _albumNameLabel = [[UIButton alloc] init];
    [_albumNameLabel  setTitleColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
    //[_albumNameLabel  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_albumNameLabel  setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    if(self.album.album_name)
    {
      [_albumNameLabel  setTitle:self.album.album_name forState:UIControlStateNormal];
      [_albumNameLabel addTarget:self action:@selector(jumpToPhotoDetailButtonActionTool:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
      [_albumNameLabel  setTitle:@"" forState:UIControlStateNormal];
    [_albumNameLabel.titleLabel  setFont:SourceHanSansNormal14];
  }
  return _albumNameLabel;
}

- (UILabel*)deleteInfo
{
  if(_deleteInfo  ==  nil)
  {
    _deleteInfo = [[UILabel  alloc]init];
    [_deleteInfo  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_deleteInfo  setTextAlignment:NSTextAlignmentCenter];
    [_deleteInfo  setFont:SourceHanSansMedium18];
    if(self.album.is_delete)
    {
      [_deleteInfo  setText:@"已删除"];
    }
  }
  return  _deleteInfo;
}

- (AlbumSecondViewController*)albumSecondView
{
  if(_albumSecondView ==  nil)
  {
    _albumSecondView  = [[AlbumSecondViewController  alloc]init];
  }
  return _albumSecondView;
}

- (UIImageView*)deleteImageBackGroud
{
  if(_deleteImageBackGroud  ==  nil)
  {
    _deleteImageBackGroud = [[UIImageView  alloc]init];
    [_deleteImageBackGroud setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
  }
  return _deleteImageBackGroud;
}

- (UIImageView*)deleteImage
{
  if(_deleteImage ==  nil)
  {
    _deleteImage  = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"DeleteCover"]];
  }
  return _deleteImage;
}

@end
