//
//  PhotoItemImageView.h
//  TestPaiwo
//  自定义的uiimageview,必须带的属性为分享,点赞,评论等等
//  Created by J006 on 15/5/7.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoItemImageView : UITapImageView

@property (nonatomic,readwrite)     int       shareNums;//分享次数
@property (nonatomic,readwrite)     int       likeNums;//点赞次数
@property (nonatomic,readwrite)     int       recommendNums;//推荐次数
@property (nonatomic,readwrite)     int       commentNums;//评论次数
@property (nonatomic,strong)        UIImage   *mainImage;//图片本体
@property (nonatomic,strong)        UIImage   *defaultImage;//默认图片


@end
