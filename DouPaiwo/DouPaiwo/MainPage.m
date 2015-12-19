//
//  MainPage.m
//  TestPaiwo
//
//  Created by J006 on 15/4/22.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "MainPage.h"
#import "NSDate+Helper.h"
#import "RootTabViewController.h"
#import "MiddleButtonInstance.h"
#import "DouAPIManager.h"
#import "CustomDrawLineLabel.h"
#import "MiddleBanner.h"
#import "MainBanner.h"
#import "DynamicContentInstance.h"
#import "DynamicContentPhotoInstance.h"
#import <Masonry.h>
#import <MJRefresh.h>
#import "MJDIYHeader.h"
#import "ODRefreshControl.h"

@interface MainPage()

@property (strong,  nonatomic)  MainBanner                    *mainBannerView;//顶端主要Banner界面
@property (strong,  nonatomic)  MiddleBanner                  *middleBannerView;//中间banner
@property (strong,  nonatomic)  UIScrollView                  *mainScrollView;//中间主要展示的scrollview
@property (strong,  nonatomic)  PocketAndPhotoView            *ppView;//pocket与专辑页面的合集,首张PP页面
@property (strong,  nonatomic)  MJRefreshAutoNormalFooter     *footerView;//滚动条底部栏,专门显示是否还有更新的消息
//@property (strong,  nonatomic)  MJRefreshNormalHeader         *headerView;//刷新头部
@property (strong,  nonatomic)  UILabel                       *noMoreLabel;//没有更多的动态
@property (strong,  nonatomic)  UIActivityIndicatorView       *activeIndicatorView;//刷新

@property (strong,  nonatomic)  PocketItemInstance            *pockItem;
@property (nonatomic,strong)    NSMutableArray                *dynamicList;//主页feed集合
@property (nonatomic,strong)    NSMutableArray                *bannerList;//主页Banner集合
@property (strong,  nonatomic)  NSMutableArray                *ppArray;

@property (nonatomic,readwrite) NSInteger                     tempInt;
@property (nonatomic,readwrite) CGFloat                       lastPPViewYpoint;
@property (nonatomic,readwrite) NSInteger                     currentPageNo;//当前信息page index
@property (nonatomic,readwrite) CGFloat                       theSizeHeight;
@property (nonatomic,readwrite) double                        lastFeedTime;
@property (nonatomic,strong)    UIView                        *statusBarBG;
@property (nonatomic,readwrite) BOOL                          isStatusBarHidden;
@property (nonatomic,readwrite) UIStatusBarStyle              currenStatusBarStyle;
@property (strong,  nonatomic)  ODRefreshControl              *refreshControl;

@end

@implementation MainPage
@synthesize isRefresh;

- (void)viewDidLoad
{
  self.currenStatusBarStyle = UIStatusBarStyleLightContent;
  self.view.backgroundColor = kColorBackGround;
  [self.view  addSubview:self.mainScrollView];
  self.automaticallyAdjustsScrollViewInsets = NO;
  [self.view  addSubview:self.statusBarBG];
  [self.mainScrollView addSubview:self.refreshControl];
  self.theSizeHeight  = kMainBanner_Height;
  [self requestBannerList];
  [self.mainBannerView  initMainBannerWithSingleBanner:self.bannerList];
  //[self.mainScrollView addSubview:self.headerView];
  [self.mainScrollView addSubview:self.mainBannerView.view];
  [self requestTheDynamicContentList];
  [self.ppView initPocketAndPhotoViewWithDynamicContentInstance:self.dynamicList];
  [self.mainScrollView addSubview:self.ppView.view];
  [self.mainScrollView addSubview:self.footerView];

}

- (void)viewDidLayoutSubviews
{
  [self.mainScrollView  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-pageToolBarHeight)];
  [self.mainBannerView.view setBackgroundColor:kColorBackGround];

  [self.mainBannerView.view setFrame:CGRectMake(0, 0,kScreen_Width,self.theSizeHeight)];
  self.refreshControl.bounds = CGRectMake(self.refreshControl.bounds.origin.x,
                                     -kMainBanner_Height,
                                     self.refreshControl.bounds.size.width,
                                     self.refreshControl.bounds.size.height);
  [self.ppView.view setY:self.mainBannerView.view.frame.size.height];
}

- (void)viewWillAppear:(BOOL)animated
{
  [MainPage setRDVTabStatusStyleDirect:self.currenStatusBarStyle];
}

- (void)viewDidAppear:(BOOL)animated
{
}

#pragma init
/**
*  主要初始化界面
*/
- (void)  initMainPage
{
}


