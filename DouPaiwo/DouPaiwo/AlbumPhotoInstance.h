//
//  AlbumPhotoInstance.h
//  DouPaiwo
//  专辑照片对象
//  Created by J006 on 15/6/6.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicContentPhotoInstance.h"
@interface AlbumPhotoInstance : DynamicContentPhotoInstance
/**
 *  @author J006, 15-06-06 16:06:27
 *
 *  排序id
 */
@property (nonatomic,readwrite)  NSInteger       sequence_id;
/**
 *  @author J006, 15-06-06 16:06:55
 *
 *  是否已经点赞
 */
@property (nonatomic,readwrite)  BOOL            is_like;
/**
 *  @author J006, 15-06-06 16:06:55
 *
 *  是否已经推荐
 */
@property (nonatomic,readwrite)  BOOL            is_recommend;
/**
 *  @author J006, 15-06-21 21:06:43
 *
 *  作者名称
 */
@property (nonatomic,strong)     NSString        *author_name;
/**
 *  @author J006, 15-06-21 21:06:09
 *
 *  作者域名
 */
@property (nonatomic,strong)     NSString        *author_domain;
/**
 *  @author J006, 15-06-24 11:06:26
 *
 *  专辑id
 */
@property (nonatomic,readwrite)  NSInteger       album_id;
/**
 *  @author J006, 15-06-24 11:06:18
 *
 *  专辑名称
 */
@property (nonatomic,strong)     NSString        *album_name;
/**
 *  @author J006, 15-06-24 11:06:55
 *
 *  作者ID
 */
@property (nonatomic,readwrite)  NSInteger       author_id;
/**
 *  @author J006, 15-06-24 11:06:33
 *
 *  作者头像地址
 */
@property (nonatomic,strong)     NSString        *author_avatar;
/**
 *  @author J006, 15-06-24 11:06:37
 *
 *  CC协议:0未署名,1署名,2.署名（BY）-相同方式共享（SA),3.署名（BY）-禁止演绎（ND）,4.署名（BY）-非商业性使用（NC）,5.署名（BY）-非商业性使用（NC）-相同方式共享（SA）,6.署名（BY）-非商业性使用（NC）-禁止演绎（ND）
 */
@property (nonatomic,readwrite)  NSInteger       cc_protocol;
/**
 *  @author J006, 15-06-26 15:06:08
 *
 *  热度
 */
@property (nonatomic,readwrite)  NSInteger       temperature;
/**
 *  @author J006, 15-06-26 15:06:32
 *
 *  是否收藏
 */
@property (nonatomic,readwrite)  BOOL            is_favorite;
/**
 *  @author J006, 15-07-02 17:07:00
 *
 *  与该专辑有关的图片列表
 */
@property (nonatomic,strong)     NSMutableArray  *photo_list;
@end
