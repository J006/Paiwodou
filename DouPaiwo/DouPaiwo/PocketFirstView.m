//
//  PocketFirstView.m
//  TestPaiwo
//
//  Created by J006 on 15/4/23.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PocketFirstView.h"
#import "PocketDetailHTML.h"
#import <RDVTabBarController.h>
#import "UITapImageView.h"
#import <Masonry/Masonry.h>
#import "DouAPIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface PocketFirstView ()

@property (strong, nonatomic) UITapImageView        *backGroundTapImageView;//背景可跳转图片
@property (strong, nonatomic) UILabel               *mainTitle;//主标题
@property (strong, nonatomic) UILabel               *subTitle;//副标题
@property (strong, nonatomic) PocketItemInstance    *pocketItemInstance;
@property (strong, nonatomic) UIImageView           *deleteImage;//已删除图片
@property (strong, nonatomic) UILabel               *deleteInfo;//已删除
@end

@implementation PocketFirstView

- (void)viewDidLoad
{
  self.view.backgroundColor = kColorBackGround;
  [self.view addSubview:self.backGroundTapImageView];
  [self.view addSubview:self.mainTitle];
  [self.view addSubview:self.subTitle];
  if(self.pocketItemInstance.is_delete)
  {
    [self.view addSubview:self.deleteImage];
    [self.view addSubview:self.deleteInfo];
  }
}

- (void)viewDidLayoutSubviews
{

  [self.backGroundTapImageView  setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  
  [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make){
    make.bottom.equalTo(self.view).with.offset(-60);
    make.left.equalTo(self.view).with.offset(25);
    make.right.equalTo(self.view).with.offset(-25);
    make.height.mas_equalTo(30);
  }];

  [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.mainTitle.mas_bottom).with.offset(0);
    make.left.equalTo(self.view).with.offset(30);
    make.right.equalTo(self.view).with.offset(-30);
    make.height.mas_equalTo(18);
  }];
  if(self.pocketItemInstance.is_delete == YES)
  {
    [self.deleteImage mas_makeConstraints:^(MASConstraintMaker *make){
      make.center.equalTo(self.backGroundTapImageView);
    }];
    
    [self.deleteInfo mas_makeConstraints:^(MASConstraintMaker *make){
      make.top.equalTo(self.deleteImage.mas_bottom).offset(10);
      make.centerX.equalTo(self.view);
    }];
  }
}

/**
 *  @author J006, 15-05-08 10:05:50
 *
 *  初始化第一张界面
 */
- (void)initPocketFirstView :(PocketItemInstance*)pocketInstance;
{
  _pocketItemInstance = pocketInstance;
}

/**
 *  @author J006, 15-05-05 12:05:23
 *
 *  跳转到pocket详细界面
 *
 *  @param sender
 */
- (void)jumpToPocketDetail
{
  PocketDetailHTML  *pocketDetail  = [[PocketDetailHTML alloc]init];
  [pocketDetail initPocketDetailHTMLWithPocketID:self.pocketItemInstance.pocket_id];
  if(![PocketFirstView checkRDVTabIsHidden])
    [pocketDetail   addBackBlock:^(id objc){
      [[PocketDetailHTML  getNavi]setNavigationBarHidden:YES];
      [PocketDetailHTML   setRDVTabHidden:NO isAnimated:NO];
      [[PocketDetailHTML  getNavi]popViewControllerAnimated:YES];
    }];
  else
    [pocketDetail   addBackBlock:^(id objc){
      [[PocketDetailHTML  getNavi]setNavigationBarHidden:YES];
      [[PocketDetailHTML  getNavi]popViewControllerAnimated:YES];
    }];
  [pocketDetail.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [[PocketFirstView    getNavi] setNavigationBarHidden:YES animated:NO];
  [PocketFirstView  setRDVTabHidden:YES isAnimated:NO];
  [PocketFirstView  naviPushViewController:pocketDetail];
}

- (UITapImageView*)backGroundTapImageView
{
  if(_backGroundTapImageView  ==  nil)
  {
    _backGroundTapImageView = [[UITapImageView alloc]init];
    _backGroundTapImageView.backgroundColor = kColorBackGround;
    if(self.pocketItemInstance.is_delete == NO)
    {
      __weak typeof(self) weakSelf = self;
      NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:self.pocketItemInstance.cover_photo] stringByAppendingString:imageSquareTailUrl];
      NSURL *url = [[NSURL  alloc]initWithString:urlString];
      [_backGroundTapImageView  setImageWithURL:url placeholderImage:nil  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
       {
         if(image)
         {
           image  = [image addBlackFillterToImageWithOrigImage];
           [weakSelf.backGroundTapImageView setImage:image];
           [weakSelf.backGroundTapImageView   addTapBlock:^(id obj) {
             [weakSelf  jumpToPocketDetail];
           }];
         }
       }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    else  if(self.pocketItemInstance.is_delete ==YES)
    {
      [_backGroundTapImageView setBackgroundColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    }
  }
  return _backGroundTapImageView;
}

- (UILabel*)mainTitle
{
  if(_mainTitle ==  nil)
  {
    _mainTitle = [[UILabel  alloc]init];
    [_mainTitle setFont:SourceHanSansNormal18];
    [_mainTitle setTextColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    [_mainTitle setTextAlignment:NSTextAlignmentCenter];
    if(_pocketItemInstance && _pocketItemInstance.pocket_title)
      [_mainTitle setText:_pocketItemInstance.pocket_title];
    else
      [_mainTitle setText:@""];
  }
  return _mainTitle;
}

- (UILabel*)subTitle
{
  if(_subTitle ==  nil)
  {
    _subTitle = [[UILabel  alloc]init];
    [_subTitle setFont:SourceHanSansNormal12];
    [_subTitle setTextColor:[UIColor colorWithRed:216/255.0 green:214/255.0 blue:208/255.0 alpha:1.0]];
    [_subTitle setTextAlignment:NSTextAlignmentCenter];
    if(_pocketItemInstance && _pocketItemInstance.pocket_second_title)
      [_subTitle setText:_pocketItemInstance.pocket_second_title];
    else
      [_subTitle setText:@""];
  }
  return _subTitle;
}

- (UILabel*)deleteInfo
{
  if(_deleteInfo  ==  nil)
  {
    _deleteInfo = [[UILabel  alloc]init];
    [_deleteInfo  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_deleteInfo  setTextAlignment:NSTextAlignmentCenter];
    [_deleteInfo  setFont:SourceHanSansMedium18];
    if(self.pocketItemInstance.is_delete)
    {
      [_deleteInfo  setText:@"已删除"];
    }
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
