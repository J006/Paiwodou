//
//  ImageDetailView.m
//  TestPaiwo
//
//  Created by J006 on 15/5/7.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "ImageDetailView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <SDWebImageDownloader.h>
@interface ImageDetailView ()

@property (strong, nonatomic)   UIScrollView              *scrollView;//主图片scrollview
@property (nonatomic,readwrite) BOOL                      zoomByDoubleTap;
@property (nonatomic,readwrite) BOOL                      isHideToolBar;
@property (strong, nonatomic)   UIImageView               *photoItemImageView;
@property (strong, nonatomic)   NSURL                     *urlString;
@property (strong, nonatomic)   UIImage                   *defaultImage;//默认图
@property (strong, nonatomic)   MBProgressHUD             *mbProgHUD;
@property (nonatomic)           float                     progress;

@property (readwrite,nonatomic) NSInteger                 receivedSize;
@property (readwrite,nonatomic) NSInteger                 expectedSize;

@end

@implementation ImageDetailView

- (void)viewDidLoad
{
  self.view.backgroundColor = [UIColor  blackColor];
  [self.view        addSubview:self.scrollView];
  [self.scrollView  addSubview:self.photoItemImageView];
  // 监听点击
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  singleTap.delaysTouchesBegan = YES;
  singleTap.numberOfTapsRequired = 1;
  [self.scrollView addGestureRecognizer:singleTap];
  UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  doubleTap.numberOfTapsRequired = 2;
  [self.scrollView addGestureRecognizer:doubleTap];
  UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
  longPressReger.minimumPressDuration = 1.0;//1秒
  [self.scrollView addGestureRecognizer:longPressReger];
  UITapGestureRecognizer *singleTapMBProgHUD = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  singleTapMBProgHUD.delaysTouchesBegan = YES;
  singleTapMBProgHUD.numberOfTapsRequired = 1;
  [self.mbProgHUD addGestureRecognizer:singleTapMBProgHUD];
  [singleTap requireGestureRecognizerToFail:doubleTap];
  
}

- (void)viewDidLayoutSubviews
{
  CGRect  frame  = self.scrollView.frame;
  frame.size  =   CGSizeMake(kScreen_Width, kScreen_Height);
  self.scrollView.frame = frame;
  if(!self.photoItemImageView.image)
    [self.photoItemImageView  setFrame:self.view.bounds];
  else
    [self.photoItemImageView  setSize:self.photoItemImageView.image.size];
  [self adjustFrame];
}

- (void)viewWillAppear:(BOOL)animated
{
  [ImageDetailView setRDVTabStatusHidden:YES];
}

#pragma init

- (void)initImageDetailViewWithURL :(NSURL*)urlString defaultImage:(UIImage*)defaultImage;
{
  self.urlString          = urlString;
  self.defaultImage       = defaultImage;
}


#pragma mark - 手势处理
/**
 *  @author J006, 15-05-06 12:05:26
 *
 *  单击回到前一个页面
 *
 *  @param tap
 */
- (void)handleSingleTap:(UITapGestureRecognizer *)tap
{
  [[ImageDetailView  getNavi] popViewControllerAnimated:YES];
}
/**
 *  @author J006, 15-05-06 12:05:14
 *
 *  双击放大
 *
 *  @param tap
 */
- (void)handleDoubleTap:(UITapGestureRecognizer *)tap
{
  self.zoomByDoubleTap = YES;
  if (self.scrollView.zoomScale == self.scrollView.maximumZoomScale)
  {
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
  }
  else
  {
    CGPoint touchPoint = [tap locationInView:self.scrollView];
    CGFloat scale = self.scrollView.maximumZoomScale/ self.scrollView.zoomScale;
    CGRect rectTozoom=CGRectMake(touchPoint.x * scale, touchPoint.y * scale, 1, 1);
    [self.scrollView zoomToRect:rectTozoom animated:YES];
  }
}
/**
 *  @author J006, 15-06-18 20:06:43
 *
 *  长按弹出保存图片的选择
 *
 *  @param press
 */
- (void)handleLongPress:(UILongPressGestureRecognizer *)press
{
  if (press.state == UIGestureRecognizerStateBegan)
  {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"是否将图片保存到本地相册?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
    [actionSheet showInView:self.view];
  }

}

/**
 *  @author J006, 15-05-06 13:05:34
 *
 *  调整frame
 */
- (void)adjustFrame
{
  
  if (self.photoItemImageView.image == nil)
    return;
  // 基本尺寸参数
  CGFloat boundsWidth = self.scrollView.bounds.size.width;
  CGFloat boundsHeight = self.scrollView.bounds.size.height;
  CGFloat imageWidth = self.photoItemImageView.image.size.width;
  CGFloat imageHeight = self.photoItemImageView.image.size.height;
  // 设置伸缩比例
  CGFloat imageScale = boundsWidth / imageWidth;
  CGFloat minScale = MIN(1.0, imageScale);
  
  CGFloat maxScale = 2.0;
  if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
    maxScale = maxScale / [[UIScreen mainScreen] scale];
  }
  
  self.scrollView.maximumZoomScale = maxScale;
  self.scrollView.minimumZoomScale = minScale;
  self.scrollView.zoomScale = minScale;
  
  
  CGRect imageFrame = CGRectMake(0, MAX(0, (boundsHeight- imageHeight*imageScale)/2), boundsWidth, imageHeight *imageScale);
  
  self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(imageFrame), CGRectGetHeight(imageFrame));
  self.photoItemImageView.frame = imageFrame;
}

