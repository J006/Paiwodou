//
//  PhotoImageWallView.h
//  TestPaiwo
//
//  Created by J006 on 15/5/7.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol PhotoImageWallViewDelegate;
@interface PhotoImageWallView : BaseViewController
@property (nonatomic, weak)      id<PhotoImageWallViewDelegate>       delegate;

- (void)initPhotoImageWall  :(NSMutableArray*)imageArray  :(BOOL)isVertical;
@end

@protocol PhotoImageWallViewDelegate <NSObject>

@optional
- (void)finishInitTheView:(PhotoImageWallView *)photoImageWallView photoImageWallHeight:(CGFloat)photoImageWallHeight photoImageWallWidth:(CGFloat)photoImageWallWidth;

@end
