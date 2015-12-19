//
//  InforMainViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/8.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "InforMainViewController.h"

@interface InforMainViewController ()

@property (strong,  nonatomic)  UITableView       *myTableView;


@end

@implementation InforMainViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"消息";
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
  [[InforMainViewController getNavi].navigationBar setTintColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0]];
  [[InforMainViewController getNavi].navigationBar setBarTintColor:[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]];
  [[InforMainViewController getNavi].navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
  [InforMainViewController setRDVTabStatusStyleDirect:UIStatusBarStyleDefault];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
