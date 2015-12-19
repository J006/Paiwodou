//
//  PocketPhotoInstance
//  TestPaiwo
//
//  Created by J006 on 15/4/22.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PocketPhotoInstance : NSObject
/**
 *  @author J006, 15-06-06 16:06:28
 *
 *  图片id
 */
@property (nonatomic,readwrite)  NSInteger       photo_id;
/**
 *  @author J006, 15-06-06 16:06:37
 *
 *  图片地址
 */
@property (nonatomic,strong)     NSString        *photo_path;
/**
 *  @author J006, 15-06-06 16:06:27
 *
 *  排序id
 */
@property (nonatomic,readwrite)  NSInteger       sequence_id;
/**
 *  @author J006, 15-06-06 16:06:12
 *
 *  热度
 */
@property (nonatomic,readwrite)  NSInteger       temperature;
/**
 *  @author J006, 15-06-06 16:06:55
 *
 *  是否已经点赞
 */
@property (nonatomic,readwrite)  BOOL            is_like;
/**
 *  @author J006, 15-06-06 16:06:34
 *
 *  是否是封面
 */
@property (nonatomic,readwrite)  BOOL            is_cover;
/**
 *  @author J006, 15-06-06 16:06:34
 *
 *  是否已经收藏
 */
@property (nonatomic,readwrite)  BOOL            is_favorite;
/**
 *  @author J006, 15-06-06 16:06:24
 *
 *  是否推荐
 */
@property (nonatomic,readwrite)  BOOL            is_recommend;
@end
