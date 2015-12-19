//
//  PhotoLikeCommentToolBar.m
//  DouPaiwo
//
//  Created by J006 on 15/6/18.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "PhotoLikeCommentToolBar.h"
#import "AlbumPhotoInstance.h"
#import "CustomDrawLineLabel.h"
#import "DouAPIManager.h"
#import <Masonry.h>
#import "CommentViewController.h"
@interface PhotoLikeCommentToolBar ()

@property (strong, nonatomic) AlbumPhotoInstance            *currentAlbumPhoto;
@property (strong, nonatomic) CommentViewController         *commentView;//评论界面

//@property (strong, nonatomic) UIButton                      *backButton;//后退按钮
@property (strong, nonatomic) UIButton                      *likeButton;//赞按钮
@property (strong, nonatomic) UILabel                       *likeNumsLabel;//赞数字
@property (strong, nonatomic) UIButton                      *recommendButton;//推荐按钮
@property (strong, nonatomic) UILabel                       *recommendNumsLabel;//推荐数字
@property (strong, nonatomic) UIButton                      *commentButton;//评论按钮
@property (strong, nonatomic) UILabel                       *commentNumsLabel;//评论数字
@property (strong, nonatomic) CustomDrawLineLabel           *firstLine;//从左到右第一条竖线
@property (strong, nonatomic) CustomDrawLineLabel           *secondLine;//从左到右第二条竖线

@property (readwrite, nonatomic) NSInteger                  currentCommentNums;//当前评论条数
@property (strong, nonatomic) CustomDrawLineLabel           *topLine;//顶部线
@property (nonatomic, copy) void(^backAction)(id);
@end

@implementation PhotoLikeCommentToolBar
#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = kColorBackGround;
  [self.view  addSubview:self.topLine];
  //[self.view  addSubview:self.backButton];
  [self.view  addSubview:self.likeButton];
  [self.view  addSubview:self.recommendButton];
  [self.view  addSubview:self.commentButton];
  [self.view  addSubview:self.commentNumsLabel];
  [self.view  addSubview:self.firstLine];
  [self.view  addSubview:self.secondLine];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager]request_GetPhotoCommentWithPhotoID :weakSelf.currentAlbumPhoto.photo_id page_no:1 page_size:pageSizeDefault :^(NSMutableArray *commentsData, NSError *error)
                    {
                      if(commentsData)
                        weakSelf.currentCommentNums = [commentsData count];
                      else
                        weakSelf.currentCommentNums   = 0;
                      dispatch_sync(dispatch_get_main_queue(), ^{
                        [weakSelf.view setNeedsLayout];
                      });
                    }];
                 });
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(0);
    make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 2));
  }];
  
  [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.centerX.equalTo(self.view.mas_centerX);
    make.size.mas_equalTo(CGSizeMake(18, 12));
  }];
  
  [self.secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.left.equalTo(self.recommendButton.mas_right).offset(18);
    make.size.mas_equalTo(CGSizeMake(1, 18));
  }];
  
  [self.firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.right.equalTo(self.recommendButton.mas_left).offset(-18);
    make.size.mas_equalTo(CGSizeMake(1, 18));
  }];
  
  [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.right.equalTo(self.firstLine.mas_left).offset(-15);
    make.size.mas_equalTo(CGSizeMake(15, 13));
  }];
  
  [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.recommendButton.mas_top);
    make.left.equalTo(self.secondLine.mas_right).offset(15);
    make.size.mas_equalTo(CGSizeMake(14, 14));
  }];
  
  if(self.currentCommentNums<9999)
    [self.commentNumsLabel  setText:[NSString stringWithFormat:@"%ld",self.currentCommentNums]];
  else
    [self.commentNumsLabel  setText:@"9999+"];
  
  [self.commentNumsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view).offset(0);
    make.left.equalTo(self.commentButton.mas_right).offset(5);
    make.size.mas_equalTo(CGSizeMake(50, 15));
  }];
}