- (void)refreshThePPView:(UIRefreshControl *)refreshControl
{
  [self.ppView.view  removeFromSuperview];
  self.ppView  = nil;
  self.dynamicList  = nil;
  [self requestTheDynamicContentList];
  [self.ppView initPocketAndPhotoViewWithDynamicContentInstance:self.dynamicList];
  [self.mainScrollView addSubview:self.ppView.view];
  [self.ppView.view setY:self.mainBannerView.view.frame.size.height];
}

#pragma mark TabBar
- (void)tabBarItemClicked
{
  if (_mainScrollView.contentOffset.y > 0)
  {
    [_mainScrollView setContentOffset:CGPointZero animated:YES];
  }
}


#pragma private method
/**
 *  @author J006, 15-06-29 11:06:27
 *
 *  请求获取第一页的动态
 */
- (void)  requestTheDynamicContentList
{
  __weak typeof(self) weakSelf = self;
  [[DouAPIManager  sharedManager]request_GetFeedWithTimeStamp:0 time_flag:1 :^(NSMutableArray *data, double lastFeedTime,NSError *error)
   {
     if(!data)
       return;
     weakSelf.dynamicList   = data;
     weakSelf.lastFeedTime  = lastFeedTime;
   }];
}

- (void)  dropViewDidBeginRefreshing:(ODRefreshControl*)refreshControl
{
  refreshControl.bounds = CGRectMake(refreshControl.bounds.origin.x,
                                     -kMainBanner_Height ,
                                     refreshControl.bounds.size.width,
                                     refreshControl.bounds.size.height);
  [refreshControl  beginRefreshing];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager] request_GetFeedWithTimeStamp:0 time_flag:1 :^(NSMutableArray *data, double lastFeedTime,NSError *error)
                    {
                      if(!data)
                      {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                          [refreshControl endRefreshing];
                        });
                        return;
                      }
                      dispatch_sync(dispatch_get_main_queue(), ^{
                        [refreshControl endRefreshing];
                        [self.ppView.view  removeFromSuperview];
                        self.ppView  = nil;
                        self.dynamicList  = nil;
                        self.dynamicList  = data;
                        self.lastFeedTime  = lastFeedTime;
                        [self.ppView initPocketAndPhotoViewWithDynamicContentInstance:self.dynamicList];
                        [self.mainScrollView addSubview:self.ppView.view];
                      });
                    }];
  });
}

/**
 *  @author J006
 *
 *  请求获取主页banner
 */
- (void)  requestBannerList
{
  __weak typeof(self) weakSelf = self;
  [[DouAPIManager  sharedManager]request_GetRecommendPocket:^(NSMutableArray *array, ErrorInstnace *error) {
    if(!array)
      return;
      weakSelf.bannerList = array;
  }];
}

#pragma UIScollView Delegate
- (void)  scrollViewDidScroll:(UIScrollView *)scrollView
{
  
  if([scrollView  isEqual:self.mainScrollView])
  {//固定mainBanner
    CGRect  frame = self.mainBannerView.view.frame;
    frame.origin.y  = scrollView.contentOffset.y;
    self.mainBannerView.view.frame = frame;
    if(scrollView.contentOffset.y>frame.size.height-ppViewTopDisctance)
    {
      if(self.statusBarBG.alpha ==  0)
      {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                           [MainPage setRDVTabStatusStyle:UIStatusBarStyleDefault preStyle:UIStatusBarStyleLightContent];
                           self.currenStatusBarStyle  = UIStatusBarStyleDefault;
                           [self.statusBarBG  setBackgroundColor:[UIColor  whiteColor]];
                           [self.statusBarBG  setAlpha:1.0];
                         }completion:^(BOOL finished){
                           
                         }];
      }
    }
    else
    {
      if(self.statusBarBG.alpha ==  1)
      {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionTransitionFlipFromBottom
                         animations:^{
                           [MainPage setRDVTabStatusStyle:UIStatusBarStyleLightContent preStyle:UIStatusBarStyleLightContent];
                           self.currenStatusBarStyle  = UIStatusBarStyleLightContent;
                           [self.statusBarBG  setBackgroundColor:[UIColor  clearColor]];
                           [self.statusBarBG  setAlpha:0.0];
                         }completion:^(BOOL finished){
                         }];
      }
    }
  }
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  if([scrollView  isEqual:self.mainScrollView])
  {
    [scrollView  setShowsVerticalScrollIndicator:YES];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}


#pragma PocketAndPhotoViewDelegate

- (void)finishInitTheView:(PocketAndPhotoView *)ppView ppHeight:(CGFloat)ppHeight
{
  [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(ppView.view.mas_bottom);
    make.width.mas_equalTo(kScreen_Width);
    make.height.mas_equalTo(30);
  }];
  [self.mainScrollView setContentSize:CGSizeMake(kScreen_Width, ppHeight+self.mainBannerView.view.frame.size.height+3*kTotalDefaultYPadding)];
}

