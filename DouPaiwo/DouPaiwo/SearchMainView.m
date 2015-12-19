//
//  SearchMainView.m
//  TestPaiwo
//
//  Created by J006 on 15/4/29.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SearchMainView.h"
#import "SearchProjectCell.h"
#import "SearchBackGroundViewController.h"
#import <TPKeyboardAvoidingCollectionView.h>
#import "SearchProjectCell.h"
#import "DouAPIManager.h"
#import "SearchMainResultView.h"
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACEXTScope.h"
#import "SearchProjectInstance.h"
#import "SearchResultDetailView.h"
#import "RecommendPhotographerView.h"
#import "SearchKeyWordsVC.h"
#import "CustomSearchBar.h"
#define pageSizeSearchAlbumPhoto 4
#define kColorNaviBarCustom [UIColor colorWithRed:41/255.0 green:42/255.0 blue:41/255.0 alpha:0.98]
@interface SearchMainView()<CustomSearchBarDelegate>

@property (nonatomic,strong)  UIView                              *contentView;
@property (nonatomic,strong)  UIView                              *headerView;
@property (nonatomic,strong)  UIView                              *bottomView;
@property (nonatomic,strong)  UISearchBar                         *searchBar;
@property (nonatomic,strong)  UITableView                         *projectTableView;//专题scrollview
@property (nonatomic,strong)  CustomSearchBar                     *customSearchBar;
@property (nonatomic,strong)  SearchBackGroundViewController      *searchBGVC;//搜索背景蒙版
@property (nonatomic,strong)  NSMutableArray                      *projectArray;//专题集合
@property (nonatomic,strong)  NSMutableArray                      *searchUsersResultArray;//搜索得到的用户列表结果
@property (nonatomic,strong)  NSMutableArray                      *searchPhotosResultArray;//搜索得到的专辑图片列表结果
@property (nonatomic,readwrite)NSInteger                          searchUsersTotalNums;
@property (nonatomic,readwrite)NSInteger                          searchAlbumPhotosTotalNums;
@property (nonatomic,readwrite)CGFloat                            theFitHeight;
@property (nonatomic,strong)  SearchProjectInstance               *currentProject;

@property (nonatomic,strong)  SearchMainResultView                *searchMainResultView;//搜索结果主界面
@property (nonatomic,strong)  SearchResultDetailView              *searchResultDetailView;
@property (nonatomic,strong)  SearchKeyWordsVC                    *searchVC;

@property (nonatomic,readwrite) CGFloat                           prevInputSearchStringTime;

@end

@implementation SearchMainView

#pragma mark  - life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  //self.navigationItem.titleView = self.customSearchBar.view;
  //[self.view  addSubview:self.customSearchBar.view];
  self.view.backgroundColor = kColorBackGround;
  self.navigationItem.titleView = self.searchBar;
  [self.view  addSubview:self.searchBar];
  [self.view  addSubview:self.projectTableView];
  [self.view  addSubview:self.searchBGVC.view];
}

- (void)viewDidLayoutSubviews
{
  [self.projectTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.width.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];
  
  [self.searchBGVC.view   mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.width.equalTo(self.view);
    make.top.equalTo(self.view);
    make.bottom.equalTo(self.view);
  }];

}

- (void)viewWillAppear:(BOOL)animated
{
  [SearchMainView setRDVTabStatusStyleDirect:UIStatusBarStyleLightContent];
}


#pragma init
- (void)  initSearchMainView :(NSMutableArray*)projectArray
{
  _projectArray = projectArray;
  _theFitHeight  = [SearchMainView heightToFitWidth:CGSizeMake(kdefaultTotalScreen_Width, 125) newWidth:kScreen_Width];
}


/**
 *  @author J006, 15-06-12 12:06:41
 *
 *  取消背景蒙版界面
 */
