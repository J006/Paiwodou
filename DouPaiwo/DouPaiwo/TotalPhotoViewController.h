//
//  TotalPhotoViewController.h
//  DouPaiwo
//  点击单张图片后,读取整体图片的专辑
//  Created by J006 on 15/9/24.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "AlbumInstance.h"

@interface TotalPhotoViewController : BaseViewController<UIScrollViewDelegate>

- (void)initTotalPhotoViewControllerWithAlbum  :(AlbumInstance*)album selectPhotoID:(NSInteger)photo_id;
/**
 *  @author J006, 15-07-04 16:07:21
 *
 *  给图片详细界面增加后退事件
 *
 *  @param backAction
 */
- (void)addBackBlock:(void(^)(id obj))backAction;
@end

