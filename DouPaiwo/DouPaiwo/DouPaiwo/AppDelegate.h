//
//  AppDelegate.h
//  DouPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WeiboSDK.h>
#import <WXApi.h>
#import <WXApiObject.h>
#import <SSWeChatSDK/WXApi.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,WeiboSDKDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow            *window;
@property (strong, nonatomic) NSString            *wbtoken;
@property (strong, nonatomic) NSString            *wbCurrentUserID;

@end
