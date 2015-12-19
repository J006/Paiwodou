//
//  FollowAndFansView.m
//  DouPaiwo
//
//  Created by J006 on 15/7/9.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "FollowAndFansView.h"
#import <MJRefresh.h>
#import "SearchResultDetailCell.h"
#import "DouAPIManager.h"
@interface FollowAndFansView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,readwrite) NSInteger                             usersTotalNums;//关注/粉丝数量
@property (nonatomic,strong)    NSMutableArray                        *usersArray;
@property (nonatomic,readwrite) UserFollowOrFan                       currenUserType;//当前为获取粉丝还是获取关注

@property (strong,nonatomic)    UITableView                           *userTableView;//用户列表容器
@property (strong,nonatomic)    MJRefreshAutoNormalFooter             *footerRefresher;//用户搜索刷新

@property (readwrite,nonatomic) NSInteger                             currentSearchPages;

@property (strong,nonatomic)    NSString                              *currentUserDomain;

@property (strong,nonatomic)    UIActivityIndicatorView               *activityIndicatorView;
@end

@implementation FollowAndFansView
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
  [self requetsToGetFollowOrFollowerUsers];
}

- (void)viewWillDisappear:(BOOL)animated
{
   if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
   {
     [[FollowAndFansView  getNavi]setNavigationBarHidden:YES animated:NO];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPersonalProfile" object:nil  userInfo:nil];
   }
  [super viewWillDisappear:animated];
}

#pragma init
- (void)initFollowAndFansViewWithUserDomain :(NSString*)userDomain  withTitle:(NSString*)title  withType:(UserFollowOrFan)userType
{
  self.title              = title;
  self.currentUserDomain  = userDomain;
  self.currenUserType     = userType;
  self.currentSearchPages = 1;
}

#pragma private methord
- (void)  requetsToGetFollowOrFollowerUsers
{
  [self.view  addSubview:self.activityIndicatorView];
  [self.activityIndicatorView  setCenter:self.view.center];
  [self.activityIndicatorView startAnimating];
  __weak typeof(self) weakSelf = self;
  if(self.currenUserType  ==  follow)
    [[DouAPIManager  sharedManager]request_GetFollowListWithDomain:self.currentUserDomain page_no:1 page_size:pageSizeDefault :^(NSMutableArray *followers, NSError *error) {
      [weakSelf.activityIndicatorView  stopAnimating];
      if(followers)
      {
        weakSelf.usersArray = followers;
        [weakSelf.userTableView  reloadData];
      }
    }];
  else  if(self.currenUserType  ==  fans)
    [[DouAPIManager  sharedManager]request_GetFollowerListWithDomain:self.currentUserDomain page_no:1 page_size:pageSizeDefault :^(NSMutableArray *fans, NSError *error) {
      [weakSelf.activityIndicatorView  stopAnimating];
      if(fans)
      {
        weakSelf.usersArray = fans;
        [weakSelf.userTableView  reloadData];
      }
    }];
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
    [cell initSearchResultDetailCellWithUserInstance:user:[FollowAndFansView getNavi]];
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
    _userTableView.tableFooterView = self.footerRefresher;
  }
  return _userTableView;
}

- (MJRefreshAutoNormalFooter*)footerRefresher
{
  if(_footerRefresher ==  nil)
  {
    __weak typeof(self) weakSelf = self;
    _footerRefresher  = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
      if(weakSelf.currenUserType  ==  follow)
        [[DouAPIManager  sharedManager]request_GetFollowListWithDomain:weakSelf.currentUserDomain page_no:weakSelf.currentSearchPages+1 page_size:pageSizeDefault :^(NSMutableArray *followers, NSError *error) {
          [weakSelf.footerRefresher endRefreshing];
          if(followers)
          {
            [weakSelf.usersArray addObjectsFromArray:followers];
            [weakSelf.userTableView  reloadData];
            weakSelf.currentSearchPages +=  1;
          }
          else
            [weakSelf.footerRefresher  setState:MJRefreshStateNoMoreData];
        }];
      else  if(weakSelf.currenUserType  ==  fans)
        [[DouAPIManager  sharedManager]request_GetFollowerListWithDomain:weakSelf.currentUserDomain page_no:weakSelf.currentSearchPages+1 page_size:pageSizeDefault :^(NSMutableArray *fans, NSError *error) {
          [weakSelf.footerRefresher endRefreshing];
          if(fans)
          {
            [weakSelf.usersArray addObjectsFromArray:fans];
            [weakSelf.userTableView  reloadData];
            weakSelf.currentSearchPages +=  1;
          }
          else
            [weakSelf.footerRefresher  setState:MJRefreshStateNoMoreData];
        }];
    }];
    [_footerRefresher setTitle:@"" forState:MJRefreshStateNoMoreData];
    [_footerRefresher setTitle:@"" forState:MJRefreshStateIdle];
    _footerRefresher.refreshingTitleHidden = YES;
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
