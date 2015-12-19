//
//  SearchResultDetailView.m
//  DouPaiwo
//
//  Created by J006 on 15/6/23.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchResultDetailView.h"
#import "SearchResultDetailCell.h"
#import <Masonry.h>
#import "AlbumPhotoInstance.h"
#import "PhotosViewController.h"
#import "DouAPIManager.h"
#import "AlbumDetailPage.h"
#import <MJRefresh.h>

#define kPaddingLeftWidth 25.0
#define kColorSearchNumsLabel [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1]
#define kColorNaviBarCustom [UIColor colorWithRed:41/255.0 green:42/255.0 blue:41/255.0 alpha:0.98]
@interface SearchResultDetailView ()

@property (strong,nonatomic)    UITableView                           *userTableView;//用户列表容器
@property (strong,nonatomic)    UIView                                *contentView;
@property (strong,nonatomic)    UIView                                *headerView;//头部信息,可现实搜索到的总数量
@property (strong,nonatomic)    UILabel                               *searchNumsLabel;//搜索到的结果展示Label

@property (strong,nonatomic)    UIScrollView                          *myScrollView;
@property (strong,nonatomic)    NSMutableArray                        *searchUsers;//搜索得到的用户集合
@property (strong,nonatomic)    NSMutableArray                        *searchAlbumPhotos;//搜索得到的照片集合
@property (strong,nonatomic)    NSMutableArray                        *imageAlbumPhotos;

@property (strong,nonatomic)    NSString                              *searchTags;//搜索词汇
@property (strong,nonatomic)    NSMutableArray                        *originalSearchTags;//搜索词汇原数组
@property (readwrite,nonatomic) NSInteger                             searchNums;//搜索到的数量

@property (strong,nonatomic)    MJRefreshAutoNormalFooter             *footerRefresher;//用户搜索刷新
@property (strong,nonatomic)    MJRefreshAutoNormalFooter             *footerAlbumPhotoRefresher;//照片搜索刷新
@property (readwrite,nonatomic) NSInteger                             currentSearchPages;
@property (readwrite,nonatomic) NSString                              *currentTitle;//当前标题
@property (readwrite,nonatomic) SearchType                            currentSearchType;//当前搜索类型

@property (strong, nonatomic)   UISwipeGestureRecognizer              *swipGestureRecognizer;//右划后退

@end

@implementation SearchResultDetailView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view                  setBackgroundColor:kColorBackGround];
  [self.view                  addGestureRecognizer:self.swipGestureRecognizer];
  if(!_currentTitle)
  {
    [self.view                addSubview:self.headerView];
    [self.headerView          addSubview:self.searchNumsLabel];
  }
  
  if(self.currentSearchType ==  UserSearchType)
  {
    self.title  = @"相关用户";
    [self.view                addSubview:self.userTableView];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                    [[DouAPIManager sharedManager] request_SearchUsersWithPageNo  :1 page_size:pageSizeDefault tags:weakSelf.originalSearchTags :^(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error)
                      {
                        if(!usersData)
                          return;
                        weakSelf.searchUsers  = usersData;
                        weakSelf.searchNums   = totalSearchNums;
                        dispatch_sync(dispatch_get_main_queue(), ^{
                          [weakSelf.userTableView reloadData];
                        });
                      }];
                   });
    return;
  }
  else  if(self.currentSearchType ==  AlbumSearchType)
    self.title  = @"相关照片";
  if(_currentTitle)
    self.title  = _currentTitle;
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager sharedManager] request_SearchPhotoWithPageNo  :1 page_size:pageSizeDefault tags:weakSelf.originalSearchTags :^(NSMutableArray *photosData, NSInteger totalSearchNums, NSError *error)
                    {
                      if(!photosData)
                        return;
                      weakSelf.searchAlbumPhotos  = photosData;
                      weakSelf.searchNums         = totalSearchNums;
                      dispatch_sync(dispatch_get_main_queue(), ^{
                        for (AlbumPhotoInstance *albumPhoto in weakSelf.searchAlbumPhotos)
                        {
                          UITapImageView        *photoImage  = [[UITapImageView alloc]init];
                          NSString              *stringURL  =  [defaultImageHeadUrl stringByAppendingString:[albumPhoto.photo_path stringByAppendingString:imageSquareTailUrl]];
                          NSURL *url = [[NSURL  alloc]initWithString:stringURL];
                          float imageWidth  = (kScreen_Width-2*kTotalDefaultPadding-10)/2;
                          UIImage *image  = [[UIImage  alloc]init];
                          image = [image  randomSetPreLoadImageWithSize:CGSizeMake(imageWidth, imageWidth)];
                          [photoImage  setImageWithUrlWaitForLoad:url placeholderImage:image tapBlock:^(id obj){
                            [weakSelf jumpToAlbumDetailActionWithAlbumPhotoID:albumPhoto.photo_id];
                          }];
                          [weakSelf.contentView  addSubview:photoImage];
                          if(!weakSelf.imageAlbumPhotos)
                            weakSelf.imageAlbumPhotos = [[NSMutableArray alloc]init];
                          [weakSelf.imageAlbumPhotos  addObject:photoImage];
                        }
                        [weakSelf.view setNeedsLayout];
                      });
                    }];
                 });
  
  
  [self.view                addSubview:self.myScrollView];
  [self.myScrollView        addSubview:self.contentView];
  /*
   for (AlbumPhotoInstance *albumPhoto in self.searchAlbumPhotos)
   {
   UITapImageView        *photoImage  = [[UITapImageView alloc]init];
   NSString              *stringURL  =  [defaultImageHeadUrl stringByAppendingString:[albumPhoto.photo_path stringByAppendingString:imageSquareTailUrl]];
   NSURL *url = [[NSURL  alloc]initWithString:stringURL];
   __weak typeof(self) weakSelf = self;
   [photoImage  setImageWithUrlWaitForLoad:url placeholderImage:nil tapBlock:^(id obj){
   [weakSelf jumpToAlbumDetailActionWithAlbumPhotoID:albumPhoto.photo_id];
   }];
   [self.contentView  addSubview:photoImage];
   if(!self.imageAlbumPhotos)
   self.imageAlbumPhotos = [[NSMutableArray alloc]init];
   [self.imageAlbumPhotos  addObject:photoImage];
   }
   */
}

