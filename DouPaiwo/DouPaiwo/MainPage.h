//
//  MainPage.h
//  TestPaiwo
//  首页主要界面
//  Created by J006 on 15/4/22.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PocketItemInstance.h"
#import "BaseViewController.h"
#import "PocketAndPhotoView.h"
#define kMainPageSmallFontSize 10
#define kMainPageMiddleFontSize 12
#define kMainPageBigFontSize 18
@interface MainPage : BaseViewController<UIScrollViewDelegate,PocketAndPhotoViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, readwrite)  BOOL              isRefresh;
@property (nonatomic, readwrite)  BOOL              canLoadMore;
/**
 *  @author J.006, 15-11-01 14:11:43
 *
 *  <#Description#>
 */
- (void)  initMainPage;

@end
