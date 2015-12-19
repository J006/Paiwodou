//
//  SocialUtilManager.m
//  DouPaiwo
//
//  Created by J006 on 15/7/22.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SocialUtilManager.h"

@interface SocialUtilManager()<WBHttpRequestDelegate>
{
}

@end
@implementation SocialUtilManager


+ (instancetype)sharedManager
{
  static SocialUtilManager *shared_manager = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    shared_manager = [[self alloc] init];
  });
  return shared_manager;
}

- (void)shareWeiboActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album  :(void (^)(BOOL isSuccess))block;
{
  [WeiboSDK registerApp:kWeiboAppKey];
  WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
  authRequest.redirectURI = kWeiboRedirectURI;
  authRequest.scope = @"all";
  
  WBMessageObject *message = [WBMessageObject message];
  WBWebpageObject *webpage = [WBWebpageObject object];
  webpage.objectID = [NSString  stringWithFormat:@"albumphoto_%ld",albumPhoto.photo_id];
  webpage.title = NSLocalizedString(album.album_name, nil);
  webpage.description = [NSString stringWithFormat:NSLocalizedString(album.album_desc, nil), [[NSDate date] timeIntervalSince1970]];
  NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:albumPhoto.photo_path] stringByAppendingString:imageSmallTailUrl];
  NSURL *url = [[NSURL  alloc]initWithString:urlString];
  webpage.thumbnailData = [NSData dataWithContentsOfURL:url];
  webpage.webpageUrl = [defaultShareMainUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",albumPhoto.photo_id]];
  message.mediaObject= webpage;
  message.text       = [@"分享来自拍我网的专辑图片:"  stringByAppendingString:album.album_name];
  WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
  [WeiboSDK sendRequest:request];
}

- (void)shareWechatActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album isText:(BOOL)isText type:(int)wxScene;
{
  [WXApi registerApp:kWeixinAppKey withDescription:@"拍我网-兜"];
  WXMediaMessage *message = [WXMediaMessage message];
  message.title = [@"分享来自拍我网的专辑图片: "  stringByAppendingString:album.album_name];
  message.description = album.album_desc;
  NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:albumPhoto.photo_path] stringByAppendingString:imageSmallTailUrl];
  NSURL *url = [[NSURL  alloc]initWithString:urlString];
  UIImage *image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
  [message setThumbImage:image];
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl  = [defaultShareMainUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",albumPhoto.photo_id]];
  message.mediaObject = ext;
  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  req.message = message;
  req.bText = isText;
  req.scene = wxScene;  //选择发送到朋友圈，默认值为WXSceneSession，发送到会话
  [WXApi sendReq:req];
}

