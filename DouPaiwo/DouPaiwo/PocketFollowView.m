//
//  PocketFollowView.m
//  TestPaiwo
//
//  Created by J006 on 15/4/23.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PocketFollowView.h"
#import <Masonry/Masonry.h>
#import "CustomLabel.h"
#import "DouAPIManager.h"
#import "NSString+Common.h"

@interface PocketFollowView ()
@property (strong, nonatomic) UIImageView         *backGroundImageView;
@property (strong, nonatomic) UILabel             *signaLabel;//签名
@property (strong, nonatomic) UIButton            *likeButton;//赞按钮
@property (strong, nonatomic) UILabel             *byLabel;//by 作者名
@property (strong, nonatomic) PocketItemInstance  *pocket;
@end

@implementation PocketFollowView

- (void)viewDidLoad
{
  [self.view  setBackgroundColor:[UIColor whiteColor]];
  [self.view  addSubview:self.backGroundImageView];
  [self.view  addSubview:self.signaLabel];
  [self.view  addSubview:self.byLabel];
  [self.view  addSubview:self.likeButton];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   NSString   *domain = @"";
                   if(weakSelf.pocket.author_domain && ![weakSelf.pocket.author_domain isEmpty])
                     domain = weakSelf.pocket.author_domain;
                   else
                    domain = weakSelf.pocket.user_domain;
                     [[DouAPIManager  sharedManager]request_GetUserProfileWithDomain :domain :^(UserInstance *data, NSError *error)
                      {
                        if(data)
                        {
                          dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.signaLabel setText:data.host_desc];
                          });
                        }
                      }];
                 });
  
}

- (void)viewDidLayoutSubviews
{
  [self.backGroundImageView setFrame:self.view.bounds];
  
  [self.signaLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.top.equalTo(self.view).with.offset(30);
    make.left.equalTo(self.view).with.offset(31);
    make.right.equalTo(self.view).with.offset(-31);
    make.height.mas_equalTo(90);
  }];

  
  [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.signaLabel).with.offset(120);
    make.size.mas_equalTo(CGSizeMake(40, 40));
  }];

  
  [self.byLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.bottom.equalTo(self.view).with.offset(-30);
    make.left.equalTo(self.view).with.offset(45);
    make.right.equalTo(self.view).with.offset(-45);
  }];
}

#pragma init
/**
 *  @author J006, 15-05-08 11:05:12
 *
 *  初始化folllow view
 */
- (void)initPocketFollowView  :(PocketItemInstance*)pocketItemInstance;
{
  _pocket = pocketItemInstance;
}

#pragma self function

- (void)likePocketAction  :(id)sender
{
  NSInteger   pocket_id  = self.pocket.pocket_id;
  [[DouAPIManager  sharedManager]request_AddPocketLikeWithPocketID  :pocket_id :^(BOOL isSuccess, NSError *error) {
    if(isSuccess)
    {
      [self.likeButton              setImage:[UIImage imageNamed:@"pocketLikeSuccess.png"] forState:UIControlStateNormal];
      [self.likeButton              removeTarget:self action:@selector(likePocketAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.likeButton              addTarget:self action:@selector(unLikePocketAction:) forControlEvents:UIControlEventTouchUpInside];
      [self.pocket                  setIs_like:YES];
    }
  }];
}

- (void)unLikePocketAction  :(id)sender
{
  NSInteger   pocket_id  = self.pocket.pocket_id;
  [[DouAPIManager  sharedManager] request_DelPocketLikeWithPocketID :pocket_id :^(BOOL isSuccess, NSError *error) {
      if(isSuccess)
      {
        [self.likeButton             setImage:[UIImage imageNamed:@"pocketLikeButton.png"] forState:UIControlStateNormal];
        [self.likeButton             removeTarget:self action:@selector(unLikePocketAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.likeButton             addTarget:self action:@selector(likePocketAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.pocket                 setIs_like:NO];
      }
  }];
}

#pragma getter setter
- (UIImageView*)backGroundImageView
{
  if(_backGroundImageView ==  nil)
  {
    _backGroundImageView  = [[UIImageView  alloc]initWithImage:[UIImage imageNamed:@"pocketDetail.png"]];
  }
  return _backGroundImageView;
}

- (UILabel*)signaLabel
{
  if(_signaLabel ==  nil)
  {
    _signaLabel = [[UILabel  alloc]init];
    [_signaLabel  setFont:SourceHanSansNormal12];
    [_signaLabel  setTextAlignment:NSTextAlignmentCenter];
    [_signaLabel  setTextColor:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_signaLabel  setNumberOfLines:5];
    if(_pocket  &&  _pocket.pocket_second_title)
      [_signaLabel  setText:_pocket.pocket_second_title];
    else
      [_signaLabel  setText:@""];

  }
  return _signaLabel;
}


- (UIButton*)likeButton
{
  if(_likeButton ==  nil)
  {
    _likeButton = [[UIButton  alloc]init];
    if(!self.pocket.is_like)
    {
      [_likeButton  setImage:[UIImage imageNamed:@"pocketLikeButton.png"] forState:UIControlStateNormal];
      [_likeButton  addTarget:self action:@selector(likePocketAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
      [_likeButton  setImage:[UIImage imageNamed:@"pocketLikeSuccess.png"] forState:UIControlStateNormal];
      [_likeButton  addTarget:self action:@selector(unLikePocketAction:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
  return _likeButton;
}

- (UILabel*)byLabel
{
  if(_byLabel ==  nil)
  {
    _byLabel = [[UILabel  alloc]init];
    [_byLabel  setFont:[UIFont boldSystemFontOfSize:kpocketFollowBigFontSize]];
    [_byLabel  setTextColor:[UIColor lightGrayColor]];
    [_byLabel  setTextAlignment:NSTextAlignmentCenter];
    if(self.pocket.author_name)
    {
      NSString  *byName = @"by. ";
      [_byLabel  setText:[byName  stringByAppendingString:_pocket.user_name]];
    }
    else  if(self.pocket.user_name)
    {
      NSString  *byName = @"by. ";
      [_byLabel  setText:[byName  stringByAppendingString:_pocket.author_name]];
    }
    else
      [_byLabel  setText:@""];
  }
  return _byLabel;
}
@end