- (void)  dismissBackGroundView
{
  [self.searchBGVC.view setAlpha:0.0];
  [self.searchBar resignFirstResponder];
  [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)enableCancelButton:(UISearchBar *)searchBar
{
  for (UIView *view in searchBar.subviews)
    for (id subview in view.subviews)
      if ( [subview isKindOfClass:[UIButton class]] )
      {
        [subview setEnabled:YES];
        return;
      }
}


#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger row=1;
  return row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger section = 1;
  if(self.projectArray && [self.projectArray count]>0)
    section = [self.projectArray   count];
  return section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SearchProjectCell *cell;
  if(self.projectArray && [self.projectArray count]>0)
  {
    cell  = [[SearchProjectCell  alloc]init];
    SearchProjectInstance   *project  = [self.projectArray objectAtIndex:indexPath.section];
    __weak typeof(self) weakSelf = self;
    if(indexPath.section  ==  0)
      [cell  initSearchProjectCell:project.title setBackGroundImage:project.mainImage tapAction:^(id objec){
        [weakSelf jumpToRecommendPhotographerView:project];
      }];
    else
    [cell  initSearchProjectCell:project.title setBackGroundImage:project.mainImage tapAction:^(id objec){
      [weakSelf settingTheCurrentProjectToSearch:project];
    }];
    [cell setHeight:_theFitHeight];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(!self.projectArray)
    return;
  SearchProjectInstance *project  = [self.projectArray  objectAtIndex:indexPath.section];
  [self settingTheCurrentProjectToSearch:project];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CGFloat height = _theFitHeight;
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height = 5;
  if(section  ==  0)
    height  = 0;

  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  CGFloat height = 5;
  return height;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
  
  //Set the background color of the View
  view.tintColor = [UIColor whiteColor];
  
  //Set the TextLabel Color
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  [header.textLabel setTextColor:[UIColor whiteColor]];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
  
  //Set the background color of the View
  view.tintColor = [UIColor whiteColor];
  
  //Set the TextLabel Color
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  [header.textLabel setTextColor:[UIColor whiteColor]];
}
#pragma CustomSearchBar delegate
- (void)removeTheKeyWordWithCustomSearchBar:(CustomSearchBar *)customSearchBar theRemainKeyWords:(NSString *)theRemainKeyWords theReaminKeyWordsArray:(NSMutableArray *)array
{
  if(!theRemainKeyWords)
  {
    self.searchBar.text = @"";
    [self.customSearchBar.view removeFromSuperview];
    self.customSearchBar  = nil;
    if(self.searchBGVC)
    {
      [self dismissBackGroundView];
    }
    if(self.searchMainResultView)
      [self.searchMainResultView.view removeFromSuperview];
    if(self.searchVC)
      [self.searchVC.view removeFromSuperview];
    [SearchMainView  setRDVTabHidden:NO isAnimated:NO];
    self.navigationItem.titleView = self.searchBar;
    return;
  }
  self.searchBar.text = theRemainKeyWords;
  [self.searchMainResultView.view  removeFromSuperview];
  self.searchMainResultView  = nil;
  self.searchMainResultView = [[SearchMainResultView alloc]init];
  [self.searchMainResultView initSearchMainResultViewWithSearchTags:theRemainKeyWords withSearchTagsArray:array];
  [self.searchMainResultView.view  setFrame:CGRectMake(0, self.searchBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-self.searchBar.frame.size.height-20)];
  [self.searchBar resignFirstResponder];
  [self enableCancelButton:self.searchBar];
  [self.view  addSubview:self.searchMainResultView.view];
}

- (void)editTheKeyWordWithCustomSearchBar:(CustomSearchBar *)customSearchBar theRemainKeyWords:(NSString *)theRemainKeyWords theReaminKeyWordsArray:(NSMutableArray *)array
{
  [self.customSearchBar.view removeFromSuperview];
  self.customSearchBar  = nil;
  self.searchBar.text = theRemainKeyWords;
  self.navigationItem.titleView = self.searchBar;
  [self.searchBar  becomeFirstResponder];
  [self settingTheSearchKeyWordsVC];
}

- (void)cancelAndBackToMainViewWithCustomSearchBar  :(CustomSearchBar*)customSearchBar
{
  [self.customSearchBar.view removeFromSuperview];
  self.customSearchBar  = nil;
  self.searchBar.text = @"";
  [self.searchBar  resignFirstResponder];
  if(self.searchBGVC)
  {
    [self dismissBackGroundView];
  }
  if(self.searchMainResultView)
    [self.searchMainResultView.view removeFromSuperview];
  if(self.searchVC)
    [self.searchVC.view removeFromSuperview];
  [SearchMainView  setRDVTabHidden:NO isAnimated:NO];
  self.navigationItem.titleView = self.searchBar;
}


#pragma searchBar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  [UIView animateWithDuration:0.2 animations:^{
    [self.searchBGVC.view  setAlpha:0.9];
  }completion:^(BOOL finished){
      [self.searchBar setShowsCancelButton:YES animated:YES];
  }];
  
  return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  if(self.searchBGVC)
  {
    [self dismissBackGroundView];
  }
  if(self.searchMainResultView)
    [self.searchMainResultView.view removeFromSuperview];
  if(self.searchVC)
    [self.searchVC.view removeFromSuperview];
  [SearchMainView  setRDVTabHidden:NO isAnimated:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  NSString  *searchString = self.searchBar.text;
  searchString  = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if([searchString isEqualToString:@""])
    return;
  else
  {
    NSArray *tagArray = [searchString componentsSeparatedByString:@" "];//根据空格分割字符串
    NSMutableArray  *searchTags     = [tagArray mutableCopy];
    NSMutableArray  *newSearchTags  = [[NSMutableArray alloc]init];
    
    for (NSString *string in searchTags)
    {
      if([string isEqualToString:@""])
        continue;
      [newSearchTags  addObject:string];
    }
    
    if(self.searchVC)
    {
      [self.searchVC.view  removeFromSuperview];
      self.searchVC = nil;
    }
    //增加自定义搜索框带关键字分割
    [self.customSearchBar initCustomSearchBarWithKeyWords:self.searchBar.text];
    self.navigationItem.titleView = self.customSearchBar.view;

    [self.searchMainResultView.view  removeFromSuperview];
    self.searchMainResultView  = nil;
    self.searchMainResultView = [[SearchMainResultView alloc]init];
    [self.searchMainResultView initSearchMainResultViewWithSearchTags:searchString withSearchTagsArray:newSearchTags];
    [self.searchMainResultView.view  setFrame:CGRectMake(0, self.searchBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-self.searchBar.frame.size.height-20)];
    [searchBar resignFirstResponder];
    [self enableCancelButton:self.searchBar];
    [self.view  addSubview:self.searchMainResultView.view];
    
    /*
    [[RACSignal merge:@[ [self requestSearchUsers:searchTags], [self requestSearchAlbumPhotos:searchTags] ]]
     subscribeCompleted:^{
       if(self.searchUsersResultArray ==  nil && self.searchPhotosResultArray ==  nil)
         return;
       else
       {
         [SearchMainView  setRDVTabHidden:YES isAnimated:YES];
         if(self.searchMainResultView  ==  nil)
         {
           self.searchMainResultView = [[SearchMainResultView alloc]init];
           [self.searchMainResultView initSearchMainResultViewWithUsersArray:self.searchUsersResultArray searchTotalNums:self.searchUsersTotalNums];
           [self.searchMainResultView initSearchMainResultViewWithAlbumPhotosArray:self.searchPhotosResultArray searchTotalNums:self.searchAlbumPhotosTotalNums];
           [self.searchMainResultView.view  setFrame:self.view.bounds];
           [[SearchMainView  getNavi] pushViewController:self.searchMainResultView animated:YES];
         }
         else
         {
           if(self.searchMainResultView)
             self.searchMainResultView =  nil;
           [[SearchMainView getNavi]popViewControllerAnimated:NO];
           self.searchMainResultView = [[SearchMainResultView alloc]init];
           [self.searchMainResultView initSearchMainResultViewWithUsersArray:self.searchUsersResultArray searchTotalNums:self.searchUsersTotalNums];
           [self.searchMainResultView initSearchMainResultViewWithAlbumPhotosArray:self.searchPhotosResultArray searchTotalNums:self.searchAlbumPhotosTotalNums];
           [self.searchMainResultView.view  setFrame:self.view.bounds];
           [[SearchMainView  getNavi] pushViewController:self.searchMainResultView animated:NO];
         }
       }
     }];
     */
    }
}

