//
//  AboutMainView.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "AboutMainView.h"
#import "LoginUserContractViewController.h"
#import <Masonry.h>

@interface AboutMainView ()

@property (strong,  nonatomic)  UIImageView           *topImageView;
@property (strong,  nonatomic)  UILabel               *versionInfo;//版本号
@property (strong,  nonatomic)  UIButton              *serviceBtn;//服务条款
@property (strong,  nonatomic)  UILabel               *copyRightInfo;//服务条款

@end

@implementation AboutMainView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"关于我们";
  [self.view setBackgroundColor:[UIColor colorWithRed:246/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
  [self.view   addSubview:self.topImageView];
  [self.view   addSubview:self.versionInfo];
  [self.view   addSubview:self.serviceBtn];
  [self.view   addSubview:self.copyRightInfo];
}

- (void)viewDidLayoutSubviews
{
  [self.view setFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, kScreen_Width, kScreen_Height-self.navigationController.navigationBar.frame.size.height)];
  
  [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(60);
    make.centerX.equalTo(self.view);
  }];
  [self.topImageView sizeToFit];
  
  [self.versionInfo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.topImageView.mas_bottom).offset(15);
    make.centerX.equalTo(self.view);
  }];
  
  [self.copyRightInfo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.view).offset(-20);
    make.centerX.equalTo(self.view);
  }];
  
  [self.copyRightInfo sizeToFit];
  
  [self.serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.copyRightInfo.mas_top).offset(-17);
    make.centerX.equalTo(self.view);
  }];
  
  [self.serviceBtn sizeToFit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma event
- (void)jumpToServiceAction
{
  LoginUserContractViewController *contract = [[LoginUserContractViewController  alloc]init];
  [AboutMainView naviPushViewController:contract];
}

#pragma getter setter
- (UILabel*)copyRightInfo
{
  if(_copyRightInfo  ==  nil)
  {
    _copyRightInfo = [[UILabel  alloc]init];
    [_copyRightInfo  setText:@"Copyright © 2015 捕光捉影"];
    [_copyRightInfo  setTextAlignment:NSTextAlignmentCenter];
    [_copyRightInfo  setFont:[UIFont systemFontOfSize:10]];
    [_copyRightInfo  setTextColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0]];
  }
  return _copyRightInfo;
}

- (UIImageView*)topImageView
{
  if(_topImageView  ==  nil)
  {
    _topImageView = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"poAboutIcon"]];
  }
  return _topImageView;
}

- (UILabel*)versionInfo
{
  if(_versionInfo ==  nil)
  {
    _versionInfo  = [[UILabel  alloc]init];
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    version = [@"Po V" stringByAppendingString:version];
    [_versionInfo  setText:version];
    [_versionInfo  setTextAlignment:NSTextAlignmentCenter];
    [_versionInfo  setFont:SourceHanSansNormal13];
    [_versionInfo  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
  return _versionInfo;
}

- (UIButton*)serviceBtn
{
  if(_serviceBtn  ==  nil)
  {
    _serviceBtn = [[UIButton alloc]init];
    [_serviceBtn setTitle:@"服务条款" forState:UIControlStateNormal];
    [_serviceBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:197/255.0 blue:85/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_serviceBtn.titleLabel  setFont:SourceHanSansNormal12];
    [_serviceBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [_serviceBtn addTarget:self action:@selector(jumpToServiceAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _serviceBtn;
}

@end