/**
 *  @author J006, 15-05-06 10:05:02
 *
 *  UIScrollView代理方法
 *
 *  @param scrollView
 *
 *  @return
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView

{
  if (self.zoomByDoubleTap) {
    CGFloat insetY = (CGRectGetHeight(self.scrollView.bounds) - CGRectGetHeight(self.photoItemImageView.frame))/2;
    insetY = MAX(insetY, 0.0);
    if (ABS(self.photoItemImageView.frame.origin.y - insetY) > 0.5) {
      [self setY:insetY :self.photoItemImageView];
    }
  }
  return self.photoItemImageView;
}


/**
 *  @author J006, 15-05-06 11:05:20
 *
 *  UIScrollView代理方法
 *
 *  @param scrollView
 *  @param view
 *  @param scale
 */
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
  self.zoomByDoubleTap = NO;
  CGFloat insetY = (CGRectGetHeight(self.scrollView.bounds) - CGRectGetHeight(self.photoItemImageView.frame))/2;
  insetY = MAX(insetY, 0.0);
  if (ABS(self.photoItemImageView.frame.origin.y - insetY) > 0.5) {
    [UIView animateWithDuration:0.2 animations:^{
      [self setY:insetY :self.photoItemImageView];
    }];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 1)
    return;
  else  if(buttonIndex==0)
  {
    UIImageWriteToSavedPhotosAlbum(self.photoItemImageView.image, self,@selector(saveImageCheckWithImage:didFinishSavingWithError:contextInfo:), nil);
  }
  
}

- (void) saveImageCheckWithImage: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
  if(image && !error)
  {
    UIAlertView *successAlertView = [[UIAlertView  alloc]initWithTitle:nil message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [successAlertView show];
  }
  else  if(error)
  {
    UIAlertView *successAlertView = [[UIAlertView  alloc]initWithTitle:nil message:@"保存失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [successAlertView show];
  }
}

- (void)setY:(CGFloat)y :(UIView*)view{
  CGRect frame = view.frame;
  frame.origin.y = y;
  view.frame = frame;
}


- (UIScrollView*)scrollView
{
  if(_scrollView==nil)
  {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate  = self;
    _scrollView.backgroundColor = [UIColor  blackColor];
  }
  return _scrollView;
}

- (UIImageView*)photoItemImageView
{
  if(_photoItemImageView  ==  nil)
  {
    _photoItemImageView = [[UIImageView  alloc]init];
    [_photoItemImageView  setBackgroundColor:[UIColor blackColor]];
    [_photoItemImageView setImage:self.defaultImage];
    __weak typeof(self) weakSelf = self;
    [_photoItemImageView setImage:self.defaultImage];
    _mbProgHUD = [[MBProgressHUD alloc] initWithView:_photoItemImageView];
    [self.view addSubview:_mbProgHUD];
    _mbProgHUD.labelText = @"图片正在加载";
    _mbProgHUD.mode = MBProgressHUDModeAnnularDeterminate;
    [_mbProgHUD  show:YES];
    /*
    [_photoItemImageView   sd_setImageWithURL:self.urlString placeholderImage:self.defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      if(image)
      {
        [weakSelf.photoItemImageView  setSize:image.size];
        [weakSelf.view setNeedsLayout];
      }
    }];
     */
    [_photoItemImageView  sd_setImageWithURL:self.urlString placeholderImage:self.defaultImage options:(SDWebImageCacheMemoryOnly) progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
      weakSelf.receivedSize  = receivedSize;
      weakSelf.expectedSize  = expectedSize;
    _mbProgHUD.progress = (float)weakSelf.receivedSize/weakSelf.expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      if(image)
      {
        [weakSelf.photoItemImageView  setSize:image.size];
        [weakSelf.view setNeedsLayout];
      }
      [_mbProgHUD removeFromSuperview];
    }];
    
    /*
    [_photoItemImageView  sd_setImageWithURL:self.urlString placeholderImage:self.defaultImage options:(SDWebImageCacheMemoryOnly) progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      
    }];
    */
    
  }
  return _photoItemImageView;
}

- (MBProgressHUD*)mbProgHUD
{
  if(_mbProgHUD ==  nil)
  {
    _mbProgHUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[self.view addSubview:_mbProgHUD];
    //_mbProgHUD.labelText = @"正在加载";
    //_mbProgHUD.mode = MBProgressHUDModeAnnularDeterminate;
  }
  return _mbProgHUD;
}
@end
