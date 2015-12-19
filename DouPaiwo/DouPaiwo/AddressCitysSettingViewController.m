//
//  AddressCitysSettingViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/16.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "AddressCitysSettingViewController.h"
#import "AddressSettingViewCellTableViewCell.h"
#import "AddressManager.h"
#import "SettingAccountView.h"
#import <Masonry.h>
#define headViewForSectionHeight  45;
@interface AddressCitysSettingViewController ()

@property (strong,    nonatomic)UITableView       *myTableView;
@property (strong,    nonatomic)UIView            *footerView;//table底部view
@property (strong,    nonatomic)NSMutableArray    *cityCodeArray;//城市code数组
@property (strong,    nonatomic)NSMutableArray    *cityNameArray;//城市名称数组
@property (strong,    nonatomic)UserInstance      *currentUser;
@property (nonatomic, copy) void(^backAction)(id);

@end

@implementation AddressCitysSettingViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"居住地";
  [self.view  addSubview:self.myTableView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.myTableView  setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma init
- (void)initAddressCitysWithCitysDic  :(NSDictionary*)citysDic  user:(UserInstance*)user
{
  if(!citysDic || !user)
    return;
  self.currentUser    = user;
  self.cityCodeArray  = [[NSMutableArray alloc]init];
  self.cityNameArray  = [[NSMutableArray alloc]init];
  for (NSString *keyCode in citysDic)
  {
    [self.cityCodeArray addObject:keyCode];
    [self.cityNameArray addObject:[citysDic objectForKey:keyCode]];
  }
}

- (void)addBackBlock:(void(^)(id obj))backAction
{
  self.backAction = backAction;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger row = 0;
  switch (section) {
    default:
      row = [self.cityCodeArray  count];
      break;
  }
  return row;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return  45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  AddressSettingViewCellTableViewCell *cell   = [[AddressSettingViewCellTableViewCell  alloc]init];
  switch (indexPath.section) {
    default:
    {
      NSString  *cityName         = [self.cityNameArray objectAtIndex:indexPath.row];
      cell.hasSecondLevelToChoose = YES;
      [cell  initAddressSettingViewCellTableViewCellWithTitle:cityName];
    }
      break;
  }
  [cell  setHeight:45];
  return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    default:
    {
      self.currentUser.address  = [self.cityCodeArray objectAtIndex:indexPath.row];
      if(_backAction)
        self.backAction(self.currentUser);
      [AddressCitysSettingViewController popToTheUIViewController:[SettingAccountView class]];
    }
      break;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat height  = headViewForSectionHeight;
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
  headerView.backgroundColor  = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
  UILabel   *contentLabel = [[UILabel  alloc]init];
  [contentLabel  setFont:SourceHanSansLight12];
  [contentLabel  setTextColor:[UIColor  colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  [contentLabel  setBackgroundColor:[UIColor clearColor]];
  [contentLabel  setText:@"全部"];
  [headerView addSubview:contentLabel];
  [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(headerView).offset(25);
    make.bottom.equalTo(headerView);
    make.size.mas_equalTo(CGSizeMake(200, 20));
  }];
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height  = headViewForSectionHeight;
  return height;
}

#pragma getter setter
- (UITableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView    = [[UITableView  alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];//UITableViewStyleGrouped使得headerViewForSection不会有黏性
    _myTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.tableFooterView  = self.footerView;
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
    [_myTableView setSeparatorColor:[UIColor  colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]];
    [_myTableView registerClass:[AddressSettingViewCellTableViewCell class] forCellReuseIdentifier:kCellIdentifier_TitleDisclosure];
  }
  return _myTableView;
}

- (UIView*)footerView
{
  if(_footerView  ==  nil)
  {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 45)];
  }
  return _footerView;
}

@end
