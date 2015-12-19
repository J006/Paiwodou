//
//  PocketAndPhotoView.h
//  TestPaiwo
//
//  Created by J006 on 15/5/19.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#define ppViewTopDisctance 30
@protocol PocketAndPhotoViewDelegate;
@interface PocketAndPhotoView : BaseViewController

@property (readwrite, nonatomic) BOOL                                     canLoadMore, willLoadMore, isLoading;
@property (nonatomic, weak)      id<PocketAndPhotoViewDelegate>           delegate;
/**
 *  @author J006, 15-06-25 13:06:07
 *
 *  初始化兜与专辑界面
 *
 *  @param dynamicInstanceArray 动态对象集合
 */
- (void)  initPocketAndPhotoViewWithDynamicContentInstance :(NSMutableArray*)dynamicInstanceArray;

- (void)  updatePocketAndPhotoViewWithDynamicContentInstance :(NSMutableArray*)dynamicInstanceArray;
@end

@protocol PocketAndPhotoViewDelegate <NSObject>
@optional
- (void)finishInitTheView:(PocketAndPhotoView *)ppView ppHeight:(CGFloat)ppHeight;

- (void)finishUpdateTheView:(PocketAndPhotoView *)ppView ppHeight:(CGFloat)ppHeight;

@end
