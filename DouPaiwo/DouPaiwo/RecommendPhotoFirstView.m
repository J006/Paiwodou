//
//  RecommendPhotoFirstView.m
//  DouPaiwo
//
//  Created by J006 on 15/9/23.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import "RecommendPhotoFirstView.h"
#import "AlbumPhotoInstance.h"
#import "DouAPIManager.h"
#import <Masonry/Masonry.h>
#import "PersonalProfile.h"
#import "PhotosViewController.h"
#import "NSString+Common.h"
#import "TotalPhotoViewController.h"
#import <Masonry.h>
@interface RecommendPhotoFirstView ()

@property (strong, nonatomic)   RecommendPhotoInstance            *recommendPhotoInstance;
@property (strong, nonatomic)   UITapImageView                    *photoImageView;//推荐图片
@property (nonatomic, readwrite)float                             theFitHeight;
@property (strong, nonatomic)   UIImageView                       *deleteImage;//已删除图片
@property (strong, nonatomic)   UILabel                           *deleteInfo;//已删除

@end

@implementation RecommendPhotoFirstView
@synthesize album;
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = kColorBackGround;
  [self.view addSubview:self.photoImageView];
  if(self.recommendPhotoInstance.is_delete)
  {
    [self.view addSubview:self.deleteImage];
    [self.view addSubview:self.deleteInfo];
  }
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.photoImageView setFrame:self.view.bounds];
  
  if(self.recommendPhotoInstance.is_delete)
  {
    [self.deleteImage  mas_makeConstraints:^(MASConstraintMaker *make) {
      make.center.equalTo(self.view);
    }];
    [self.deleteImage  sizeToFit];
    
    [self.deleteInfo  mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.view);
      make.top.equalTo(self.deleteImage.mas_bottom).offset(10);
    }];
    [self.deleteInfo  sizeToFit];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init
- (void)  initRecommendPhotoSingleViewWithAlbumPhoto:(RecommendPhotoInstance*)recommendPhotoInstance;
{
  self.recommendPhotoInstance = recommendPhotoInstance;
}

#pragma event


/**
 *  @author J006, 15-05-11 15:05:16
 *
 *  跳转到照片详细页面
 *
 *  @param sender 按钮
 */
- (void)jumpToRecommendPhotoDetailAction:(id)sender
{
  /*
  PhotosViewController  *photosVC = [[PhotosViewController alloc]init];
  [photosVC initPhotoViewControllerWithPhotoID:self.recommendPhotoInstance.photo_id];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  if(![RecommendPhotoFirstView checkRDVTabIsHidden])
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
  [RecommendPhotoFirstView  setRDVTabHidden:YES  isAnimated:NO];
  [RecommendPhotoFirstView  naviPushViewController:photosVC];
   */
  TotalPhotoViewController  *photosVC = [[TotalPhotoViewController alloc]init];
  [photosVC initTotalPhotoViewControllerWithAlbum:self.album selectPhotoID:self.recommendPhotoInstance.photo_id];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  if(![RecommendPhotoFirstView checkRDVTabIsHidden])
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
  [RecommendPhotoFirstView  setRDVTabHidden:YES  isAnimated:NO];
  [RecommendPhotoFirstView  naviPushViewController:photosVC];
}


#pragma getter setter

- (UITapImageView*)photoImageView
{
  if(_photoImageView ==  nil)
  {
    _photoImageView = [[UITapImageView alloc] init];
    if(self.recommendPhotoInstance.is_delete ==NO)
    {
      __weak typeof(self) weakSelf = self;
      NSString  *stringURL  = [[defaultImageHeadUrl stringByAppendingString:self.recommendPhotoInstance.cover_path] stringByAppendingString:imageSquareTailUrl];
      NSURL *url = [[NSURL  alloc]initWithString:stringURL];
      [_photoImageView  setImageWithUrlWaitForLoad :url placeholderImage:nil tapBlock:^(id obj)
       {
         [weakSelf  jumpToRecommendPhotoDetailAction:nil];
       }];
    }
    else  if(self.recommendPhotoInstance.is_delete ==YES)
    {
      [_photoImageView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    }
  }
  return _photoImageView;
}

- (UILabel*)deleteInfo
{
  if(_deleteInfo  ==  nil)
  {
    _deleteInfo = [[UILabel  alloc]init];
    [_deleteInfo  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_deleteInfo  setTextAlignment:NSTextAlignmentCenter];
    [_deleteInfo  setFont:SourceHanSansMedium18];
    [_deleteInfo  setText:@"已删除"];
  }
  return  _deleteInfo;
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
