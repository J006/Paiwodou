//
//  LoginInitViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/7/4.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "LoginInitViewController.h"
#import "PhotoImageWallView.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry.h>

@interface LoginInitViewController ()

@property (strong,  nonatomic)  UIImageView             *topImageView;
@property (strong,  nonatomic)  UIButton                *logInButton;
@property (strong,  nonatomic)  UIButton                *registerButton;
@property (strong,  nonatomic)  UILabel                 *bottomLabel;//Copyright © 2015 捕光捉影
@property (strong,  nonatomic)  MPMoviePlayerController *moviePlayer;

@end

@implementation LoginInitViewController

#pragma life cycle
- (void)viewDidLoad
{
  [super        viewDidLoad];
  [self.view    setBackgroundColor:[UIColor blackColor]];
  [self.view    addSubview:self.moviePlayer.view];
  [self.view    addSubview:self.topImageView];
  [self.view    addSubview:self.registerButton];
  [self.view    addSubview:self.logInButton];
  [self.view    addSubview:self.bottomLabel];
  
}

- (void)viewDidLayoutSubviews
{
  [super  viewDidLayoutSubviews];
  [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(110);
  }];
  [self.topImageView sizeToFit];
  
  [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view).offset(30);
    make.bottom.equalTo(self.view).offset(-90);
  }];
  [self.registerButton sizeToFit];
  
  [self.logInButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-30);
    make.bottom.equalTo(self.view).offset(-90);
  }];
  [self.logInButton sizeToFit];
  
  [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view.mas_centerX);
    make.bottom.equalTo(self.view).offset(-15);
  }];
  [self.bottomLabel  sizeToFit];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self castAnimation];
}

- (void)viewWillAppear:(BOOL)animated
{
  [[LoginInitViewController  getNavi] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

#pragma init

#pragma event
- (void)  jumpToLoginMainView:  (id)sender
{
  LoginViewController *loginVC = [[LoginViewController alloc] init];
  [[LoginViewController getNavi] setNavigationBarHidden:NO animated:NO];
  [LoginInitViewController  naviPushViewController:loginVC];
}

- (void)  jumpToRegisterMainView:  (id)sender
{
  RegisterViewController *regVC = [[RegisterViewController alloc] init];
  [[LoginViewController getNavi] setNavigationBarHidden:NO animated:NO];
  [LoginInitViewController  naviPushViewController:regVC];
}


#pragma private method
/**
 *  @author J.006, 15-09-23 12:09:43
 *
 *  顶部图标和2个按钮以及底部信息显现.
 */
- (void)castAnimation
{
  [UIView animateWithDuration:3.0
                        delay:0.0
                      options:UIViewAnimationOptionTransitionCrossDissolve
                   animations:^{
                     [self.topImageView       setAlpha:1.0];
                     [self.bottomLabel        setAlpha:1.0];
                     [self.logInButton        setAlpha:1.0];
                     [self.registerButton     setAlpha:1.0];
                   }completion:^(BOOL finished){
                   }];
}


#pragma getter setter

- (UIImageView*)topImageView
{
  if(_topImageView  ==  nil)
  {
    _topImageView = [[UIImageView  alloc]init];
    [_topImageView setImage:[UIImage imageNamed:@"loginInitTopImage"]];
    [_topImageView setAlpha:0.0];
  }
  return _topImageView;
}


- (UILabel*)bottomLabel
{
  if(_bottomLabel  ==  nil)
  {
    _bottomLabel = [[UILabel  alloc]init];
    [_bottomLabel  setText:@"Copyright © 2015 捕光捉影"];
    [_bottomLabel  setTextAlignment:NSTextAlignmentCenter];
    [_bottomLabel  setFont:[UIFont systemFontOfSize:10]];
    [_bottomLabel  setTextColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0]];
    [_bottomLabel  setAlpha:0.0];
  }
  return _bottomLabel;
}

- (UIButton*)logInButton
{
  if(_logInButton ==  nil)
  {
    _logInButton  = [[UIButton alloc]init];
    [_logInButton  setImage:[UIImage  imageNamed:@"loginInitBtn"] forState:UIControlStateNormal];
    [_logInButton  addTarget:self action:@selector(jumpToLoginMainView:) forControlEvents:UIControlEventTouchUpInside];
    [_logInButton  setAlpha:0.0];
  }
  return _logInButton;
}

- (UIButton*)registerButton
{
  if(_registerButton  ==  nil)
  {
    _registerButton = [[UIButton alloc]init];
    [_registerButton  setImage:[UIImage  imageNamed:@"registerBtn"] forState:UIControlStateNormal];
    [_registerButton  addTarget:self action:@selector(jumpToRegisterMainView:) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton  setAlpha:0.0];
  }
  return _registerButton;
}

- (MPMoviePlayerController*)moviePlayer
{
  if(_moviePlayer ==  nil)
  {
    NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"starting"  ofType:@"m4v"];
    if (moviePath)
    {
      NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
      _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:movieURL];
      [_moviePlayer  setFullscreen:YES];
      _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
      _moviePlayer.controlStyle = MPMovieControlStyleNone;
      _moviePlayer.repeatMode = MPMovieRepeatModeOne;
      [_moviePlayer prepareToPlay];
      [_moviePlayer.view setFrame:self.view.bounds];
      [_moviePlayer  play];
    }
  }
  return _moviePlayer;
}

@end
