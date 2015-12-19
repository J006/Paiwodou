//
//  RecommendPhotoSingleView.m
//  DouPaiwo
//
//  Created by J006 on 15/7/2.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "RecommendPhotoSingleView.h"
#import "AlbumPhotoInstance.h"
#import "DouAPIManager.h"
#import <Masonry/Masonry.h>
#import "PersonalProfile.h"
#import "PhotosViewController.h"
#import "NSString+Common.h"
#import "RecommendPhotoFirstView.h"
#import "RecommendPhotoSecondView.h"
@interface RecommendPhotoSingleView ()

@property (strong, nonatomic)   RecommendPhotoInstance            *recommendPhotoInstance;
@property (strong, nonatomic)   RecommendPhotoFirstView           *recommendPhotoFirstView;
@property (strong, nonatomic)   RecommendPhotoSecondView          *recommendPhotoSecondView;
@property (strong, nonatomic)   UITapImageView                    *avatarImageView;//推荐人头像
@property (strong, nonatomic)   UIButton                          *recommendedName;//推荐人名称
@property (strong, nonatomic)   UIButton                          *photoAuthor;//原作者名称
@property (strong, nonatomic)   UIButton                          *albumNameLabel;//专辑名称
@property (strong, nonatomic)   UILabel                           *deleteInfo;//原内容已被删除
@property (nonatomic, readwrite)float                             theFitHeight;
@property (strong, nonatomic)   UIScrollView                      *photoScrollView;//滚动界面容器scrollview
@property (strong, nonatomic)   PersonalProfile                   *ppView;
@property (strong, nonatomic)   AlbumInstance                     *album;
@end

@implementation RecommendPhotoSingleView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = kColorBackGround;
  [self.view addSubview:self.avatarImageView];
  [self.view addSubview:self.photoAuthor];
  [self.view addSubview:self.recommendedName];
  [self.view addSubview:self.albumNameLabel];
  if(self.recommendPhotoInstance.is_delete)
     [self.view addSubview:self.deleteInfo];
  [self.view addSubview:self.photoScrollView];
  CGFloat theFitHeight  = [RecommendPhotoSingleView heightToFitWidth:CGSizeMake(kdefaultScreen_Width, kRecommendphotoSingleViewHeight) newWidth:kScreen_Width];
  self.theFitHeight = theFitHeight;
  [self.recommendPhotoFirstView initRecommendPhotoSingleViewWithAlbumPhoto:self.recommendPhotoInstance];
  [self.photoScrollView addSubview:self.recommendPhotoFirstView.view];
  
  if(!self.recommendPhotoInstance.is_delete)
    [self.photoScrollView addSubview:self.recommendPhotoSecondView.view];
  __weak typeof(self) weakSelf = self;
  if(self.recommendPhotoInstance.is_delete)
    return;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager] request_GetAlbumPhotoWithPhotoID :weakSelf.recommendPhotoInstance.photo_id :^(AlbumPhotoInstance *albumPhotoInstance, NSError *error)
                    {
                      if(!albumPhotoInstance)
                        return;
                      [[DouAPIManager  sharedManager] request_GetAlbumWithAlbumID:albumPhotoInstance.album_id :^(AlbumInstance *data, NSError *error) {
                        if(!data)
                          return;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                          weakSelf.album  = data;
                          weakSelf.recommendPhotoFirstView.album  = data;
                          [weakSelf.recommendPhotoSecondView initARecommendPhotoSecondViewControllerWithAlbum:data];
                          [weakSelf.recommendPhotoSecondView.view  setNeedsLayout];
                        });
                      }];
                    }];
                 });
  
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.left.equalTo(self.view).with.offset(kTotalDefaultPadding);
    make.size.mas_equalTo(CGSizeMake(25, 25));
  }];
  [self.avatarImageView doCircleFrame];
  
  [self.recommendedName mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(5);
    make.left.equalTo(self.avatarImageView.mas_right).with.offset(10);
  }];
  [self.recommendedName sizeToFit];
  [self.recommendedName setHeight:30];
  
  [self.photoAuthor mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.recommendPhotoFirstView.view.mas_bottom).with.offset(0);
    make.right.equalTo(self.view).with.offset(-kTotalDefaultPadding);
  }];
  [self.photoAuthor sizeToFit];
  
  [self.albumNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.recommendPhotoFirstView.view.mas_bottom).with.offset(5);
    make.left.equalTo(self.view).with.offset(kTotalDefaultPadding);
  }];
  [self.albumNameLabel  sizeToFit];
  
  if(self.recommendPhotoInstance.is_delete)
    [self.deleteInfo mas_makeConstraints:^(MASConstraintMaker *make){
      make.bottom.equalTo(self.view).with.offset(-20);
      make.centerX.equalTo(self.view);
      make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
  
  [self.photoScrollView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).offset(39);
    make.left.equalTo(self.view).offset(0);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScreen_Width-kTotalDefaultPadding*2));
  }];
  CGFloat theFollowViewWidth  = [RecommendPhotoSingleView widthToFitHeight:CGSizeMake(180, 270) newHeight:kScreen_Width-kTotalDefaultPadding*2];
  //设置第一张图片界面
  [self.recommendPhotoFirstView.view mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.photoScrollView);
    make.left.equalTo(self.photoScrollView).offset(kTotalDefaultPadding);
    make.size.mas_equalTo(CGSizeMake(kScreen_Width-kTotalDefaultPadding*2, kScreen_Width-kTotalDefaultPadding*2));
  }];
  //设置第二张介绍界面
  if(!self.recommendPhotoInstance.is_delete)
  {
    [self.recommendPhotoSecondView.view mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.recommendPhotoFirstView.view.mas_right).offset(10);
      make.top.equalTo(self.photoScrollView);
      make.size.mas_equalTo(CGSizeMake(theFollowViewWidth, kScreen_Width-kTotalDefaultPadding*2));
    }];
    //设置scrollview的内容宽度
    self.photoScrollView.contentSize  = CGSizeMake(kScreen_Width+theFollowViewWidth+10, kScreen_Width-2*kTotalDefaultPadding);
  }
  else
    self.photoScrollView.contentSize  = CGSizeMake(kScreen_Width, kScreen_Width-2*kTotalDefaultPadding);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author J006, 15-04-23 13:04:34
 *
 *  滚动界面容器初始化:包括第一张和第二张界面的初始化
 *
 */
