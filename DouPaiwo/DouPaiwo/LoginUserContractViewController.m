//
//  LoginUserContractViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/22.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import "LoginUserContractViewController.h"

@interface LoginUserContractViewController ()

@property (nonatomic,strong)    UIWebView                     *webView;

@end

@implementation LoginUserContractViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"用户协议";
  NSString* path = [[NSBundle mainBundle] pathForResource:@"protocol" ofType:@"html"];
  NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
  [self.webView loadHTMLString:content baseURL:[NSURL URLWithString:defaultMainUrl]];
  [self.view  addSubview:self.webView];
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  [self.webView                         setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super  viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma getter setter
- (UIWebView*)webView
{
  if(_webView ==  nil)
  {
    _webView  = [[UIWebView  alloc]init];
    _webView.backgroundColor  = kColorBackGround;
    _webView.delegate = self;
    _webView.scrollView.delegate  = self;
  }
  return _webView;
}

@end
