//
//  ProfileSettingView.m
//  DouPaiwo
//
//  Created by J006 on 15/7/28.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "ProfileSettingView.h"
#import "ProfileSettingCell.h"

#import "DouAPIManager.h"

@interface ProfileSettingView ()

@property (strong,  nonatomic)  UIView                  *headerView;//table顶部view
@property (nonatomic,strong)    UITableView             *myTableView;
@property (strong,  nonatomic)  UserInstance            *currentUser;
@property (strong,  nonatomic)  NSString                *domain;
@property (strong, nonatomic) UIActivityIndicatorView   *activityIndicatorView;
@end

@implementation ProfileSettingView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"账号安全";
  [self.view  addSubview:self.myTableView];
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  if(self.currentUser)
    [self.myTableView setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void) viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
  {
  }
  [super viewWillDisappear:animated];
}

#pragma init
- (void)initAccountSettingViewWithUser  :(UserInstance*)user;
{
  self.currentUser   =   user;
}

#pragma UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = 0;
  switch (section)
  {
    case 0:
      row = 3;
      break;
    default:
      row = 2;
      break;
  }
  return row;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  if(self.currentUser)
    return nil;
  CGFloat height  = 0;
  if(section  ==  1)
    height  = 20;
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
  headerView.backgroundColor  = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height  = 0;
  if(section  ==  1)
    height  = 20;
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
    return  45;
  else  if(indexPath.section == 1)
  {
    if(indexPath.row==1)
      return  120;
    else
      return  45;
  }
  else
    return  45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(!self.currentUser)
    return nil;
  ProfileSettingCell  *cell = [[ProfileSettingCell alloc]init];
  switch (indexPath.section)
  {
    case 0:
    {
      switch (indexPath.row)
      {
        case 0:
        {
          [cell  initProfileSettingCellWithTitile:@"电子邮件" value:self.currentUser.email];
          [cell  setHeight:45];
        }
          break;
        case 1:
        {
          [cell  initProfileSettingCellWithTitile:@"手机号码" value:self.currentUser.phone];
          [cell  setHeight:45];
        }
          break;
        default:
        {
          [cell  initProfileSettingCellWithTitile:@"修改密码" value:nil];
          [cell  setHeight:45];
        }
          break;
      }
    }
      break;
    default:
    {
      if(indexPath.row  ==  0)
      {
        [cell  initProfileSettingCellWithTitile:@"账号绑定" value:nil];
        [cell  setHeight:45];
      }
      else
      {
        [cell  initProfileSettingCellWithTitile:nil value:nil];
        [cell  setIsBindTheAccount:YES];
        [cell  setHeight:120];
      }
    }
      break;
  }
  return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.0;
}

#pragma getter setter
- (UITableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView                  = [[UITableView  alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor  = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _myTableView.dataSource       = self;
    _myTableView.delegate         = self;
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
    [_myTableView setSeparatorColor:[UIColor  colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]];
    _myTableView.tableHeaderView  = self.headerView;
  }
  return _myTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    [_headerView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
  }
  return _headerView;
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