- (void)  initScrollView
{
  //[self initFollowView:pocketItem];
  [self.photoScrollView addSubview:self.recommendPhotoSecondView.view];
}

#pragma init
- (void)  initRecommendPhotoSingleViewWithAlbumPhoto:(RecommendPhotoInstance*)recommendPhotoInstance;
{
  self.recommendPhotoInstance = recommendPhotoInstance;
}

#pragma event

- (void)jumpToUserProfileViewByAuthorName
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
  [RecommendPhotoSingleView naviPushViewController:self.ppView];
}


#pragma getter setter

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

- (RecommendPhotoFirstView*)recommendPhotoFirstView
{
  if(_recommendPhotoFirstView ==  nil)
  {
    _recommendPhotoFirstView  = [[RecommendPhotoFirstView  alloc]init];
  }
  return  _recommendPhotoFirstView;
}

- (RecommendPhotoSecondView*)recommendPhotoSecondView
{
  if(_recommendPhotoSecondView ==  nil)
  {
    _recommendPhotoSecondView  = [[RecommendPhotoSecondView  alloc]init];
  }
  return  _recommendPhotoSecondView;
}

- (UITapImageView*)avatarImageView
{
  if(_avatarImageView ==  nil)
  {
    _avatarImageView = [[UITapImageView alloc] init];
    [_avatarImageView setSize:CGSizeMake(25, 25)];
    if(self.recommendPhotoInstance.user_avatar)
    {
      __weak typeof(self) weakSelf = self;
      NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:weakSelf.recommendPhotoInstance.user_avatar]];
      [_avatarImageView  setImageWithUrlWaitForLoadForAvatarCircle :url placeholderImage:nil tapBlock:^(id obj)
       {
       }];
    }
  }
  return _avatarImageView;
}

- (UIButton*)photoAuthor
{
  if(_photoAuthor ==  nil)
  {
    _photoAuthor = [[UIButton alloc] init];
    if(self.recommendPhotoInstance.author_name && ![self.recommendPhotoInstance.author_name  isEqualToString:@""])
    {
      NSMutableAttributedString *origAuthor = [[NSMutableAttributedString alloc]initWithString:@"原作者  |  "];
      [origAuthor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0] range:NSMakeRange(0,origAuthor.length)];
      [origAuthor addAttribute:NSFontAttributeName value:SourceHanSansNormal12 range:NSMakeRange(0,origAuthor.length)];
      NSString  *content  = self.recommendPhotoInstance.author_name;
      NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
      [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:101/255.0 green:101/255.0 blue:101/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
      [string_content addAttribute:NSFontAttributeName value:SourceHanSansMedium12 range:NSMakeRange(0,string_content.length)];
      [origAuthor appendAttributedString:string_content];
      [_photoAuthor  setAttributedTitle:origAuthor forState:UIControlStateNormal];
      [_photoAuthor addTarget:self action:@selector(jumpToUserProfileViewByAuthorName) forControlEvents:UIControlEventTouchUpInside];
    }
    else
      [_photoAuthor  setTitle:@"" forState:UIControlStateNormal];
  }
  return _photoAuthor;
}

- (UILabel*)deleteInfo
{
  if(_deleteInfo  ==  nil)
  {
    _deleteInfo = [[UILabel  alloc]init];
    [_deleteInfo  setTextColor:[UIColor lightGrayColor]];
    [_deleteInfo  setTextAlignment:NSTextAlignmentRight];
    [_deleteInfo  setFont:[UIFont systemFontOfSize:14]];
    if(self.recommendPhotoInstance.is_delete)
    {
       [_deleteInfo  setText:@"原内容已被删除"];
    }
  }
  return  _deleteInfo;
}

- (UIButton*)recommendedName
{
  if(_recommendedName==  nil)
  {
    _recommendedName = [[UIButton alloc] init];
    if(self.recommendPhotoInstance.user_name)
    {
      [_recommendedName   setTitle:self.recommendPhotoInstance.user_name forState:UIControlStateNormal];
    }
    else
      [_recommendedName   setTitle:@"" forState:UIControlStateNormal];
    [_recommendedName  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recommendedName  setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_recommendedName.titleLabel  setFont:SourceHanSansMedium14];
  }
  return _recommendedName;
}

- (UIButton*)albumNameLabel
{
  if(_albumNameLabel ==  nil)
  {
    _albumNameLabel = [[UIButton alloc] init];
    
  }
  return _albumNameLabel;
}

@end
