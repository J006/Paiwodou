//
//  SingleBannerView.m
//  DouPaiwo
//
//  Created by J006 on 15/6/8.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "SingleBannerView.h"
#import "UITapImageView.h"
#import <Masonry/Masonry.h>
#import "CustomDrawLineLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "PocketDetailHTML.h"
#define kSingleBannerViewSmallFontSize 12
#define kSingleBannerViewBigFontSize 20
@interface  SingleBannerView()

@property (strong, nonatomic) UILabel                   *descriPhotographerName;//时装摄影师--Rvs
@property (strong, nonatomic) UITapImageView            *tapImageView;//背景图
@property (strong, nonatomic) PocketItemInstance        *pocket;
@property (readwrite,nonatomic) CGFloat                 viewHeight;

@end

@implementation SingleBannerView

#pragma mark  - life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.viewHeight  = kMainBanner_Height;
  self.view.backgroundColor = kColorBackGround;
  [self.view  addSubview:self.tapImageView];
  [self.view  addSubview:self.descriPhotographerName];
}

- (void)viewDidLayoutSubviews
{
  [self.tapImageView  setFrame:CGRectMake(0, 0, kScreen_Width, self.viewHeight)];
  
  if(self.pocket)
    [self.descriPhotographerName  setText:self.pocket.pocket_title];
  [self.descriPhotographerName mas_makeConstraints:^(MASConstraintMaker *make){
    make.center.equalTo(self.view);
    make.size.mas_equalTo(CGSizeMake(200, 40));
  }];

}

#pragma init
- (void)initSingleBannerViewWithPocket  :(PocketItemInstance*)pocket
{
  self.pocket = pocket;
}

#pragma event
- (void)jumpToPocketDetail
{
  PocketDetailHTML  *pocketDetail  = [[PocketDetailHTML alloc]init];
  [pocketDetail initPocketDetailHTMLWithPocketID:self.pocket.pocket_id];
  if(![SingleBannerView checkRDVTabIsHidden])
    [pocketDetail   addBackBlock:^(id objc){
      [[PocketDetailHTML  getNavi]setNavigationBarHidden:YES];
      [PocketDetailHTML   setRDVTabHidden:NO isAnimated:NO];
      [[PocketDetailHTML  getNavi]popViewControllerAnimated:YES];
    }];
  else
    [pocketDetail   addBackBlock:^(id objc){
      [[PocketDetailHTML  getNavi]setNavigationBarHidden:YES];
      [[PocketDetailHTML  getNavi]popViewControllerAnimated:YES];
    }];
  [pocketDetail.view setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [[SingleBannerView    getNavi] setNavigationBarHidden:YES animated:NO];
  [SingleBannerView  setRDVTabHidden:YES isAnimated:NO];
  [SingleBannerView  naviPushViewController:pocketDetail];
}

#pragma mark - getters and setters

- (UILabel*)descriPhotographerName
{
  if(_descriPhotographerName==nil)
  {
    _descriPhotographerName = [[UILabel  alloc]init];
    [_descriPhotographerName  setTextAlignment:NSTextAlignmentCenter];
    [_descriPhotographerName  setTextColor:[UIColor whiteColor]];
    [_descriPhotographerName  setFont:SourceHanSansNormal20];
  }
  return  _descriPhotographerName;
}

- (UITapImageView*)tapImageView
{
  if(_tapImageView==nil)
  {
    _tapImageView = [[UITapImageView  alloc]init];

    if(self.pocket.cover_photo)
    {
      __weak typeof(self) weakSelf = self;
      NSURL *url = [[NSURL  alloc]initWithString:[[defaultImageHeadUrl stringByAppendingString:self.pocket.cover_photo]stringByAppendingString:imageBannerUrl]];
      [_tapImageView  setImageWithURL:url placeholderImage:nil  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
       {
         if(image)
         {
           image  = [image cutSizeFitFor:CGSizeMake(kScreen_Width,  weakSelf.viewHeight)];
           image  = [image addBlackFillterToImageWithOrigImage];
           [weakSelf.tapImageView  setSize:CGSizeMake(kScreen_Width, weakSelf.viewHeight)];
           [weakSelf.tapImageView  setImage:image];
           [weakSelf.tapImageView  addTapBlock:^(id obj) {
             [weakSelf  jumpToPocketDetail];
           }];
         }
       }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
  }
  return  _tapImageView;
}


@end
