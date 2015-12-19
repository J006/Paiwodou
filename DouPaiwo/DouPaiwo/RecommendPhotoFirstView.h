//
//  RecommendPhotoFirstView.h
//  DouPaiwo
//
//  Created by J006 on 15/9/23.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendPhotoInstance.h"
#import "AlbumInstance.h"
@interface RecommendPhotoFirstView : BaseViewController
@property (strong,nonatomic)  AlbumInstance   *album;

- (void)  initRecommendPhotoSingleViewWithAlbumPhoto:(RecommendPhotoInstance*)recommendPhotoInstance;

@end