- (void)shareTencenterActionWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album
{
  self.tencentOAuth =[[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
  //分享跳转URL
  NSString *mainString          = [defaultShareMainUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",albumPhoto.photo_id]];
  NSURL    *mainURL             =[[NSURL  alloc]initWithString:mainString];
  //分享图预览图URL地址
  NSString  *urlString          = [[defaultImageHeadUrl stringByAppendingString:albumPhoto.photo_path] stringByAppendingString:imageSmallTailUrl];
  NSURL     *previewUrl         = [[NSURL  alloc]initWithString:urlString];
  QQApiNewsObject     *newsObj  =[QQApiNewsObject  objectWithURL:mainURL title:[@"分享来自拍我网的专辑图片: "  stringByAppendingString:album.album_name] description:album.album_desc previewImageURL:previewUrl];
  SendMessageToQQReq  *req      = [SendMessageToQQReq reqWithContent:newsObj];
  //将内容分享到qq
  [QQApiInterface sendReq:req];
}

- (void)shareWeiboActionWithPocket :(PocketItemInstance*)pocket
{
  [WeiboSDK registerApp:kWeiboAppKey];
  WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
  authRequest.redirectURI = kWeiboRedirectURI;
  authRequest.scope = @"all";
  
  WBMessageObject *message = [WBMessageObject message];
  WBWebpageObject *webpage = [WBWebpageObject object];
  webpage.objectID = [NSString  stringWithFormat:@"pocket_%ld",pocket.pocket_id];
  webpage.title = NSLocalizedString(pocket.pocket_title, nil);
  webpage.description = [NSString stringWithFormat:NSLocalizedString(pocket.pocket_second_title, nil), [[NSDate date] timeIntervalSince1970]];
  NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:pocket.cover_photo] stringByAppendingString:imageSmallTailUrl];
  NSURL *url = [[NSURL  alloc]initWithString:urlString];
  webpage.thumbnailData = [NSData dataWithContentsOfURL:url];
  webpage.webpageUrl = [defaultSharePocketMainUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",pocket.pocket_id]];
  message.mediaObject= webpage;
  message.text       = [@"分享来自拍我网的图文: "  stringByAppendingString:pocket.pocket_title];
  WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
  [WeiboSDK sendRequest:request];
}

- (void)shareWechatActionWithPocket :(PocketItemInstance*)pocket  type:(int)wxScene
{
  [WXApi registerApp:kWeixinAppKey withDescription:@"拍我网-兜"];
  WXMediaMessage *message = [WXMediaMessage message];
  message.title = [@"分享来自拍我网的图文: "  stringByAppendingString:pocket.pocket_title];
  message.description = pocket.pocket_second_title;
  NSString  *urlString  = [[defaultImageHeadUrl stringByAppendingString:pocket.cover_photo] stringByAppendingString:imageSmallTailUrl];
  NSURL *url = [[NSURL  alloc]initWithString:urlString];
  UIImage *image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
  [message setThumbImage:image];
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl  = [defaultSharePocketMainUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",pocket.pocket_id]];
  message.mediaObject = ext;
  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  req.message = message;
  req.bText = NO;
  req.scene = wxScene;  //选择发送到朋友圈，默认值为WXSceneSession，发送到会话
  [WXApi sendReq:req];
}

- (void)shareTencenterActionWithPocket :(PocketItemInstance*)pocket
{
  self.tencentOAuth =[[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
  //分享跳转URL
  NSString *mainString          = [defaultSharePocketMainUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",pocket.pocket_id]];
  NSURL    *mainURL             =[[NSURL  alloc]initWithString:mainString];
  //分享图预览图URL地址
  NSString  *urlString          = [[defaultImageHeadUrl stringByAppendingString:pocket.cover_photo] stringByAppendingString:imageSmallTailUrl];
  NSURL     *previewUrl         = [[NSURL  alloc]initWithString:urlString];
  QQApiNewsObject     *newsObj  = [QQApiNewsObject  objectWithURL:mainURL title:[@"分享来自拍我网的图文: "  stringByAppendingString:pocket.pocket_title] description:pocket.pocket_second_title previewImageURL:previewUrl];
  SendMessageToQQReq  *req      = [SendMessageToQQReq reqWithContent:newsObj];
  //将内容分享到qq
  [QQApiInterface sendReq:req];
}

- (void)shareWeiboActionWithUser :(UserInstance*)shareUser;
{
  [WeiboSDK registerApp:kWeiboAppKey];
  WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
  authRequest.redirectURI = kWeiboRedirectURI;
  authRequest.scope = @"all";
  
  WBMessageObject *message = [WBMessageObject message];
  WBWebpageObject *webpage = [WBWebpageObject object];
  webpage.objectID = [NSString  stringWithFormat:@"user_%ld",shareUser.host_id];
  webpage.title = NSLocalizedString(shareUser.host_name, nil);
  webpage.description = [NSString stringWithFormat:NSLocalizedString(shareUser.host_desc, nil), [[NSDate date] timeIntervalSince1970]];
  NSString  *urlString  = [defaultImageHeadUrl stringByAppendingString:shareUser.host_avatar];
  NSURL *url = [[NSURL  alloc]initWithString:urlString];
  webpage.thumbnailData = [NSData dataWithContentsOfURL:url];
  webpage.webpageUrl = [defaultMainUrl stringByAppendingString:[NSString stringWithFormat:@"%@",shareUser.host_domain]];
  message.mediaObject= webpage;
  message.text       = [@"分享来自拍我网的摄影师: "  stringByAppendingString:shareUser.host_name];
  WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
  [WeiboSDK sendRequest:request];
}
- (void)shareWechatActionWithUser :(UserInstance*)shareUser  type:(int)wxScene;
{
  [WXApi registerApp:kWeixinAppKey withDescription:@"拍我网-兜"];
  WXMediaMessage *message = [WXMediaMessage message];
  message.title = [@"分享来自拍我网的摄影师: "  stringByAppendingString:shareUser.host_name];
  message.description = shareUser.host_name;
  NSString  *urlString  = [defaultImageHeadUrl stringByAppendingString:shareUser.host_avatar];
  NSURL *url = [[NSURL  alloc]initWithString:urlString];
  UIImage *image  = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
  [message setThumbImage:image];
  WXWebpageObject *ext = [WXWebpageObject object];
  ext.webpageUrl  = [defaultMainUrl stringByAppendingString:[NSString stringWithFormat:@"%@",shareUser.host_domain]];
  message.mediaObject = ext;
  SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
  req.message = message;
  req.bText = NO;
  req.scene = wxScene;  //选择发送到朋友圈，默认值为WXSceneSession，发送到会话
  [WXApi sendReq:req];
}
- (void)shareTencenterActionWithUser :(UserInstance*)shareUser;
{
  self.tencentOAuth =[[TencentOAuth alloc] initWithAppId:kQQAppKey andDelegate:self];
  //分享跳转URL
  NSString *mainString          = [defaultMainUrl stringByAppendingString:[NSString stringWithFormat:@"%@",shareUser.host_domain]];
  NSURL    *mainURL             =[[NSURL  alloc]initWithString:mainString];
  //分享图预览图URL地址
  NSString  *urlString          = [defaultImageHeadUrl stringByAppendingString:shareUser.host_avatar];
  NSURL     *previewUrl         = [[NSURL  alloc]initWithString:urlString];
  QQApiNewsObject     *newsObj  = [QQApiNewsObject  objectWithURL:mainURL title:[@"分享来自拍我网的摄影师: "  stringByAppendingString:shareUser.host_name] description:shareUser.host_desc previewImageURL:previewUrl];
  SendMessageToQQReq  *req      = [SendMessageToQQReq reqWithContent:newsObj];
  //将内容分享到qq
  [QQApiInterface sendReq:req];
}

- (WBMessageObject *)messageToShare :(ShareType)type  message:(WBMessageObject*)message
{
  
  if (type  ==  ShareTypeImage)
  {
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
    message.imageObject = image;
  }
  
  if (type  ==  ShareTypeMedia)
  {
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = NSLocalizedString(@"分享网页标题", nil);
    webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
    webpage.webpageUrl = @"http://sina.cn?a=1";
    message.mediaObject = webpage;
  }
  
  return message;
}

#pragma QQ Delegate
- (void)tencentDidLogin
{
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
  
}

-(void)tencentDidNotNetWork
{
  
}

@end