- (void)viewDidLayoutSubviews
{
  if(_headerView)
  {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make){
      make.left.equalTo(self.view);
      make.top.equalTo(self.view).offset(64);
      make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width,36));
    }];
    if(self.searchNums)
    {
      NSString  *searchString = @"\"";
      NSString  *searchNumsString  =[NSString stringWithFormat:@" 共%ld个搜索结果",self.searchNums];
      searchString  = [searchString stringByAppendingString:self.searchTags];
      searchString  = [searchString stringByAppendingString:@"\""];
      searchString  = [searchString stringByAppendingString:searchNumsString];
      [_searchNumsLabel  setText:searchString];
    }
    [self.searchNumsLabel mas_makeConstraints:^(MASConstraintMaker *make){
      make.center.equalTo(self.headerView);
      make.size.mas_equalTo(CGSizeMake(200,24));
    }];
  }

  if(self.searchUsers)
  {
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make){
      make.top.equalTo(self.headerView.mas_bottom);
      make.bottom.equalTo(self.view.mas_bottom);
      make.width.mas_equalTo(self.view.frame.size.width);
    }];
  }
  else  if(self.searchAlbumPhotos)
  {
    if(_currentTitle)
    {
      [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.frame.size.width);
      }];
    }
    else
    {
      [self.myScrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.frame.size.width);
      }];
    }

    float imageWidth  = (kScreen_Width-2*kTotalDefaultPadding-10)/2;
    UIView  *viewEven,*viewOdd;//奇偶view
    for (NSInteger i = 0;i<[self.imageAlbumPhotos count];i++)
    {
      UITapImageView      *imageView  = [self.imageAlbumPhotos  objectAtIndex:i];
      if(i%2==0)
      {
        if(viewEven)
        {
          [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(viewEven.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(kTotalDefaultPadding);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageWidth));
          }];
        }
        else
        {
          [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.contentView.mas_top).offset(30);
            make.left.equalTo(self.contentView).offset(kTotalDefaultPadding);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageWidth));
          }];
        }
        viewEven  = imageView;
      }
      else
      {
        if(viewOdd)
        {
          [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(viewOdd.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-kTotalDefaultPadding);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageWidth));
          }];
        }
        else
        {
          [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.contentView.mas_top).offset(30);
            make.right.equalTo(self.contentView).offset(-kTotalDefaultPadding);
            make.size.mas_equalTo(CGSizeMake(imageWidth,imageWidth));
          }];
        }
        viewOdd  = imageView;
      }
    }
    NSInteger index = [self.imageAlbumPhotos count]/2+[self.imageAlbumPhotos count]%2;
    float heightContent = index*imageWidth+(index-1)*10+30+10;
    if(heightContent<kScreen_Height)
      heightContent = kScreen_Height;
    [self.contentView  setFrame:CGRectMake(0, 0, kScreen_Width, heightContent)];
    [self.myScrollView setContentSize:CGSizeMake(kScreen_Width, heightContent)];
  }
}

