//
//  SettingView.m
//  TestPaiwo
//
//  Created by J006 on 15/5/19.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SettingView.h"
#import "ProfileSettingView.h"
#import "SettingCell.h"
#import "SettingAccountView.h"
#import "PushSettingView.h"
#import <Masonry.h>
#import "DouAPIManager.h"
#import "LoginInitViewController.h"
#import "LoginViewController.h"
#import "AboutMainView.h"

#define topViewButtonDistanceX 8
#define topViewButtonDistanceY 19
#define kPaddingLeftWidth 15.0
#define kSettingPaddingLeftWidth 18.0

@interface SettingView ()

@property (strong,  nonatomic)  UITableView                           *myTableView;
@property (strong,  nonatomic)  UserInstance                          *myUser;
@property (strong,  nonatomic)  UIView                                *headerView;//table顶部view
@property (strong,  nonatomic)  UIView                                *footerView;//table底部view
@property (strong,  nonatomic)  UIButton                              *loginBtn;//登录按钮
@property (strong,  nonatomic)  SettingAccountView                    *settingAccountView;
@property (strong,  nonatomic)  ProfileSettingView                    *profileSettingView;
@property (strong,  nonatomic)  UIAlertView                           *alertViewForCleanMemory;
@property (strong,  nonatomic)  UIAlertView                           *alertViewForLogOut;

@end

