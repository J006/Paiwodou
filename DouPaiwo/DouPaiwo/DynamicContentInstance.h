//
//  DynamicContentInstance.h
//  DouPaiwo
//  动态对象
//  Created by J006 on 15/6/16.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicContentInstance : NSObject
/**
 *  @author J006, 15-06-16 10:06:05
 *
 *  动态id,可以转变成专辑ID,兜ID
 */
@property (nonatomic,readwrite)  NSInteger            content_id;
/**
 *  @author J006, 15-06-16 10:06:37
 *
 *  动态类型
 */
@property (nonatomic,readwrite)  NSInteger            content_type;
/**
 *  @author J006, 15-06-16 10:06:19
 *
 *  动态用户id
 */
@property (nonatomic,readwrite)  NSInteger            content_user_id;
/**
 *  @author J006, 15-06-16 10:06:05
 *
 *  动态用户名
 */
@property (nonatomic,strong)     NSString             *content_user_name;
/**
 *  @author J006, 15-06-16 10:06:45
 *
 *  动态用户头像地址
 */
@property (nonatomic,strong)     NSString             *content_user_avatar;
/**
 *  @author J006, 15-06-16 10:06:16
 *
 *  动态用户的域名
 */
@property (nonatomic,strong)     NSString             *content_user_domain;
/**
 *  @author J006, 15-06-16 10:06:53
 *
 *  动态图片集合,如果是兜的话只有一张封面
 */
@property (nonatomic,strong)     NSMutableArray       *photo_list;
/**
 *  @author J006, 15-06-16 10:06:31
 *
 *  图片数量
 */
@property (nonatomic,readwrite)  NSInteger            photo_count;
/**
 *  @author J006, 15-06-16 10:06:59
 *
 *  动态的标题
 */
@property (nonatomic,strong)     NSString             *content_title;
/**
 *  @author J006, 15-06-16 10:06:19
 *
 *  动态的描述
 */
@property (nonatomic,strong)     NSString             *content_desc;
/**
 *  @author J006, 15-06-16 10:06:45
 *
 *  动态的作者ID
 */
@property (nonatomic,readwrite)  NSInteger            content_author_id;
/**
 *  @author J006, 15-06-16 11:06:03
 *
 *  动态作者名称
 */
@property (nonatomic,strong)     NSString             *content_author_name;
/**
 *  @author J006, 15-06-16 11:06:41
 *
 *  动态作者的域名
 */
@property (nonatomic,strong)     NSString             *content_author_domain;
/**
 *  @author J006, 15-06-16 11:06:43
 *
 *  动态的制作时间
 */
@property (nonatomic,strong)     NSString             *create_time;
/**
 *  @author J006, 15-06-16 11:06:20
 *
 *  是否已经点赞
 */
@property (nonatomic,readwrite)  BOOL                 is_like;
/**
 *  @author J006, 15-06-16 11:06:24
 *
 *  是否已经推荐
 */
@property (nonatomic,readwrite)  BOOL                 is_recommend;
/**
 *  @author J006, 15-06-16 11:06:39
 *
 *  是否已经删除
 */
@property (nonatomic,readwrite)  BOOL                 is_delete;
@end
