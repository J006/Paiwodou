//
//  PageToolBarViewController.m
//  TestPaiwo
//
//  Created by J006 on 15/4/21.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "RootTabViewController.h"
#import "SearchMainView.h"
#import "MainPage.h"
#import "InformationMainViewViewController.h"
#import "PMInformationInstance.h"
#import "PersonalProfile.h"
#import "DouAPIManager.h"
#import "SearchProjectInstance.h"
#import "InforMainViewController.h"
#import "UIImage+Common.h"
#import <RDVTabBarItem.h>

@interface RootTabViewController()

@property (strong,  nonatomic) MainPage                               *mainPage;//pocket,Photo主界面
@property (strong,  nonatomic) SearchMainView                         *searchMainView;//探索栏界面
@property (strong,  nonatomic) InformationMainViewViewController      *infoMainView;//消息界面
@property (strong,  nonatomic) InforMainViewController                *infoMainVC;//消息界面
@property (strong,  nonatomic) PersonalProfile                        *ppView;//个人界面/他人界面

@end

@implementation RootTabViewController
@synthesize isHiddenStatus,statusStyle;


/**
 *  @author J006, 15-05-09 15:05:11
 *
 *  初始化底部工具栏
 *
 *  @param mainPage 
 */
- (RootTabViewController*)initPageToolBarView
{
  self.statusStyle  = UIStatusBarStyleLightContent;
  [self setupViewControllers];
  self.delegate = self;
  return self;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
  return self.statusStyle;
}

- (BOOL)prefersStatusBarHidden
{
  return self.isHiddenStatus;
}


/**
 *  @author J006, 15-05-11 14:05:39
 *
 *  主界面,我的关注
 *
 *  @return 主界面,我的关注
 */
- (MainPage*) getMainPage
{
  _mainPage = [[MainPage alloc]init];
  [_mainPage.view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  
  [self.mainPage  initMainPage];
  return self.mainPage;
}

/**
 *  @author J006, 15-05-11 14:05:24
 *
 *  探索界面初始化
 *
 *  @return 探索界面对象
 */
- (SearchMainView*)getSearchMainView
{
    self.searchMainView = [[SearchMainView alloc]init];
    CGRect  frame = self.searchMainView.view.frame;
    frame.origin.x  = 0;
    frame.origin.y  = 0;
    frame.size.width  = kScreen_Width;
    frame.size.height = kScreen_Height;
    self.searchMainView.view.frame = frame;
    [self.searchMainView.view  setBackgroundColor:[UIColor whiteColor]];
    NSMutableArray  *array  = [[NSMutableArray alloc]initWithCapacity:8];
    for (NSInteger i=0; i<8; i++)
    {
      SearchProjectInstance *project  = [[SearchProjectInstance  alloc]init];
      NSString  *tempTitle;
      NSString  *tempSearchTags;
      NSString  *string   = [NSString stringWithFormat:@"projectSearchCell%ld.png",i+1];
      if(i==0)
      {
        tempTitle = @"那些有才华的摄影师";
        tempSearchTags  = @"摄影师";
      }
      else  if(i==1)
      {
        tempTitle = @"人像";
        tempSearchTags  = @"人像 写真 个人写真";
      }
      else  if(i==2)
      {
        tempTitle = @"日系";
        tempSearchTags  = @"日系 小清新 清新 JK DK";
      }
      else  if(i==3)
      {
        tempTitle = @"黑白";
        tempSearchTags  = @"黑白";
      }
      else  if(i==4)
      {
        tempTitle = @"东西";
        tempSearchTags  = @"静物 东西";
      }
      else  if(i==5)
      {
        tempTitle = @"情绪";
        tempSearchTags  = @"情绪 忧郁";
      }
      else  if(i==6)
      {
        tempTitle = @"人文";
        tempSearchTags  = @"人文";
      }
      else  if(i==7)
      {
        tempTitle = @"风景";
        tempSearchTags  = @"风光 风景";
      }
      [project  setTitle:tempTitle];
      [project  setSearchTags:tempSearchTags];
      [project  setMainImage:[UIImage  imageNamed:string]];
      [array  addObject:project];
    }
    [self.searchMainView  initSearchMainView  :array];
    return self.searchMainView;
}

/**
 *  @author J006, 15-05-18 13:05:36
 *
 *  消息界面
 *
 *  @return
 */
- (InformationMainViewViewController*)  getInformationMainView
{
  self.infoMainView = [[InformationMainViewViewController alloc]init];
  CGRect  frame = self.infoMainView.view.frame;
  frame.origin.x  = 0;
  frame.origin.y  = 20;
  frame.size.width  = kScreen_Width;
  frame.size.height = kScreen_Height-20;
  self.infoMainView.view.frame = frame;
  NSMutableArray  *pmArray  = [[NSMutableArray alloc]init];
  for (int i=0; i<10; i++)
  {
    PMInformationInstance *pm = [[PMInformationInstance  alloc]init];
    [pmArray  addObject:pm];
  }
  [self.infoMainView  initInformationMainView:pmArray];
  return self.infoMainView;
}

- (InforMainViewController*)  getInforMainViewController
{
  self.infoMainVC = [[InforMainViewController alloc]init];
  [self.infoMainVC.view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  return self.infoMainVC;
}

- (PersonalProfile*)  getPersonalProfile
{
  self.ppView = [[PersonalProfile  alloc]init];
  [self.ppView  initPersonalProfileWithUserDomain:nil isSelf:YES];
  [self.ppView  setValueIsNoNeedToBack:YES];
  return self.ppView;
}

#pragma tabarController delegate
/*
- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
  if(tabBarController.selectedIndex ==  0)
  {
    RootTabViewController *rootTabVC  = (RootTabViewController*)tabBarController;
    [rootTabVC.mainPage  scrollToTop];
  }
}
 */

- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
  if (tabBarController.selectedViewController == viewController) {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
      UINavigationController *nav = (UINavigationController *)viewController;
      if (nav.topViewController == nav.viewControllers[0]) {
        BaseViewController *rootVC = (BaseViewController *)nav.topViewController;
        if ([rootVC respondsToSelector:@selector(tabBarItemClicked)]) {
          [rootVC performSelector:@selector(tabBarItemClicked)];
        }
      }
    }
  }
  return YES;
}