- (void)finishUpdateTheView:(PocketAndPhotoView *)ppView ppHeight:(CGFloat)ppHeight
{
  [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(ppView.view.mas_bottom);
    make.width.mas_equalTo(kScreen_Width);
    make.height.mas_equalTo(30);
  }];
  [self.mainScrollView setContentSize:CGSizeMake(kScreen_Width, ppHeight+self.mainBannerView.view.frame.size.height+3*kTotalDefaultYPadding)];
}

#pragma getter setter
- (MainBanner*) mainBannerView
{
  if(_mainBannerView  ==  nil)
  {
    _mainBannerView = [[MainBanner alloc]init];
  }
  return _mainBannerView;
}

- (MiddleBanner*) middleBannerView
{
  if(_middleBannerView  ==  nil)
  {
    _middleBannerView = [[MiddleBanner alloc]init];
  }
  return _middleBannerView;
}

- (UIScrollView*) mainScrollView
{
  if(_mainScrollView  ==  nil)
  {
    _mainScrollView = [[UIScrollView alloc]init];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    _mainScrollView.delegate  = self;

  }
  return _mainScrollView;
}

- (PocketAndPhotoView*)  ppView
{
  if(_ppView  ==  nil)
  {
    _ppView = [[PocketAndPhotoView alloc]init];
    _ppView.delegate  = self;
  }
  return _ppView;
}

- (MJRefreshAutoNormalFooter*) footerView
{
  if(_footerView  ==  nil)
  {
      __weak typeof(self) weakSelf = self;
    _footerView = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
      [[DouAPIManager  sharedManager] request_GetFeedWithTimeStamp:self.lastFeedTime time_flag:1 :^(NSMutableArray *data, double lastFeedTime,NSError *error)
       {
         [_footerView  endRefreshing];
         if(!data)
         {
           [_footerView  setState:MJRefreshStateNoMoreData];
           return;
         }
         weakSelf.lastFeedTime  = lastFeedTime;
         [weakSelf.ppView updatePocketAndPhotoViewWithDynamicContentInstance:data];
         [weakSelf.ppView.view setNeedsLayout];
       }];
    }];
    [_footerView setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footerView setTitle:@"" forState:MJRefreshStateIdle];
    _footerView.refreshingTitleHidden = YES;
  }
  return _footerView;
}

/*
- (MJRefreshNormalHeader*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
      [[DouAPIManager  sharedManager] request_GetFeedWithTimeStamp:0 time_flag:1 :^(NSMutableArray *data, double lastFeedTime,NSError *error)
       {
         [_headerView endRefreshing];
         if(!data)
           return;
         [self.ppView.view  removeFromSuperview];
         self.ppView  = nil;
         self.dynamicList  = nil;
         self.dynamicList  = data;
         self.lastFeedTime  = lastFeedTime;
         [self.ppView initPocketAndPhotoViewWithDynamicContentInstance:self.dynamicList];
         [self.mainScrollView addSubview:self.ppView.view];
       }];
    }];
    [_headerView setTitle:@"" forState:MJRefreshStateIdle];
    [_headerView setTitle:@"" forState:MJRefreshStateNoMoreData];
  }
  
  return _headerView;
}
 */

- (ODRefreshControl*)refreshControl
{
  if(_refreshControl  ==  nil)
  {
    _refreshControl = [[ODRefreshControl alloc]initInScrollView:self.mainScrollView];
    [_refreshControl setTintColor:[UIColor darkGrayColor]];
    [_refreshControl setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
  }
  return _refreshControl;
}

- (UILabel*)noMoreLabel
{
  if(_noMoreLabel ==  nil)
  {
    _noMoreLabel  = [[UILabel  alloc]init];
    [_noMoreLabel  setText:@""];
    [_noMoreLabel  setTextAlignment:NSTextAlignmentCenter];
    [_noMoreLabel  setFont:[UIFont systemFontOfSize:kMainPageMiddleFontSize]];
    [_noMoreLabel  setTextColor:[UIColor  lightGrayColor]];
  }
  return _noMoreLabel;
}


- (UIActivityIndicatorView*)activeIndicatorView
{
  if(_activeIndicatorView ==  nil)
  {
    _activeIndicatorView  = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  }
  return _activeIndicatorView;
}

- (UIView*)statusBarBG
{
  if(_statusBarBG ==  nil)
  {
    _statusBarBG  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    [_statusBarBG   setBackgroundColor:[UIColor clearColor]];
    [_statusBarBG   setAlpha:0.0];
  }
  return _statusBarBG;
}

@end
