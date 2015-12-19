//
//  SearchKeyWordsVC.m
//  DouPaiwo
//  即时搜索关键字
//  Created by J006 on 15/8/24.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SearchKeyWordsVC.h"
#import "UITapImageView.h"
#import "DouAPIManager.h"
#import <Masonry.h>
#import <MBProgressHUD.h>
#import "SearchResultDetailView.h"
#import "PersonalProfile.h"
#define cellHeight  42
#define pageSizeSearchAlbumPhoto 4
#define kColorNaviBarCustom [UIColor colorWithRed:41/255.0 green:42/255.0 blue:41/255.0 alpha:0.98]
@interface SearchKeyWordsVC ()

@property (strong,  nonatomic)  UITapImageView          *maskView;//背景蒙版带高斯模糊
@property (strong,  nonatomic)  UIImage                 *mainBlurImage;
@property (strong,  nonatomic)  UIImageView             *mainBlurImageView;
@property (strong,  nonatomic)  UITableView             *searchTableView;
@property (nonatomic,strong)    PersonalProfile         *ppView;
@property (nonatomic,strong)    SearchResultDetailView  *searchResultDetailView;

@property (readwrite,nonatomic) NSInteger               searchTypeNums;
@property (strong,  nonatomic)  NSString                *keyWords;//当前关键字
@property (strong,  nonatomic)  NSMutableArray          *resultTypeArray;//搜索结果类别集合
@property (strong,  nonatomic)  UserInstance            *searchUser;//当前搜索到的用户第一个

@property (strong,  nonatomic)  UILabel                 *noResultLabel;
@property (strong,  nonatomic)  MBProgressHUD           *mbProgHUD;

//@property (strong,  nonatomic)  NSString                *prevSearchString;//上一次搜索的字符串

@end
@implementation SearchKeyWordsVC

#pragma life cycle
- (void)viewDidLoad
{
  [super  viewDidLoad];
  self.mainBlurImage   = [self.mainBlurImage imageWithGaussianBlur:self.mainBlurImage];
  [self.view            addSubview:self.mainBlurImageView];
  [self.view            addSubview:self.maskView];
  [self.view            addSubview:self.searchTableView];
  [self.view            addSubview:self.noResultLabel];
  [self                 requestSearchWithKeyWord:self.keyWords];
}

- (void)viewDidLayoutSubviews
{
  [super          viewDidLayoutSubviews];
  [self.view              setBackgroundColor:[UIColor clearColor]];
  [self.mainBlurImageView setFrame:self.view.bounds];
  [self.maskView          setFrame:self.view.bounds];
  if(self.resultTypeArray)
    [self.searchTableView   setFrame:CGRectMake(0, 0, kScreen_Width, 100)];
  [self.noResultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.centerY.equalTo(self.view).offset(-60);
    make.width.equalTo(self.view);
    make.height.mas_equalTo(30);
  }];
}

#pragma init

- (void)initSearchKeyWordsVCWithSnapshot  :(UIImage*)image  keyWords:(NSString*)keyWords
{
  self.mainBlurImage  = image;
  self.keyWords       = keyWords;
}

#pragma private methods
- (void)backgroundTapped
{
  [self.view  removeFromSuperview];
}

- (void)  setRefresh
{
  [self requestSearchWithKeyWord:self.keyWords];
}


