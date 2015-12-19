//
//  SettingTextViewController.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SettingTextViewController.h"
#import "UIBarButtonItem+Common.h"
#import "SettingTextViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "NSString+Common.h"

@interface SettingTextViewController ()
@property (strong,    nonatomic) UITableView           *myTableView;
@property (strong,    nonatomic) NSString              *myTextValue;

@property (strong,    nonatomic) NSString              *textValue;
@property (copy,      nonatomic) void(^doneBlock)      (NSString *textValue);
@property (assign,    nonatomic) SettingType           settingType;
@property (strong,    nonatomic) UIView               *headerView;//table顶部view

@property (readwrite, nonatomic) NSInteger            stringMaxLimitNums;

@property (readwrite, nonatomic) NSInteger            stringMinLimitNums;
@property (strong, nonatomic)    UIBarButtonItem      *doneButton;//完成按钮

@end

@implementation SettingTextViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationItem setRightBarButtonItem:self.doneButton animated:YES];
  [self.view addSubview:self.myTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init
- (void)  initTheSettingTextViewControllerWithTitle :(NSString*)title textValue:(NSString *)textValue :(SettingType)type  doneBlock:(void(^)(NSString *textValue))block
{
  self.title        = title;
  self.textValue    = textValue ? textValue : @"";
  self.doneBlock    = block;
  self.settingType  = type;
}

- (void)  setTextStringMaxLimit  :(NSInteger)limit
{
  self.stringMaxLimitNums  = limit;
}

- (void)  setTextStringMinLimit  :(NSInteger)limit
{
  self.stringMinLimitNums  = limit;
}

#pragma private methods

- (BOOL)checkInputTextValueIsLegalWithString  :(NSString*)inputString
{
  BOOL  isLegal = NO;
  if(!inputString)
    return NO;
  if(inputString.length>_stringMaxLimitNums || inputString.length<_stringMinLimitNums)
    return NO;
  isLegal = YES;
  /*
  if(_settingType ==  SettingTypeNickName)
  {
    isLegal = [inputString validateNickName];
  }
  else  if(_settingType == SettingTypeHostDomain)
  {
    isLegal = [inputString validateHostDomain];
  }
   */
  return isLegal;
}

- (BOOL)validateHostDomain  :(NSString*)inputString
{
  NSPredicate *hostTest     =  [NSPredicate predicateWithFormat:@"SELF MATCHES '^[a-zA-Z0-9][a-zA-Z0-9_-]+$'"];
  return  [hostTest evaluateWithObject:inputString];
}


#pragma event
- (void)doneBtnClicked:(id)sender
{
  if (self.doneBlock && _myTextValue)
  {
    BOOL  isLegal = NO;
    if(_settingType ==  SettingTypeNickName)
    {
      isLegal = [_myTextValue validateNickName];
      if(!isLegal)
      {
        UIAlertView *alertView  = [[UIAlertView  alloc]initWithTitle:@"" message:@"输入内容必须为英文字母数字与中文." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
      }
    }
    else  if(_settingType == SettingTypeHostDomain)
    {
      isLegal = [_myTextValue validateHostDomain];
      if(!isLegal)
      {
        UIAlertView *alertView  = [[UIAlertView  alloc]initWithTitle:@"" message:@"输入内容必须为英文字母与数字." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
      }
    }
    self.doneBlock(_myTextValue);
  }
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  SettingTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_SettingText forIndexPath:indexPath];
  if(_settingType == SettingTypeNickName || _settingType == SettingTypeHostDomain)
  {
    [cell setTextValue:_textValue isTextField:YES andTextChangeBlock:^(NSString *textValue)
    {
      self.myTextValue = textValue;
    }];
  }
  else  if(_settingType == SettingTypeHostDesc)
  {
    [cell setTextValue:_textValue isTextField:NO andTextChangeBlock:^(NSString *textValue) {
      self.myTextValue = textValue;
    }];
  }
  [cell  setTextStringMaxLimit:self.stringMaxLimitNums];
  [cell  setTextStringMinLimit:self.stringMinLimitNums];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(_settingType == SettingTypeNickName || _settingType == SettingTypeHostDomain)
    return 44;
  else
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma getter setter
- (UITableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = kColorTableSectionBg;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.tableHeaderView  = self.headerView;
    [_myTableView registerClass:[SettingTextViewCell class] forCellReuseIdentifier:kCellIdentifier_SettingText];
  }
  return _myTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    [_headerView setBackgroundColor:kColorTableSectionBg];
  }
  return _headerView;
}

- (UIBarButtonItem*)doneButton
{
  if(_doneButton  ==  nil)
  {
    _doneButton = [UIBarButtonItem itemWithBtnTitle:@"完成" target:self action:@selector(doneBtnClicked:)];
    RAC(self, doneButton.enabled) = [RACSignal combineLatest:@[RACObserve(self, myTextValue)] reduce:^id(NSString *myTextValue){
      return @([self checkInputTextValueIsLegalWithString:_myTextValue]);
    }];
  }
  return _doneButton;
}


@end