-(void) viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
  {
    //[[SearchResultDetailView  getNavi]setNavigationBarHidden:YES];
  }
  [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init
- (void)initSearchResultDetailViewWithSearchUsers:(NSMutableArray*)searchUsers searchUsersNums:(NSInteger)searchUsersNums searchTags:(NSString*)searchTags  withOriginalSearchTags:(NSMutableArray*)originalSearchTags;
{
  self.searchUsers          = searchUsers;
  self.searchNums           = searchUsersNums;
  self.searchTags           = searchTags;
  self.originalSearchTags   = originalSearchTags;
  self.currentSearchPages   = 1;
}

- (void)initSearchResultDetailViewWithSearchAlbumPhotos:(NSMutableArray*)searchAlbumPhotos searchAlbumNums:(NSInteger)searchAlbumNums searchTags:(NSString*)searchTags  withOriginalSearchTags:(NSMutableArray*)originalSearchTags;
{
  self.searchAlbumPhotos    = searchAlbumPhotos;
  self.searchNums           = searchAlbumNums;
  self.searchTags           = searchTags;
  self.originalSearchTags   = originalSearchTags;
  self.currentSearchPages   = 1;
}

- (void)initSearchResultDetailViewWithOriginalSearchTags:(NSMutableArray*)originalSearchTags searchTags:(NSString*)searchTags searchType:(SearchType)searchType;
{
  self.originalSearchTags   = originalSearchTags;
  self.searchTags           = searchTags;
  self.currentSearchType    = searchType;
  self.currentSearchPages   = 1;
}

- (void)initTheProjectTitle  :(NSString*)title
{
  self.currentTitle         = title;
}

#pragma Tablview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = 0;
  if(section  ==  0 &&  self.searchUsers)
    row = [self.searchUsers count];
  return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section==0 && self.searchUsers)
  {
    SearchResultDetailCell *cell = [[SearchResultDetailCell  alloc]init];
    UserInstance  *user = [self.searchUsers objectAtIndex:indexPath.row];
    [cell initSearchResultDetailCellWithUserInstance:user:[SearchResultDetailView getNavi]];
    [cell setHeight:70];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  float height=60;
  if (indexPath.section==0)
    height  = 60;
  return  height;
}

#pragma EVENT
/**
 *  @author J006, 15-07-10 17:07:00
 *
 *  跳转到照片详细界面而非影集
 *
 *  @param albumPhotoID
 */
- (void)jumpToAlbumDetailActionWithAlbumPhotoID :(NSInteger)albumPhotoID
{
  PhotosViewController  *photosVC = [[PhotosViewController alloc]init];
  [photosVC initPhotoViewControllerWithPhotoID:albumPhotoID];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [photosVC   addBackBlock:^(id objc){
    [[PhotosViewController  getNavi]setNavigationBarHidden:NO animated:NO];
    [[PhotosViewController  getNavi]popViewControllerAnimated:YES];
    if(self.currentTitle)
      [PhotosViewController  setRDVTabHidden:NO  isAnimated:NO];
  }];
  [SearchResultDetailView   setRDVTabHidden:YES  isAnimated:NO];
  [[SearchResultDetailView  getNavi]setNavigationBarHidden:YES];
  [SearchResultDetailView   naviPushViewController:photosVC];
}

- (void)backToSearchResultDetailView  :(id)sender
{
  [[SearchResultDetailView getNavi]popViewControllerAnimated:YES];
}

#pragma getter setter
- (UITableView*)userTableView
{
  if(_userTableView ==  nil)
  {
    _userTableView  = [[UITableView  alloc]init];
    _userTableView.backgroundColor = kColorBackGround;
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    [_userTableView.tableHeaderView  setBackgroundColor:[UIColor  colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _userTableView.footer = self.footerRefresher;
  }
  return _userTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc]init];
    [_headerView setBackgroundColor:kColorSearchNumsLabel];
  }
  return _headerView;
}

