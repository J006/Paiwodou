//
//  SocialUtilManager.h
//  DouPaiwo
//
//  Created by J006 on 15/7/22.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeiboSDK.h>
#import <WXApi.h>
#import <WXApiObject.h>
#import <SSWeChatSDK/WXApi.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import "AlbumPhotoInstance.h"
#import "AlbumInstance.h"
#import "PocketItemInstance.h"
#import "UserInstance.h"
typedef NS_ENUM(NSInteger, ShareType)
{
  ShareTypeImage                              = 1,//微信分享类型图片
  ShareTypeMedia                              = 2,//微信分享类型网页
};
@interface SocialUtilManager : NSObject<TencentSessionDelegate>

@property (strong, nonatomic) TencentOAuth *tencentOAuth;

+ (instancetype)sharedManager;

- (void)shareWeiboActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album  :(void (^)(BOOL isSuccess))block;

- (void)shareWechatActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album isText:(BOOL)isText type:(int)wxScene;

- (void)shareTencenterActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album;

- (void)shareWeiboActionWithPocket :(PocketItemInstance*)pocket;

- (void)shareWechatActionWithPocket :(PocketItemInstance*)pocket  type:(int)wxScene;

- (void)shareTencenterActionWithPocket :(PocketItemInstance*)pocket;

- (void)shareWeiboActionWithUser :(UserInstance*)shareUser;

- (void)shareWechatActionWithUser :(UserInstance*)shareUser  type:(int)wxScene;

- (void)shareTencenterActionWithUser :(UserInstance*)shareUser;
@end
