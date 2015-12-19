//
//  PocketItemInstance
//  TestPaiwo
//
//  Created by J006 on 15/4/22.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, PocketFollowState) {
  pocketFollow_NO  = 1,//未关注
  pocketFollow_YES = 2,//是你关注了他
  pocketFollow_HE  = 3,//是他关注了你
  pocketFollow_EACH  = 4,//是互相关注
};
typedef NS_ENUM(NSInteger, ContentType) {
  publish_pocket=2,
  recommend_pocket=6,
};
@interface PocketItemInstance : NSObject

/**
 *  @author J006, 15-06-05 17:06:34
 *
 *  兜ID
 */
@property (nonatomic,readwrite) NSInteger  pocket_id;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  主标题
 */
@property (nonatomic,strong)    NSString   *pocket_title;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  兜类型
 */
@property (nonatomic,readwrite)    ContentType   pocket_type;
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
 *  用户域
 */
@property (nonatomic,strong)    NSString   *user_domain;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  兜的图片集合
 */
@property (nonatomic,strong)    NSMutableArray   *photo_list;
/**
 *  @author J006, 15-06-05 17:06:28
 *
 *  图片数量
 */
@property (nonatomic,readwrite) NSInteger        photo_count;
/**
 *  @author J006, 15-06-05 17:06:19
 *
 *  主标题
 */
@property (nonatomic,strong)    NSString   *content_title;
/**
 *  @author J006, 15-06-05 17:06:19
 *
 *  副标题
 */
@property (nonatomic,strong)    NSString   *pocket_second_title;
/**
 *  @author J006, 15-06-05 17:06:57
 *
 *  封面图片地址
 */
@property (nonatomic,strong)    NSString   *cover_photo;
/**
 *  @author J006, 15-06-10 11:06:12
 *
 *  推荐人姓名
 */
@property (nonatomic,strong)  NSString     *recommond_name;
/**
 *  @author J006, 15-06-10 12:06:45
 *
 *  作者名称
 */
@property (nonatomic,strong)   NSString   *author_name;
/**
 *  @author J006, 15-07-05 14:07:57
 *
 *  兜内容,用以拼接html页面
 */
@property (nonatomic,strong)   NSString   *pocket_content;
/**
 *  @author J006, 15-07-05 14:07:44
 *
 *  作者头像
 */
@property (nonatomic,strong)   NSString   *author_avatar;
/**
 *  @author J006, 15-07-05 14:07:40
 *
 *  作者域
 */
@property (nonatomic,strong)   NSString   *author_domain;
/**
 *  @author J006, 15-07-05 15:07:38
 *
 *  作者ID
 */
@property (nonatomic,readwrite)NSInteger  author_id;
/**
 *  @author J006, 15-07-05 14:07:38
 *
 *  是否是自己
 */
@property (nonatomic,readwrite)BOOL       is_self;
/**
 *  @author J006, 15-07-05 14:07:58
 *
 *  关注作者状态
 */
@property (nonatomic,readwrite)PocketFollowState  followState;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  是否已经收藏
 */
@property (nonatomic,readwrite)BOOL       is_favorite;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  是否推荐
 */
@property (nonatomic,readwrite)BOOL       is_recommend;
/**
 *  @author J006, 15-06-16 11:06:43
 *
 *  时间
 */
@property (nonatomic,strong)   NSString             *create_time;
/**
 *  @author J006, 15-06-16 11:06:20
 *
 *  是否已经点赞
 */
@property (nonatomic,readwrite)  BOOL                 is_like;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  是否删除
 */
@property (nonatomic,readwrite)BOOL       is_delete;
/**
 *  @author J006, 15-07-05 15:07:55
 *
 *  兜热度
 */
@property (nonatomic,readwrite)NSInteger  temperature;
/**
 *  @author J006, 15-07-05 15:07:39
 *
 *  最后更新的时间
 */
@property (nonatomic,readwrite)double       feed_time;
@end
