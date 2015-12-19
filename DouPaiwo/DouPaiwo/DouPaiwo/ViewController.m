//
//  ViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "ViewController.h"
#import "PocketItemInstance.h"
#import "RootTabViewController.h"
#import "LoginViewController.h"
#import "SearchMainView.h"
#import "DouAPIManager.h"
#import "LoginInitViewController.h"

@interface ViewController ()

@property (nonatomic  ,strong)  RootTabViewController     *tabBarController;
@property (nonatomic  ,strong)  UINavigationController    *navi;
@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view    setBackgroundColor:[UIColor blackColor]];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)initViewController
{
  [self naviBarSetting];
  UIWindow * window = [[UIApplication sharedApplication] keyWindow];
  if(![DouAPIManager currentSessionData])
  {
    LoginInitViewController *loginVC = [[LoginInitViewController alloc] init];
    self.navi  = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self.navi setNavigationBarHidden:YES];
    [window setRootViewController:self.navi];
    //[loginVC moveAnimation];
  }
  else
  {
    self.tabBarController = [[RootTabViewController  alloc]init];
    window.rootViewController = [self.tabBarController  initPageToolBarView];
  }
}

/**
 *  @author J006, 15-06-02 11:06:53
 *
 *  navibar相关全局设置
 */
- (void)  naviBarSetting
{
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:41/255.0 green:42/255.0 blue:41/255.0 alpha:1.0]];
  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
  [UINavigationBar  appearance].barStyle = UIStatusBarStyleLightContent;
}

//- (void)  naviBarSetting
//{
//  [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
//  [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
//  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//  [UINavigationBar  appearance].barStyle = UIStatusBarStyleLightContent;
//}

- (void)viewDidAppear:(BOOL)animated
{
  [self initViewController];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