- (void)searchBar:(UISearchBar *)searchBar  textDidChange:(NSString *)searchText
{
  NSDate* dat               = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval nowSeconds =[dat timeIntervalSince1970]*1000 ;//毫秒数
  if(self.prevInputSearchStringTime==0)
    self.prevInputSearchStringTime  = nowSeconds;
  else  if(nowSeconds-self.prevInputSearchStringTime<500)//输入间隔小于0.5秒不进行搜索
  {
    self.prevInputSearchStringTime  = nowSeconds;
    return;
  }
  else
    self.prevInputSearchStringTime  = nowSeconds;
  [self settingTheSearchKeyWordsVC];
}

- (void) settingTheSearchKeyWordsVC
{
  NSString  *searchString = self.searchBar.text;
  searchString  = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if([searchString isEqualToString:@""])
  {
    if(self.searchVC)
    {
      [self.searchVC.view  removeFromSuperview];
      self.searchVC = nil;
    }
    
    return;
  }
  else
  {
    UIImage *image  = [[UIImage  alloc]init];
    CGRect  frameView = CGRectMake(0, self.searchBar.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-self.searchBar.frame.size.height-20);
    if(!self.searchVC)
    {
      image = [image  takeSnapshotFrameOfView:self.view WithFrame:frameView];
      image = [image  imageWithGaussianBlur:image];
      self.searchVC  = [[SearchKeyWordsVC  alloc]init];
      [self.searchVC initSearchKeyWordsVCWithSnapshot:image keyWords:searchString];
      [self.searchVC.view  setFrame:frameView];
      [self.view addSubview:self.searchVC.view];
    }
    else
    {
      [self.searchVC.view  removeFromSuperview];
      image = [image  takeSnapshotFrameOfView:self.view WithFrame:frameView];
      image = [image  imageWithGaussianBlur:image];
      self.searchVC  = [[SearchKeyWordsVC  alloc]init];
      [self.searchVC initSearchKeyWordsVCWithSnapshot:image keyWords:searchString];
      [self.searchVC.view  setFrame:frameView];
      //[self.searchVC setRefresh];
      [self.view addSubview:self.searchVC.view];
    }
  }
}

