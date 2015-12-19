//
//  CommentInstance.h
//  DouPaiwo
//
//  Created by J006 on 15/6/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentInstance : NSObject
/**
 *  @author J006, 15-06-26 13:06:40
 *
 *  照片评论id
 */
@property (readwrite,nonatomic)      NSInteger                           comment_id;
/**
 *  @author J006, 15-06-26 13:06:40
 *
 *  评论内容,最大140,中文占2个.
 */
@property (strong,   nonatomic)      NSString                            *comment_text;
/**
 *  @author J006, 15-06-26 13:06:29
 *
 *  评论者user id
 */
@property (readwrite,nonatomic)      NSInteger                           comment_user_id;
/**
 *  @author J006, 15-06-26 13:06:11
 *
 *  评论者姓名
 */
@property (strong,   nonatomic)      NSString                            *comment_user_name;
/**
 *  @author J006, 15-06-26 13:06:48
 *
 *  评论者的头像地址
 */
@property (strong,   nonatomic)      NSString                            *comment_user_avatar;
/**
 *  @author J006, 15-06-26 13:06:23
 *
 *  评论者的域
 */
@property (strong,   nonatomic)      NSString                            *comment_user_domain;
/**
 *  @author J006, 15-06-26 13:06:52
 *
 *  被评论的人的user id,如果是0的话,则是默认照片作者,可以选择其他人评论
 */
@property (readwrite,nonatomic)      NSInteger                           reply_user_id;
/**
 *  @author J006, 15-06-26 13:06:31
 *
 *  被评论的人的用户名
 */
@property (strong,   nonatomic)      NSString                            *reply_user_name;
/**
 *  @author J006, 15-06-26 13:06:56
 *
 *  被评论的人的域
 */
@property (strong,   nonatomic)      NSString                            *reply_user_domain;
/**
 *  @author J006, 15-06-26 13:06:25
 *
 *  发布时间
 */
@property (strong,   nonatomic)      NSString                            *create_time;
/**
 *  @author J006, 15-06-26 13:06:44
 *
 *  该评论是否是自己发的
 */
@property (readwrite,nonatomic)      BOOL                                is_self;
@end
