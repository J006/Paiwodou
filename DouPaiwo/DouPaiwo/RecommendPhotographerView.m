//
//  RecommendPhotographerView.m
//  DouPaiwo
//
//  Created by J006 on 15/8/5.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "RecommendPhotographerView.h"
#import <MJRefresh.h>
#import "DouAPIManager.h"
#import "SearchResultDetailCell.h"
@interface RecommendPhotographerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)    NSMutableArray                        *usersArray;

@property (strong,nonatomic)    UITableView                           *userTableView;//用户列表容器
@property (strong,nonatomic)    MJRefreshAutoNormalFooter             *footerRefresher;//用户搜索刷新

@property (readwrite,nonatomic) NSInteger                             currentSearchPages;

@property (strong,nonatomic)    NSString                              *currentUserDomain;

@property (strong,nonatomic)    UIActivityIndicatorView               *activityIndicatorView;
@end

@implementation RecommendPhotographerView

#pragma life cycle
- (void)viewDidLoad
{
  [super          viewDidLoad];
  [self.view      addSubview:self.userTableView];
}

- (void)viewDidLayoutSubviews
{
  [super                viewDidLayoutSubviews];
  [self.view            setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [self.userTableView   setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
}

- (void)viewDidAppear:(BOOL)animated
{
  [self requetsToGetRecommendPhotographer];
}

- (void)viewWillAppear:(BOOL)animated
{
  [RecommendPhotographerView setRDVTabHidden:YES isAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [RecommendPhotographerView setRDVTabHidden:NO isAnimated:NO];
}

#pragma init

- (void)initRecommendPhotographerViewWith :(NSString*)title
{
  self.title  = title;
}

#pragma private methord
- (void)  requetsToGetRecommendPhotographer
{
  [self.view  addSubview:self.activityIndicatorView];
  [self.activityIndicatorView  setCenter:self.view.center];
  [self.activityIndicatorView startAnimating];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   __weak typeof(self) weakSelf = self;
                   [[DouAPIManager  sharedManager]request_GetRecommendUser:^(NSMutableArray *array, ErrorInstnace *error) {
                     if(!array)
                       return;
                     dispatch_sync(dispatch_get_main_queue(), ^{
                      [weakSelf.activityIndicatorView stopAnimating];
                       weakSelf.usersArray = array;
                       [weakSelf.userTableView  reloadData];
                     });

                   }];
                 });
}

#pragma Tablview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = 0;
  if(section  ==  0 &&  self.usersArray)
    row = [self.usersArray count];
  return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section==0 && self.usersArray)
  {
    SearchResultDetailCell *cell = [[SearchResultDetailCell  alloc]init];
    UserInstance  *user = [self.usersArray objectAtIndex:indexPath.row];
    [cell initSearchResultDetailCellWithUserInstance:user:[RecommendPhotographerView getNavi]];
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
  float height=70;
  if (indexPath.section==0)
    height  = 70;
  return  height;
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
    [_userTableView.tableHeaderView  setBackgroundColor:[UIColor lightGrayColor]];
    _userTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_userTableView.tableFooterView = self.footerRefresher;
  }
  return _userTableView;
}

- (MJRefreshAutoNormalFooter*)footerRefresher
{
  if(_footerRefresher ==  nil)
  {
    //__weak typeof(self) weakSelf = self;
    _footerRefresher  = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{

    }];
    [_footerRefresher setTitle:kMJRefreshNomoreUser forState:MJRefreshStateNoMoreData];
  }
  return _footerRefresher;
}

- (UIActivityIndicatorView*)activityIndicatorView
{
  if(_activityIndicatorView ==  nil)
  {
    _activityIndicatorView  = [[UIActivityIndicatorView  alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  }
  return _activityIndicatorView;
}
@end
