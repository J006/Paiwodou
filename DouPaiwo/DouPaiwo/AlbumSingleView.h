//
//  PhotoSingleView.h
//  TestPaiwo
//
//  Created by J006 on 15/4/23.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumInstance.h"
#import "BaseViewController.h"
#define kdefaultScreen_Width 320
#define kphotoSingleViewHeight 338//363
#define kalbumSmallFontSize 11
#define kalbumBigFontSize 15
@interface AlbumSingleView : BaseViewController<UIScrollViewDelegate>

@property (nonatomic,readwrite) float       photoY;
/**
 *  @author J006, 15-06-09 17:06:39
 *
 *  初始化一些参数
 *
 *  @param 
 */
- (void)  initAlbumSingleView :(AlbumInstance*)album;

@end