/**
 *  @author J006, 15-05-11 14:05:45
 *
 *  底部工具栏初始化
 *
 *  @return 底部工具栏
 */
- (RootTabViewController*)setupViewControllers
{
  self.tabBar.frame = CGRectMake(0, kScreen_Height-pageToolBarHeight, kScreen_Width, pageToolBarHeight);
  UINavigationController  *nav_ppview = [[UINavigationController alloc]initWithRootViewController:[self getPersonalProfile]];
  [nav_ppview setNavigationBarHidden:YES];
  UINavigationController  *nav_mainpage = [[UINavigationController alloc]initWithRootViewController:[self getMainPage]];
  [nav_mainpage setNavigationBarHidden:YES];
  UINavigationController  *nav_inforMainVC = [[UINavigationController alloc]initWithRootViewController:[self getInforMainViewController]];
  [nav_inforMainVC setNavigationBarHidden:NO];
  UINavigationController  *nav_searchmainview = [[UINavigationController alloc]initWithRootViewController:[self getSearchMainView]];
  [nav_searchmainview setNavigationBarHidden:NO];
  [self setViewControllers:@[nav_mainpage,nav_searchmainview,nav_inforMainVC,nav_ppview]];
   
  //[self setViewControllers:@[[self getMainPage],[self getSearchMainView],[self getPersonalProfile]]];
  return [self customizeTabBarForController:self];
}

- (RootTabViewController*)customizeTabBarForController:(RootTabViewController *)tabBarController
{
  UIImage *finishedImage = [UIImage imageNamed:@"tabbar_select.png"];
  UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal.png"];
  [tabBarController.tabBar setHeight:49];
  NSInteger index = 0;
  tabBarController.tabBar.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
  CGRect  tabFrame  = CGRectMake(0, 0, tabBarController.tabBar.frame.size.width, tabBarController.tabBar.frame.size.height);
  UIImage *tabImage = [UIImage  imageWithColor:[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1] withFrame:tabFrame];
  UIImageView *tabBG  = [[UIImageView alloc]initWithImage:tabImage];
  [tabBG setFrame:tabFrame];
  [tabBarController.tabBar.backgroundView  addSubview:tabBG];
  [tabBarController.tabBar setTranslucent:YES];
  for (RDVTabBarItem *item in [[tabBarController tabBar] items])
  {
    [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
    [item setTitle:nil];
    UIImage *selectedimage;
    UIImage *unselectedimage;
    if(index==0)
    {
      unselectedimage = [UIImage imageNamed:@"home_normal.png"];
      selectedimage   = [UIImage imageNamed:@"home_select.png"];
      //[self setRDVTabItemHasAttentionIconWithItemIndex:0 hasAttentionIcon:YES attentionNums:99];
    }
    else  if(index==1)
    {
      unselectedimage = [UIImage imageNamed:@"search_normal.png"];
      selectedimage   = [UIImage imageNamed:@"search_select.png"];
    }
    else  if(index==2)
    {
      unselectedimage = [UIImage imageNamed:@"info_normal.png"];
      selectedimage   = [UIImage imageNamed:@"info_select.png"];
      [self setRDVTabItemHasAttentionIconWithItemIndex:2 hasAttentionIcon:YES attentionNums:0];
      
    }
    else  if(index==3)
    {
      unselectedimage = [UIImage imageNamed:@"profile_normal.png"];
      selectedimage   = [UIImage imageNamed:@"profile_select.png"];
    }
    [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
    index++;
  }
  return  tabBarController;
}

- (void)setRDVTabItemHasAttentionIconWithItemIndex :(NSInteger)itemIndex  hasAttentionIcon  :(BOOL)hasAttention attentionNums :(NSInteger)nums;
{
  NSInteger index = 0;
  for (RDVTabBarItem *item in [[self tabBar] items])
  {
    if(index  ==  itemIndex)
    {
      if(hasAttention)
      {
        if(nums==0)
        {
          [item  setBadgeBackgroundImage:[UIImage  imageNamed:@"infoNewAttention.png"]];
          [item  setBadgeTextFont:[UIFont systemFontOfSize:4]];
          [item  setBadgePositionAdjustment:UIOffsetMake(-2, 8)];
          [item  setBadgeValue:@" "];
        }
        else
        {
          [item  setBadgeBackgroundImage:[UIImage  imageNamed:@"infoNewAttention.png"]];
          [item  setBadgeTextFont:[UIFont systemFontOfSize:12]];
          [item  setBadgePositionAdjustment:UIOffsetMake(0, 2)];
          [item  setBadgeValue:[NSString  stringWithFormat:@"%ld",nums]];
        }
        
      }
      else
      {
        [item  setBadgeValue:@""];
      }

      return;
    }
    else
      index++;
  }
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