# pragma RACSignal
- (RACSignal*)requestSearchUsers  :(NSMutableArray*)searchTags
{
  RACSignal *requestSignal =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
    [[DouAPIManager sharedManager] request_SearchUsersWithPageNo: 1 page_size:pageSizeDefault tags:searchTags :^(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error)
     {
       if(usersData)
       {
         self.searchUsersResultArray  = usersData;
         self.searchUsersTotalNums  = totalSearchNums;
       }
       else
       {
         self.searchUsersResultArray  = nil;
         self.searchUsersTotalNums  = 0;
       }
     }];
    return nil;
  }];
  /*
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber){
      [[DouAPIManager sharedManager] request_SearchUsersWithSession:nil page_no:1 page_size:pageSizeDefault tags:searchTags :^(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error)
       {
         if(usersData)
         {
           self.searchUsersResultArray  = usersData;
           self.searchUsersTotalNums  = totalSearchNums;
         }
         else
         {
           self.searchUsersResultArray  = nil;
           self.searchUsersTotalNums  = 0;
         }
       }];
  }];
   */
  return requestSignal;
}

- (RACSignal*)requestSearchAlbumPhotos:(NSMutableArray*)searchTags
{
  //专辑图片搜索
  RACSignal *requestSignal =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
    [[DouAPIManager sharedManager] request_SearchPhotoWithPageNo  :1 page_size:pageSizeSearchAlbumPhoto tags:searchTags :^(NSMutableArray *photosData, NSInteger totalSearchNums, NSError *error)
     {
       if(photosData)
       {
         self.searchPhotosResultArray  = photosData;
         self.searchAlbumPhotosTotalNums  = totalSearchNums;
       }
       else
       {
         self.searchPhotosResultArray  = nil;
         self.searchAlbumPhotosTotalNums  = 0;
       }
     }];
        return nil;
  }];
    return requestSignal;
}

#pragma private method
/**
 *  @author J006, 15-07-10 16:07:24
 *
 *  设置专题搜索关键字并跳转
 *
 *  @param project
 */
