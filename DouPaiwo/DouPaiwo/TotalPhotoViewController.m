//
//  TotalPhotoViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/24.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import "TotalPhotoViewController.h"
#import "PhotosViewController.h"
#import "AlbumPhotoInstance.h"
#import <Masonry.h>
#import "ShareTotalViewController.h"
#import "DouAPIManager.h"

@interface TotalPhotoViewController ()<PhotosViewControllerDelegate>

@property (strong, nonatomic) UIScrollView              *mainScrollView;//专辑所有图容器列表
@property (nonatomic, strong) UIPageControl             *pageControl;
@property (strong, nonatomic) NSMutableArray            *singlePhotosViewsArray;//PhotoView集合
@property (strong, nonatomic) AlbumInstance             *albumInstance;
@property (readwrite, nonatomic) NSInteger              photo_id;
@property (readwrite, nonatomic) NSInteger              selectID;//当前选中的图片序号

@property (nonatomic,strong)  UIButton                  *backButton;  //后退按钮
@property (nonatomic,strong)  UIButton                  *shareButton;//分享按钮
@property (strong, nonatomic) ShareTotalViewController  *shareVC;
@property (strong, nonatomic) AlbumPhotoInstance        *albumPhoto;

@property (nonatomic, copy)   void(^backAction)(id);

@end

@implementation TotalPhotoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.mainScrollView];
  [self.view  addSubview:self.pageControl];
  [self.view  addSubview:self.backButton];
  if(!self.albumInstance)
  {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                     [[DouAPIManager  sharedManager] request_GetAlbumPhotoWithPhotoID :weakSelf.photo_id :^(AlbumPhotoInstance *albumPhotoInstance, NSError *error)
                      {
                        if(!albumPhotoInstance)
                          return;
                        [[DouAPIManager  sharedManager] request_GetAlbumWithAlbumID:albumPhotoInstance.album_id :^(AlbumInstance *data, NSError *error) {
                          if(!data)
                            return;
                          dispatch_sync(dispatch_get_main_queue(), ^{
                            self.albumInstance  = data;
                            [weakSelf initTheConentView];
                            //[weakSelf.view  setNeedsLayout];
                          });
                        }];
                      }];
                   });
  }
  else
  {
    [self  initTheConentView];
  }
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  [self.backButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.view).offset(10);
    make.top.equalTo(self.view).offset(10);
    make.size.mas_equalTo(CGSizeMake(40,40));
  }];
  [self.mainScrollView setFrame:self.view.bounds];
  if(!self.albumInstance)
    return;
  float scrollViewContentWidth  = 0;
  for (NSInteger i =0; i<[self.singlePhotosViewsArray count]; i++)
  {
    PhotosViewController  *photoVC  = [self.singlePhotosViewsArray objectAtIndex:i];
    [photoVC.view  setFrame:CGRectMake(i*kScreen_Width, 0, kScreen_Width, kScreen_Height)];
    scrollViewContentWidth  +=  kScreen_Width;
  }
  [self.pageControl  setFrame:CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height-30, 30, 30)];
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.right.equalTo(self.view).offset(-10);
    make.top.equalTo(self.view).offset(10);
    make.size.mas_equalTo(CGSizeMake(40,40));
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [[TotalPhotoViewController getNavi] setNavigationBarHidden:YES];
  [[TotalPhotoViewController getNavi].interactivePopGestureRecognizer setDelegate:nil];//由于setNavigationBarHidden后,自带的手势将会被删除,该代码还原了之前的代码
  [TotalPhotoViewController setRDVTabStatusHidden:YES];
}

#pragma init
- (void)initTotalPhotoViewControllerWithAlbum  :(AlbumInstance*)album selectPhotoID:(NSInteger)photo_id;
{
  self.albumInstance  = album;
  self.photo_id       = photo_id;
}

