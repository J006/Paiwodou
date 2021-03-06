/**
 * Autogenerated by Thrift Compiler (0.9.2)
 *
 * DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
 *  @generated
 */

#import <Foundation/Foundation.h>

#import "TProtocol.h"
#import "TApplicationException.h"
#import "TProtocolException.h"
#import "TProtocolUtil.h"
#import "TProcessor.h"
#import "TObjective-C.h"
#import "TBase.h"

#import "auth.h"
#import "content.h"
#import "user.h"
#import "search.h"

@interface InvalidOperation : NSException <TBase, NSCoding> {
  int32_t __error_id;
  NSString * __error_code;

  BOOL __error_id_isset;
  BOOL __error_code_isset;
}

#if TARGET_OS_IPHONE || (MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
@property (nonatomic, getter=error_id, setter=setError_id:) int32_t error_id;
@property (nonatomic, retain, getter=error_code, setter=setError_code:) NSString * error_code;
#endif

- (id) init;
- (id) initWithError_id: (int32_t) error_id error_code: (NSString *) error_code;

- (void) read: (id <TProtocol>) inProtocol;
- (void) write: (id <TProtocol>) outProtocol;

- (void) validate;

#if !__has_feature(objc_arc)
- (int32_t) error_id;
- (void) setError_id: (int32_t) error_id;
#endif
- (BOOL) error_idIsSet;

#if !__has_feature(objc_arc)
- (NSString *) error_code;
- (void) setError_code: (NSString *) error_code;
#endif
- (BOOL) error_codeIsSet;

@end

@protocol AppServer <NSObject>
- (NSString *) ping: (NSString *) msg;  // throws InvalidOperation *, TException
- (EmailLoginResponse *) email_login: (EmailLoginRequest *) request;  // throws InvalidOperation *, TException
- (SocialLoginResponse *) qq_login: (SocialLoginRequest *) request;  // throws InvalidOperation *, TException
- (SocialLoginResponse *) weibo_login: (SocialLoginRequest *) request;  // throws InvalidOperation *, TException
- (SocialLoginResponse *) weixin_login: (SocialLoginRequest *) request;  // throws InvalidOperation *, TException
- (GetFeedResponse *) get_feed: (GetFeedRequest *) request;  // throws InvalidOperation *, TException
- (GetRecommendPocketResponse *) get_recommend_pocket: (GetRecommendPocketRequest *) request;  // throws InvalidOperation *, TException
- (GetRecommendUserResponse *) get_recommend_user: (GetRecommendUserRequest *) request;  // throws InvalidOperation *, TException
- (GetDynamicListResponse *) get_dynamic_list: (GetDynamicListRequest *) request;  // throws InvalidOperation *, TException
- (GetAlbumListResponse *) get_album_list: (GetAlbumListRequest *) request;  // throws InvalidOperation *, TException
- (GetAlbumResponse *) get_album: (GetAlbumRequest *) request;  // throws InvalidOperation *, TException
- (GetPhotoResponse *) get_photo: (GetPhotoRequest *) request;  // throws InvalidOperation *, TException
- (GetPhotoRecommendResponse *) get_photo_recommend: (GetPhotoRecommendRequest *) request;  // throws InvalidOperation *, TException
- (GetPhotoCommentResponse *) get_photo_comment: (GetPhotoCommentRequest *) request;  // throws InvalidOperation *, TException
- (AddPhotoCommentResponse *) add_photo_comment: (AddPhotoCommentRequest *) request;  // throws InvalidOperation *, TException
- (void) delete_photo_comment: (DeletePhotoCommentRequest *) request;  // throws InvalidOperation *, TException
- (GetPocketListResponse *) get_pocket_list: (GetPocketListRequest *) request;  // throws InvalidOperation *, TException
- (GetPocketResponse *) get_pocket: (GetPocketRequest *) request;  // throws InvalidOperation *, TException
- (GetPocketCommentResponse *) get_pocket_comment: (GetPocketCommentRequest *) request;  // throws InvalidOperation *, TException
- (AddPocketCommentResponse *) add_pocket_comment: (AddPocketCommentRequest *) request;  // throws InvalidOperation *, TException
- (void) delete_pocket_comment: (DeletePocketCommentRequest *) request;  // throws InvalidOperation *, TException
- (GetUploadResponse *) get_upload: (GetUploadRequest *) request;  // throws InvalidOperation *, TException
- (GetHomeResponse *) get_home: (GetHomeRequest *) request;  // throws InvalidOperation *, TException
- (GetTopUserResponse *) get_top_user: (GetTopUserRequest *) request;  // throws InvalidOperation *, TException
- (FollowResponse *) follow: (FollowRequest *) request;  // throws InvalidOperation *, TException
- (UnFollowResponse *) un_follow: (UnFollowRequest *) request;  // throws InvalidOperation *, TException
- (GetFollowListResponse *) get_follow_list: (GetFollowListRequest *) request;  // throws InvalidOperation *, TException
- (GetFollowerListResponse *) get_follower_list: (GetFollowerListRequest *) request;  // throws InvalidOperation *, TException
- (void) add_photo_like: (AddPhotoLikeRequest *) request;  // throws InvalidOperation *, TException
- (void) delete_photo_like: (DeletePhotoLikeRequest *) request;  // throws InvalidOperation *, TException
- (void) add_pocket_like: (AddPocketLikeRequest *) request;  // throws InvalidOperation *, TException
- (void) delete_pocket_like: (DeletePocketLikeRequest *) request;  // throws InvalidOperation *, TException
- (void) add_photo_recommend: (AddPhotoRecommendRequest *) request;  // throws InvalidOperation *, TException
- (void) delete_photo_recommend: (DeletePhotoRecommendRequest *) request;  // throws InvalidOperation *, TException
- (void) add_pocket_recommend: (AddPocketRecommendRequest *) request;  // throws InvalidOperation *, TException
- (void) delete_pocket_recommend: (DeletePocketRecommendRequest *) request;  // throws InvalidOperation *, TException
- (void) put_stype: (PutStyleRequest *) request;  // throws InvalidOperation *, TException
- (GetUserInfoResponse *) get_user_info: (GetUserInfoRequest *) request;  // throws InvalidOperation *, TException
- (ModifyUserInfoResponse *) modify_user_info: (ModifyUserInfoRequest *) request;  // throws InvalidOperation *, TException
- (SearchPhotoResponse *) search_photo: (SearchPhotoRequest *) request;  // throws InvalidOperation *, TException
- (SearchUserResponse *) search_user: (SearchUserRequest *) request;  // throws InvalidOperation *, TException
- (HotSearchResponse *) hot_search: (HotSearchRequest *) request;  // throws InvalidOperation *, TException
@end

@interface AppServerClient : NSObject <AppServer> {
  id <TProtocol> inProtocol;
  id <TProtocol> outProtocol;
}
- (id) initWithProtocol: (id <TProtocol>) protocol;
- (id) initWithInProtocol: (id <TProtocol>) inProtocol outProtocol: (id <TProtocol>) outProtocol;
@end

@interface AppServerProcessor : NSObject <TProcessor> {
  id <AppServer> mService;
  NSDictionary * mMethodMap;
}
- (id) initWithAppServer: (id <AppServer>) service;
- (id<AppServer>) service;
@end

@interface serverConstants : NSObject {
}
@end
