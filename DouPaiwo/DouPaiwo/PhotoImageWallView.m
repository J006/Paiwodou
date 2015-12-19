//
//  PhotoImageWallView.m
//  TestPaiwo
//
//  Created by J006 on 15/5/7.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PhotoImageWallView.h"
#import "PhotoItemImageView.h"
#import <Masonry.h>
#define distanceBetweenImageX 10
#define distanceBetweenImageY 10
#define distanceVerticalBetweenImageX 10
#define distanceVerticalBetweenImageY 10

@interface PhotoImageWallView ()

@property (nonatomic,strong)      NSMutableArray      *imageArray;
@property (nonatomic,readwrite)   BOOL                isVertical;

@end

@implementation PhotoImageWallView

#pragma life cycle
- (void)viewDidLoad
{
  self.view.backgroundColor = kColorBackGround;
  for (UIView *imageView in _imageArray)
  {
    [self.view  addSubview:imageView];
  }
}

- (void)viewDidLayoutSubviews
{
  NSMutableArray  *tempArray = _imageArray;
  if([_imageArray  count]>kmaxImageNumsForChangeLine)
  {
    tempArray  = [self cleanArray:_imageArray  :_isVertical];//此刻array为二维数组
    float heightLeftTop       = 0;
    float widthLeftTop        = 0;
    float heightRightBottom   = 0;
    float widthRightBottom    = 0;
    UIView  *lastView;
    for (int i=0;i<[[tempArray objectAtIndex:0]count];i++)
    {
      PhotoItemImageView *imageView = [[tempArray objectAtIndex:0]objectAtIndex:i];
      CGRect frameButton  = imageView.frame;
      frameButton.size = imageView.frame.size;
      if(!_isVertical)
      {
        frameButton.origin.y  = 0;
        if(!lastView)
          frameButton.origin.x  = 0;
        else
          frameButton.origin.x  = lastView.frame.origin.x+distanceBetweenImageX+lastView.frame.size.width;
        widthLeftTop  = frameButton.origin.x+frameButton.size.width;
        heightLeftTop = frameButton.size.height;
        /*
        frameButton.origin.y  = 0;
        frameButton.origin.x  = i*frameButton.size.width+i*distanceBetweenImageX;
        widthLeftTop = frameButton.origin.x+frameButton.size.width;
        heightLeftTop = frameButton.size.height;
         */
        imageView.frame  = frameButton;
      }
      else
      {
        frameButton.origin.x  = photoDetailDistanceVerticalX;
        if(!lastView)
          frameButton.origin.y  = 0;
        else
          frameButton.origin.y  = lastView.frame.origin.y+distanceVerticalBetweenImageY+lastView.frame.size.height;
        widthLeftTop  = frameButton.size.width;
        heightLeftTop = frameButton.origin.y+frameButton.size.height;
        /*
        frameButton.origin.x  = photoDetailDistanceVerticalX;
        frameButton.origin.y  = i*frameButton.size.height+i*distanceVerticalBetweenImageY;
        heightLeftTop = frameButton.origin.y+frameButton.size.height;
        widthLeftTop  = frameButton.size.width;
        */
        imageView.frame  = frameButton;
      }
      lastView  = imageView;
    }
    UIView  *lastViewRight;
    for (int i=0;i<[[tempArray objectAtIndex:1]count];i++)
    {
      PhotoItemImageView *imageView = [[tempArray objectAtIndex:1]objectAtIndex:i];
      CGRect frameButton  = imageView.frame;
      frameButton.size = imageView.frame.size;
      if(!_isVertical)
      {
        frameButton.origin.y  = heightLeftTop+distanceBetweenImageY;
        if(!lastViewRight)
          frameButton.origin.x  = 0;
        else
          frameButton.origin.x  = lastViewRight.frame.origin.x+distanceBetweenImageX+lastViewRight.frame.size.width;
        imageView.frame  = frameButton;
        widthRightBottom  = frameButton.origin.x+frameButton.size.width;
        heightRightBottom = frameButton.size.height+distanceBetweenImageY;
        /*
        frameButton.origin.y  = heightLeftTop+distanceBetweenImageY;
        frameButton.origin.x  = i*frameButton.size.width+i*distanceBetweenImageX;
        imageView.frame  = frameButton;
        widthRightBottom = frameButton.origin.x+frameButton.size.width;
        heightRightBottom = frameButton.size.height+distanceBetweenImageY;
         */
      }
      else
      {
        frameButton.origin.x  = photoDetailDistanceVerticalX+widthLeftTop+distanceVerticalBetweenImageX;
        if(!lastViewRight)
          frameButton.origin.y  = 0;
        else
          frameButton.origin.y  = lastViewRight.frame.origin.y+distanceVerticalBetweenImageY+lastViewRight.frame.size.height;
        imageView.frame  = frameButton;
        widthRightBottom  = frameButton.size.width;
        heightRightBottom = frameButton.origin.y+frameButton.size.height;
        /*
        frameButton.origin.x  = photoDetailDistanceVerticalX+widthLeftTop+distanceVerticalBetweenImageX;
        frameButton.origin.y  = i*frameButton.size.height+i*distanceVerticalBetweenImageY;
        imageView.frame  = frameButton;
        widthRightBottom = frameButton.size.width;
        heightRightBottom = frameButton.origin.y+frameButton.size.height;
         */
      }
      lastViewRight = imageView;
    }
    
    CGRect mainFrame  = self.view.frame;
    if(!_isVertical)
      mainFrame.size  = CGSizeMake(MAX(widthLeftTop, widthRightBottom)+kmaxImageNumsForChangeLine, heightLeftTop+heightRightBottom);
    else
      mainFrame.size  = CGSizeMake(widthLeftTop+widthRightBottom, MAX(heightLeftTop, heightRightBottom)+kmaxImageNumsForChangeLine);
    self.view.frame = mainFrame;
    
  }
  else
  {
    float heightTop     = 0;
    float widthTop      = 0;
    NSInteger tempArrayCount  = [tempArray count];
    UIView  *lastView;
    for (int i=0;i<tempArrayCount;i++)
    {
      PhotoItemImageView *imageView = [tempArray  objectAtIndex:i];
      CGRect frameButton  = imageView.frame;
      if(!_isVertical)
      {
        frameButton.origin.y  = 0;
        if(!lastView)
          frameButton.origin.x  = 0;
        else
          frameButton.origin.x  = lastView.frame.origin.x+distanceBetweenImageX+lastView.frame.size.width;
        [imageView setFrame:frameButton];
        widthTop  = frameButton.origin.x+frameButton.size.width;
        heightTop = imageView.frame.size.height;
      }
      else
      {
        frameButton.origin.x  = photoDetailDistanceVerticalX;
        if(!lastView)
          frameButton.origin.y  = 0;
        else
          frameButton.origin.y  = lastView.frame.origin.y+distanceVerticalBetweenImageY+lastView.frame.size.height;
        [imageView setFrame:frameButton];
        widthTop  = frameButton.size.width;
        heightTop = frameButton.origin.y+frameButton.size.height;
      }
      lastView  = imageView;
    }
    CGRect mainFrame  = self.view.frame;
    if(!_isVertical)
    {
      mainFrame.size  = CGSizeMake(widthTop+kmaxImageNumsForChangeLine, heightTop);
    }
    else
      mainFrame.size  = CGSizeMake(widthTop, heightTop+kmaxImageNumsForChangeLine);
    self.view.frame = mainFrame;
    
  }
  if (_delegate && [_delegate respondsToSelector:@selector(finishInitTheView:photoImageWallHeight:photoImageWallWidth:)])
  {
    [self.delegate finishInitTheView:self photoImageWallHeight:self.view.frame.size.height photoImageWallWidth:self.view.frame.size.width];
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma init
/**
 *  @author J006, 15-05-07 18:05:42
 *
 *  初始化照片墙
 *  @param isVertical 是否是垂直
 *  @param imageArray PhotoItemImageView的集合
 */
- (void)initPhotoImageWall  :(NSMutableArray*)imageArray  :(BOOL)isVertical
{
  _imageArray = imageArray;
  _isVertical = isVertical;
}

#pragma private method
/**
 *  @author J006, 15-05-07 17:05:18
 *
 *  超过10的图片集合,整理后的array,双排根据上下排列,保证上下排列的宽度不会相差太多
 *
 *  @param imageArray
 *  @param isVertical 是否是垂直
 *  @return
 */
- (NSMutableArray*) cleanArray  :(NSMutableArray*)imageArray  :(BOOL)isVertical
{
  NSMutableArray  *tempCLearArray = [[NSMutableArray alloc]initWithCapacity:2];//二维数组
  NSMutableArray  *topArray = [[NSMutableArray alloc]init];//上层或左行图片数组
  NSMutableArray  *bottomArray = [[NSMutableArray alloc]init];//下层或右行图片数组
  [tempCLearArray addObject:topArray];
  [tempCLearArray addObject:bottomArray];
  NSUInteger arrayCounts = [imageArray count];
  float topLeftWidthTotal = 0;//上层左列图片总长度
  float bottomRightWidthTotal = 0;//下层右列图片总长度
  for (int i=0; i<arrayCounts; i++)
  {
    PhotoItemImageView    *itemImageView  = ((PhotoItemImageView*)[imageArray objectAtIndex:i]);
    if(topLeftWidthTotal<=bottomRightWidthTotal)
    {
      [topArray  addObject:[imageArray objectAtIndex:i]];
      if(!isVertical)
        topLeftWidthTotal +=  itemImageView.frame.size.width;
      else
        topLeftWidthTotal +=  itemImageView.frame.size.height;
    }
    else
    {
      [bottomArray  addObject:[imageArray objectAtIndex:i]];
      if(!isVertical)
        bottomRightWidthTotal +=  itemImageView.frame.size.width;
      else
        bottomRightWidthTotal +=  itemImageView.frame.size.height;
    }
  }
  return  tempCLearArray;
}

@end
