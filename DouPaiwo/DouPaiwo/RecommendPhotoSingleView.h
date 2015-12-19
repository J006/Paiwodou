//
//  RecommendPhotoSingleView.h
//  DouPaiwo
//  推荐单张图片主界面
//  Created by J006 on 15/7/2.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendPhotoInstance.h"
#define kdefaultScreen_Width 320
#define kRecommendphotoSingleViewHeight 338

@interface RecommendPhotoSingleView : BaseViewController<UIScrollViewDelegate>

@property (nonatomic,readwrite) float       photoY;

- (void)  initRecommendPhotoSingleViewWithAlbumPhoto:(RecommendPhotoInstance*)recommendPhotoInstance;

@end
