//
//  MainBanner.m
//  TestPaiwo
//
//  Created by J006 on 15/4/22.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "MainBanner.h"
#import "SingleBannerView.h"
#import <Masonry.h>
#import "CustomUIControl.h"

@interface MainBanner()

@property (strong, nonatomic) UIScrollView              *mainScrollView;//背景图,可切换
@property (nonatomic, strong) CustomUIControl           *pageControl;
@property (strong, nonatomic) NSMutableArray            *singleBannerArray;//pocket集合
@property (strong, nonatomic) NSMutableArray            *singleBannerViewArray;//bannerView集合

@end

@implementation MainBanner


- (void)viewDidLoad
{
  self.view.backgroundColor = kColorBackGround;
  [self.view  addSubview:self.mainScrollView];
  [self.view  addSubview:self.pageControl];
  for (NSInteger i=0; i<[_singleBannerArray count]; i++)
  {
    PocketItemInstance    *pocket = [_singleBannerArray objectAtIndex:i];
    SingleBannerView  *singleBannerView=  [[SingleBannerView alloc]init];
    [singleBannerView initSingleBannerViewWithPocket:pocket];
    [self.singleBannerViewArray addObject:singleBannerView];
    [self.mainScrollView  addSubview:singleBannerView.view];
  }
}

- (void)viewDidLayoutSubviews
{

  [self.mainScrollView setFrame:self.view.bounds];

  float scrollViewContentWidth  = 0;
  UIView  *tempView = nil;
  for (NSInteger i =0;i<[self.singleBannerViewArray count]; i++)
  {
    SingleBannerView  *singleBannerView=  [self.singleBannerViewArray objectAtIndex:i];
    if(tempView==nil)
    {
      [singleBannerView.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else
    {
      [singleBannerView.view setFrame:CGRectMake(tempView.frame.size.width+tempView.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    tempView  = singleBannerView.view;
    scrollViewContentWidth  +=  singleBannerView.view.frame.size.width;
  }
  
  [self.mainScrollView  setContentSize:CGSizeMake(scrollViewContentWidth, self.view.frame.size.height)];
  
  [self.pageControl  setFrame:CGRectMake(self.view.frame.size.width/2-15, self.view.frame.size.height-30, 30, 30)];

}

#pragma init
- (void)initMainBannerWithSingleBanner  :(NSMutableArray*)array;
{
  _singleBannerArray  = array;
}

#pragma UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  _pageControl.currentPage = page;
}

- (void)changePage:(id)sender
{
  NSInteger page = self.pageControl.currentPage;
  CGRect frame = self.mainScrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [self.mainScrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark - getters and setters
- (UIScrollView*) mainScrollView
{
  if (_mainScrollView == nil)
  {
    _mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = kColorBackGround;
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
  }
  return _mainScrollView;
}

- (CustomUIControl*)  pageControl
{
  if(_pageControl ==  nil)
  {
    _pageControl  = [[CustomUIControl alloc]init];
    [_pageControl  setNumberOfPages:[_singleBannerArray  count]];
    [_pageControl  setCurrentPage:0];
    [_pageControl  addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
  }
  return _pageControl;
}

- (NSMutableArray*) singleBannerViewArray
{
  if(_singleBannerViewArray ==  nil)
  {
    _singleBannerViewArray  = [[NSMutableArray alloc]init];
  }
  return _singleBannerViewArray;
}

@end