- (UILabel*)searchNumsLabel
{
  if(_searchNumsLabel == nil)
  {
    _searchNumsLabel = [[UILabel  alloc]init];
    [_searchNumsLabel   setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_searchNumsLabel   setFont:SourceHanSansLight12];
    [_searchNumsLabel   setTextAlignment:NSTextAlignmentCenter];
  }
  return _searchNumsLabel;
}

- (UIScrollView*)myScrollView
{
  if(_myScrollView  ==  nil)
  {
    _myScrollView = [[UIScrollView alloc]init];
    [_myScrollView  setBackgroundColor:[UIColor whiteColor]];
    _myScrollView.footer  = self.footerAlbumPhotoRefresher;
  }
  return _myScrollView;
}

- (UIView*)contentView
{
  if(_contentView ==  nil)
  {
    _contentView  = [[UIView alloc]init];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
  }
  return _contentView;
}

- (MJRefreshAutoNormalFooter*)footerRefresher
{
  if(_footerRefresher ==  nil)
  {
    _footerRefresher  = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
      [[DouAPIManager  sharedManager]request_SearchUsersWithPageNo:self.currentSearchPages+1 page_size:pageSizeDefault tags:self.originalSearchTags :^(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error)
       {
         [_footerRefresher endRefreshing];
         if(usersData)
         {
           [self.searchUsers    addObjectsFromArray:usersData];
           [self.userTableView  reloadData];
           self.currentSearchPages  +=  1;
         }
         else
           [_footerRefresher  setState:MJRefreshStateNoMoreData];
       }];
    }];
    [_footerRefresher setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footerRefresher setTitle:@"" forState:MJRefreshStateIdle];
    _footerRefresher.refreshingTitleHidden = YES;
  }
  return _footerRefresher;
}

- (MJRefreshAutoNormalFooter*)footerAlbumPhotoRefresher
{
  if(_footerAlbumPhotoRefresher ==  nil)
  {
    __weak typeof(self) weakSelf = self;
    _footerAlbumPhotoRefresher  = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
      [[DouAPIManager  sharedManager]request_SearchPhotoWithPageNo:weakSelf.currentSearchPages+1 page_size:pageSizeDefault tags:weakSelf.originalSearchTags :^(NSMutableArray *photoData, NSInteger totalSearchNums, NSError *error)
       {
         [_footerAlbumPhotoRefresher endRefreshing];
         if(photoData)
         {
           for (AlbumPhotoInstance *albumPhoto in photoData)
           {
             UITapImageView        *photoImage  = [[UITapImageView alloc]init];
             NSString              *stringURL  =  [defaultImageHeadUrl stringByAppendingString:[albumPhoto.photo_path stringByAppendingString:imageSquareTailUrl]];
             NSURL *url = [[NSURL  alloc]initWithString:stringURL];
             float imageWidth  = (kScreen_Width-2*kTotalDefaultPadding-10)/2;
             UIImage *image  = [[UIImage  alloc]init];
             image = [image  randomSetPreLoadImageWithSize:CGSizeMake(imageWidth, imageWidth)];
             [photoImage  setImageWithUrlWaitForLoad:url placeholderImage:image tapBlock:^(id obj){
               [weakSelf jumpToAlbumDetailActionWithAlbumPhotoID:albumPhoto.photo_id];
             }];
             [self.contentView  addSubview:photoImage];
             if(!weakSelf.imageAlbumPhotos)
               weakSelf.imageAlbumPhotos = [[NSMutableArray alloc]init];
             [weakSelf.imageAlbumPhotos  addObject:photoImage];
           }
           [self.view  setNeedsLayout];
           self.currentSearchPages  +=  1;
         }
         else
           [_footerAlbumPhotoRefresher  setState:MJRefreshStateNoMoreData];
       }];
    }];
    [_footerAlbumPhotoRefresher setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footerAlbumPhotoRefresher setTitle:@"" forState:MJRefreshStateIdle];
    _footerAlbumPhotoRefresher.refreshingTitleHidden = YES;
  }
  return _footerAlbumPhotoRefresher;
}

- (UISwipeGestureRecognizer*)swipGestureRecognizer
{
  if(_swipGestureRecognizer ==  nil)
  {
    _swipGestureRecognizer  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToSearchResultDetailView:)];
    [_swipGestureRecognizer   setDirection:UISwipeGestureRecognizerDirectionRight];
  }
  return _swipGestureRecognizer;
}
@end
