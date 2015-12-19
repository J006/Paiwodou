//
//  CommentViewController.h
//  DouPaiwo
//  评论界面
//  Created by J006 on 15/6/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "UIMessageInputViewController.h"
#import "AlbumPhotoInstance.h"
#import "PocketItemInstance.h"
#define kCommentViewControllerSmallFontSize 12
#define kCommentViewControllerMiddleFontSize 14
#define kCommentViewControllerBigFontSize 18
@interface CommentViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIMessageInputViewControllerDelegate>

- (void)initCommentViewControllerWithAlbumPhoto  :(AlbumPhotoInstance*)albumPhoto;

- (void)initCommentViewControllerWithPocket  :(PocketItemInstance*)pocket;
@end
