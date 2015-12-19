//
//  AppDelegate.m
//  DouPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate
@synthesize wbCurrentUserID,wbtoken;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
  return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  return [WeiboSDK handleOpenURL:url delegate:self] || [WXApi handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url];
}

#pragma Weibo Delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
  
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
  if ([response isKindOfClass:WBAuthorizeResponse.class])
  {

    WeiboSDKResponseStatusCode statusCode  = [(WBAuthorizeResponse *)response statusCode];
    if(statusCode!=WeiboSDKResponseStatusCodeSuccess)
      return;
    self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
    self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
    LoginViewController *loginVC  = [[(WBAuthorizeResponse *)response requestUserInfo]objectForKey:@"SSO_From"];
    [loginVC  socailLoginActionWithOpenID :self.wbCurrentUserID withType:WeiboLoginType];
    //[alert show];
  }
  else      if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
  {
    //WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
    
  }
}

#pragma WeiXin Delegate

-(void) onReq:(BaseReq*)req
{

}

-(void) onResp:(BaseResp*)resp
{
  if([resp isKindOfClass:[SendAuthResp class]])
  {
    int errorCode   = resp.errCode;
    if(errorCode!=0)
      return;
    SendAuthResp    *sendAuthResp = (SendAuthResp*)resp;
    NSString *returnCode = sendAuthResp.code;
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kWeixinAppKey,kWeixinSecret,returnCode];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSURL *zoneUrl = [NSURL URLWithString:url];
      NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
      NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
      if (data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString  *access_token = [dic objectForKey:@"access_token"];
        NSString  *openid       = [dic objectForKey:@"openid"];
        if(!access_token  ||  !openid)
          return;
        NSString *urlGetUnionid =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",access_token,openid];
        NSURL *unionIDUrl = [NSURL URLWithString:urlGetUnionid];
        NSString *unionStr = [NSString stringWithContentsOfURL:unionIDUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *dataUnion = [unionStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
          if(dataUnion)
          {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString  *unionid = [dic objectForKey:@"unionid"];
            NSString  *openid       = [dic objectForKey:@"openid"];
            if(!unionid  ||  !openid)
              return;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"WechatLogin" object:nil  userInfo:dic];
          }
        });
      }
    });
  }
  
  else  if([resp isKindOfClass:[SendMessageToWXResp class]])
  {
    NSString *strMsg = [NSString stringWithFormat:@"发送消息结果:%d", resp.errCode];
    NSLog(@"strMsg=%@",strMsg);
  }
}

@end
