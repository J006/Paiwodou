//
//  PhotoLikeCommentToolBar.h
//  DouPaiwo
//  图片预览界面下边栏的点赞评论界面
//  Created by J006 on 15/6/18.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "AlbumInstance.h"
#import "AlbumPhotoInstance.h"
#define kPhotoLikeCommentToolBarSmallFontSize 11
#define kPhotoLikeCommentToolBarMiddleFontSize 14
#define kPhotoLikeCommentToolBarBigFontSize 18
@interface PhotoLikeCommentToolBar : BaseViewController
/**
 *  @author J006, 15-06-18 14:06:52
 *
 *  初始化界面
 *
 *  @param album 专辑
 *  @param index 索引
 */
- (void)initPhotoLikeCommentToolBarWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto;

- (void)addBackBlock:(void(^)(id obj))backAction;

@end
