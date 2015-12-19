//
//  AlbumSecondViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "AlbumSecondViewController.h"
#import <Masonry.h>
#import "CustomDrawLineLabel.h"
#import "DouAPIManager.h"
@interface AlbumSecondViewController ()

@property (strong,  nonatomic)  UITapImageView        *backGroundImageView;
@property (strong,  nonatomic)  UILabel               *contentLabel;
@property (strong,  nonatomic)  CustomDrawLineLabel   *lineLabel;
@property (strong,  nonatomic)  UILabel               *tagsLabel;
@property (strong,  nonatomic)  AlbumInstance         *album;
@property (strong,  nonatomic)   UILabel              *byLabel;//by 作者名
@end

@implementation AlbumSecondViewController

- (void)viewDidLoad
{
  [super      viewDidLoad];
  [self.view  setBackgroundColor:[UIColor whiteColor]];
  [self.view  addSubview:self.backGroundImageView];
  [self.view  addSubview:self.contentLabel];
  [self.view  addSubview:self.lineLabel];
  [self.view  addSubview:self.tagsLabel];
  [self.view  addSubview:self.byLabel];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   [[DouAPIManager  sharedManager] request_GetAlbumWithAlbumID :weakSelf.album.album_id :^(AlbumInstance *newAlbum, NSError *error)
                    {
                      if(!newAlbum)
                        return;
                      dispatch_sync(dispatch_get_main_queue(), ^{
                        weakSelf.album = newAlbum;
                        [weakSelf.view  setNeedsLayout];
                      });
                    }];
                 });
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  [self.backGroundImageView setFrame:self.view.bounds];
  
  if(self.album)
    [self.contentLabel  setText:self.album.album_desc];
  
  [self.lineLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.view);
    make.left.equalTo(self.view).offset(20);
    make.right.equalTo(self.view).offset(-20);
    make.height.mas_equalTo(1);
  }];
  
  CGPoint  pointLineX = CGPointMake(0, 0);
  CGPoint  pointLineY = CGPointMake(self.lineLabel.frame.size.width, 0);
  [self.lineLabel initLabel:pointLineX :pointLineY :kColorBannerLine];
  
  
  [self.contentLabel  sizeToFit];
  [self.contentLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.lineLabel.mas_top).offset(-22);
    make.centerX.equalTo(self.lineLabel);
  }];
  
  if(self.album.tags && [self.album.tags count]>0)
  {
    NSString  *tempTags = @"";
    for (NSString *tag in self.album.tags)
    {
      tempTags  = [tempTags stringByAppendingString:tag];
      tempTags  = [tempTags stringByAppendingString:@" | "];
    }
    tempTags  = [tempTags substringWithRange:NSMakeRange(0, tempTags.length-3)];
    [self.tagsLabel  setText:tempTags];
  }
  
  [self.tagsLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.lineLabel.mas_top).offset(10);
    make.centerX.equalTo(self.lineLabel);
  }];
  
  [self.tagsLabel  sizeToFit];
  
  [self.byLabel mas_makeConstraints:^(MASConstraintMaker *make){
    make.bottom.equalTo(self.view).with.offset(-30);
    make.centerX.equalTo(self.view);
  }];
  if(self.album.author_name)
  {
    NSString  *byName = @"by. ";
    [_byLabel  setText:[byName  stringByAppendingString:self.album.author_name]];
  }
  else  if(self.album.user_name)
  {
    NSString  *byName = @"by. ";
    [_byLabel  setText:[byName  stringByAppendingString:self.album.user_name]];
  }
  else
    [_byLabel  setText:@""];
  [self.byLabel sizeToFit];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma init
- (void)initAlbumSecondViewControllerWithAlbum  :(AlbumInstance*)album
{
  self.album =  album;
}

#pragma getter setter

- (UITapImageView*)backGroundImageView
{
  if(_backGroundImageView ==  nil)
  {
    _backGroundImageView  = [[UITapImageView  alloc]initWithImage:[UIImage imageNamed:@"pocketDetail.png"]];
  }
  return _backGroundImageView;
}

- (UILabel*)contentLabel
{
  if(_contentLabel  ==  nil)
  {
    _contentLabel = [[UILabel  alloc]init];
    [_contentLabel setTextAlignment:NSTextAlignmentCenter];
    [_contentLabel setFont:SourceHanSansLight12];
    [_contentLabel setNumberOfLines:3];
  }
  return _contentLabel;
}

- (CustomDrawLineLabel*)lineLabel
{
  if(_lineLabel ==  nil)
  {
    _lineLabel  = [[CustomDrawLineLabel  alloc]init];
  }
  return _lineLabel;
}

- (UILabel*)tagsLabel
{
  if(_tagsLabel ==  nil)
  {
    _tagsLabel  = [[UILabel  alloc]init];
    [_tagsLabel  setTextColor:[UIColor  colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
    [_tagsLabel  setFont:SourceHanSansNormal12];
    [_tagsLabel  setNumberOfLines:3];
    [_tagsLabel  setTextAlignment:NSTextAlignmentCenter];
  }
  return _tagsLabel;
}

- (UILabel*)byLabel
{
  if(_byLabel ==  nil)
  {
    _byLabel = [[UILabel  alloc]init];
    [_byLabel  setFont:[UIFont boldSystemFontOfSize:12]];
    [_byLabel  setTextColor:[UIColor lightGrayColor]];
    [_byLabel  setTextAlignment:NSTextAlignmentCenter];
  }
  return _byLabel;
}

@end