- (void)requestSearchWithKeyWord  :(NSString*)keyWords
{
  //如果新的搜索关键字在去空格后与之前搜索的关键字相同,则不做搜索.
  /*
  if(!self.prevSearchString)
    if([[keyWords stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:[self.prevSearchString stringByReplacingOccurrencesOfString:@" " withString:@""] ])
      return;
  self.prevSearchString = keyWords;
   */
  __weak typeof(self) weakSelf = self;
  NSArray *tagArray = [keyWords componentsSeparatedByString:@" "];//根据空格分割字符串
  NSMutableArray  *searchTags     = [tagArray mutableCopy];
  NSMutableArray  *newSearchTags  = [[NSMutableArray alloc]init];
  NSString        *searchString=@"";
  for (NSString *string in searchTags)
  {
    if([string isEqualToString:@""])
      continue;
    searchString  = [searchString   stringByAppendingString:string];
    [newSearchTags  addObject:string];
  }
  if(!self.resultTypeArray)
    self.resultTypeArray  = [[NSMutableArray alloc]init];
  else
  {
    [self.resultTypeArray  removeAllObjects];
  }
  [self.view addSubview:self.mbProgHUD];  
  [self.mbProgHUD showAnimated:YES whileExecutingBlock:^{
    [[DouAPIManager sharedManager] request_SearchUsersWithPageNo: 1 page_size:pageSizeDefault tags:newSearchTags :^(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error)
     {
       if(usersData)
       {
         [self.resultTypeArray addObject:[NSNumber  numberWithInteger:SearchUsers]];
         self.searchUser  = [usersData objectAtIndex:0];
       }
       [[DouAPIManager sharedManager] request_SearchPhotoWithPageNo: 1  page_size:pageSizeSearchAlbumPhoto tags:newSearchTags :^(NSMutableArray *photosData, NSInteger totalSearchNums, NSError *error)
        {
          if(photosData)
          {
            [self.resultTypeArray addObject:[NSNumber  numberWithInteger:SearchPhotos]];
          }
          dispatch_sync(dispatch_get_main_queue(), ^{
            if(!self.resultTypeArray || [self.resultTypeArray count]==0)
              [self.noResultLabel setAlpha:1.0];
            else
              [self.noResultLabel setAlpha:0.0];
            [weakSelf.searchTableView  reloadData];
          });
        }];
     }];
  } completionBlock:^{
    if(!self.resultTypeArray || [self.resultTypeArray count]==0)
      [self.noResultLabel setAlpha:1.0];
    else
      [self.noResultLabel setAlpha:0.0];
    [self.searchTableView  reloadData];
    [self.mbProgHUD removeFromSuperview];
    self.mbProgHUD = nil;
  }];
}

#pragma private methods
- (void)jumpToUserProfileView
{
  self.ppView = [[PersonalProfile  alloc]init];
  [self.ppView  initPersonalProfileWithUserDomain:self.searchUser.host_domain isSelf:NO];
  [SearchKeyWordsVC setRDVTabHidden:YES isAnimated:NO];
  [[SearchKeyWordsVC getNavi] setNavigationBarHidden:YES animated:NO];
  [self.ppView addBackBlock:^(id obj) {
    [PersonalProfile setRDVTabHidden:NO isAnimated:NO];
    [[PersonalProfile getNavi] setNavigationBarHidden:NO animated:NO];
    [[PersonalProfile  getNavi]popViewControllerAnimated:YES];
  }];
  [SearchKeyWordsVC naviPushViewController:self.ppView];

}

/**
 *  @author J006, 15-06-23 00:06:10
 *
 *  跳转到详细列表界面:搜索到的列表用户,专辑的列表界面
 *
 *  @param sender
 */
