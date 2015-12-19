//
//  PocketAndPhotoView.m
//  TestPaiwo
//
//  Created by J006 on 15/5/19.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PocketAndPhotoView.h"
#import "PocketItemInstance.h"
#import "AlbumInstance.h"
#import "RecommendPhotoInstance.h"
#import "RecommendPhotoSingleView.h"
#import "PocketSingleView.h"
#import "AlbumSingleView.h"
#import "AlbumPhotoInstance.h"
#import "DouAPIManager.h"
#import <Masonry.h>


#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface PocketAndPhotoView ()

@property (strong,nonatomic)  NSMutableArray                    *totalInstanceArray;
@property (strong,nonatomic)  NSMutableArray                    *totalViewArray;
@property (strong,nonatomic)  NSMutableArray                    *recommendPhotoArray;
@property (strong,nonatomic)  NSMutableArray                    *pocketViewArray;
@property (strong,nonatomic)  NSMutableArray                    *albumViewArray;
@property (strong,nonatomic)  NSMutableArray                    *recommendPhotoViewArray;

@property (strong,nonatomic)  NSMutableArray                    *updateInstanceArray;//需要更新的实例对象
@property (strong,nonatomic)  NSMutableArray                    *updateViewArray;
@property (strong,nonatomic)  NSMutableArray                    *updatePocketViewArray;
@property (strong,nonatomic)  NSMutableArray                    *updateAlbumViewArray;
@property (strong,nonatomic)  NSMutableArray                    *updateRecommendPhotoViewArray;

@property (readwrite,nonatomic) float                           totalViewYPoint;
@property (strong,nonatomic)  NSString                          *host_domain;//用户域
@end

