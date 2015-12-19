//
//  PhotosViewController.h
//  DouPaiwo
//  专辑图片预览页面
//  Created by J006 on 15/6/17.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "AlbumInstance.h"
#import "AlbumPhotoInstance.h"
#import "UserInstance.h"
#import "RecommendPhotoInstance.h"
#import "ShareTotalViewController.h"

@protocol PhotosViewControllerDelegate;
@interface PhotosViewController : BaseViewController<UIScrollViewDelegate>
@property (nonatomic, weak)      id<PhotosViewControllerDelegate>       delegate;
/**
 *  @author J006, 15-07-04 16:07:23
 *
 *  初始化
 *
 *  @param photoID              当前推荐图ID
 */
- (void)initPhotoViewControllerWithPhotoID :(NSInteger)photoID;
/**
 *  @author J006, 15-07-04 16:07:21
 *
 *  给图片详细界面增加后退事件
 *
 *  @param backAction
 */
- (void)addBackBlock:(void(^)(id obj))backAction;

@end

@protocol PhotosViewControllerDelegate <NSObject>

@optional
- (void)setTheShareButtonAndBackToAnimationMoveWithAlpha :(CGFloat)alpha albumPhoto:(AlbumPhotoInstance*)albumPhoto;
- (void)setTheCurrenPhoto :(AlbumPhotoInstance*)albumPhoto;
@end
