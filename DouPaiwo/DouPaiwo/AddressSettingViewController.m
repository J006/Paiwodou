//
//  AddressSettingViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "AddressSettingViewController.h"
#import "AddressSettingViewCellTableViewCell.h"
#import "AddressManager.h"
#import <Masonry.h>
#import "AddressCitysSettingViewController.h"
#define headViewForSectionHeight  45;
@interface AddressSettingViewController ()

@property (strong,    nonatomic)  UITableView                       *myTableView;
@property (strong,    nonatomic)  UIView                            *footerView;//table底部view
@property (strong,    nonatomic)  NSString                          *currentCityCode;
@property (strong,    nonatomic)  NSMutableArray                    *provinceCodeArray;//省份code数组
@property (strong,    nonatomic)  NSMutableArray                    *provinceNameArray;//省份名称数组
@property (strong,    nonatomic)  UserInstance                      *user;
@property (strong,    nonatomic)  AddressCitysSettingViewController *addressCitys;
@property (nonatomic, copy) void(^backAction)(id);

@end

@implementation AddressSettingViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"居住地";
  [self.view  addSubview:self.myTableView];
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  [self.myTableView  setFrame:self.view.bounds];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super  viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewWillDisappear:(BOOL)animated
{

}

- (void)viewDidDisappear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma init
- (void)initAddressSettingVCWithCurrentCityCode :(NSString*)code  user:(UserInstance*)user
{
  self.currentCityCode    =   code;
  self.user               =   user;
  self.provinceCodeArray  =   [AddressManager provinceCodeArray];
  self.provinceNameArray  =   [AddressManager provinceNameArray];
}

- (void)addBackBlock:(void(^)(id obj))backAction
{
  self.backAction = backAction;
}


#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = 0;
  switch (section) {
    case 0:
      row = 1;
      break;
    default:
      row = [self.provinceNameArray count];
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
    case 0:
    {
      NSString  *cityName     = [AddressManager getCityNameWithCityCode:self.currentCityCode];
      NSString  *provinceName = [AddressManager getProvinceNameWithCityCode:self.currentCityCode];
      [cell  initAddressSettingViewCellTableViewCellWithTitle:[[provinceName  stringByAppendingString:@" "]stringByAppendingString:cityName]];
    }
      break;
    default:
    {
      NSString  *provinceName       = [self.provinceNameArray objectAtIndex:indexPath.row];
      NSString  *currenProvinceName = [AddressManager getProvinceNameWithCityCode:self.currentCityCode];
      if([provinceName isEqualToString:currenProvinceName])
        cell.isSelected = YES;
      if([AddressManager getCitysInProvinceWithCode:[self.provinceCodeArray objectAtIndex:indexPath.row]])
        cell.hasSecondLevelToChoose = YES;
      [cell  initAddressSettingViewCellTableViewCellWithTitle:provinceName];
    }
      break;
  }
  [cell  setHeight:45];
  return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (indexPath.section) {
    case 0:
    {
      [self.navigationController  popViewControllerAnimated:YES];
    }
      break;
    default:
    {
      NSDictionary  *citysDic = [AddressManager getCitysInProvinceWithCode:[self.provinceCodeArray objectAtIndex:indexPath.row]];
      if(!citysDic)
      {
        self.user.address = [self.provinceCodeArray objectAtIndex:indexPath.row];
        self.backAction(self.user);
        [self.navigationController  popViewControllerAnimated:YES];
        return;
      }
      
      self.addressCitys = [[AddressCitysSettingViewController  alloc]init];
      [self.addressCitys initAddressCitysWithCitysDic:citysDic user:self.user];
      [self.addressCitys addBackBlock:self.backAction];
      [AddressSettingViewController naviPushViewController:self.addressCitys];
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
  if(section  ==  0)
    [contentLabel  setText:@"已选中的位置"];
  else if(section  ==  1)
    [contentLabel  setText:@"国内"];
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
