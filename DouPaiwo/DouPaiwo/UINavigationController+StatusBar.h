//
//  UINavigationController+StatusBar.h
//  DouPaiwo
//
//  Created by J006 on 15/8/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (StatusBar)
- (UIStatusBarStyle)preferredStatusBarStyle;
-(UIViewController *)childViewControllerForStatusBarStyle;
-(UIViewController *)childViewControllerForStatusBarHidden;
@end
