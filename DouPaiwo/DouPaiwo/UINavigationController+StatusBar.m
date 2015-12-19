//
//  UINavigationController+StatusBar.m
//  DouPaiwo
//
//  Created by J006 on 15/8/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "UINavigationController+StatusBar.h"

@implementation UINavigationController (StatusBar)


- (UIStatusBarStyle)preferredStatusBarStyle
{
  return [[self topViewController] preferredStatusBarStyle];
}

-(UIViewController *)childViewControllerForStatusBarStyle
{
  return self.topViewController;
}

-(UIViewController *)childViewControllerForStatusBarHidden
{
  return self.topViewController;
}



@end
