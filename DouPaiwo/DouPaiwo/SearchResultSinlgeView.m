//
//  SearchResultSinlgeView.m
//  DouPaiwo
//
//  Created by J006 on 15/6/19.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchResultSinlgeView.h"
#import "SearchBackGroundViewController.h"
#import "UserInstance.h"
#import "AlbumPhotoInstance.h"
#import "UITapImageView.h"
#import "SearchResultDetailView.h"
#import "DouAPIManager.h"
#import "PersonalProfile.h"
#import "AlbumDetailPage.h"
#import <Masonry.h>
#import "PhotosViewController.h"
#define kColorNaviBarCustom [UIColor colorWithRed:41/255.0 green:42/255.0 blue:41/255.0 alpha:0.98]
@interface SearchResultSinlgeView ()

@property (nonatomic,strong)    UILabel                               *mainTitle;//摄影师,兜,照片
@property (nonatomic,strong)    UIScrollView                          *mainScrollView;//主滚动条界面
@property (nonatomic,strong)    UILabel                               *resultNums;//结果数字
@property (nonatomic,strong)    UIButton                              *moreButton;//更多按钮
@property (nonatomic,strong)    UIScrollView                          *avatarScrollView;//用户列表滚动条容器
@property (nonatomic,strong)    NSMutableArray                        *imageIconArray;//用户头像集合
@property (nonatomic,strong)    NSMutableArray                        *descStringArray;//描述文字集合
@property (nonatomic,strong)    NSMutableArray                        *albumImageArray;//专辑图片集合

@property (nonatomic,readwrite) NSInteger                             resultType;
@property (nonatomic,strong)    NSMutableArray                        *resultArray;
@property (nonatomic,readwrite) NSInteger                             totalSearchNums;
@property (nonatomic,strong)    NSString                              *searchTags;

@property (nonatomic,strong)    SearchResultDetailView                *searchResultDetailView;
@property (nonatomic,strong)    PersonalProfile                       *ppView;
@end

@implementation SearchResultSinlgeView

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.mainTitle];
  [self.view  addSubview:self.resultNums];
  [self.view  addSubview:self.moreButton];
  if(self.resultType  ==  resultType_photographer)
  {
    [self.view addSubview:self.avatarScrollView];
    for (NSInteger i=0; i<[self.resultArray  count]; i++)
    {
      UserInstance    *userIntance  = [self.resultArray objectAtIndex:i];
      UITapImageView  *avatarImage  = [[UITapImageView alloc]init];
      [avatarImage setSize:CGSizeMake(50, 50)];
      __weak typeof(self) weakSelf = self;
      NSURL *url = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:userIntance.host_avatar]];
      [avatarImage  setImageWithUrlWaitForLoadForAvatarCircle :url placeholderImage:nil tapBlock:^(id obj){
        [weakSelf jumpToUserProfileView:userIntance];
      }];
      [self.imageIconArray    addObject:avatarImage];
      [self.avatarScrollView  addSubview:avatarImage];
      UILabel         *descLabel    = [[UILabel  alloc]init];
      [descLabel  setText:userIntance.host_name];
      [descLabel  setTextColor:[UIColor lightGrayColor]];
      [descLabel  setTextAlignment:NSTextAlignmentCenter];
      [descLabel  setFont:[UIFont systemFontOfSize:kSearchResultSinlgeViewSmallFontSize]];
      [self.descStringArray   addObject:descLabel];
      [self.avatarScrollView  addSubview:descLabel];
    }
  }
  else  if(self.resultType  ==  resultType_album)
  {
    for (NSInteger i=0; i<[self.resultArray  count]; i++)
    {
      AlbumPhotoInstance    *albumPhoto  = [self.resultArray objectAtIndex:i];
      UITapImageView        *photoImage  = [[UITapImageView alloc]init];
      NSString              *stringURL  =  [defaultImageHeadUrl stringByAppendingString:[albumPhoto.photo_path stringByAppendingString:imageSquareTailUrl]];
      NSURL *url = [[NSURL  alloc]initWithString:stringURL];
      __weak typeof(self) weakSelf = self;
      float imageWidth  = (self.view.frame.size.width-kTotalDefaultPadding*2-10)/2;
      UIImage *image  = [[UIImage  alloc]init];
      image = [image  randomSetPreLoadImageWithSize:CGSizeMake(imageWidth, imageWidth)];
      [photoImage  setImageWithUrlWaitForLoad:url placeholderImage:nil tapBlock:^(id obj){
        [weakSelf jumpToAlbumDetailActionWithAlbumPhoto:albumPhoto];
      }];
      [self.view  addSubview:photoImage];
      [self.albumImageArray addObject:photoImage];
    }
  }
  else  if(self.resultType  ==  resultType_pocket)
  {
  
  }
}

