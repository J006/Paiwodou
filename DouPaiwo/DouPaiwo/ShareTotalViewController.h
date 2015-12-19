//
//  ShareTotalViewController.h
//  DouPaiwo
//  分享界面弹出
//  Created by J006 on 15/7/23.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "AlbumPhotoInstance.h"
#import "AlbumInstance.h"
#import "PocketItemInstance.h"
#import "UserInstance.h"
#define kShareTotalViewControllerSmallFontSize 10
#define kShareTotalViewControllerMiddleFontSize 14
#define kShareTotalViewControllerBigFontSize 18
typedef NS_ENUM(NSInteger, ShareContentType)
{
  ShareContentTypePhotoAndAlbum                             = 1,//图片,专辑
  ShareContentTypePocket                                    = 2,//Pocket
  ShareContentTypeUser                                      = 3,//摄影师
};
@interface ShareTotalViewController : BaseViewController

- (void)initSharePhotoAndAlbumWithSnapshot  :(UIImage*)image  albumPhoto:(AlbumPhotoInstance*)albumPhoto album:(AlbumInstance*)album  shareContentType:(ShareContentType)ShareContentType;

- (void)initSharePocketWithSnapshot         :(UIImage*)image  pocket:(PocketItemInstance*)pocket shareContentType:(ShareContentType)ShareContentType;

- (void)initShareUserWithSnapshot           :(UIImage*)image  shareUser:(UserInstance*)shareUser shareContentType:(ShareContentType)ShareContentType;

- (void)confirmIsNeedToSetRDVShow           :(BOOL)isNeedToSetRDVShow;
@end
