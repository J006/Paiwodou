//
//  DouAPIManager.h
//  DouPaiwo
//
//  Created by J006 on 15/6/4.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "user.h"
#import "UserInstance.h"
#import "PocketItemInstance.h"
#import "AlbumInstance.h"
#import "AlbumPhotoInstance.h"
#import "RecommendPhotoInstance.h"
#import "DynamicContentInstance.h"
#import "DynamicContentPhotoInstance.h"
#import "server.h"
#import "search.h"
#import "TSocketClient.h"
#import "TBinaryProtocol.h"
#import "TTransport.h"
#import "CommentInstance.h"
#import "ErrorInstnace.h"
#import "LoginInstance.h"
#import "FileUploadInstance.h"
typedef NS_ENUM(NSInteger, SocialType)
{
  WeiboLoginType                              = 1,//微博
  WeiXinLoginType                             = 2,//微信
  QQLoginType                                 = 3,//QQ
};

/**
 *  @author J006, 15-06-04 16:06:01
 *
 *  兜的网络连接接口API类
 */
@interface DouAPIManager : NSObject

/**
 *  @author J006, 15-06-04 16:06:29
 *
 *  实例对象
 *
 *  @return
 */
+ (instancetype)sharedManager;
/**
 *  @author J006, 15-07-02 12:07:40
 *
 *  存session
 *
 *  @param seesion
 */
+ (void)saveSessionData :(NSString*)seesion;
/**
 *  @author J006, 15-07-02 14:07:35
 *
 *  存储当前domain
 *
 *  @param seesion
 */
+ (void)saveDomainData :(NSString*)domain;
/**
 *  @author J006, 15-07-02 12:07:58
 *
 *  删除session与domain
 */
+ (void)removeSessionData;
/**
 *  @author J006, 15-07-02 14:07:06
 *
 *  获取当前domain
 *
 *  @return
 */
+ (NSString*)currentDomainData;
/**
 *  @author J006, 15-07-02 19:07:04
 *
 *  获取当前session
 *
 *  @return
 */
+ (NSString*)currentSessionData;
/**
 *  @author J006, 15-08-04 19:07:16
 *
 *  获取上传图片接口
 *
 */
- (void)request_GetUpload                  :(void (^)(FileUploadInstance *fileUploadInstance, ErrorInstnace *error))block;
/**
 *  @author J006, 15-08-04 19:07:16
 *
 *  改变背景图
 *
 */
- (void)request_PutStyleWithBannerPhoto :(NSString*)banner_photo  :(void (^)(BOOL isSuccess, ErrorInstnace *error))block;
/**
 *  @author J006, 15-08-04 19:07:16
 *
 *  获取banner上的推荐Pocket
 *
 */
- (void)request_GetRecommendPocket         :(void (^)(NSMutableArray *array, ErrorInstnace *error))block;
/**
 *  @author J006, 15-08-04 19:07:16
 *
 *  获取有才华的摄影师
 *
 */
- (void)request_GetRecommendUser           :(void (^)(NSMutableArray *array, ErrorInstnace *error))block;
/**
 *  @author J006, 15-08-04 19:07:16
 *
 *  获取登录者的个人信息用以设置界面
 *
 */
- (void)request_GetUserInfo                :(void (^)(UserInstance *userInstance, ErrorInstnace *error))block;
/**
 *  @author J006, 15-08-04 19:07:16
 *
 *  更新用户信息
 *
 */
- (void)request_ModifyUserInfoWithUser     :(UserInstance*)user  :(void (^)(UserInstance *userInstance, ErrorInstnace *error))block;
/**
 *  @author J006, 15-07-02 19:07:16
 *
 *  登录接口,email或者手机号
 *
 *  @param email
 *  @param password
 *  @param block
 */
- (void)request_LoginWithEmail            :(NSString*)email password:(NSString*)password  :(void (^)(LoginInstance *userInstance, ErrorInstnace *error))block;
/**
 *  @author J006, 15-07-02 19:07:16
 *
 *  登录接口,openID
 *
 *  @param openID
 */
- (void)request_SocialLoginWithOpenID     :(NSString*)openID withTypeID:(SocialType)type :(void (^)(LoginInstance *userInstance, ErrorInstnace *error))block;
/**
 *  @author J006, 15-06-04 17:06:41
 *
 *  获取用户信息
 */
