//
//  PocketLikeCommentToolBar.h
//  DouPaiwo
//
//  Created by J006 on 15/7/15.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "PocketItemInstance.h"
#define kPocketLikeCommentToolBarSmallFontSize 11
#define kPocketLikeCommentToolBarMiddleFontSize 14
#define kPocketLikeCommentToolBarBigFontSize 18
@interface PocketLikeCommentToolBar : BaseViewController

- (void)initPhotoLikeCommentToolBarWithPocketItem :(PocketItemInstance*)pocketItem;

@end