- (void)  settingTheCurrentProjectToSearch  :(SearchProjectInstance*)project
{
  self.currentProject = project;
  NSString  *searchString = project.searchTags;
  NSArray *tagArray = [searchString componentsSeparatedByString:@" "];//根据空格分割字符串
  NSMutableArray  *searchTags = [tagArray mutableCopy];
  self.searchResultDetailView = [[SearchResultDetailView alloc]init];
  [self.searchResultDetailView   initSearchResultDetailViewWithOriginalSearchTags:searchTags searchTags:project.title searchType:ProjectSearchType];
  [self.searchResultDetailView   initTheProjectTitle:project.title];
  [self.searchResultDetailView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [self.navigationController  pushViewController:self.searchResultDetailView animated:YES];
}
/**
 *  @author J006, 15-08-05 16:07:24
 *
 *  跳转到有才华的摄影师
 *
 *  @param project
 */
- (void)  jumpToRecommendPhotographerView  :(SearchProjectInstance*)project
{
  RecommendPhotographerView *recommendPhotoView = [[RecommendPhotographerView  alloc]init];
  [recommendPhotoView initRecommendPhotographerViewWith:project.title];
  [recommendPhotoView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [SearchMainView naviPushViewController:recommendPhotoView];
}

#pragma getter setter
- (UITableView*)projectTableView
{
  if(_projectTableView  ==  nil)
  {
    _projectTableView= [[UITableView alloc]init];
    _projectTableView.delegate = self;
    _projectTableView.dataSource = self;
    _projectTableView.separatorColor = [UIColor  whiteColor];
    _projectTableView.backgroundColor  = [UIColor  whiteColor];
    [_projectTableView setTableHeaderView:self.headerView];
    [_projectTableView setTableFooterView:self.bottomView];
    _projectTableView.tableHeaderView.backgroundColor = [UIColor  whiteColor];
    _projectTableView.tableFooterView.backgroundColor = [UIColor  whiteColor];
    _projectTableView.sectionIndexBackgroundColor = [UIColor  whiteColor];
    _projectTableView.sectionIndexTrackingBackgroundColor = [UIColor  whiteColor];
    _projectTableView.sectionIndexColor = [UIColor  whiteColor];
    _projectTableView.backgroundView = [[UIView alloc]initWithFrame:_projectTableView.bounds];
    _projectTableView.backgroundView.backgroundColor = [UIColor  whiteColor];
  }
  return _projectTableView;
}

- (SearchBackGroundViewController*)searchBGVC
{
  if(_searchBGVC  ==  nil)
  {
    _searchBGVC= [[SearchBackGroundViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    [_searchBGVC  initSearchBackGroundView:^(id obj) {
      [weakSelf dismissBackGroundView];
    }];
  }
  return _searchBGVC;
}

- (UISearchBar*)searchBar
{
  if(_searchBar ==  nil)
  {
    _searchBar  = [[UISearchBar  alloc]init];
    [_searchBar setPlaceholder:@"搜索你喜欢的..."];
    _searchBar.translucent = YES;
    _searchBar.showsScopeBar = YES;
    [_searchBar resignFirstResponder];
    _searchBar.delegate  = self;
    _searchBar.delegate  = self;
    for (UIView* subview in [[_searchBar.subviews lastObject] subviews])
    {
      if ([subview isKindOfClass:[UITextField class]])
      {
        UITextField *textField = (UITextField*)subview;
        textField.textColor = [UIColor lightGrayColor];//修改输入字体的颜色
        [textField setBackgroundColor:[UIColor darkGrayColor]];//修改输入框的颜色
        [textField setFont:SourceHanSansNormal14];
        [textField setValue:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0 ]forKeyPath:@"_placeholderLabel.textColor"];   //修改placeholder的颜色
      }
    }
    _searchBar.barTintColor = [UIColor colorWithRed:41/255.0 green:42/255.0 blue:41/255.0 alpha:1.0];
  }
  return _searchBar;
}

- (UIView*)contentView
{
  if(_contentView ==  nil)
  {
    _contentView  = [[UIView alloc]init];
  }
  return _contentView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc]init];
    [_headerView setFrame:CGRectMake(0, 0, kScreen_Width, 20)];
  }
  return _headerView;
}

- (UIView*)bottomView
{
  if(_bottomView  ==  nil)
  {
    _bottomView = [[UIView alloc]init];
    [_bottomView setFrame:CGRectMake(0, 0, kScreen_Width, 55)];
  }
  return _bottomView;
}

- (CustomSearchBar*)customSearchBar
{
  if(_customSearchBar ==  nil)
  {
    _customSearchBar  = [[CustomSearchBar  alloc]init];
    _customSearchBar.delegate = self;
  }
  return _customSearchBar;
}

@end