- (void)request_GetUserProfileWithDomain  :(NSString*)host_domain :(void (^)(UserInstance *data, NSError *error))block;
/**
 *  @author J006, 15-06-05 11:06:35
 *
 *  获取本人信息,根据session来获取
 */
- (void)request_GetTopUser :(void (^)(UserInstance *selfUser, NSError *error))block;
/**
 *  @author J006, 15-06-08 10:06:01
 *
 *  根据用户domain获取该用户的pocket列表
 *
 *  @param host_domain
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_GetPocketListWithDomain :(NSString*)host_domain page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *data, NSError *error))block;
/**
 *  @author J006, 15-06-06 15:06:36
 *
 *  根据用户domain获取该用户的专辑列表
 *
 *  @param host_domain
 *  @param page_no
 *  @param page_size
 *  @param block  需要返回专辑的集合
 */
- (void)request_GetAlbumListWithDomain :(NSString*)host_domain page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *data, NSError *error))block;
/**
 *  @author J006, 15-06-08 10:06:45
 *
 *  根据session和专辑id获取专辑
 *
 *  @param album_id
 *  @param block
 */
- (void)request_GetAlbumWithAlbumID :(NSInteger)album_id  :(void (^)(AlbumInstance *data, NSError *error))block;
/**
 *  @author J006, 15-06-08 11:06:22
 *
 *  根据session和专辑id获取图片
 *
 *  @param photo_id
 *  @param block
 */
- (void)request_GetAlbumPhotoWithPhotoID  :(NSInteger)photo_id  :(void (^)(AlbumPhotoInstance *albumPhotoInstance, NSError *error))block;
/**
 *  @author J006, 15-06-16 13:06:50
 *
 * 根据用户domain获取该用户的动态列表
 *
 *  @param host_domain
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_GetDynamicContentWithDomain :(NSString*)host_domain  page_no:(NSInteger)page_no page_size:(NSInteger)page_size :(void (^)(NSMutableArray *data, NSError *error))block;
/**
 *  @author J006, 15-07-17 13:06:50
 *
 * 根据用户session获取该用户feed列表
 *
 *  @param session
 *  @param time_stamp
 *  @param time_flag
 *  @param block
 */
- (void)request_GetFeedWithTimeStamp  :(double)time_stamp time_flag:(NSInteger)time_flag :(void (^)(NSMutableArray *data, double lastFeedTime, NSError *error))block;
/**
 *  @author J006, 15-06-19 12:06:44
 *
 *  搜索用户
 *
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_SearchUsersWithPageNo  :(NSInteger)page_no page_size:(NSInteger)page_size tags:(NSMutableArray*)tags :(void (^)(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error))block;
/**
 *  @author J006, 15-06-21 21:06:20
 *
 *  搜索图片
 *
 *  @param page_no
 *  @param page_size
 *  @param tags
 *  @param block
 */
- (void)request_SearchPhotoWithPageNo :(NSInteger)page_no page_size:(NSInteger)page_size tags:(NSMutableArray*)tags :(void (^)(NSMutableArray *photoData, NSInteger totalSearchNums, NSError *error))block;

/**
 *  @author J006, 15-06-26 11:06:05
 *
 *  点赞图片
 *
 *  @param photo_id
 *  @param block
 */
- (void)request_AddPhotoLikeWithPhotoID :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:15
 *
 *  取消图片点赞
 *
 *  @param photo_id
 *  @param block
 */
- (void)request_DelPhotoLikeWithPhotoID :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:10
 *
 *  推荐一张照片
 *
 *  @param photo_id
 *  @param block
 */
- (void)request_AddPhotoRecommendWithPhotoID  :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:46
 *
 *  取消推荐一张图片
 *
 *  @param photo_id
 *  @param block
 */
- (void)request_DelPhotoRecommendWithPhotoID  :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 13:06:25
 *
 *  获取图片评论
 *
 *  @param photo_id
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_GetPhotoCommentWithPhotoID  :(NSInteger)photo_id page_no:(NSInteger)page_no page_size:(NSInteger)page_size :(void (^)(NSMutableArray *commentsData, NSError *error))block;
/**
 *  @author J006, 15-06-28 15:06:18
 *
 *  增加一条评论
 *
 *  @param photo_id
 *  @param reply_user_id
 *  @param comment_text
 *  @param block
 */
