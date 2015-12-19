//
//  RegisterViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/7/1.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewCell.h"
#import "RegisterInstance.h"
#import "TPKeyboardAvoidingTableView.h"
#import "RootTabViewController.h"
#import "NSString+Common.h"
#import "DouAPIManager.h"
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "UITTTAttributedLabel.h"
#import "UIBarButtonItem+Common.h"
#import "NSString+Common.h"
#import "LoginUserContractViewController.h"
#import "LoginViewController.h"

@interface RegisterViewController ()<TTTAttributedLabelDelegate>

@property (strong,    nonatomic)     RegisterInstance             *myRegister;//注册实例对象
@property (strong,    nonatomic)     UIActivityIndicatorView      *activityIndicator;//下一步转圈
@property (strong,    nonatomic)     UIButton                     *nextBtn;//下一步按钮
@property (strong,    nonatomic)     UIView                       *bottomView;//底部view:下一步,兜用户服务协议
@property (strong,    nonatomic)     UITTTAttributedLabel         *contractLabel;//服务条款
@property (strong,    nonatomic)     TPKeyboardAvoidingTableView  *myTableView;
@property (strong,    nonatomic)     UIView                       *headerView;//table顶部view
@property (strong,    nonatomic)     UIBarButtonItem              *loginBtn;

@end

@implementation RegisterViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"手机注册";
  [self.navigationItem setRightBarButtonItem:self.loginBtn animated:YES];
  self.myRegister = [[RegisterInstance alloc]init];
  [self.view  addSubview:self.myTableView];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.myTableView             setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [[RegisterViewController getNavi] setNavigationBarHidden:NO];
  [[RegisterViewController getNavi].navigationBar setTintColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0]];
  [[RegisterViewController getNavi].navigationBar setBarTintColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
  [[RegisterViewController getNavi].navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  RegisterViewCell   *cell = [[RegisterViewCell  alloc]init];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  __weak typeof(self) weakSelf = self;
  if(indexPath.section==0)
  {
    [cell configWithPlaceholder:@"手机号" valueStr:self.myRegister.phone  textfieldType:type_phone];
    cell.textValueChangedBlock = ^(NSString *valueStr)
    {
      weakSelf.myRegister.phone = valueStr;
    };
    [cell setHeight:40];
  }
  else  if(indexPath.section==1)
  {
    [cell configWithPlaceholder:@"验证码" valueStr:self.myRegister.j_captcha textfieldType:type_captcha];
    cell.textValueChangedBlock = ^(NSString *valueStr)
    {
      weakSelf.myRegister.j_captcha = valueStr;
    };
    [cell setHeight:40];
  }
  else
  {
    [cell configWithPlaceholder:@"密码" valueStr:self.myRegister.password textfieldType:type_password];
    cell.textValueChangedBlock = ^(NSString *valueStr)
    {
      weakSelf.myRegister.password = valueStr;
    };
    [cell setHeight:40];
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
  
  //Set the background color of the View
  view.tintColor = [UIColor whiteColor];
  
  //Set the TextLabel Color
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  [header.textLabel setTextColor:[UIColor whiteColor]];
  
}

#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components
{
  if ([[components objectForKey:@"actionStr"] isEqualToString:@"gotoServiceTermsVC"])
  {
    [self gotoServiceTermsVC];
  }
}

- (void)gotoServiceTermsVC
{
  LoginUserContractViewController *contract = [[LoginUserContractViewController  alloc]init];
  [RegisterViewController naviPushViewController:contract];
}

#pragma event
- (void)jumpToLoginVC
{
  LoginViewController *loginVC  = [[LoginViewController  alloc]init];
  [RegisterViewController naviPushViewController:loginVC];
}


#pragma getter setter

- (UIActivityIndicatorView*)activityIndicator
{
  if(_activityIndicator ==  nil)
  {
    _activityIndicator = [[UIActivityIndicatorView alloc]
                          initWithActivityIndicatorStyle:
                          UIActivityIndicatorViewStyleGray];
    CGSize nextButtonSize = self.nextBtn.bounds.size;
    _activityIndicator.hidesWhenStopped = YES;
    [_activityIndicator setCenter:CGPointMake(nextButtonSize.width/2, nextButtonSize.height/2)];
  }
  return _activityIndicator;
}

- (UIButton*)nextBtn
{
  if(_nextBtn  ==  nil)
  {
    _nextBtn = [[UIButton alloc]init];
    [_nextBtn    setBackgroundImage:[UIImage imageNamed:@"nextStepButton.png"] forState:UIControlStateNormal];
    [_nextBtn    setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn    setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn.titleLabel setFont:SourceHanSansNormal16];
    [_nextBtn   setFrame:CGRectMake(40, 0, kScreen_Width-80, 40)];
    //[_nextBtn  addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    RAC(self, nextBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, myRegister.phone), RACObserve(self, myRegister.password)] reduce:^id(NSString *phone, NSString *password){
      return @((_myRegister.phone && _myRegister.phone.length>0 && [_myRegister.phone validatePhone]) && (_myRegister.password && _myRegister.password.length > 0) && (_myRegister.j_captcha && _myRegister.j_captcha.length > 0));
    }];
  }
  return _nextBtn;
}

- (UIView*)bottomView
{
  if(_bottomView  ==  nil)
  {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:self.nextBtn];
    [_bottomView addSubview:self.contractLabel];
    [_contractLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(300, 20));
      make.centerX.equalTo(_bottomView);
      make.top.equalTo(_nextBtn.mas_bottom);
    }];

  }
  return _bottomView;
}

- (UITTTAttributedLabel*)contractLabel
{
  if(_contractLabel ==  nil)
  {
    _contractLabel  =  [[UITTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    _contractLabel.textAlignment = NSTextAlignmentCenter;
    _contractLabel.font = SourceHanSansNormal11;
    _contractLabel.textColor = [UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0];
    _contractLabel.numberOfLines = 0;
    _contractLabel.linkAttributes = kLinkAttributes;
    _contractLabel.activeLinkAttributes = kLinkAttributesActive;
    _contractLabel.delegate = self;
    NSString *tipStr = @"点击下一步即表示您同意Po用户服务协议";
    _contractLabel.text = tipStr;
    [_contractLabel addLinkToTransitInformation:@{@"actionStr" : @"gotoServiceTermsVC"} withRange:[tipStr rangeOfString:@"Po用户服务协议"]];
  }
  return _contractLabel;
}

- (TPKeyboardAvoidingTableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView  = [[TPKeyboardAvoidingTableView  alloc]init];
    [_myTableView setBackgroundColor:kColorBackGround];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView  setTableFooterView:self.bottomView];
    [_myTableView  setTableHeaderView:self.headerView];
    _myTableView.contentInset = UIEdgeInsetsMake(-kHigher_iOS_6_1_DIS(20), 0, 0, 0);
  }
  return _myTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 68)];
  }
  return _headerView;
}

- (UIBarButtonItem*)loginBtn
{
  if(_loginBtn  ==  nil)
  {
    _loginBtn = [UIBarButtonItem itemWithBtnTitle:@"登录" target:self action:@selector(jumpToLoginVC)];
    NSDictionary* barButtonItemAttributes =@{NSFontAttributeName:
                                               SourceHanSansNormal15,
                                             NSForegroundColorAttributeName:
                                               [UIColor colorWithRed:46.0/255 green:216.0/255 blue:136.0/255 alpha:1.0]
                                             };
    [_loginBtn setTitleTextAttributes:barButtonItemAttributes forState:UIControlStateNormal];
  }
  return _loginBtn;
}

@end