- (void)jumpToDetailListView:(SearchKeyType)searchType
{
  [[SearchKeyWordsVC getNavi].navigationBar setBackgroundColor:kColorNaviBarCustom];//背景颜色
  [[SearchKeyWordsVC getNavi].navigationBar setTintColor:[UIColor whiteColor]];//箭头颜色
  [[SearchKeyWordsVC getNavi].navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];//题目标题颜色
  [[SearchKeyWordsVC getNavi] setNavigationBarHidden:NO animated:NO];
  self.searchResultDetailView  = nil;
  NSArray *tagArray = [self.keyWords componentsSeparatedByString:@" "];//根据空格分割字符串
  NSMutableArray  *searchTags     = [tagArray mutableCopy];
  NSMutableArray  *newSearchTags  = [[NSMutableArray alloc]init];
  NSString        *searchString=@"";
  for (NSString *string in searchTags)
  {
    if([string isEqualToString:@""])
      continue;
    searchString  = [searchString   stringByAppendingString:string];
    [newSearchTags  addObject:string];
  }
  if(searchType  ==  SearchUsers)
  {
    [self.searchResultDetailView      initSearchResultDetailViewWithOriginalSearchTags:newSearchTags searchTags:self.keyWords searchType:UserSearchType];
    [self.searchResultDetailView.view setBackgroundColor:kColorBackGround];
    [self.searchResultDetailView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [[SearchKeyWordsVC getNavi] pushViewController:self.searchResultDetailView animated:YES];
  }
  else  if  (searchType  ==  SearchPhotos)
  {
    [self.searchResultDetailView      initSearchResultDetailViewWithOriginalSearchTags:newSearchTags searchTags:self.keyWords searchType:AlbumSearchType];
    [self.searchResultDetailView.view setBackgroundColor:kColorBackGround];
    [self.searchResultDetailView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [[SearchKeyWordsVC getNavi] pushViewController:self.searchResultDetailView animated:YES];
  }
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger nums  = 0;
  if(self.resultTypeArray)
    nums  = [self.resultTypeArray count];
  return nums;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger row = 1;
  if(!self.resultTypeArray)
    row = 0;
  return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SearchKeyWordsTableViewCell     *cell;
  if(cell==nil)
  {
    cell = [[SearchKeyWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchKeyWordsTableViewCellIdentify];
  }
  if(indexPath.section  ==  0)
  {
    SearchKeyWordsTableViewCell     *cell = [[SearchKeyWordsTableViewCell  alloc]init];
    if([(NSNumber*)[self.resultTypeArray objectAtIndex:0]integerValue] ==  SearchUsers)
    {
      NSString  *urlString  = [defaultImageHeadUrl stringByAppendingString:_searchUser.host_avatar];
      NSURL     *url = [[NSURL  alloc]initWithString:urlString];
      [cell     initSearchKeyWordsTableViewCellWithType:SearchUsers title:@"用户" avatarURL:url value:_searchUser.host_name];
      [cell      addUserTapBlockWithAction:^(id obj) {
        [self jumpToUserProfileView];
      }];
      [cell     setHeight:cellHeight];
      return cell;
    }
    else
    {
      SearchKeyWordsTableViewCell     *cell = [[SearchKeyWordsTableViewCell  alloc]init];
      [cell     initSearchKeyWordsTableViewCellWithType:SearchUsers title:@"查看相关照片" avatarURL:nil value:nil];
      [cell     setHeight:cellHeight];
      return cell;
    }
  }
  else  if(indexPath.section  ==  1)
  {
    SearchKeyWordsTableViewCell     *cell = [[SearchKeyWordsTableViewCell  alloc]init];
    [cell     initSearchKeyWordsTableViewCellWithType:SearchUsers title:@"查看相关照片" avatarURL:nil value:nil];
    [cell     setHeight:cellHeight];
    return cell;
  }
  return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = cellHeight;
  return height;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self jumpToDetailListView:[(NSNumber*)[self.resultTypeArray objectAtIndex:indexPath.section]integerValue]];
}


#pragma getter setter

- (UITapImageView*)maskView
{
  if(_maskView  ==  nil)
  {
    _maskView   = [[UITapImageView alloc]init];
    UIImage *image  = [UIImage  imageWithColor:[UIColor  colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:0.3]];
    [_maskView  setImage:image];
    __weak typeof(self) weakSelf = self;
    [_maskView  addTapBlock:^(id obj) {
      [weakSelf  backgroundTapped];
    }];
  }
  return _maskView;
}

- (UIImageView*)mainBlurImageView
{
  if(_mainBlurImageView ==  nil)
  {
    _mainBlurImageView  = [[UIImageView  alloc]initWithFrame:self.view.bounds];
    [_mainBlurImageView  setImage:self.mainBlurImage];
  }
  return _mainBlurImageView;
}

- (UITableView*)searchTableView
{
  if(_searchTableView ==  nil)
  {
    _searchTableView  = [[UITableView  alloc]init];
    _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//解决UITableViewStyleGrouped类型,会填满整个UITableView的多cell问题
    [_searchTableView setBackgroundColor:[UIColor clearColor]];
    [_searchTableView setScrollEnabled:NO];
    _searchTableView.dataSource = self;
    _searchTableView.delegate = self;
    [_searchTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_searchTableView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 25)];
    [_searchTableView setSeparatorColor:[UIColor  colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]];
  }
  return _searchTableView;
}

- (UILabel*)noResultLabel
{
  if(_noResultLabel ==  nil)
  {
    _noResultLabel  = [[UILabel  alloc]init];
    _noResultLabel.backgroundColor = [UIColor clearColor];
    _noResultLabel.font = SourceHanSansNormal14;
    _noResultLabel.textColor = [UIColor lightGrayColor];
    _noResultLabel.textAlignment = NSTextAlignmentCenter;
    [_noResultLabel  setText:@"没有搜索到相关内容..."];
    [_noResultLabel  setAlpha:0.0];
  }
  return _noResultLabel;
}

- (MBProgressHUD*)mbProgHUD
{
  if(_mbProgHUD ==  nil)
  {
    _mbProgHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _mbProgHUD.mode = MBProgressHUDModeIndeterminate;
  }
  return _mbProgHUD;
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
