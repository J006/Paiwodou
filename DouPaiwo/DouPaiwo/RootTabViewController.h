//
//  PageToolBarViewController.h
//  TestPaiwo
//
//  Created by J006 on 15/4/21.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RDVTabBarController.h>

@interface RootTabViewController : RDVTabBarController<RDVTabBarControllerDelegate>

@property (readwrite,nonatomic) BOOL              isHiddenStatus;
@property (readwrite,nonatomic) UIStatusBarStyle  statusStyle;

- (RootTabViewController*)initPageToolBarView;

- (void)setRDVTabItemHasAttentionIconWithItemIndex :(NSInteger)itemIndex  hasAttentionIcon  :(BOOL)hasAttention attentionNums :(NSInteger)nums;

@end
