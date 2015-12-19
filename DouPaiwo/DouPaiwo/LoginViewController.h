//
//  LoginViewController.h
//  DouPaiwo
//  登录界面
//  Created by J006 on 15/6/30.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "LoginInstance.h"
#import "DouAPIManager.h"
#import <WeiboSDK.h>
#import <WXApi.h>
#import <WXApiObject.h>
#import <SSWeChatSDK/WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>

#define kLoginViewControllerSmallFontSize 10
#define kLoginViewControllerMiddleFontSize 14
#define kLoginViewControllerBigFontSize 18

@interface LoginViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,WXApiDelegate,TencentApiInterfaceDelegate,TencentSessionDelegate>

- (void)socailLoginActionWithOpenID :(NSString*)openID  withType:(SocialType)type;

@end