- (void)initTheConentView
{
  [self.mainScrollView  setContentSize:CGSizeMake(kScreen_Width*([self.albumInstance photo_count]+2), self.view.frame.size.height)];
  for (NSInteger i =0; i<[self.albumInstance photo_count]; i++)
  {
    AlbumPhotoInstance  *albumPhoto = [[self.albumInstance photo_list] objectAtIndex:i];
    if(albumPhoto.photo_id == self.photo_id)
    {
      self.pageControl.currentPage  = i+1;
      [self.mainScrollView scrollRectToVisible:CGRectMake(kScreen_Width * (i+1),0,kScreen_Width,kScreen_Height) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第最后页
      [self.mainScrollView setContentOffset:CGPointMake(kScreen_Width * (i+1), 0)];
    }
    
    if(i==0)
    {
      AlbumPhotoInstance  *albumPhotoLast = [[self.albumInstance photo_list] objectAtIndex:[self.albumInstance photo_count]-1];
      PhotosViewController  *photoVC  = [[PhotosViewController alloc]init];
      photoVC.delegate   =  self;
      [photoVC initPhotoViewControllerWithPhotoID:albumPhotoLast.photo_id];
      [photoVC addBackBlock:self.backAction];
      [self.mainScrollView addSubview:photoVC.view];
      [self.singlePhotosViewsArray addObject:photoVC];
    }
    
    PhotosViewController  *photoVC  = [[PhotosViewController alloc]init];
    photoVC.delegate   =  self;
    [photoVC initPhotoViewControllerWithPhotoID:albumPhoto.photo_id];
    [photoVC addBackBlock:self.backAction];
    [self.mainScrollView addSubview:photoVC.view];
    [self.singlePhotosViewsArray addObject:photoVC];
    
    if(i==self.albumInstance.photo_count-1)
    {
      AlbumPhotoInstance  *albumPhotoFirst = [[self.albumInstance photo_list] objectAtIndex:0];
      photoVC.delegate   =  self;
      PhotosViewController  *photoVC  = [[PhotosViewController alloc]init];
      [photoVC initPhotoViewControllerWithPhotoID:albumPhotoFirst.photo_id];
      [photoVC addBackBlock:self.backAction];
      [self.mainScrollView addSubview:photoVC.view];
      [self.singlePhotosViewsArray addObject:photoVC];
    }
  }
  
  [self.view  addSubview:self.shareButton];
}

#pragma UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat pagewidth = self.mainScrollView.frame.size.width;
  NSInteger page = floor((self.mainScrollView.contentOffset.x - pagewidth/(self.albumInstance.photo_count+2))/pagewidth)+1;
  page --;  // 默认从第二页开始 [4] 1,2,3,4 [1]
  self.pageControl.currentPage = page;
  if(page<0)
    page = 0;
  else  if(page>[self.albumInstance photo_count]-1)
    page = [self.albumInstance photo_count]-1;
    
  AlbumPhotoInstance  *albumPhoto = [[self.albumInstance photo_list] objectAtIndex:page];
  self.photo_id = albumPhoto.photo_id;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat pagewidth = scrollView.frame.size.width;
  int currentPage = floor((scrollView.contentOffset.x - pagewidth/ (self.albumInstance.photo_count+2)) / pagewidth) + 1;
  if (currentPage==0)
  {
    [scrollView scrollRectToVisible:CGRectMake(kScreen_Width * self.albumInstance.photo_count,0,kScreen_Width,kScreen_Height) animated:NO]; // 序号0 最后1页
  }
  else if (currentPage==(self.albumInstance.photo_count+1))
  {
    [scrollView scrollRectToVisible:CGRectMake(kScreen_Width,0,kScreen_Width,kScreen_Height) animated:NO]; // 最后+1,循环第1页
  }

}

- (void)changePage:(id)sender
{
  NSInteger page = self.pageControl.currentPage;
  CGRect frame = self.mainScrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [self.mainScrollView scrollRectToVisible:frame animated:YES];
}

#pragma PhotosViewControllerDelegate

- (void)setTheShareButtonAndBackToAnimationMoveWithAlpha:(CGFloat)alpha albumPhoto:(AlbumPhotoInstance *)albumPhoto
{
  [UIView animateWithDuration:0.7
                        delay:0.0
                      options:UIViewAnimationOptionTransitionFlipFromBottom
                   animations:^{
                     [self.shareButton  setAlpha:alpha];
                     [self.backButton   setAlpha:alpha];
                   }completion:^(BOOL finished){
                   }];
  self.albumPhoto  = albumPhoto;
}

- (void)setTheCurrenPhoto:(AlbumPhotoInstance *)albumPhoto
{
  if(self.photo_id == albumPhoto.photo_id)
  {
    self.albumPhoto = albumPhoto;
  }
}

#pragma private method
- (void)addBackBlock:(void(^)(id obj))backAction
{
  self.backAction = backAction;
}

#pragma event

- (void)backToLastViewAction
{
  if(self.backAction)
    self.backAction(self);
  else
    [[TotalPhotoViewController  getNavi] popViewControllerAnimated:YES];
}

- (void)shareTheCurrentPhotoAction
{
  self.shareVC  = [[ShareTotalViewController alloc]init];
  UIImage *image  = [[UIImage  alloc]init];
  PhotosViewController  *photoVC  = [self.singlePhotosViewsArray objectAtIndex:self.pageControl.currentPage+1];
  image = [image  takeSnapshotOfView:photoVC.view];
  [self.shareVC  initSharePhotoAndAlbumWithSnapshot:image albumPhoto:self.albumPhoto album:self.albumInstance shareContentType:ShareContentTypePhotoAndAlbum];
  [self.shareVC .view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [TotalPhotoViewController naviPushViewControllerWithNoAniation:self.shareVC];
}

#pragma mark - getters and setters
- (UIScrollView*) mainScrollView
{
  if (_mainScrollView == nil)
  {
    _mainScrollView = [[UIScrollView alloc] init];
    [_mainScrollView setFrame:self.view.bounds];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = kColorBackGround;
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
  }
  return _mainScrollView;
}

- (NSMutableArray*)singlePhotosViewsArray
{
  if(_singlePhotosViewsArray  ==  nil)
  {
    _singlePhotosViewsArray = [[NSMutableArray alloc]init];
  }
  return _singlePhotosViewsArray;
}

- (UIPageControl*)  pageControl
{
  if(_pageControl ==  nil)
  {
    _pageControl  = [[UIPageControl alloc]init];
    [_pageControl  setNumberOfPages:[self.albumInstance photo_count]];
    [_pageControl  setCurrentPage:0];
    [_pageControl  addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
  }
  return _pageControl;
}

- (UIButton*)backButton
{
  if(_backButton  ==  nil)
  {
    _backButton  = [[UIButton alloc]init];
    [_backButton setImage:[UIImage imageNamed:@"backCircleButton"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backToLastViewAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _backButton;
}

- (UIButton*)shareButton
{
  if(_shareButton  ==  nil)
  {
    _shareButton  = [[UIButton alloc]init];
    [_shareButton setImage:[UIImage imageNamed:@"shareButtonCircleButton"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareTheCurrentPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [_shareButton setAdjustsImageWhenHighlighted:NO];
  }
  return _shareButton;
}

@end