- (void)request_AddPhotoCommentWithPhotoID  :(NSInteger)photo_id  reply_user_id:(NSInteger)reply_user_id  comment_text:(NSString*)comment_text :(void (^)(CommentInstance *comment, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:46
 *
 *  删除一条图片评论
 *
 *  @param comment_id
 *  @param block
 */
- (void)request_DelPhotoCommentWithCommentID  :(NSInteger)comment_id  photo_id:(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-29 13:06:07
 *
 *  点赞兜
 *
 *  @param pocket_id
 *  @param block
 */
- (void)request_AddPocketLikeWithPocketID  :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-29 13:06:10
 *
 *  取消点赞兜
 *
 *  @param pocket_id
 *  @param block
 */
- (void)request_DelPocketLikeWithPocketID :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:10
 *
 *  推荐一个兜
 *
 *  @param pocket_id
 *  @param block
 */
- (void)request_AddPocketRecommendWithPocketID  :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:46
 *
 *  取消推荐一个兜
 *
 *  @param pocket_id
 *  @param block
 */
- (void)request_DelPocketRecommendWithPocketID  :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-26 13:06:25
 *
 *  获取兜评论
 *
 *  @param pocket_id
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_GetPocketCommentWithPocketID  :(NSInteger)pocket_id page_no:(NSInteger)page_no page_size:(NSInteger)page_size :(void (^)(NSMutableArray *commentsData, NSError *error))block;
/**
 *  @author J006, 15-06-28 15:06:18
 *
 *  增加兜评论
 *
 *  @param pocket_id
 *  @param reply_user_id
 *  @param comment_text
 *  @param block
 */
- (void)request_AddPocketCommentWithPocketID  :(NSInteger)pocket_id  reply_user_id:(NSInteger)reply_user_id  comment_text:(NSString*)comment_text :(void (^)(CommentInstance *comment, NSError *error))block;
/**
 *  @author J006, 15-06-26 11:06:46
 *
 *  删除一个兜评论
 *
 *  @param comment_id
 *  @param block
 */
- (void)request_DelPocketCommentWithCommentID  :(NSInteger)comment_id pocket_id:(NSInteger)pocket_id :(void (^)(BOOL isSuccess, NSError *error))block;
/**
 *  @author J006, 15-06-29 14:06:39
 *
 *  关注对方
 *
 *  @param follow_id
 *  @param block
 */
- (void)request_FollowWithFollowID :(NSInteger)follow_id  :(void (^)(NSInteger follow_state, NSError *error))block;
/**
 *  @author J006, 15-06-29 14:06:46
 *
 *  取消关注对方
 *
 *  @param follow_id
 *  @param block
 */
- (void)request_UnFollowWithFollowID  :(NSInteger)follow_id  :(void (^)(NSInteger follow_state, NSError *error))block;
/**
 *  @author J006, 15-06-29 14:06:40
 *
 *  获取关注列表
 *
 *  @param host_domain
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_GetFollowListWithDomain :(NSString*)host_domain  page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *followers, NSError *error))block;
/**
 *  @author J006, 15-06-29 14:06:18
 *
 *  获取粉丝列表
 *
 *  @param host_domain
 *  @param page_no
 *  @param page_size
 *  @param block
 */
- (void)request_GetFollowerListWithDomain :(NSString*)host_domain  page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *fans, NSError *error))block;
/**
 *  @author J006, 15-07-04 13:07:41
 *
 *  获取照片的推荐图片
 *
 *  @param album_id
 *  @param block
 */
- (void)request_GetPhotoRecommendWithAlbumID :(NSInteger)album_id :(void (^)(NSMutableArray *recommendPhotoList, NSError *error))block;
/**
 *  @author J006, 15-07-05 14:07:07
 *
 *  获取兜详细信息
 *
 *  @param pocket_id
 *  @param block
 */
- (void)request_GetPocketWithPocketID :(NSInteger)pocket_id :(void (^)(PocketItemInstance *pocketItemInstance, NSError *error))block;
@end