- (void)viewDidLayoutSubviews
{
  [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view);
    make.left.equalTo(self.view).offset(kTotalDefaultPadding);
    make.size.mas_equalTo(CGSizeMake(60,25));
  }];
  
  [self.resultNums mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.mainTitle);
    make.left.equalTo(self.mainTitle.mas_right).offset(5);
    make.size.mas_equalTo(CGSizeMake(100,25));
  }];
  
  [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view);
    make.right.equalTo(self.view).offset(-10);
    make.size.mas_equalTo(CGSizeMake(50,25));
  }];
  
  if(self.resultType  ==  resultType_photographer)
  {
    [self.avatarScrollView  mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.mainTitle.mas_bottom);
      make.left.equalTo(self.view);
      make.right.equalTo(self.view);
      make.bottom.equalTo(self.view);
    }];
    //摆放图片头像icon
    UIView  *lastView = nil;
    for (NSInteger  i=0; i<[self.imageIconArray  count]; i++)
    {
      UITapImageView  *avatarImage = [self.imageIconArray  objectAtIndex:i];
      UILabel *descLabel = [self.descStringArray  objectAtIndex:i];
      [avatarImage  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarScrollView).offset(25);
        if(lastView)
          make.left.equalTo(lastView.mas_right).offset(50);
        else
          make.left.equalTo(self.avatarScrollView).offset(35);
        make.size.mas_equalTo(CGSizeMake(50,50));
      }];
      lastView  = avatarImage;
      [descLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(avatarImage.mas_bottom).offset(5);
        make.centerX.equalTo(avatarImage.mas_centerX);
        //make.size.mas_equalTo(CGSizeMake(60,20));
      }];
      [descLabel  sizeToFit];

    }
    if(self.resultArray)
    {
      [self.avatarScrollView  setContentSize:CGSizeMake(35+25*2*([self.descStringArray count]-1)+25*2*[self.descStringArray count]+10, self.avatarScrollView.frame.size.height)];
    }
  }
  
  else    if(self.resultType  ==  resultType_album)
  {
    //摆放专辑图片
    for (NSInteger  i=0; i<[self.albumImageArray  count]; i++)
    {
      UITapImageView  *photoImage = [self.albumImageArray  objectAtIndex:i];
      if(i==0)
      {
        [photoImage  mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.view).offset(kTotalDefaultPadding);
          make.top.equalTo(self.mainTitle.mas_bottom);
          make.size.mas_equalTo(CGSizeMake((self.view.frame.size.width-60)/2,(self.view.frame.size.width-60)/2));
        }];
      }
      else  if(i==1)
      {
        [photoImage  mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(self.view).offset(-kTotalDefaultPadding);
          make.top.equalTo(self.mainTitle.mas_bottom);
          make.size.mas_equalTo(CGSizeMake((self.view.frame.size.width-kTotalDefaultPadding*2-10)/2,(self.view.frame.size.width-kTotalDefaultPadding*2-10)/2));
        }];
        }
      else  if(i==2)
      {
        [photoImage  mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.view).offset(kTotalDefaultPadding);
          make.top.equalTo(self.view).offset((self.view.frame.size.width-kTotalDefaultPadding*2-10)/2+35);
          make.size.mas_equalTo(CGSizeMake((self.view.frame.size.width-kTotalDefaultPadding*2-10)/2,(self.view.frame.size.width-kTotalDefaultPadding*2-10)/2));
        }];
      }
      else  if(i==3)
      {
        [photoImage  mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.equalTo(self.view).offset(-kTotalDefaultPadding);
          make.top.equalTo(self.view).offset((self.view.frame.size.width-kTotalDefaultPadding*2-10)/2+35);
          make.size.mas_equalTo(CGSizeMake((self.view.frame.size.width-kTotalDefaultPadding*2-10)/2,(self.view.frame.size.width-kTotalDefaultPadding*2-10)/2));
        }];
      }
    }
      //(self.view.frame.size.width-60)/2
  }
  
}

