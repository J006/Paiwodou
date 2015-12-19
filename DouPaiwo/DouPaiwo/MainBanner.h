//
//  MainBanner.h
//  TestPaiwo
//
//  Created by J006 on 15/4/22.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface MainBanner : BaseViewController<UIScrollViewDelegate>

/**
 *  @author J006, 15-06-09 10:06:33
 *
 *  初始化banner
 *
 *  @param array 封面背景图的对象集合:目前是Pocket列表
 */
- (void)initMainBannerWithSingleBanner  :(NSMutableArray*)array;

@end