@implementation PocketAndPhotoView
@synthesize willLoadMore,canLoadMore,isLoading;

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = kColorBackGround;
  for (id object in _totalInstanceArray)
  {
    if([object isKindOfClass:[PocketItemInstance class]])
    {
      PocketItemInstance  *pocketItem = (PocketItemInstance*)object;
      PocketSingleView    *pocketSingleView  = [[PocketSingleView  alloc]init];
      [pocketSingleView  initPocketSingleView:pocketItem];
      [self.pocketViewArray addObject:pocketSingleView];
      [self.totalViewArray  addObject:pocketSingleView];
      [self.view            addSubview:pocketSingleView.view];
    }
    else  if([object isKindOfClass:[AlbumInstance class]])
    {
      AlbumInstance     *album = (AlbumInstance*)object;
      AlbumSingleView   *albumSingleView  = [[AlbumSingleView  alloc]init];
      [albumSingleView  initAlbumSingleView:album];
      [self.albumViewArray  addObject:albumSingleView];
      [self.totalViewArray  addObject:albumSingleView];
      [self.view            addSubview:albumSingleView.view];
    }
    else  if([object isKindOfClass:[RecommendPhotoInstance class]])
    {
      RecommendPhotoInstance     *recoPhoto = (RecommendPhotoInstance*)object;
      RecommendPhotoSingleView   *recoSingleView  = [[RecommendPhotoSingleView  alloc]init];
      [recoSingleView  initRecommendPhotoSingleViewWithAlbumPhoto:recoPhoto];
      [self.recommendPhotoViewArray   addObject:recoSingleView];
      [self.totalViewArray            addObject:recoSingleView];
      [self.view                      addSubview:recoSingleView.view];
    }
  }
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  if(!_totalViewArray)
    return;
  CGFloat theFitPocketHeight          = [PocketAndPhotoView heightToFitWidth:CGSizeMake(kdefaultScreen_Width, kpocketViewHeight) newWidth:kScreen_Width];
  CGFloat theFitAlbumHeight           = [PocketAndPhotoView heightToFitWidth:CGSizeMake(kdefaultScreen_Width, kphotoSingleViewHeight) newWidth:kScreen_Width];
  CGFloat theFitRecommendPhotoHeight  = [PocketAndPhotoView heightToFitWidth:CGSizeMake(kdefaultScreen_Width, kphotoSingleViewHeight) newWidth:kScreen_Width];
  NSInteger pocketCounts  = 0;
  NSInteger photoCounts   = 0;
  NSInteger recommendPhotoCounts   = 0;
  if(_pocketViewArray)
    pocketCounts  = [_pocketViewArray count];
  if(_albumViewArray)
    photoCounts  = [_albumViewArray count];
  if(_recommendPhotoViewArray)
    recommendPhotoCounts  = [_recommendPhotoViewArray count];
  [self.view setSize:CGSizeMake(kScreen_Width, theFitPocketHeight*pocketCounts+theFitAlbumHeight*photoCounts+theFitRecommendPhotoHeight*recommendPhotoCounts+ppViewTopDisctance)];
  UIViewController  *vc;
  for (id object in _totalViewArray)
  {
    if([object isKindOfClass:[PocketSingleView class]])
    {
      PocketSingleView  *pocketSingleView   = object;
      if(vc.view ==  nil)
      {
        [pocketSingleView.view mas_makeConstraints:^(MASConstraintMaker *make){
          make.top.equalTo(self.view).offset(ppViewTopDisctance);
          make.left.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(kScreen_Width, theFitPocketHeight));
        }];
      }
      else
      {
        [pocketSingleView.view mas_makeConstraints:^(MASConstraintMaker *make){
          make.top.equalTo(vc.view.mas_bottom);
          make.left.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(kScreen_Width, theFitPocketHeight));
        }];
      }
      vc  = pocketSingleView;
    }
    else  if([object isKindOfClass:[AlbumSingleView class]])
    {
      AlbumSingleView   *albumSingleView  = object;
      if(vc.view ==  nil)
      {
        [albumSingleView.view mas_makeConstraints:^(MASConstraintMaker *make){
          make.top.equalTo(self.view).offset(ppViewTopDisctance);
          make.left.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(kScreen_Width, theFitAlbumHeight));
        }];
      }
      else
      {
        [albumSingleView.view mas_makeConstraints:^(MASConstraintMaker *make){
          make.top.equalTo(vc.view.mas_bottom);
          make.left.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(kScreen_Width, theFitAlbumHeight));
        }];
      }
      vc  = albumSingleView;
    }
    else  if([object isKindOfClass:[RecommendPhotoSingleView class]])
    {
      RecommendPhotoSingleView  *recommendPhotoSingleView   = object;
      if(vc.view ==  nil)
      {
        [recommendPhotoSingleView.view mas_makeConstraints:^(MASConstraintMaker *make){
          make.top.equalTo(self.view).offset(ppViewTopDisctance);
          make.left.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(kScreen_Width, theFitRecommendPhotoHeight));
        }];
      }
      else
      {
        [recommendPhotoSingleView.view mas_makeConstraints:^(MASConstraintMaker *make){
          make.top.equalTo(vc.view.mas_bottom);
          make.left.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(kScreen_Width, theFitRecommendPhotoHeight));
        }];
      }
      vc  = recommendPhotoSingleView;
    }
  }
  if (_delegate && [_delegate respondsToSelector:@selector(finishInitTheView:ppHeight:)])
  {
    [self.delegate finishInitTheView:self ppHeight:self.view.frame.size.height];
  }

}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewWillAppear:(BOOL)animated
{
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma init
- (void)  initPocketAndPhotoViewWithDynamicContentInstance :(NSMutableArray*)dynamicInstanceArray;
{
  //self.totalInstanceArray =  [self refineTheDynamicInstanceArray:dynamicInstanceArray];
  self.totalInstanceArray =  dynamicInstanceArray;
}

- (void)  updatePocketAndPhotoViewWithDynamicContentInstance :(NSMutableArray*)dynamicInstanceArray
{
  //self.updateInstanceArray  = [[NSMutableArray alloc]init];
  self.updateInstanceArray  = dynamicInstanceArray;
  for (id object in self.updateInstanceArray)
  {
    if([object isKindOfClass:[PocketItemInstance class]])
    {
      PocketItemInstance  *pocketItem = (PocketItemInstance*)object;
      PocketSingleView    *pocketSingleView  = [[PocketSingleView  alloc]init];
      [pocketSingleView  initPocketSingleView:pocketItem];
      [self.pocketViewArray addObject:pocketSingleView];
      [self.totalViewArray  addObject:pocketSingleView];
      [self.view            addSubview:pocketSingleView.view];
    }
    else  if([object isKindOfClass:[AlbumInstance class]])
    {
      AlbumInstance     *album = (AlbumInstance*)object;
      AlbumSingleView   *albumSingleView  = [[AlbumSingleView  alloc]init];
      [albumSingleView  initAlbumSingleView:album];
      [self.albumViewArray  addObject:albumSingleView];
      [self.totalViewArray  addObject:albumSingleView];
      [self.view            addSubview:albumSingleView.view];
    }
    else  if([object isKindOfClass:[RecommendPhotoInstance class]])
    {
      RecommendPhotoInstance     *recoPhoto = (RecommendPhotoInstance*)object;
      RecommendPhotoSingleView   *recoSingleView  = [[RecommendPhotoSingleView  alloc]init];
      [recoSingleView  initRecommendPhotoSingleViewWithAlbumPhoto:recoPhoto];
      [self.recommendPhotoViewArray   addObject:recoSingleView];
      [self.totalViewArray            addObject:recoSingleView];
      [self.view                      addSubview:recoSingleView.view];
    }
  }
}

#pragma private method
/*
- (NSMutableArray*)refineTheDynamicInstanceArray  :(NSMutableArray*)dynamicInstanceArray
{
  NSMutableArray    *tempArray  = [[NSMutableArray alloc]init];
  for (DynamicContentInstance *dynamicContentInstance in dynamicInstanceArray)
  {
    if(dynamicContentInstance.content_type ==  publish_album)
    {
      AlbumInstance  *albumInstance  = [[AlbumInstance  alloc]init];
      albumInstance.album_id = dynamicContentInstance.content_id;
      albumInstance.content_type  = dynamicContentInstance.content_type;
      albumInstance.content_user_id  = dynamicContentInstance.content_user_id;
      albumInstance.author_name  = dynamicContentInstance.content_user_name;
      albumInstance.author_avatar  = dynamicContentInstance.content_user_avatar;
      albumInstance.author_domain  = dynamicContentInstance.content_user_domain;
      NSMutableArray  *albumPhotoArray;
      for (DynamicContentPhotoInstance *objectPhoto in dynamicContentInstance.photo_list)
      {
        if(!albumPhotoArray)
          albumPhotoArray = [[NSMutableArray alloc]init];
        AlbumPhotoInstance *albumPhoto = [[AlbumPhotoInstance  alloc]init];
        albumPhoto.photo_id = objectPhoto.photo_id;
        albumPhoto.photo_path = objectPhoto.photo_path;
        albumPhoto.is_cover = objectPhoto.is_cover;
        [albumPhotoArray  addObject:albumPhoto];
      }
      albumInstance.photo_list  = albumPhotoArray;
      albumInstance.photo_count  = dynamicContentInstance.photo_count;
      albumInstance.album_name  = dynamicContentInstance.content_title;
      albumInstance.album_desc  = dynamicContentInstance.content_desc;
      albumInstance.content_user_id  = dynamicContentInstance.content_user_id;
      albumInstance.content_user_name  = dynamicContentInstance.content_user_name;
      albumInstance.content_user_avatar  = dynamicContentInstance.content_user_avatar;
      albumInstance.content_user_domain  = dynamicContentInstance.content_user_domain;
      albumInstance.create_time  = dynamicContentInstance.create_time;
      albumInstance.is_like  = dynamicContentInstance.is_like;
      albumInstance.is_recommend  = dynamicContentInstance.is_recommend;
      albumInstance.is_delete  = dynamicContentInstance.is_delete;
      [tempArray addObject:albumInstance];
    }
    else if(dynamicContentInstance.content_type ==  recommend_pocket || dynamicContentInstance.content_type ==  publish_pocket)
    {
      PocketItemInstance  *pocketInstance  = [[PocketItemInstance  alloc]init];
      pocketInstance.pocket_id = dynamicContentInstance.content_id;
      pocketInstance.content_type  = dynamicContentInstance.content_type;
      pocketInstance.content_user_id  = dynamicContentInstance.content_user_id;
      pocketInstance.content_user_name  = dynamicContentInstance.content_user_name;
      pocketInstance.content_user_avatar  = dynamicContentInstance.content_user_avatar;
      pocketInstance.content_user_domain  = dynamicContentInstance.content_user_domain;
      for (DynamicContentPhotoInstance *objectPhoto in dynamicContentInstance.photo_list)
      {
        pocketInstance.cover_photo = objectPhoto.photo_path;
      }
      pocketInstance.photo_count  = dynamicContentInstance.photo_count;
      pocketInstance.pocket_title  = dynamicContentInstance.content_title;
      pocketInstance.content_desc  = dynamicContentInstance.content_desc;
      pocketInstance.content_author_id  = dynamicContentInstance.content_author_id;
      pocketInstance.content_author_name  = dynamicContentInstance.content_author_name;
      pocketInstance.content_author_domain  = dynamicContentInstance.content_author_domain;
      pocketInstance.create_time  = dynamicContentInstance.create_time;
      pocketInstance.is_like  = dynamicContentInstance.is_like;
      pocketInstance.is_recommend  = dynamicContentInstance.is_recommend;
      pocketInstance.is_delete  = dynamicContentInstance.is_delete;
      [tempArray addObject:pocketInstance];
    }
    else  if(dynamicContentInstance.content_type ==  recommend_photo)
    {
      RecommendPhotoInstance  *recommendPhotoInstance  = [[RecommendPhotoInstance  alloc]init];
      recommendPhotoInstance.content_id = dynamicContentInstance.content_id;
      recommendPhotoInstance.content_type  = dynamicContentInstance.content_type;
      recommendPhotoInstance.content_user_id  = dynamicContentInstance.content_user_id;
      recommendPhotoInstance.content_user_name  = dynamicContentInstance.content_user_name;
      recommendPhotoInstance.content_user_avatar  = dynamicContentInstance.content_user_avatar;
      recommendPhotoInstance.content_user_domain  = dynamicContentInstance.content_user_domain;
      NSMutableArray  *albumPhotoArray;
      for (DynamicContentPhotoInstance *objectPhoto in dynamicContentInstance.photo_list)
      {
        if(!albumPhotoArray)
          albumPhotoArray = [[NSMutableArray alloc]init];
        AlbumPhotoInstance *albumPhoto = [[AlbumPhotoInstance  alloc]init];
        albumPhoto.photo_id = objectPhoto.photo_id;
        albumPhoto.photo_path = objectPhoto.photo_path;
        albumPhoto.is_cover = objectPhoto.is_cover;
        [albumPhotoArray  addObject:albumPhoto];
      }
      recommendPhotoInstance.photo_list  = albumPhotoArray;
      recommendPhotoInstance.photo_count  = dynamicContentInstance.photo_count;
      recommendPhotoInstance.content_title  = dynamicContentInstance.content_title;
      recommendPhotoInstance.content_author_id  = dynamicContentInstance.content_author_id;
      recommendPhotoInstance.content_author_name  = dynamicContentInstance.content_author_name;
      recommendPhotoInstance.content_author_domain  = dynamicContentInstance.content_author_domain;
      recommendPhotoInstance.content_desc  = dynamicContentInstance.content_desc;
      recommendPhotoInstance.create_time  = dynamicContentInstance.create_time;
      recommendPhotoInstance.is_like  = dynamicContentInstance.is_like;
      recommendPhotoInstance.is_recommend  = dynamicContentInstance.is_recommend;
      recommendPhotoInstance.is_delete  = dynamicContentInstance.is_delete;
      [tempArray addObject:recommendPhotoInstance];
    }
  }
  return tempArray;
}
*/


#pragma getter setter
- (NSMutableArray*)pocketViewArray
{
  if(_pocketViewArray ==  nil)
  {
    _pocketViewArray  = [[NSMutableArray alloc]init];
  }
  return _pocketViewArray;
}

- (NSMutableArray*)albumViewArray
{
  if(_albumViewArray ==  nil)
  {
    _albumViewArray  = [[NSMutableArray alloc]init];
  }
  return _albumViewArray;
}

- (NSMutableArray*)totalInstanceArray
{
  if(_totalInstanceArray ==  nil)
  {
    _totalInstanceArray  = [[NSMutableArray alloc]init];
  }
  return _totalInstanceArray;
}

- (NSMutableArray*)totalViewArray
{
  if(_totalViewArray ==  nil)
  {
    _totalViewArray  = [[NSMutableArray alloc]init];
  }
  return _totalViewArray;
}

- (NSMutableArray*)recommendPhotoArray
{
  if(_recommendPhotoArray ==  nil)
  {
    _recommendPhotoArray  = [[NSMutableArray alloc]init];
  }
  return _recommendPhotoArray;
}

- (NSMutableArray*)recommendPhotoViewArray
{
  if(_recommendPhotoViewArray ==  nil)
  {
    _recommendPhotoViewArray  = [[NSMutableArray alloc]init];
  }
  return _recommendPhotoViewArray;
}

@end
