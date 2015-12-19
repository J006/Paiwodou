//
//  ImageDetailView.h
//  图片预览主界面
//
//  Created by J006 on 15/5/7.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class ImageDetailView;
@protocol ImageDetailViewDelegate <NSObject>
- (void)imageDetailViewSingleTap:(ImageDetailView *)imageDetailView;
@end
@interface ImageDetailView : BaseViewController<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) id<ImageDetailViewDelegate> imageDetailViewDelegate;

- (void)initImageDetailViewWithURL :(NSURL*)urlString defaultImage:(UIImage*)defaultImage;

@end
