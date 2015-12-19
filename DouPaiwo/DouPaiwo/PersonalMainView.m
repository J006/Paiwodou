//
//  PersonalMainView.m
//  DouPaiwo
//
//  Created by J006 on 15/6/25.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "PersonalMainView.h"
#import "PocketAndPhotoView.h"
#import "UserInstance.h"
#import <Masonry.h>
#import "DouAPIManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <MJRefresh.h>

@interface PersonalMainView ()<PocketAndPhotoViewDelegate>

@property (strong, nonatomic) UIScrollView                  *mainScrollView;//中间主要展示的scrollview
@property (strong, nonatomic) PocketAndPhotoView            *ppView;//pocket与专辑页面的合集

@property (strong, nonatomic) UserInstance                  *currentUser;
@property (nonatomic,strong)  NSMutableArray                *dynamicList;

@property (nonatomic,strong)  MJRefreshAutoNormalFooter     *refreshFooter;
@property (nonatomic,readwrite) NSInteger                   currentPageNo;//当前信息page index
@property (strong, nonatomic) UIActivityIndicatorView       *activityIndicatorView;

@end

@implementation PersonalMainView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  setBackgroundColor:kColorBackGround];
  [self.view  addSubview:self.mainScrollView];
  [self.view addSubview:self.activityIndicatorView];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager]request_GetDynamicContentWithDomain  :weakSelf.currentUser.host_domain page_no:1 page_size:pageSizeDefault :^(NSMutableArray *data, NSError *error)
                    {
                      if(!data)
                      {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                           [weakSelf.activityIndicatorView stopAnimating];
                            return;
                        });
                      }
                      weakSelf.dynamicList = data;
                      dispatch_sync(dispatch_get_main_queue(), ^{
                          [weakSelf.activityIndicatorView stopAnimating];
                          [weakSelf.ppView initPocketAndPhotoViewWithDynamicContentInstance:weakSelf.dynamicList];
                          [weakSelf.mainScrollView  addSubview:weakSelf.ppView.view];
                      });
                    }];
                 });
}


- (void)viewDidLayoutSubviews
{
  [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view);
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
  if(self.dynamicList)
    [self.ppView.view setOrigin:CGPointMake(0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init
- (void)initPersonalMainViewWithUser  :(UserInstance*)currUser
{
  self.currentUser  = currUser;
  self.currentPageNo  = 1;
}
#pragma PocketAndPhotoViewDelegate

- (void)finishInitTheView:(PocketAndPhotoView *)ppView ppHeight:(CGFloat)ppHeight
{
  /*
  [self.refreshFooter mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(ppView.view.mas_bottom);
    make.width.mas_equalTo(kScreen_Width);
    make.height.mas_equalTo(50);
  }];
   */
  [self.mainScrollView setContentSize:CGSizeMake(kScreen_Width, ppHeight+50)];
}

#pragma self function

#pragma getter setter

- (UIScrollView*)mainScrollView
{
  if(_mainScrollView  ==  nil)
  {
    _mainScrollView = [[UIScrollView alloc]init];
    [_mainScrollView  setBackgroundColor:kColorBackGround];
    _mainScrollView.footer  = self.refreshFooter;
  }
  return _mainScrollView;
}

-(PocketAndPhotoView*)  ppView
{
  if(_ppView  ==  nil)
  {
    _ppView = [[PocketAndPhotoView alloc]init];
    _ppView.delegate  = self;
  }
  return _ppView;
}

- (MJRefreshAutoNormalFooter*)refreshFooter
{
  if(_refreshFooter ==  nil)
  {
    _refreshFooter  = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
      [[DouAPIManager  sharedManager] request_GetDynamicContentWithDomain:self.currentUser.host_domain page_no:self.currentPageNo+1 page_size:pageSizeDefault :^(NSMutableArray *data, NSError *error)
       {
         [_refreshFooter  endRefreshing];
         if(!data)
         {
           [_refreshFooter  setState:MJRefreshStateNoMoreData];
           return;
         }
         [self.ppView updatePocketAndPhotoViewWithDynamicContentInstance:data];
         [self.ppView.view setNeedsLayout];
         self.currentPageNo +=  1;
       }];
    }];
    [_refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
    [_refreshFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_refreshFooter setRefreshingTitleHidden:YES];
  }
  return _refreshFooter;
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