@implementation SettingView

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view        addSubview:self.myTableView];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager]request_GetUserInfo:^(UserInstance *userInstance, ErrorInstnace *error) {
                     if(!userInstance)
                       return;
                     weakSelf.myUser.host_name = userInstance.host_name;
                     weakSelf.myUser.host_desc = userInstance.host_desc;
                     weakSelf.myUser.host_avatar = userInstance.host_avatar;
                     weakSelf.myUser.host_domain = userInstance.host_domain;
                     weakSelf.myUser.host_gender = userInstance.host_gender;
                     weakSelf.myUser.birthday = userInstance.birthday;
                     weakSelf.myUser.address = userInstance.address;
                     weakSelf.myUser.qq = userInstance.qq;
                     weakSelf.myUser.weixin = userInstance.weixin;
                     weakSelf.myUser.weibo = userInstance.weibo;
                     dispatch_sync(dispatch_get_main_queue(), ^{
                       [weakSelf.myTableView  reloadData];
                     });
                   }];
                   
                 });
  

}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.myTableView setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
  [super viewWillAppear:animated];
  [self.myTableView reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
  {
    [[SettingView  getNavi]setNavigationBarHidden:YES];
    [SettingView  setRDVTabHidden:NO isAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPersonalProfile" object:nil  userInfo:nil];
  }
  [super viewWillDisappear:animated];
}

#pragma init
- (void)initSettingView :(UserInstance*)myUser
{
  self.title  = @"设置";
  _myUser = myUser;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = 0;
  switch (section) {
    case 0:
      row = 1;
      break;
    case 1:
      row = 3;
      break;
    case 2:
      row = 1;
      break;
      /*
    case 3:
      row = 1;
       */
    default:
      row = 1;
      break;
  }
  return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(!self.myUser)
    return nil;
  SettingCell *cell   = [[SettingCell  alloc]init];
  switch (indexPath.section)
  {
    case 0:
      switch (indexPath.row)
    {
      default:
      {
        NSURL *url  = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.myUser.host_avatar]];
        NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansMedium16,NSFontAttributeName, [UIColor blackColor],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrHostName = [[NSMutableAttributedString  alloc]initWithString:self.myUser.host_name attributes:attributeDict];
        [cell initSettingCellWithTitle:attrHostName imageUrl:url];
        [cell setIsNeedDoAddBottomLine  :YES];
        [cell setIsNeedDoAddTopLine     :YES];
        [cell setHeight:80];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
    }
      break;
    case 1:
      switch (indexPath.row)
    {
      case 0:
      {
        NSDictionary *attributeAccountDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrAccoutSafe = [[NSMutableAttributedString  alloc]initWithString:@"账号安全" attributes:attributeAccountDict];
        [cell initSettingCellWithTitle:attrAccoutSafe imageUrl:nil];
        [cell setIsNeedDoAddTopLine     :YES];
        [cell setHeight:45];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
      case 1:
      {
        NSDictionary *attributeInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrAccoutInfo = [[NSMutableAttributedString  alloc]initWithString:@"消息推送" attributes:attributeInfoDict];
        [cell initSettingCellWithTitle:attrAccoutInfo imageUrl:nil];
        [cell setHeight:45];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
      default:
      {
        NSDictionary *attributeAboutDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrAbout = [[NSMutableAttributedString  alloc]initWithString:@"关于Po" attributes:attributeAboutDict];
        [cell initSettingCellWithTitle:attrAbout  imageUrl:nil];
        [cell setIsNeedDoAddBottomLine  :YES];
        [cell setHeight:45];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
    }
      break;
    case 2:
      //switch (indexPath.row)
    {
        /*
      case 0:
      {
        NSDictionary *attributeKanKanDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrKanKan = [[NSMutableAttributedString  alloc]initWithString:@"看看谁在这儿" attributes:attributeKanKanDict];
        [cell initSettingCellWithTitle:attrKanKan imageUrl:nil];
        [cell setIsNeedDoAddTopLine     :YES];
        [cell setHeight:45];
      }
        break;
      case 1:
      {
        NSDictionary *attributeLikeDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrLike = [[NSMutableAttributedString  alloc]initWithString:@"喜欢Po吗?去评个分吧" attributes:attributeLikeDict];
        [cell initSettingCellWithTitle:attrLike imageUrl:nil];
        [cell setHeight:45];
      }
        break;
      case 2:
      {
        NSDictionary *attributeBackDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrBack = [[NSMutableAttributedString  alloc]initWithString:@"建议反馈" attributes:attributeBackDict];
        [cell initSettingCellWithTitle:attrBack imageUrl:nil];
        [cell setHeight:45];
      }
        break;
         
      default:
      {
        NSDictionary *attributeAboutDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrAbout = [[NSMutableAttributedString  alloc]initWithString:@"关于Po" attributes:attributeAboutDict];
        [cell initSettingCellWithTitle:attrAbout  imageUrl:nil];
        [cell setIsNeedDoAddBottomLine  :YES];
        [cell setHeight:45];
      }
        break;
         */
        NSDictionary *attributeClearDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
        NSMutableAttributedString *attrClear = [[NSMutableAttributedString  alloc]initWithString:@"清除缓存" attributes:attributeClearDict];
        //NSString  *memory =[NSString  stringWithFormat:@"%.2f",[self getFilePathMemory]];
        [cell setTheMainValue: [self  getFilePathMemory]];
        [cell initSettingCellWithTitle:attrClear imageUrl:nil];
        [cell setIsNeedDoAddBottomLine  :YES];
        [cell setIsNeedDoAddTopLine     :YES];
        [cell setHeight:45];
        [cell  setAccessoryType:UITableViewCellAccessoryNone];
    }
      break;
      /*
    case 3:
    {
      NSDictionary *attributeClearDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
      NSMutableAttributedString *attrClear = [[NSMutableAttributedString  alloc]initWithString:@"清除缓存" attributes:attributeClearDict];
      [cell initSettingCellWithTitle:attrClear imageUrl:nil];
      [cell setIsNeedDoAddBottomLine  :YES];
      [cell setIsNeedDoAddTopLine     :YES];
      [cell setHeight:45];
    }
      break;
       */
    default:
    {
      NSDictionary *attributeLogOutDict = [NSDictionary dictionaryWithObjectsAndKeys:SourceHanSansNormal15,NSFontAttributeName, [UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0],NSForegroundColorAttributeName,nil];
      NSMutableAttributedString *attrLogOut = [[NSMutableAttributedString  alloc]initWithString:@"退出登录" attributes:attributeLogOutDict];
      [cell initSettingCellWithTitle:attrLogOut imageUrl:nil];
      [cell setIsNeedDoAddBottomLine  :YES];
      [cell setIsNeedDoAddTopLine     :YES];
      [cell setIsNeedLogOutBtn:YES];
      [cell setHeight:45];
      [cell  setAccessoryType:UITableViewCellAccessoryNone];
    }
      break;
    
  }
  //[tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  switch (indexPath.section)
  {
    case 0:
      switch (indexPath.row)
    {
      default:
      {
        self.settingAccountView = [[SettingAccountView alloc] init];
        [self.settingAccountView  initSettingAccountView:self.myUser];
        [self.settingAccountView.view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
        [SettingView  naviPushViewController:self.settingAccountView];
      }
        break;
    }
      break;
    case 1:
      switch (indexPath.row)
    {
      case 0:
      {
        self.profileSettingView = [[ProfileSettingView alloc] init];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0,-60) forBarMetrics:UIBarMetricsDefault];
        [self.profileSettingView  initAccountSettingViewWithUser:self.myUser];
        [self.profileSettingView.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        [SettingView  naviPushViewController:self.profileSettingView];
      }
        break;
      default:
      {
        AboutMainView *abouMainView = [[AboutMainView  alloc]init];
        [SettingView  naviPushViewController:abouMainView];
      }
        break;
    }
      break;
    case 2:
      switch (indexPath.row)
    {
      default:
      {
         [self.alertViewForCleanMemory show];
      }
        break;
    }
      break;
    case 3:
    {
      //[self.alertViewForLogOut show];
      [self  logoutAction:nil];
    }
      break;
    default:
      break;
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat height  = 15;
  if(section  ==  0)
    height  = 0;
  else  if(section  ==  1)
    height  = 20;
  else  if(section  ==  2)
    height  = 20;
  else  if(section  ==  3)
    height  = 20;
  else  if(section  ==  4)
    height  = 20;
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
  headerView.backgroundColor  = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height  = 15;
  if(section  ==  0)
    height  = 0;
  else  if(section  ==  1)
    height  = 20;
  else  if(section  ==  2)
    height  = 20;
  else  if(section  ==  3)
    height  = 20;
  else  if(section  ==  4)
    height  = 20;
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 0)
  {
    return  80;
  }
  else
    return  45;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(alertView  ==  self.alertViewForCleanMemory)
  {
    if (buttonIndex == 1)
    {
      NSFileManager *fileManager = [NSFileManager defaultManager];
      NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
      [fileManager removeItemAtPath:cacheFilePath error:nil];
      //NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
      //[self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [self.myTableView reloadData];//刷新表视图
    }
  }
  else  if(alertView  ==  self.alertViewForLogOut)
  {
    if (buttonIndex == 1)
    {
      [self logoutAction:nil];
    }
  }
}

#pragma event action

- (void)logoutAction  :(id)sender
{
  [DouAPIManager   removeSessionData];
  LoginInitViewController *loginVC = [[LoginInitViewController alloc] init];
  //LoginViewController     *loginVC = [[LoginViewController   alloc]init];
  UINavigationController *navi  = [[UINavigationController alloc]initWithRootViewController:loginVC];
  [navi setNavigationBarHidden:YES];
  UIWindow * window = [[UIApplication sharedApplication] keyWindow];
  [window setRootViewController:navi];

}

#pragma private method
-(NSString*)getFilePathMemory
{
  //定义变量存储总的缓存大小
  long long sumSize = 0;
  //01.获取当前图片缓存路径
  NSString *cacheFilePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
  //02.创建文件管理对象
  NSFileManager *filemanager = [NSFileManager defaultManager];
  //获取当前缓存路径下的所有子路径
  NSArray *subPaths = [filemanager subpathsOfDirectoryAtPath:cacheFilePath error:nil];
  //遍历所有子文件
  for (NSString *subPath in subPaths) {
  //1）.拼接完整路径
  NSString *filePath = [cacheFilePath stringByAppendingFormat:@"/%@",subPath];
  //2）.计算文件的大小
  long long fileSize = [[filemanager attributesOfItemAtPath:filePath error:nil]fileSize];
  //3）.加载到文件的大小
  sumSize += fileSize;
  }
  float size_m = sumSize/(1000*1000);
  return [NSString stringWithFormat:@"%.2fM",size_m];
}

- (void)clearCacheAtPath:(NSString *)path
{
  NSFileManager *fileManager=[NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:path])
  {
    NSArray *childerFiles=[fileManager subpathsAtPath:path];
    for (NSString *fileName in childerFiles)
    {
      //如有需要，加入条件，过滤掉不想删除的文件
      NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
      [fileManager removeItemAtPath:absolutePath error:nil];
    }
  }
}

#pragma getter setter
- (UITableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView    = [[UITableView  alloc]init];
    _myTableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 0)];
    [_myTableView setSeparatorColor:[UIColor  colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]];
    _myTableView.tableHeaderView  = self.headerView;
    _myTableView.tableFooterView  = self.footerView;
    [_myTableView registerClass:[SettingCell class] forCellReuseIdentifier:kCellIdentifier_TitleDisclosure];
  }
  return _myTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    [_headerView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
  }
  return _headerView;
}

- (UIView*)footerView
{
  if(_footerView  ==  nil)
  {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 20)];
    //[_footerView  addSubview:self.loginBtn];
  }
  return _footerView;
}

- (UIAlertView*)alertViewForLogOut
{
  if(_alertViewForLogOut  ==  nil)
  {
    _alertViewForLogOut = [[UIAlertView alloc]initWithTitle:@"退出登录" message:@"确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
  }
  return _alertViewForLogOut;
}

- (UIAlertView*)alertViewForCleanMemory
{
  if(_alertViewForCleanMemory ==  nil)
  {
    _alertViewForCleanMemory = [[UIAlertView alloc]initWithTitle:@"缓存清除" message:@"确定清除缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
  }
  return _alertViewForCleanMemory;
}

/*
- (UIButton*)loginBtn
{
  if(_loginBtn  ==  nil)
  {
    _loginBtn = [[UIButton alloc]init];
    [_loginBtn  setTitle:@"退出登录" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:SourceHanSansNormal15];
    [_loginBtn  setFrame:CGRectMake(kSettingPaddingLeftWidth, 20, kScreen_Width-kSettingPaddingLeftWidth*2, 45)];
    [_loginBtn  setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [_loginBtn  addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _loginBtn;
}
 */
@end