#pragma init
- (void)initPhotoLikeCommentToolBarWithAlbumPhoto :(AlbumPhotoInstance*)albumPhoto;
{
  self.currentAlbumPhoto  = albumPhoto;
  self.currentCommentNums = 0;
}

#pragma self function
/*
- (void)backToLastViewAction  :(id)sender
{
  if(self.backAction)
    self.backAction(self);
  else
    [[PhotoLikeCommentToolBar  getNavi] popViewControllerAnimated:YES];
}
*/
/**
 *  @author J006, 15-06-25 21:06:12
 *
 *  点赞操作
 */
- (void)likeAction  :(id)sender
{
  NSInteger   photo_id  = self.currentAlbumPhoto.photo_id;
  [[DouAPIManager  sharedManager]request_AddPhotoLikeWithPhotoID  :photo_id :^(BOOL isSuccess, NSError *error)
  {
    if(isSuccess)
    {
      [self.likeButton              setImage:[UIImage imageNamed:@"photoLikedButton.png"] forState:UIControlStateNormal];
      [self.likeButton              removeTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.likeButton              addTarget:self action:@selector(unlikeAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.currentAlbumPhoto   setIs_like:YES];
    }
  }];
}

/**
 *  @author J006, 15-06-25 21:06:32
 *
 *  取消赞操作
 */
- (void)unlikeAction  :(id)sender
{
  NSInteger   photo_id  = self.currentAlbumPhoto.photo_id;
  [[DouAPIManager  sharedManager]request_DelPhotoLikeWithPhotoID  :photo_id :^(BOOL isSuccess, NSError *error)
   {
     if(isSuccess)
     {
       [self.likeButton             setImage:[UIImage imageNamed:@"photoLikeButton.png"] forState:UIControlStateNormal];
       [self.likeButton             removeTarget:self action:@selector(unlikeAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.likeButton             addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.currentAlbumPhoto  setIs_like:NO];
     }
   }];
}

/**
 *  @author J006, 15-06-25 21:06:12
 *
 *  推荐操作
 */
- (void)recommendAction  :(id)sender
{
  NSInteger   photo_id  = self.currentAlbumPhoto.photo_id;
  [[DouAPIManager  sharedManager]request_AddPhotoRecommendWithPhotoID :photo_id :^(BOOL isSuccess, NSError *error)
   {
     if(isSuccess)
     {
       [self.recommendButton    setImage:[UIImage imageNamed:@"photoRecommendedButton.png"] forState:UIControlStateNormal];
       [self.recommendButton    removeTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.recommendButton    addTarget:self action:@selector(unRecommendAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.currentAlbumPhoto  setIs_recommend:YES];
     }
   }];
}

/**
 *  @author J006, 15-06-25 21:06:32
 *
 *  取消推荐操作
 */
- (void)unRecommendAction  :(id)sender
{
  NSInteger   photo_id  = self.currentAlbumPhoto.photo_id;
  [[DouAPIManager  sharedManager]request_DelPhotoRecommendWithPhotoID :photo_id :^(BOOL isSuccess, NSError *error)
   {
     if(isSuccess)
     {
       [self.recommendButton    setImage:[UIImage imageNamed:@"photoRecommentButton.png"] forState:UIControlStateNormal];
       [self.recommendButton    removeTarget:self action:@selector(unRecommendAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.recommendButton    addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
       [self.currentAlbumPhoto  setIs_recommend:NO];
     }
   }];
}

- (void)jumpToCommentViewAction :(id)sender
{
  CommentViewController *commentView   =  [[CommentViewController  alloc]init];
  [commentView initCommentViewControllerWithAlbumPhoto:self.currentAlbumPhoto];
  [commentView.view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [[PhotoLikeCommentToolBar getNavi] setNavigationBarHidden:NO];
  [PhotoLikeCommentToolBar  naviPushViewController:commentView];
}

- (void)addBackBlock:(void(^)(id obj))backAction
{
  if(backAction)
    self.backAction = backAction;
}

#pragma getter setter
/*
- (UIButton*)backButton
{
  if(_backButton  ==  nil)
  {
    _backButton = [[UIButton alloc]init];
    [_backButton  setImage:[UIImage imageNamed:@"photoBackButton.png"] forState:UIControlStateNormal];
    [_backButton  addTarget:self action:@selector(backToLastViewAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _backButton;
}
*/
 
- (UIButton*)likeButton
{
  if(_likeButton  ==  nil)
  {
    _likeButton = [[UIButton alloc]init];
    if(!self.currentAlbumPhoto.is_like)
    {
      [_likeButton  setImage:[UIImage imageNamed:@"photoLikeButton.png"] forState:UIControlStateNormal];
      [_likeButton  addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else  if(self.currentAlbumPhoto.is_like)
    {
      [_likeButton  setImage:[UIImage imageNamed:@"photoLikedButton.png"] forState:UIControlStateNormal];
      [_likeButton  addTarget:self action:@selector(unlikeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return _likeButton;
}

- (UILabel*)likeNumsLabel
{
  if(_likeNumsLabel  ==  nil)
  {
    _likeNumsLabel = [[UILabel alloc]init];
  }
  return _likeNumsLabel;
}

- (UIButton*)recommendButton
{
  if(_recommendButton  ==  nil)
  {
    _recommendButton = [[UIButton alloc]init];
    if(!self.currentAlbumPhoto.is_recommend)
    {
      [_recommendButton  setImage:[UIImage imageNamed:@"photoRecommentButton.png"] forState:UIControlStateNormal];
      [_recommendButton  addTarget:self action:@selector(recommendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else  if(self.currentAlbumPhoto.is_recommend)
    {
      [_recommendButton  setImage:[UIImage imageNamed:@"photoRecommendedButton.png"] forState:UIControlStateNormal];
      [_recommendButton  addTarget:self action:@selector(unRecommendAction:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return _recommendButton;
}

- (UILabel*)recommendNumsLabel
{
  if(_recommendNumsLabel  ==  nil)
  {
    _recommendNumsLabel = [[UILabel alloc]init];
  }
  return _recommendNumsLabel;
}

- (UIButton*)commentButton
{
  if(_commentButton  ==  nil)
  {
    _commentButton = [[UIButton alloc]init];
    [_commentButton  setImage:[UIImage imageNamed:@"photoCommentButton.png"] forState:UIControlStateNormal];
    [_commentButton  addTarget:self action:@selector(jumpToCommentViewAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _commentButton;
}

- (UILabel*)commentNumsLabel
{
  if(_commentNumsLabel  ==  nil)
  {
    _commentNumsLabel = [[UILabel alloc]init];
    [_commentNumsLabel  setText:@""];
    [_commentNumsLabel  setTextColor:[UIColor lightGrayColor]];
    [_commentNumsLabel  setFont:[UIFont systemFontOfSize:kPhotoLikeCommentToolBarSmallFontSize]];
  }
  return _commentNumsLabel;
}

- (CustomDrawLineLabel*)firstLine
{
  if(_firstLine  ==  nil)
  {
    _firstLine = [[CustomDrawLineLabel alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(0, pointLineX.x+18);
    [_firstLine initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _firstLine;
}

- (CustomDrawLineLabel*)secondLine
{
  if(_secondLine  ==  nil)
  {
    _secondLine = [[CustomDrawLineLabel alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(0, pointLineX.x+18);
    [_secondLine initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _secondLine;
}

- (CommentViewController*)commentView
{
  if(_commentView ==  nil)
  {
    _commentView  = [[CommentViewController  alloc]init];
  }
  return _commentView;
}

- (CustomDrawLineLabel*)topLine
{
  if(_topLine  ==  nil)
  {
    _topLine = [[CustomDrawLineLabel alloc]init];
    CGPoint  pointLineX = CGPointMake(0, 0);
    CGPoint  pointLineY = CGPointMake(self.view.frame.size.width, 0);
    [_topLine initLabel:pointLineX :pointLineY :kColorBannerLine];
  }
  return _topLine;
}

@end