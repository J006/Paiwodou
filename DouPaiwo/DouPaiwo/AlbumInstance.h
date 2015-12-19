//
//  AlbumInstance.h
//  DouPaiwo
//  专辑对象
//  Created by J006 on 15/6/6.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, AlbumType) {
  publish_album=1,
};
@interface AlbumInstance : NSObject
/**
 *  @author J006, 15-06-06 15:06:33
 *
 *  专辑ID
 */
@property (nonatomic,readwrite)NSInteger  album_id;
/**
 *  @author J006, 15-06-06 17:06:15
 *
 *  封面图片地址
 */
@property (nonatomic,strong)   NSString   *cover_path;
/**
 *  @author J006, 15-06-06 15:06:38
 *
 *  是否是自己
 */
@property (nonatomic,readwrite)BOOL  is_self;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  专辑类型
 */
@property (nonatomic,readwrite)    AlbumType   album_type;
/**
 *  @author J006, 15-06-06 15:06:45
 *
 *  专辑名称
 */
@property (nonatomic,strong)   NSString   *album_name;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  用户ID
 */
@property (nonatomic,readwrite)    NSInteger   user_id;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  用户名称
 */
@property (nonatomic,strong)    NSString   *user_name;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  用户头像
 */
@property (nonatomic,strong)    NSString   *user_avatar;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  图片集合
 */
@property (nonatomic,strong)    NSMutableArray   *photo_list;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  是否删除
 */
@property (nonatomic,readwrite)BOOL       is_delete;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  用户域
 */
@property (nonatomic,strong)    NSString   *user_domain;
/**
 *  @author J006, 15-06-16 11:06:43
 *
 *  时间
 */
@property (nonatomic,strong)     NSString             *create_time;
/**
 *  @author J006, 15-06-06 15:06:50
 *
 *  专辑描述
 */
@property (nonatomic,strong)   NSString   *album_desc;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  图片数量
 */
@property (nonatomic,readwrite) NSInteger        photo_count;
/**
 *  @author J006, 15-06-06 16:06:28
 *
 *  标签列表
 */
@property (nonatomic,strong)   NSMutableArray   *tags;
/**
 *  @author J006, 15-06-06 16:06:30
 *
 *  作者ID
 */
@property (nonatomic,readwrite)   NSInteger   author_id;
/**
 *  @author J006, 15-06-06 16:06:30
 *
 *  作者名称
 */
@property (nonatomic,strong)   NSString   *author_name;
/**
 *  @author J006, 15-06-06 16:06:47
 *
 *  作者的domain
 */
@property (nonatomic,strong)   NSString   *author_domain;
/**
 *  @author J006, 15-06-06 16:06:09
 *
 *  作者头像图片地址
 */
@property (nonatomic,strong)   NSString   *author_avatar;
/**
 *  @author J006, 15-06-06 16:06:11
 *
 *  CC协议:0未署名,1署名,2.署名（BY）-相同方式共享（SA),3.署名（BY）-禁止演绎（ND）,4.署名（BY）-非商业性使用（NC）,5.署名（BY）-非商业性使用（NC）-相同方式共享（SA）,6.署名（BY）-非商业性使用（NC）-禁止演绎（ND）
 */
@property (nonatomic,readwrite)NSInteger  cc_protocol;
/**
 *  @author J006, 15-06-10 11:06:12
 *
 *  推荐人姓名
 */
@property (nonatomic,strong)  NSString     *recommond_name;
/**
 *  @author J006, 15-06-10 11:06:04
 *
 *  专辑热度
 */
@property (nonatomic,strong)  NSString     *hot;
/**
 *  @author J006, 15-06-16 11:06:20
 *
 *  是否已经点赞
 */
@property (nonatomic,readwrite)  BOOL                 is_like;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  是否推荐
 */
@property (nonatomic,readwrite)BOOL       is_recommend;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  最后更新的时间
 */
@property (nonatomic,readwrite)double       feed_time;

@end