#pragma init
- (void)initSearchResultSinlgeViewWithType:(NSInteger)resultType  resultArray:(NSMutableArray*)resultArray totalSearchNums:(NSInteger)totalSearchNums searchTags:(NSString*)searchTags;
{
  self.resultType           = resultType;
  self.resultArray          = resultArray;
  self.totalSearchNums      = totalSearchNums;
  self.searchTags           = searchTags;
}


#pragma self funation
/**
 *  @author J006, 15-06-23 00:06:10
 *
 *  跳转到详细列表界面:搜索到的列表用户,专辑的列表界面
 *
 *  @param sender
 */
- (void)jumpToDetailListView:(id)sender
{
  [[SearchResultSinlgeView getNavi].navigationBar setBackgroundColor:kColorNaviBarCustom];//背景颜色
  [[SearchResultSinlgeView getNavi].navigationBar setTintColor:[UIColor whiteColor]];//箭头颜色
  [[SearchResultSinlgeView getNavi].navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];//题目标题颜色
  [[SearchResultSinlgeView getNavi] setNavigationBarHidden:NO animated:NO];
  
  NSArray *tagArray = [self.searchTags componentsSeparatedByString:@" "];//根据空格分割字符串
  NSMutableArray  *searchTags = [tagArray mutableCopy];
  if(self.resultType  ==  resultType_photographer)
  {
    [self.searchResultDetailView      initSearchResultDetailViewWithOriginalSearchTags:searchTags searchTags:self.searchTags searchType:UserSearchType];
    [self.searchResultDetailView.view setBackgroundColor:kColorBackGround];
    [self.searchResultDetailView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [[SearchResultSinlgeView getNavi] pushViewController:self.searchResultDetailView animated:YES];
  }
  else  if  (self.resultType  ==  resultType_album)
  {
    [self.searchResultDetailView      initSearchResultDetailViewWithOriginalSearchTags:searchTags searchTags:self.searchTags searchType:AlbumSearchType];
    [self.searchResultDetailView.view setBackgroundColor:kColorBackGround];
    [self.searchResultDetailView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [[SearchResultSinlgeView getNavi] pushViewController:self.searchResultDetailView animated:YES];
  }
}

- (void)jumpToUserProfileView :(UserInstance*)currUser;
{
  self.ppView = [[PersonalProfile  alloc]init];
  BOOL      isSelf = NO;
  NSString  *currentDomain  = [DouAPIManager  currentDomainData];
  if([currUser.host_domain isEqualToString:currentDomain])
    isSelf  = YES;
  [self.ppView  initPersonalProfileWithUserDomain:currUser.host_domain isSelf:isSelf];
  [SearchResultSinlgeView setRDVTabHidden:YES isAnimated:NO];
  [[SearchResultSinlgeView getNavi] setNavigationBarHidden:YES animated:NO];
  [self.ppView addBackBlock:^(id obj) {
    [PersonalProfile setRDVTabHidden:NO isAnimated:NO];
    [[PersonalProfile getNavi] setNavigationBarHidden:NO animated:NO];
    [[PersonalProfile  getNavi]popViewControllerAnimated:YES];
  }];
  [SearchResultSinlgeView naviPushViewController:self.ppView];
}

/**
 *  @author J006, 15-07-10 17:07:58
 *
 *  跳转到图片详细界面而非专辑界面
 *
 *  @param albumPhotoID
 */
- (void)jumpToAlbumDetailActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto
{
  PhotosViewController  *photosVC = [[PhotosViewController alloc]init];

  [photosVC initPhotoViewControllerWithPhotoID:albumPhoto.photo_id];
  [photosVC.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [photosVC   addBackBlock:^(id objc){
    [PhotosViewController setRDVTabHidden:NO isAnimated:NO];
    [[PhotosViewController  getNavi]setNavigationBarHidden:NO animated:NO];
    [[PhotosViewController  getNavi]popViewControllerAnimated:YES];
  }];
  [SearchResultDetailView  setRDVTabHidden:YES  isAnimated:NO];
  [[SearchResultDetailView  getNavi]  setNavigationBarHidden:YES animated:NO];
  [SearchResultDetailView  naviPushViewController:photosVC];
}

#pragma getter setter
- (UIScrollView*)mainScrollView
{
  if(_mainScrollView  ==  nil)
  {
    _mainScrollView = [[UIScrollView alloc]init];
    [_mainScrollView setBackgroundColor:[UIColor clearColor]];
  }
  return _mainScrollView;
}

- (UILabel*)mainTitle
{
  if(_mainTitle ==  nil)
  {
    _mainTitle  = [[UILabel  alloc]init];
    NSString  *title;
    if(self.resultType==resultType_photographer)
      title = @"摄影师";
    else  if(self.resultType==resultType_pocket)
      title = @"兜";
    else  if(self.resultType==resultType_album)
      title = @"照片";
    [_mainTitle  setText:title];
    [_mainTitle  setTextAlignment:NSTextAlignmentLeft];
    [_mainTitle  setFont:SourceHanSansNormal17];
    [_mainTitle  setTextColor:[UIColor  blackColor]];
  }
    return _mainTitle;
}

- (UILabel*)resultNums
{
  if(_resultNums  ==  nil)
  {
    _resultNums  = [[UILabel  alloc]init];
    NSString  *nums;
    if(self.resultArray)
    {
      nums  =  [NSString stringWithFormat:@"%ld",self.totalSearchNums];
    }
    else
    {
      nums = @"0";
    }

    [_resultNums  setText:[nums stringByAppendingString:@"个结果"]];
    [_resultNums  setTextAlignment:NSTextAlignmentLeft];
    [_resultNums  setFont:SourceHanSansNormal12];
    [_resultNums  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
    return _resultNums;
}

- (UIButton*)moreButton
{
  if(_moreButton  ==  nil)
  {
    _moreButton = [[UIButton alloc]init];
    [_moreButton  setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_moreButton  setTitleColor:[UIColor  colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_moreButton.titleLabel setFont:SourceHanSansNormal14];
    [_moreButton  addTarget:self action:@selector(jumpToDetailListView:) forControlEvents:UIControlEventTouchUpInside];
  }
    return _moreButton;
}

- (UIScrollView*)avatarScrollView
{
  if(_avatarScrollView  ==  nil)
  {
    _avatarScrollView = [[UIScrollView alloc]init];
    _avatarScrollView.delegate  = self;
    [_avatarScrollView setShowsHorizontalScrollIndicator:NO];
  }
  return _avatarScrollView;
}

- (NSMutableArray*)imageIconArray
{
  if(_imageIconArray  ==  nil)
  {
    _imageIconArray = [[NSMutableArray alloc]init];
  }
  return _imageIconArray;
}

- (NSMutableArray*)descStringArray
{
  if(_descStringArray  ==  nil)
  {
    _descStringArray = [[NSMutableArray alloc]init];
  }
  return _descStringArray;
}

- (NSMutableArray*)albumImageArray
{
  if(_albumImageArray  ==  nil)
  {
    _albumImageArray = [[NSMutableArray alloc]init];
  }
  return _albumImageArray;
}

- (SearchResultDetailView*)searchResultDetailView
{
  if(_searchResultDetailView  ==  nil)
  {
    _searchResultDetailView = [[SearchResultDetailView alloc]init];
  }
  return _searchResultDetailView;
}
@end
