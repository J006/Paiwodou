//
//  SearchMainResultView.m
//  DouPaiwo
//
//  Created by J006 on 15/6/19.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchMainResultView.h"
#import "SearchBackGroundViewController.h"
#import "SearchResultSinlgeView.h"
#import "DouAPIManager.h"
#import <Masonry.h>
#define pageSizeSearchAlbumPhoto 4

@interface SearchMainResultView ()

@property (nonatomic,strong)    UIScrollView                          *mainScrollView;//主界面的滚动条
@property (nonatomic,strong)    NSMutableArray                        *usersArray;
@property (nonatomic,strong)    NSMutableArray                        *photosArray;
@property (nonatomic,readwrite) NSInteger                             searchUsersTotalNums;//搜索用户得到的结果数量
@property (nonatomic,readwrite) NSInteger                             searchAlbumPhotosTotalNums;//搜索图片得到的结果数量
@property (nonatomic,strong)    NSString                              *searchTags;//搜索字符串
@property (nonatomic,strong)    NSMutableArray                        *searchTagsArray;//搜索的数组集合

@property (nonatomic,strong)    SearchResultSinlgeView                *searchUserSingleView;//搜索结果用户列表
@property (nonatomic,strong)    SearchResultSinlgeView                *searchAlbumPhotosSingleView;//搜索结果专辑图片列表

@property (strong, nonatomic)   UIActivityIndicatorView               *activityIndicatorView;
@end

@implementation SearchMainResultView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.mainScrollView];
  [self.view  addSubview:self.activityIndicatorView];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager sharedManager] request_SearchUsersWithPageNo: 1 page_size:pageSizeDefault tags:self.searchTagsArray :^(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error)
                    {
                      if(usersData)
                      {
                        weakSelf.usersArray              = usersData;
                        weakSelf.searchUsersTotalNums    = totalSearchNums;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                          [weakSelf.searchUserSingleView  initSearchResultSinlgeViewWithType:resultType_photographer resultArray:weakSelf.usersArray totalSearchNums:weakSelf.searchUsersTotalNums  searchTags:weakSelf.searchTags];
                          [weakSelf.mainScrollView  addSubview:weakSelf.searchUserSingleView.view];
                        });

                      }
                      else
                      {
                        weakSelf.usersArray              = nil;
                        weakSelf.searchUsersTotalNums    = 0;
                      }
                      [[DouAPIManager sharedManager] request_SearchPhotoWithPageNo: 1  page_size:pageSizeSearchAlbumPhoto tags:self.searchTagsArray :^(NSMutableArray *photosData, NSInteger totalSearchNums, NSError *error)
                       {
                         if(photosData)
                         {
                           weakSelf.photosArray                    = photosData;
                           weakSelf.searchAlbumPhotosTotalNums     = totalSearchNums;
                           dispatch_sync(dispatch_get_main_queue(), ^{
                             [weakSelf.searchAlbumPhotosSingleView  initSearchResultSinlgeViewWithType:resultType_album resultArray:weakSelf.photosArray totalSearchNums:weakSelf.searchAlbumPhotosTotalNums searchTags:weakSelf.searchTags];
                             [weakSelf.mainScrollView  addSubview:weakSelf.searchAlbumPhotosSingleView.view];
                           });
                         }
                         else
                         {
                           weakSelf.photosArray                    = nil;
                           weakSelf.searchAlbumPhotosTotalNums     = 0;
                         }
                        dispatch_sync(dispatch_get_main_queue(), ^{
                                        [weakSelf.activityIndicatorView stopAnimating];
                                        [weakSelf.view  setNeedsLayout];
                                     });

                       }];
                      
                    }];
                 });
  
}

- (void)viewDidLayoutSubviews
{
  [self.mainScrollView  mas_makeConstraints:^(MASConstraintMaker* make){
    make.center.equalTo(self.view);
    make.size.equalTo(self.view);
  }];
  UIView  *lastView  = nil;
  if(self.usersArray)
  {
    [self.searchUserSingleView.view mas_makeConstraints:^(MASConstraintMaker  *make){
      make.top.mas_equalTo(25);
      make.left.equalTo(self.view.mas_left);
      make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 120));
    }];
    lastView  = self.searchUserSingleView.view;
  }
  if(self.photosArray)
  {
    [self.searchAlbumPhotosSingleView.view mas_makeConstraints:^(MASConstraintMaker  *make){
      if(self.usersArray)
        make.top.mas_equalTo(self.searchUserSingleView.view.mas_bottom).offset(25);
      else
        make.top.mas_equalTo(25);
      make.left.equalTo(self.view.mas_left);
      make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 25+10+(self.view.frame.size.width-60)));
    }];
    lastView  = self.searchAlbumPhotosSingleView.view;
  }
  CGFloat scrollViewHeight  = kScreen_Height;
  if(lastView)
  {
    if(lastView.frame.origin.y+lastView.frame.size.height+10>scrollViewHeight)
      scrollViewHeight  = lastView.frame.origin.y+lastView.frame.size.height+10;
  }
  [self.mainScrollView  setContentSize:CGSizeMake(self.view.frame.size.width,scrollViewHeight)];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma init
- (void)initSearchMainResultViewWithUsersArray  :(NSMutableArray*)usersArray  searchTotalNums:(NSInteger)searchTotalNums  searchTags:(NSString*)searchTags
{
  self.usersArray             = usersArray;
  self.searchUsersTotalNums   = searchTotalNums;
  self.searchTags             = searchTags;
}

- (void)initSearchMainResultViewWithAlbumPhotosArray  :(NSMutableArray*)photosArray  searchTotalNums:(NSInteger)searchTotalNums searchTags:(NSString*)searchTags
{
  self.photosArray                  = photosArray;
  self.searchAlbumPhotosTotalNums   = searchTotalNums;
  self.searchTags                   = searchTags;
}

- (void)initSearchMainResultViewWithSearchTags  :(NSString*)searchTags withSearchTagsArray:(NSMutableArray*)searchTagsArray
{
  self.searchTags       = searchTags;
  self.searchTagsArray  = searchTagsArray;
}


#pragma event

#pragma getter setter

- (UIScrollView*)mainScrollView
{
  if(_mainScrollView  ==  nil)
  {
    _mainScrollView = [[UIScrollView alloc]init];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
  }
  return _mainScrollView;
}

- (SearchResultSinlgeView*)searchUserSingleView
{
  if(_searchUserSingleView  ==  nil)
  {
    _searchUserSingleView = [[SearchResultSinlgeView alloc]init];
  }
  return _searchUserSingleView;
}
- (SearchResultSinlgeView*)searchAlbumPhotosSingleView
{
  if(_searchAlbumPhotosSingleView  ==  nil)
  {
    _searchAlbumPhotosSingleView = [[SearchResultSinlgeView alloc]init];
  }
  return _searchAlbumPhotosSingleView;
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

@end
