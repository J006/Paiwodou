//
//  PhotoDetailPage.h
//  TestPaiwo
//
//  Created by J006 on 15/5/6.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInstance.h"
#import "BaseViewController.h"
#define kalbumDetailSmallFontSize 11
#define kalbumDetailMiddleFontSize 14
#define kalbumDetailBigFontSize 18
@interface AlbumDetailPage : BaseViewController<UIScrollViewDelegate>

/**
 *  @author J006, 15-05-07 10:05:47
 *
 *  初始化专辑详细界面
 *
 *  @param albumID
 */
- (void)initAlbumDetailPageWithAlbumID :(NSInteger)albumID;

- (void)addBackBlock:(void(^)(id obj))backAction;

@end
