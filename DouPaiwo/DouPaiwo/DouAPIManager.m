//
//  DouAPIManager.m
//  DouPaiwo
//
//  Created by J006 on 15/6/4.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "DouAPIManager.h"
#define Code_SessionData      @"sessionCookies"
#define Code_DomainData       @"domainCookies"

@implementation DouAPIManager

+ (instancetype)sharedManager {
  static DouAPIManager *shared_manager = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    shared_manager = [[self alloc] init];
  });
  return shared_manager;
}

+ (void)saveSessionData :(NSString*)seesion
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject: seesion forKey: Code_SessionData];
  [defaults synchronize];
}

+ (void)saveDomainData :(NSString*)domain
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject: domain forKey: Code_DomainData];
  [defaults synchronize];
}

+ (void)removeSessionData
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults removeObjectForKey:Code_SessionData];
  [defaults removeObjectForKey:Code_DomainData];
  [defaults synchronize];
}

+ (NSString*)currentSessionData
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString    *session  = [defaults objectForKey:Code_SessionData];
  return session;
}

+ (NSString*)currentDomainData
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString    *domain  = [defaults objectForKey:Code_DomainData];
  return domain;
}

- (void)request_GetRecommendPocket         :(void (^)(NSMutableArray *array, ErrorInstnace *error))block
{
  @try
  {
    TSocketClient               *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetRecommendPocketRequest   *request            = [[GetRecommendPocketRequest  alloc]initWithSession:[DouAPIManager currentSessionData]];
    GetRecommendPocketResponse  *response           = [appClinet  get_recommend_pocket:request];
    NSMutableArray  *array  = [response  pocket_list];
    NSMutableArray  *tempPocketArray  = [[NSMutableArray alloc]initWithCapacity:[array  count]];
    for (RecommendPocket *pocket in array)
    {
      PocketItemInstance  *pocketInstance = [[PocketItemInstance alloc]init];
      pocketInstance.pocket_id                  = pocket.pocket_id;
      pocketInstance.pocket_title               = pocket.pocket_title;
      pocketInstance.cover_photo                = pocket.pocket_cover_photo;
      [tempPocketArray  addObject:pocketInstance];
    }
    block(tempPocketArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_GetRecommendPocket" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetRecommendPocket" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetRecommendUser           :(void (^)(NSMutableArray *array, ErrorInstnace *error))block
{
  @try
  {
    TSocketClient               *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetRecommendUserRequest     *request            = [[GetRecommendUserRequest  alloc]initWithSession:[DouAPIManager currentSessionData]];
    GetRecommendUserResponse    *response           = [appClinet  get_recommend_user:request];
    NSMutableArray  *array  = [response  user_list];
    NSMutableArray  *tempPocketArray  = [[NSMutableArray alloc]initWithCapacity:[array  count]];
    for (RecommendUser *user in array)
    {
      UserInstance  *userInstance = [[UserInstance alloc]init];
      userInstance.host_id                  = user.user_id;
      userInstance.host_name                = user.user_name;
      userInstance.host_avatar              = user.user_avatar;
      userInstance.host_domain              = user.user_domain;
      userInstance.follow_state             = 0;
      [tempPocketArray  addObject:userInstance];
    }
    block(tempPocketArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_GetRecommendUser" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetRecommendUser" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetUserInfo                :(void (^)(UserInstance *userInstance, ErrorInstnace *error))block
{
  @try
  {
    TSocketClient               *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetUserInfoRequest          *request            = [[GetUserInfoRequest  alloc]initWithSession:[DouAPIManager currentSessionData]];
    GetUserInfoResponse         *response           = [appClinet  get_user_info:request];
    UserInstance  *user  = [[UserInstance alloc]init];
    user.host_name       = [response  user_name];
    user.host_desc       = [response  user_desc];
    user.host_avatar     = [response  user_avatar];
    user.host_domain     = [response  user_domain];
    user.host_gender     = [response  gender];
    user.birthday        = [response  birthday];
    user.address         = [response  address];
    user.qq              = [response  qq];
    user.weixin          = [response  weixin];
    user.weibo           = [response  weibo];
    block(user,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_GetUserInfo" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetUserInfo" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_PutStyleWithBannerPhoto :(NSString*)banner_photo  :(void (^)(BOOL isSuccess, ErrorInstnace *error))block;
{
  @try
  {
    TSocketClient               *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    PutStyleRequest             *request            = [[PutStyleRequest  alloc]initWithSession:[DouAPIManager currentSessionData] banner_photo:banner_photo];
    [appClinet  put_stype:request];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(NO,[self debugLogInfor:@"request_PutStyleWithBannerPhoto" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_PutStyleWithBannerPhoto" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetUpload                  :(void (^)(FileUploadInstance *fileUploadInstance, ErrorInstnace *error))block;
{
  @try
  {
    TSocketClient               *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetUploadRequest            *request            = [[GetUploadRequest  alloc]initWithSession:[DouAPIManager currentSessionData]];
    GetUploadResponse           *response           = [appClinet  get_upload:request];
    FileUploadInstance          *fileUpload         = [[FileUploadInstance alloc]init];
    fileUpload.policy           =   response.policy;
    fileUpload.signature        =   response.signature;
    fileUpload.key_id           =   response.key_id;
    fileUpload.object_key       =   response.object_key;
    block(fileUpload,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_GetUpload" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetUpload" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_ModifyUserInfoWithUser     :(UserInstance*)user  :(void (^)(UserInstance *userInstance, ErrorInstnace *error))block
{
  @try
  {
    TSocketClient               *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    ModifyUserInfoRequest       *request            = [[ModifyUserInfoRequest  alloc]initWithSession:[DouAPIManager currentSessionData] user_name:user.host_name user_desc:user.host_desc user_avatar:user.host_avatar user_domain:user.host_domain gender:(int32_t)user.host_gender birthday:user.birthday address:user.address qq:user.qq weixin:user.weixin weibo:user.weibo];
    ModifyUserInfoResponse      *response           = [appClinet  modify_user_info:request];
    UserInstance  *user  = [[UserInstance alloc]init];
    user.host_name       = [response  user_name];
    user.host_desc       = [response  user_desc];
    user.host_avatar     = [response  user_avatar];
    user.host_domain     = [response  user_domain];
    user.host_gender     = [response  gender];
    user.birthday        = [response  birthday];
    user.address         = [response  address];
    user.qq              = [response  qq];
    user.weixin          = [response  weixin];
    user.weibo           = [response  weibo];
    block(user,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_ModifyUserInfoWithUser" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_ModifyUserInfoWithUser" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_LoginWithEmail  :(NSString*)email password:(NSString*)password  :(void (^)(LoginInstance *userInstance, ErrorInstnace *error))block;
{
  @try
  {
    TSocketClient           *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol         *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient         *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    EmailLoginRequest       *emailLoginRequest  = [[EmailLoginRequest  alloc]initWithEmail:email password:password];
    EmailLoginResponse      *emailLoginResponse = [appClinet  email_login:emailLoginRequest];
    LoginInstance           *login               = [[LoginInstance alloc]init];
    login.user_id          =    [emailLoginResponse user_id];
    login.email_state      =    [emailLoginResponse email_state];
    login.gift             =    [emailLoginResponse gift];
    login.session          =    [emailLoginResponse session];
    [DouAPIManager removeSessionData];
    [DouAPIManager saveSessionData:[emailLoginResponse session]];
    block(login,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_LoginWithEmail" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_LoginWithEmail" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_SocialLoginWithOpenID     :(NSString*)openID withTypeID:(SocialType)type :(void (^)(LoginInstance *userInstance, ErrorInstnace *error))block;
{
  @try
  {
    TSocketClient           *transport            = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol         *protocol             = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient         *appClinet            = [[AppServerClient  alloc]initWithProtocol:protocol];
    SocialLoginRequest      *socialLoginRequest   = [[SocialLoginRequest  alloc]initWithOpen_id:openID];
    SocialLoginResponse     *socialLoginResponse;
    switch (type)
    {
      case WeiboLoginType:
        socialLoginResponse = [appClinet weibo_login:socialLoginRequest];
        break;
      case WeiXinLoginType:
        socialLoginResponse = [appClinet weixin_login:socialLoginRequest];
        break;
      case QQLoginType:
        socialLoginResponse = [appClinet qq_login:socialLoginRequest];
        break;
    }
    LoginInstance *login   =    [[LoginInstance alloc]init];
    login.user_id          =    [socialLoginResponse user_id];
    login.gift             =    [socialLoginResponse gift];
    login.session          =    [socialLoginResponse session];
    login.is_first         =    [socialLoginResponse is_first];
    [DouAPIManager removeSessionData];
    [DouAPIManager saveSessionData:[socialLoginResponse session]];
    block(login,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,[self debugLogInfor:@"request_SocialLoginWithOpenID" NSException:nil InvalidOperation:invalid]);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"v" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetUserProfileWithDomain  :(NSString*)host_domain :(void (^)(UserInstance *data, NSError *error))block;
{
  @try
  {
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient *appClinet  = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetHomeRequest   *getHomeRequest = [[GetHomeRequest alloc]initWithSession:[DouAPIManager currentSessionData] host_domain:host_domain];
    GetHomeResponse  *homeResponse  = [appClinet    get_home:getHomeRequest];
    UserInstance  *userInstance = [[UserInstance alloc]init];
    userInstance.is_self        =  [homeResponse is_self];//与session对比,决定是否是自己
    userInstance.host_id        =  [homeResponse host_id];//用户id
    userInstance.host_name      =  [homeResponse host_name];//用户名
    userInstance.host_avatar    =  [homeResponse host_avatar];//用户头像地址
    userInstance.host_domain    =  [homeResponse host_domain];//个性域名
    userInstance.host_desc      =  [homeResponse host_desc];//个人简介,说明
    userInstance.host_gender    =  [homeResponse host_gender];//性别
    userInstance.banner_photo    =  [homeResponse banner_photo];//banner图片
    userInstance.dynamic_count  = [homeResponse dynamic_count];//动态数
    userInstance.follow_count   =  [homeResponse follow_count];//关注数
    userInstance.follower_count =    [homeResponse follower_count];//粉丝数
    userInstance.follow_state   =  [homeResponse follow_state];//1是未关注,2是你关注了他,3是他关注了你,4是互相关注
    userInstance.address        = [homeResponse address];//地址的编码
    userInstance.gift           = [homeResponse gift];//天赋:摄影师,模特,化妆师,与1 &一下就是摄影师
    userInstance.photograph_type=[homeResponse  photograph_type];//拍摄类型
    userInstance.photograph_address=[homeResponse photograph_address];//拍摄地址
    block(userInstance,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetUserProfileWithDomain" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetUserProfileWithDomain" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_GetTopUser :(void (^)(UserInstance *selfUser, NSError *error))block;
{
  @try
  {
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient *appClinet  = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetTopUserRequest   *getTopUserRequest    = [[GetTopUserRequest alloc]initWithSession:[DouAPIManager currentSessionData]];
    GetTopUserResponse  *getTopUserResponse   = [appClinet  get_top_user:getTopUserRequest];
    UserInstance  *user = [[UserInstance alloc]init];
    user.host_name      = [getTopUserResponse  user_name];
    user.gift           = [getTopUserResponse  gift];
    user.host_avatar    = [getTopUserResponse  user_avatar];
    user.host_domain    = [getTopUserResponse  user_domain];
    if(![DouAPIManager currentDomainData])
      [DouAPIManager  saveDomainData:[getTopUserResponse  user_domain]];
    block(user, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetTopUser" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetTopUser" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_GetPocketListWithDomain :(NSString*)host_domain page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *data, NSError *error))block;
{
  @try
  {
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient *appClinet  = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetPocketListRequest  *getPocketListRequest  = [[GetPocketListRequest alloc]initWithSession:[DouAPIManager  currentSessionData] host_domain:host_domain page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetPocketListResponse *getPocketListRespon   =  [appClinet  get_pocket_list:getPocketListRequest];
    NSMutableArray  *array  = [getPocketListRespon  pocket_list];
    NSMutableArray  *tempPocketArray  = [[NSMutableArray alloc]initWithCapacity:[array  count]];
    for (Pocket *pocket in array)
    {
      PocketItemInstance  *pocketInstance = [[PocketItemInstance alloc]init];
      pocketInstance.pocket_id                  = pocket.pocket_id;
      pocketInstance.pocket_title               = pocket.pocket_title;
      pocketInstance.pocket_second_title        = pocket.pocket_second_title;
      pocketInstance.cover_photo                = pocket.cover_photo;
      pocketInstance.create_time                = pocket.create_time;
      pocketInstance.is_like                    = pocket.is_like;
      pocketInstance.is_recommend               = pocket.is_recommend;
      [tempPocketArray  addObject:pocketInstance];
    }
    block(tempPocketArray, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetPocketListWithDomain" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetPocketListWithDomain" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
  
}

- (void)request_GetAlbumListWithDomain :(NSString*)host_domain page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *data, NSError *error))block;
{
  @try
  {
    TSocketClient *transport = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol *protocol = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient *appClinet  = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetAlbumListRequest  *getAblumListRequest  =  [[GetAlbumListRequest alloc]initWithSession:[DouAPIManager  currentSessionData] host_domain:host_domain page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetAlbumListResponse *getAblumListRespon   =  [appClinet  get_album_list:getAblumListRequest];
    NSMutableArray  *array  = [getAblumListRespon  album_list];
    NSMutableArray  *tempAlbumArray  = [[NSMutableArray alloc]initWithCapacity:[array  count]];
    for (Album *album in array)
    {
      AlbumInstance  *albumInstance = [[AlbumInstance alloc]init];
      albumInstance.album_id  = album.album_id;
      albumInstance.is_self   = album.album_name;
      albumInstance.photo_count = album.photo_count;
      albumInstance.cover_path = album.cover_path;
      //AlbumPhotoInstance  *albumPhoto = [self request_GetAlbum];;
      
    }
    block(tempAlbumArray, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetAlbumListWithDomain" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetAlbumListWithDomain" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }

}

- (void)request_GetAlbumWithAlbumID :(NSInteger)album_id  :(void (^)(AlbumInstance *data, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetAlbumRequest       *getAlbumRequest    = [[GetAlbumRequest  alloc]initWithSession:[DouAPIManager currentSessionData] album_id:album_id];
    GetAlbumResponse      *getAlbumResponse   = [appClinet  get_album:getAlbumRequest];
    NSMutableArray        *albumPhotoList     =[[NSMutableArray  alloc]init];
    AlbumInstance         *album              = [[AlbumInstance  alloc]init];
    album.album_id  = getAlbumResponse.album_id;
    album.is_self  = getAlbumResponse.is_self;
    album.album_name  = getAlbumResponse.album_name;
    album.album_desc  = getAlbumResponse.album_desc;
    album.cc_protocol  = getAlbumResponse.cc_protocol;
    album.create_time  = getAlbumResponse.create_time;
    album.tags  = getAlbumResponse.tags;
    for (AlbumPhoto *albumPhoto  in getAlbumResponse.photo_list)
    {
      AlbumPhotoInstance  *albumPhotoInstance = [[AlbumPhotoInstance alloc]init];
      albumPhotoInstance.photo_id     =     albumPhoto.photo_id;
      albumPhotoInstance.photo_path   =     albumPhoto.photo_path;
      albumPhotoInstance.sequence_id  =     albumPhoto.sequence_id;
      albumPhotoInstance.is_like      =     albumPhoto.is_like;
      [albumPhotoList addObject:albumPhotoInstance];
    }
    if(albumPhotoList)
      album.photo_count = [albumPhotoList count];
    album.photo_list  = albumPhotoList;
    album.author_name  = getAlbumResponse.author_name;
    album.author_domain  = getAlbumResponse.author_domain;
    album.author_avatar  = getAlbumResponse.author_avatar;
    block(album, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetAlbumWithAlbumID" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetAlbumWithAlbumID" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_GetAlbumPhotoWithPhotoID  :(NSInteger)photo_id  :(void (^)(AlbumPhotoInstance *albumPhotoInstance, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetPhotoRequest       *getPhotoRequest    = [[GetPhotoRequest  alloc]initWithSession:[DouAPIManager currentSessionData] photo_id:photo_id];
    GetPhotoResponse      *getPhotoResponse   = [appClinet  get_photo:getPhotoRequest];
    AlbumPhotoInstance    *albumPhotoInstnace = [[AlbumPhotoInstance alloc]init];
    albumPhotoInstnace.photo_id             = [getPhotoResponse  photo_id];
    albumPhotoInstnace.photo_path           = [getPhotoResponse  photo_path];
    albumPhotoInstnace.album_id             = [getPhotoResponse  album_id];
    albumPhotoInstnace.album_name           = [getPhotoResponse  album_name];
    albumPhotoInstnace.author_id            = [getPhotoResponse  author_id];
    albumPhotoInstnace.author_name          = [getPhotoResponse  author_name];
    albumPhotoInstnace.author_avatar        = [getPhotoResponse  author_avatar];
    albumPhotoInstnace.author_domain        = [getPhotoResponse  author_domain];
    albumPhotoInstnace.cc_protocol          = [getPhotoResponse  cc_protocol];
    NSMutableArray    *photoListArray = [[NSMutableArray alloc]initWithCapacity:[[getPhotoResponse photo_list] count]];
    for (Photo *photo in [getPhotoResponse photo_list])
    {
      AlbumPhotoInstance    *albumPhoto;
      if(photo.photo_id ==  albumPhotoInstnace.photo_id)
        albumPhoto  = albumPhotoInstnace;
      else
        albumPhoto  = [[AlbumPhotoInstance alloc]init];
      albumPhoto.photo_id     =   photo.photo_id;
      albumPhoto.photo_path   =   photo.photo_path;
      albumPhoto.sequence_id  =   photo.sequence_id;
      albumPhoto.temperature  =   photo.temperature;
      albumPhoto.is_like      =   photo.is_like;
      albumPhoto.is_favorite  =   photo.is_favorite;
      albumPhoto.is_recommend =   photo.is_recommend;
      [photoListArray addObject:albumPhoto];
    }
    albumPhotoInstnace.photo_list = photoListArray;
    block(albumPhotoInstnace, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetAlbumPhotoWithPhotoID" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetAlbumPhotoWithPhotoID" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_GetDynamicContentWithDomain :(NSString*)host_domain  page_no:(NSInteger)page_no page_size:(NSInteger)page_size :(void (^)(NSMutableArray *data, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetDynamicListRequest *dynamicListRequest = [[GetDynamicListRequest  alloc]initWithSession:[DouAPIManager currentSessionData] host_domain:host_domain page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetDynamicListResponse *dynamicListResponse   =  [appClinet  get_dynamic_list:dynamicListRequest];
    NSMutableArray  *array  = [dynamicListResponse  content_list];
    NSMutableArray  *responArray;
    for (DynamicContent *dynamic in array)
    {
      if(!responArray)
        responArray = [[NSMutableArray alloc]initWithCapacity:[array count]];
      
      if(dynamic.content_type ==  publish_album)
      {
        AlbumInstance  *albumInstance  = [[AlbumInstance  alloc]init];
        albumInstance.album_id          = dynamic.content_id;
        albumInstance.album_type        = dynamic.content_type;
        albumInstance.user_id           = dynamic.content_user_id;
        albumInstance.user_name         = dynamic.content_user_name;
        albumInstance.user_avatar       = dynamic.content_user_avatar;
        albumInstance.user_domain       = dynamic.content_user_domain;
        NSMutableArray  *albumPhotoArray;
        for (DynamicContentPhoto *objectPhoto in dynamic.photo_list)
        {
          if(!albumPhotoArray)
            albumPhotoArray = [[NSMutableArray alloc]init];
          AlbumPhotoInstance *albumPhoto = [[AlbumPhotoInstance  alloc]init];
          albumPhoto.photo_id = objectPhoto.photo_id;
          albumPhoto.photo_path = objectPhoto.photo_path;
          albumPhoto.is_cover = objectPhoto.is_cover;
          [albumPhotoArray  addObject:albumPhoto];
        }
        albumInstance.photo_list      = albumPhotoArray;
        albumInstance.photo_count     = dynamic.photo_count;
        albumInstance.album_name      = dynamic.content_title;
        albumInstance.album_desc      = dynamic.content_desc;
        albumInstance.create_time     = dynamic.create_time;
        albumInstance.author_id       = dynamic.content_author_id;
        albumInstance.author_name     = dynamic.content_author_name;
        albumInstance.author_domain   = dynamic.content_author_domain;
        albumInstance.is_like         = dynamic.is_like;
        albumInstance.is_recommend    = dynamic.is_recommend;
        albumInstance.is_delete       = dynamic.is_delete;
        [responArray addObject:albumInstance];
      }
      else if(dynamic.content_type ==  recommend_pocket || dynamic.content_type ==  publish_pocket)
      {
        PocketItemInstance  *pocketInstance  = [[PocketItemInstance  alloc]init];
        pocketInstance.pocket_id            = dynamic.content_id;
        pocketInstance.pocket_type          = dynamic.content_type;
        pocketInstance.user_id              = dynamic.content_user_id;
        pocketInstance.user_name            = dynamic.content_user_name;
        pocketInstance.user_avatar          = dynamic.content_user_avatar;
        pocketInstance.user_domain          = dynamic.content_user_domain;
        for (DynamicContentPhoto *objectPhoto in dynamic.photo_list)
        {
          pocketInstance.cover_photo = objectPhoto.photo_path;
        }
        pocketInstance.photo_count          = dynamic.photo_count;
        pocketInstance.pocket_title         = dynamic.content_title;
        pocketInstance.pocket_second_title  = dynamic.content_desc;
        pocketInstance.author_id            = dynamic.content_author_id;
        pocketInstance.author_name          = dynamic.content_author_name;
        pocketInstance.author_domain        = dynamic.content_author_domain;
        pocketInstance.create_time          = dynamic.create_time;
        pocketInstance.is_like              = dynamic.is_like;
        pocketInstance.is_recommend         = dynamic.is_recommend;
        pocketInstance.is_delete            = dynamic.is_delete;
        [responArray addObject:pocketInstance];
      }
      else  if(dynamic.content_type ==  recommend_photo)
      {
        RecommendPhotoInstance  *recommendPhotoInstance  = [[RecommendPhotoInstance  alloc]init];
        recommendPhotoInstance.photo_id     = dynamic.content_id;
        recommendPhotoInstance.type         = dynamic.content_type;
        recommendPhotoInstance.user_id      = dynamic.content_user_id;
        recommendPhotoInstance.user_name    = dynamic.content_user_name;
        recommendPhotoInstance.user_avatar  = dynamic.content_user_avatar;
        recommendPhotoInstance.user_domain  = dynamic.content_user_domain;
        NSMutableArray  *albumPhotoArray;
        for (DynamicContentPhoto *objectPhoto in dynamic.photo_list)
        {
          if(!albumPhotoArray)
            albumPhotoArray = [[NSMutableArray alloc]init];
          AlbumPhotoInstance *albumPhoto = [[AlbumPhotoInstance  alloc]init];
          albumPhoto.photo_id = objectPhoto.photo_id;
          albumPhoto.photo_path = objectPhoto.photo_path;
          albumPhoto.is_cover = objectPhoto.is_cover;
          [albumPhotoArray  addObject:albumPhoto];
          recommendPhotoInstance.cover_path = objectPhoto.photo_path;
        }
        recommendPhotoInstance.photo_list   = albumPhotoArray;
        recommendPhotoInstance.photo_count  = dynamic.photo_count;
        recommendPhotoInstance.photo_name   = dynamic.content_title;
        recommendPhotoInstance.author_id    = dynamic.content_author_id;
        recommendPhotoInstance.author_name  = dynamic.content_author_name;
        recommendPhotoInstance.author_domain= dynamic.content_author_domain;
        recommendPhotoInstance.photo_desc   = dynamic.content_desc;
        recommendPhotoInstance.create_time  = dynamic.create_time;
        recommendPhotoInstance.is_like      = dynamic.is_like;
        recommendPhotoInstance.is_recommend = dynamic.is_recommend;
        recommendPhotoInstance.is_delete    = dynamic.is_delete;
        [responArray addObject:recommendPhotoInstance];
      }
    }
    block(responArray, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil, nil);
    [self debugLogInfor:@"request_GetDynamicContentWithDomain" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    block(nil, nil);
    [self debugLogInfor:@"request_GetDynamicContentWithDomain" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }

}

- (void)request_GetFeedWithTimeStamp  :(double)time_stamp time_flag:(NSInteger)time_flag :(void (^)(NSMutableArray *data, double lastFeedTime, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetFeedRequest        *getFeedRequest     = [[GetFeedRequest  alloc]initWithSession:[DouAPIManager currentSessionData] time_stamp:time_stamp time_flag:(int32_t)time_flag];
    GetFeedResponse       *getFeedResponse    =  [appClinet  get_feed:getFeedRequest];
    NSMutableArray  *array  = [getFeedResponse  feed_list];
    NSMutableArray  *responArray;
    double  lastFeed  = 0;
    for (FeedContent *feed in array)
    {
      if(!responArray)
        responArray = [[NSMutableArray alloc]initWithCapacity:[array count]];
      //NSString      *typeName;
      NSData        *contentData    = [feed.content dataUsingEncoding:NSUTF8StringEncoding];
      NSDictionary  *contentDic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableLeaves error:nil];
      if(feed.content_type ==  publish_album)
      {
        AlbumInstance  *albumInstance  = [[AlbumInstance  alloc]init];
        albumInstance.album_id          = feed.content_id;
        albumInstance.album_type        = feed.content_type;
        albumInstance.user_id           = feed.user_id;
        albumInstance.user_name         = feed.user_name;
        albumInstance.user_avatar       = feed.user_avatar;
        albumInstance.user_domain       = feed.user_domain;
        albumInstance.feed_time         = feed.feed_time;
        albumInstance.author_name       = [contentDic  objectForKey:@"content_author_name"];
        albumInstance.album_name        = [contentDic  objectForKey:@"album_name"];
        albumInstance.photo_count       = [(NSNumber*)[contentDic  objectForKey:@"photo_count"]longLongValue];
        albumInstance.author_id         = [(NSNumber*)[contentDic  objectForKey:@"content_author_id"]longLongValue];
        albumInstance.is_delete         = [[contentDic  objectForKey:@"is_delete"] boolValue];
        albumInstance.author_domain     = [contentDic  objectForKey:@"content_author_domain"];
        NSMutableArray                  *albumPhotoArray;
        for (NSDictionary *dic in [contentDic  objectForKey:@"photo_list"])
        {
          if(!albumPhotoArray)
            albumPhotoArray = [[NSMutableArray alloc]init];
          AlbumPhotoInstance  *albumPhoto = [[AlbumPhotoInstance alloc]init];
          if([dic objectForKey:@"is_cover"])
            albumPhoto.is_cover = [[dic objectForKey:@"is_cover"]boolValue];
          if([dic objectForKey:@"photo_path"])
            albumPhoto.photo_path = [dic objectForKey:@"photo_path"];
          if([dic objectForKey:@"photo_id"])
            albumPhoto.photo_id = [(NSNumber*)[dic objectForKey:@"photo_id"]longLongValue];
          [albumPhotoArray addObject:albumPhoto];
        }
        albumInstance.photo_list    = albumPhotoArray;
        lastFeed  = albumInstance.feed_time;
        [responArray addObject:albumInstance];
      }
      else if(feed.content_type ==  recommend_pocket || feed.content_type ==  publish_pocket)
      {
        PocketItemInstance  *pocketInstance  = [[PocketItemInstance  alloc]init];
        pocketInstance.pocket_id            = feed.content_id;
        pocketInstance.pocket_type          = feed.content_type;
        pocketInstance.user_id              = feed.user_id;
        pocketInstance.user_name            = feed.user_name;
        pocketInstance.user_avatar          = feed.user_avatar;
        pocketInstance.user_domain          = feed.user_domain;
        pocketInstance.feed_time            = feed.feed_time;
        pocketInstance.author_name          = [contentDic  objectForKey:@"content_author_name"];
        pocketInstance.pocket_second_title  = [contentDic  objectForKey:@"pocket_second_title"];
        pocketInstance.is_recommend         = [[contentDic  objectForKey:@"is_recommend"]boolValue];
        pocketInstance.author_id            = [(NSNumber*)[contentDic  objectForKey:@"content_author_id"] longLongValue];
        pocketInstance.is_like              = [[contentDic  objectForKey:@"is_like"] boolValue];
        pocketInstance.is_delete            = [[contentDic  objectForKey:@"is_delete"]boolValue];
        pocketInstance.pocket_title         = [contentDic  objectForKey:@"pocket_title"];
        pocketInstance.author_domain        = [contentDic  objectForKey:@"content_author_domain"];
        pocketInstance.cover_photo          = [contentDic  objectForKey:@"cover_photo"];
        lastFeed  = pocketInstance.feed_time;
        [responArray addObject:pocketInstance];
      }
      else  if(feed.content_type ==  recommend_photo)
      {
        RecommendPhotoInstance  *recommendPhotoInstance  = [[RecommendPhotoInstance  alloc]init];
        recommendPhotoInstance.photo_id     = feed.content_id;
        recommendPhotoInstance.type         = feed.content_type;
        recommendPhotoInstance.user_id      = feed.user_id;
        recommendPhotoInstance.user_name    = feed.user_name;
        recommendPhotoInstance.user_avatar  = feed.user_avatar;
        recommendPhotoInstance.feed_time    = feed.feed_time;
        recommendPhotoInstance.is_like      = [[contentDic  objectForKey:@"is_like"]boolValue];
        recommendPhotoInstance.is_delete    = [[contentDic  objectForKey:@"is_delete"]boolValue];
        recommendPhotoInstance.is_recommend = [[contentDic  objectForKey:@"is_recommend"]boolValue];
        recommendPhotoInstance.author_name  = [contentDic  objectForKey:@"content_author_name"];
        recommendPhotoInstance.cover_path   = [contentDic  objectForKey:@"photo_path"];
        recommendPhotoInstance.author_domain= [contentDic  objectForKey:@"content_author_domain"];
        recommendPhotoInstance.author_id    = [(NSNumber*)[contentDic  objectForKey:@"content_author_id"] longLongValue];
        lastFeed  = recommendPhotoInstance.feed_time;
        [responArray addObject:recommendPhotoInstance];
      }
    }
    block(responArray,lastFeed, nil);
  }
  @catch (InvalidOperation *invalid)
  {
    block(nil,0, nil);
    [self debugLogInfor:@"request_GetFeedWithTimeStamp" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    block(nil,0, nil);
    [self debugLogInfor:@"request_GetFeedWithTimeStamp" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_SearchUsersWithPageNo  :(NSInteger)page_no page_size:(NSInteger)page_size tags:(NSMutableArray*)tags :(void (^)(NSMutableArray *usersData, NSInteger totalSearchNums, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    SearchUserRequest     *searchUserRequest  = [[SearchUserRequest  alloc]initWithSession:[DouAPIManager currentSessionData] page_no:(int32_t)page_no page_size:(int32_t)page_size tags:tags];
    SearchUserResponse    *searchUserResponse = [appClinet  search_user:searchUserRequest];
    NSMutableArray  *usersArray  = [searchUserResponse  user_list];
    NSMutableArray  *resultArray;
    NSInteger tempTotalSearchNums = searchUserResponse.count;
    for (SearchUser *searchUser in usersArray)
    {
      if(!resultArray)
        resultArray = [[NSMutableArray alloc]initWithCapacity:[usersArray count]];
      UserInstance  *userInstance = [[UserInstance alloc]init];
      userInstance.host_id          = searchUser.user_id;
      userInstance.host_name        = searchUser.user_name;
      userInstance.host_desc        = searchUser.user_desc;
      userInstance.host_avatar      = searchUser.avatar;
      userInstance.host_domain      = searchUser.domain;
      userInstance.host_gender      = searchUser.gender;
      userInstance.address          = searchUser.address;
      userInstance.follow_state     = searchUser.follow_state;
      [resultArray addObject:userInstance];
    }
    block(resultArray, tempTotalSearchNums,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_SearchUsersWithPageNo" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_SearchUsersWithPageNo" NSException:exception InvalidOperation:nil];
  }
  @finally
  {

  }
}

- (void)request_SearchPhotoWithPageNo :(NSInteger)page_no page_size:(NSInteger)page_size tags:(NSMutableArray*)tags :(void (^)(NSMutableArray *photoData, NSInteger totalSearchNums, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    SearchPhotoRequest    *searchPhotoRequest = [[SearchPhotoRequest  alloc]initWithSession:[DouAPIManager  currentSessionData] page_no:(int32_t)page_no page_size:(int32_t)page_size tags:tags];
    SearchPhotoResponse   *searchPhotoResponse = [appClinet  search_photo:searchPhotoRequest];
    NSMutableArray  *photosArray  = [searchPhotoResponse  photo_list];
    NSMutableArray  *resultArray;
    NSInteger tempTotalSearchNums = searchPhotoResponse.count;
    for (SearchPhoto *searchPhoto in photosArray)
    {
      if(!resultArray)
        resultArray = [[NSMutableArray alloc]initWithCapacity:[photosArray count]];
      AlbumPhotoInstance  *photoInstance = [[AlbumPhotoInstance alloc]init];
      photoInstance.photo_id          = searchPhoto.photo_id;
      photoInstance.photo_path        = searchPhoto.photo_path;
      photoInstance.is_like           = searchPhoto.is_like;
      photoInstance.author_name       = searchPhoto.author_name;
      photoInstance.author_domain     = searchPhoto.author_domain;
      [resultArray addObject:photoInstance];
    }
     block(resultArray, tempTotalSearchNums,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_SearchPhotoWithPageNo" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_SearchPhotoWithPageNo" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_AddPhotoLikeWithPhotoID :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient         *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol       *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient       *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    AddPhotoLikeRequest   *addPhotoLikeRequest= [[AddPhotoLikeRequest  alloc]initWithSession:[DouAPIManager currentSessionData] photo_id:photo_id];
    [appClinet  add_photo_like:addPhotoLikeRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_AddPhotoLikeWithPhotoID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_AddPhotoLikeWithPhotoID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_DelPhotoLikeWithPhotoID :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient             *transport          = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol           *protocol           = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient           *appClinet          = [[AppServerClient  alloc]initWithProtocol:protocol];
    DeletePhotoLikeRequest    *delPhotoLikeRequest= [[DeletePhotoLikeRequest  alloc]initWithSession:[DouAPIManager  currentSessionData] photo_id:photo_id];
    [appClinet  delete_photo_like:delPhotoLikeRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_DelPhotoLikeWithPhotoID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_DelPhotoLikeWithPhotoID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_AddPhotoRecommendWithPhotoID  :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient               *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol             *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient             *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    AddPhotoRecommendRequest    *addPhotoRecommendRequest = [[AddPhotoRecommendRequest  alloc]initWithSession:[DouAPIManager currentSessionData] photo_id:photo_id];
    [appClinet  add_photo_recommend:addPhotoRecommendRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_AddPhotoRecommendWithPhotoID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_AddPhotoRecommendWithPhotoID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_DelPhotoRecommendWithPhotoID  :(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    DeletePhotoRecommendRequest   *delPhotoRecommendRequest = [[DeletePhotoRecommendRequest  alloc]initWithSession:[DouAPIManager currentSessionData] photo_id:photo_id];
    [appClinet  delete_photo_recommend:delPhotoRecommendRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_DelPhotoRecommendWithPhotoID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_DelPhotoRecommendWithPhotoID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetPhotoCommentWithPhotoID  :(NSInteger)photo_id page_no:(NSInteger)page_no page_size:(NSInteger)page_size :(void (^)(NSMutableArray *commentsData, NSError *error))block;
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetPhotoCommentRequest        *getPhotoCommentRequest   = [[GetPhotoCommentRequest alloc]initWithSession:[DouAPIManager currentSessionData] photo_id:photo_id page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetPhotoCommentResponse       *getPhotoCommentResponse  = [appClinet  get_photo_comment:getPhotoCommentRequest];
    NSMutableArray                *commentArray;
    for (Comment *comment in [getPhotoCommentResponse comment_list])
    {
      if(!commentArray)
        commentArray  = [[NSMutableArray alloc]initWithCapacity:[[getPhotoCommentResponse comment_list] count]];
      CommentInstance        *commentInstnace  = [[CommentInstance alloc]init];
      commentInstnace.comment_id             =         comment.comment_id;
      commentInstnace.comment_text           =         comment.comment_text;
      commentInstnace.comment_user_id        =         comment.comment_user_id;
      commentInstnace.comment_user_name      =         comment.comment_user_name;
      commentInstnace.comment_user_avatar    =         comment.comment_user_avatar;
      commentInstnace.comment_user_domain    =         comment.comment_user_domain;
      commentInstnace.reply_user_id          =         comment.reply_user_id;
      commentInstnace.reply_user_name        =         comment.reply_user_name;
      commentInstnace.reply_user_domain      =         comment.reply_user_domain;
      commentInstnace.create_time            =         comment.create_time;
      commentInstnace.is_self                =         comment.is_self;
      [commentArray addObject:commentInstnace];
    }
    block(commentArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetPhotoCommentWithPhotoID" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetPhotoCommentWithPhotoID" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }

}

- (void)request_AddPhotoCommentWithPhotoID  :(NSInteger)photo_id  reply_user_id:(NSInteger)reply_user_id  comment_text:(NSString*)comment_text :(void (^)(CommentInstance *comment, NSError *error))block;
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    AddPhotoCommentRequest        *addPhotoCommentRequest   = [[AddPhotoCommentRequest alloc]initWithSession:[DouAPIManager currentSessionData] reply_user_id:reply_user_id photo_id:photo_id comment_text:comment_text];
    AddPhotoCommentResponse       *addPhotoCommentResponse  = [appClinet  add_photo_comment:addPhotoCommentRequest];
    CommentInstance               *photoComment             = [[CommentInstance alloc]init];
    Comment                       *comment                  = [addPhotoCommentResponse comment];
    photoComment.comment_id       =   comment.comment_id;
    photoComment.comment_text     =   comment.comment_text;
    photoComment.comment_user_id     =   comment.comment_user_id;
    photoComment.comment_user_name     =   comment.comment_user_name;
    photoComment.comment_user_avatar     =   comment.comment_user_avatar;
    photoComment.comment_user_domain     =   comment.comment_user_domain;
    photoComment.reply_user_id     =   comment.reply_user_id;
    photoComment.reply_user_name     =   comment.reply_user_name;
    photoComment.reply_user_domain     =   comment.reply_user_domain;
    photoComment.create_time     =   comment.create_time;
    photoComment.is_self     =   comment.is_self;
    block(photoComment,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_AddPhotoCommentWithPhotoID" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_AddPhotoCommentWithPhotoID" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_DelPhotoCommentWithCommentID  :(NSInteger)comment_id  photo_id:(NSInteger)photo_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    DeletePhotoCommentRequest     *delPhotoCommentRequest   = [[DeletePhotoCommentRequest  alloc]initWithSession:[DouAPIManager currentSessionData] photo_id:photo_id comment_id:comment_id];
    [appClinet  delete_photo_comment:delPhotoCommentRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_DelPhotoCommentWithCommentID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_DelPhotoCommentWithCommentID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_AddPocketLikeWithPocketID  :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient           *transport            = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol         *protocol             = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient         *appClinet            = [[AppServerClient  alloc]initWithProtocol:protocol];
    AddPocketLikeRequest    *addPocketLikeRequest = [[AddPocketLikeRequest  alloc]initWithSession:[DouAPIManager  currentSessionData] pocket_id:pocket_id];
    [appClinet  add_pocket_like:addPocketLikeRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_AddPocketLikeWithPocketID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_AddPocketLikeWithPocketID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_DelPocketLikeWithPocketID :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    DeletePocketLikeRequest       *delPocketLikeRequest     = [[DeletePocketLikeRequest  alloc]initWithSession:[DouAPIManager currentSessionData] pocket_id:pocket_id];
    [appClinet  delete_pocket_like:delPocketLikeRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_DelPocketLikeWithPocketID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_DelPocketLikeWithPocketID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_AddPocketRecommendWithPocketID  :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    AddPocketRecommendRequest     *addPocketRecommendRequest= [[AddPocketRecommendRequest  alloc]initWithSession:[DouAPIManager currentSessionData] pocket_id:pocket_id];
    [appClinet  add_pocket_recommend:addPocketRecommendRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_AddPocketRecommendWithPocketID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_AddPocketRecommendWithPocketID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_DelPocketRecommendWithPocketID  :(NSInteger)pocket_id  :(void (^)(BOOL isSuccess, NSError *error))block
{
  @try
  {
    TSocketClient                 *transport                    = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                     = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                    = [[AppServerClient  alloc]initWithProtocol:protocol];
    DeletePocketRecommendRequest  *deletePocketRecommendRequest = [[DeletePocketRecommendRequest  alloc]initWithSession:[DouAPIManager currentSessionData] pocket_id:pocket_id];
    [appClinet  delete_pocket_recommend:deletePocketRecommendRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_DelPocketRecommendWithPocketID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_DelPocketRecommendWithPocketID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetPocketCommentWithPocketID  :(NSInteger)pocket_id page_no:(NSInteger)page_no page_size:(NSInteger)page_size :(void (^)(NSMutableArray *commentsData, NSError *error))block
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetPocketCommentRequest       *getPocketCommentRequest  = [[GetPocketCommentRequest alloc]initWithSession:[DouAPIManager currentSessionData] pocket_id:pocket_id page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetPocketCommentResponse      *getPocketCommentResponse  = [appClinet  get_pocket_comment:getPocketCommentRequest];
    NSMutableArray                *commentArray;
    for (Comment *comment in [getPocketCommentResponse comment_list])
    {
      if(!commentArray)
        commentArray  = [[NSMutableArray alloc]initWithCapacity:[[getPocketCommentResponse comment_list] count]];
      CommentInstance        *commentInstnace  = [[CommentInstance alloc]init];
      commentInstnace.comment_id             =         comment.comment_id;
      commentInstnace.comment_text           =         comment.comment_text;
      commentInstnace.comment_user_id        =         comment.comment_user_id;
      commentInstnace.comment_user_name      =         comment.comment_user_name;
      commentInstnace.comment_user_avatar    =         comment.comment_user_avatar;
      commentInstnace.comment_user_domain    =         comment.comment_user_domain;
      commentInstnace.reply_user_id          =         comment.reply_user_id;
      commentInstnace.reply_user_name        =         comment.reply_user_name;
      commentInstnace.reply_user_domain      =         comment.reply_user_domain;
      commentInstnace.create_time            =         comment.create_time;
      commentInstnace.is_self                =         comment.is_self;
      [commentArray addObject:commentInstnace];
    }
    block(commentArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetPocketCommentWithPocketID" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetPocketCommentWithPocketID" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_AddPocketCommentWithPocketID  :(NSInteger)pocket_id  reply_user_id:(NSInteger)reply_user_id  comment_text:(NSString*)comment_text :(void (^)(CommentInstance *comment, NSError *error))block
{
  @try
  {
    TSocketClient                 *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    AddPocketCommentRequest       *adddPocketCommentRequest = [[AddPocketCommentRequest alloc]initWithSession:[DouAPIManager currentSessionData] reply_user_id:reply_user_id pocket_id:pocket_id comment_text:comment_text];
    AddPocketCommentResponse      *addPocketCommentResponse  = [appClinet  add_pocket_comment:adddPocketCommentRequest];
    CommentInstance               *pocketComment             = [[CommentInstance alloc]init];
    Comment                       *comment                  = [addPocketCommentResponse comment];
    pocketComment.comment_id          =   comment.comment_id;
    pocketComment.comment_text        =   comment.comment_text;
    pocketComment.comment_user_id     =   comment.comment_user_id;
    pocketComment.comment_user_name   =   comment.comment_user_name;
    pocketComment.comment_user_avatar =   comment.comment_user_avatar;
    pocketComment.comment_user_domain =   comment.comment_user_domain;
    pocketComment.reply_user_id       =   comment.reply_user_id;
    pocketComment.reply_user_name     =   comment.reply_user_name;
    pocketComment.reply_user_domain   =   comment.reply_user_domain;
    pocketComment.create_time         =   comment.create_time;
    pocketComment.is_self             =   comment.is_self;
    block(pocketComment,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_AddPhotoCommentWithPhotoID" NSException:nil InvalidOperation:invalid];
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_AddPhotoCommentWithPhotoID" NSException:exception InvalidOperation:nil];
  }
  @finally
  {
    
  }
}

- (void)request_DelPocketCommentWithCommentID  :(NSInteger)comment_id pocket_id:(NSInteger)pocket_id :(void (^)(BOOL isSuccess, NSError *error))block;
{
  @try
  {
    TSocketClient                 *transport                    = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol               *protocol                     = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient               *appClinet                    = [[AppServerClient  alloc]initWithProtocol:protocol];
    DeletePocketCommentRequest    *deletePocketCommentRequest   = [[DeletePocketCommentRequest  alloc]initWithSession:[DouAPIManager currentSessionData] pocket_id:pocket_id comment_id:comment_id];
    [appClinet  delete_pocket_comment:deletePocketCommentRequest];
    block(YES,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_DelPocketCommentWithCommentID" NSException:nil InvalidOperation:invalid];
    block(NO,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_DelPocketCommentWithCommentID" NSException:exception InvalidOperation:nil];
    block(NO,nil);
  }
  @finally
  {
    
  }
}

- (void)request_FollowWithFollowID :(NSInteger)follow_id  :(void (^)(NSInteger follow_state, NSError *error))block;
{
  @try
  {
    TSocketClient           *transport            = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol         *protocol             = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient         *appClinet            = [[AppServerClient  alloc]initWithProtocol:protocol];
    FollowRequest           *followRequest        = [[FollowRequest  alloc]initWithSession:[DouAPIManager currentSessionData] follow_id:follow_id];
    FollowResponse          *followResponse       = [appClinet  follow:followRequest];
    block(followResponse.follow_state,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_FollowWithSession" NSException:nil InvalidOperation:invalid];
    block(0,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_FollowWithSession" NSException:exception InvalidOperation:nil];
    block(0,nil);
  }
  @finally
  {
    
  }
}

- (void)request_UnFollowWithFollowID  :(NSInteger)follow_id  :(void (^)(NSInteger follow_state, NSError *error))block;
{
  @try
  {
    TSocketClient           *transport            = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol         *protocol             = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient         *appClinet            = [[AppServerClient  alloc]initWithProtocol:protocol];
    UnFollowRequest         *unFollowRequest      = [[UnFollowRequest  alloc]initWithSession:[DouAPIManager currentSessionData] follow_id:follow_id];
    UnFollowResponse        *unFollowResponse     = [appClinet  un_follow:unFollowRequest];
    block(unFollowResponse.follow_state,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_UnFollowWithSession" NSException:nil InvalidOperation:invalid];
    block(0,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_UnFollowWithSession" NSException:exception InvalidOperation:nil];
    block(0,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetFollowListWithDomain :(NSString*)host_domain  page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *followers, NSError *error))block
{
  @try
  {
    TSocketClient           *transport            = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol         *protocol             = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient         *appClinet            = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetFollowListRequest    *getFollowListRequest = [[GetFollowListRequest alloc]initWithSession:[DouAPIManager currentSessionData] host_domain:host_domain page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetFollowListResponse   *getFollowListResponse= [appClinet  get_follow_list:getFollowListRequest];
    NSMutableArray          *usersArray;
    for (FollowUser *followUser in [getFollowListResponse user_list])
    {
      if(!usersArray)
        usersArray  = [[NSMutableArray alloc]initWithCapacity:[[getFollowListResponse user_list] count]];
      UserInstance    *user = [[UserInstance alloc]init];
      user.host_id          =   followUser.user_id;
      user.host_name        =   followUser.user_name;
      user.host_desc        =   followUser.user_desc;
      user.host_avatar      =   followUser.user_avatar;
      user.host_domain      =   followUser.user_domain;
      user.host_gender      =   followUser.user_gender;
      user.address          =   followUser.user_address;
      user.follow_state     =   followUser.follow_state;
      user.follow_date      =   followUser.follow_date;
      [usersArray addObject:user];
    }
    block(usersArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetFollowListWithDomain" NSException:nil InvalidOperation:invalid];
    block(nil,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetFollowListWithDomain" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetFollowerListWithDomain :(NSString*)host_domain  page_no:(NSInteger)page_no page_size:(NSInteger)page_size  :(void (^)(NSMutableArray *fans, NSError *error))block
{
  @try
  {
    TSocketClient             *transport                = [[TSocketClient alloc] initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol           *protocol                 = [[TBinaryProtocol alloc] initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient           *appClinet                = [[AppServerClient  alloc]initWithProtocol:protocol];
    GetFollowerListRequest    *getFollowerListRequest   = [[GetFollowerListRequest alloc]initWithSession:[DouAPIManager currentSessionData] host_domain:host_domain page_no:(int32_t)page_no page_size:(int32_t)page_size];
    GetFollowerListResponse   *getFollowerListResponse  = [appClinet  get_follower_list:getFollowerListRequest];
    NSMutableArray            *usersArray;
    for (FollowUser *followUser in [getFollowerListResponse user_list])
    {
      if(!usersArray)
        usersArray  = [[NSMutableArray alloc]initWithCapacity:[[getFollowerListResponse user_list] count]];
      UserInstance    *user = [[UserInstance alloc]init];
      user.host_id          =   followUser.user_id;
      user.host_name        =   followUser.user_name;
      user.host_desc        =   followUser.user_desc;
      user.host_avatar      =   followUser.user_avatar;
      user.host_domain      =   followUser.user_domain;
      user.host_gender      =   followUser.user_gender;
      user.address          =   followUser.user_address;
      user.follow_state     =   followUser.follow_state;
      user.follow_date      =   followUser.follow_date;
      [usersArray addObject:user];
    }
    block(usersArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetFollowerListWithDomain" NSException:nil InvalidOperation:invalid];
    block(nil,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetFollowerListWithDomain" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }

}

- (void)request_GetPhotoRecommendWithAlbumID :(NSInteger)album_id :(void (^)(NSMutableArray *recommendPhotoList, NSError *error))block
{
  @try
  {
    TSocketClient                       *transport                        = [[TSocketClient     alloc]  initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol                     *protocol                         = [[TBinaryProtocol   alloc]  initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient                     *appClinet                        = [[AppServerClient   alloc]  initWithProtocol:protocol];
    GetPhotoRecommendRequest            *getPhotoRecommendRequest         = [[GetPhotoRecommendRequest  alloc]initWithSession:[DouAPIManager currentSessionData] album_id:album_id];
    GetPhotoRecommendResponse           *getPhotoRecommendResponse       =  [appClinet  get_photo_recommend:getPhotoRecommendRequest];
    NSMutableArray          *albumPhotoArray;
    for (RecommendPhoto *recommendPhoto in [getPhotoRecommendResponse photo_list])
    {
      if(!albumPhotoArray)
        albumPhotoArray = [[NSMutableArray alloc]initWithCapacity:[[getPhotoRecommendResponse photo_list]count]];
      AlbumPhotoInstance          *albumPhoto = [[AlbumPhotoInstance alloc]init];
      albumPhoto.photo_id     =   recommendPhoto.photo_id;
      albumPhoto.photo_path   =   recommendPhoto.photo_path;
      [albumPhotoArray  addObject:albumPhoto];
    }
    block(albumPhotoArray,nil);
  }
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetPhotoRecommendWithAlbumID" NSException:nil InvalidOperation:invalid];
    block(nil,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetPhotoRecommendWithAlbumID" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

- (void)request_GetPocketWithPocketID :(NSInteger)pocket_id :(void (^)(PocketItemInstance *pocketItemInstance, NSError *error))block
{
  @try
  {
    TSocketClient                       *transport                        = [[TSocketClient     alloc]  initWithHostname:kAPI_MainURL port:kAPI_MainURLPORT];
    TBinaryProtocol                     *protocol                         = [[TBinaryProtocol   alloc]  initWithTransport:transport strictRead:YES strictWrite:YES];
    AppServerClient                     *appClinet                        = [[AppServerClient   alloc]  initWithProtocol:protocol];
    GetPocketRequest                    *getPocketRequest                 = [[GetPocketRequest  alloc]  initWithSession:[DouAPIManager  currentSessionData] pocket_id:pocket_id];
    GetPocketResponse                   *getPocketResponse                = [appClinet  get_pocket:getPocketRequest];
    if(!getPocketResponse)
      return      block(nil,nil);
    PocketItemInstance  *pocket = [[PocketItemInstance alloc]init];
    pocket.pocket_id              =     getPocketResponse.pocket_id;
    pocket.cover_photo            =     getPocketResponse.pocket_cover_photo;
    pocket.pocket_title           =     getPocketResponse.pocket_title;
    pocket.pocket_second_title    =     getPocketResponse.pocket_second_title;
    pocket.pocket_content         =     getPocketResponse.pocket_content;
    pocket.create_time            =     getPocketResponse.create_time;
    pocket.author_id              =     getPocketResponse.author_id;
    pocket.author_name            =     getPocketResponse.author_name;
    pocket.author_avatar          =     getPocketResponse.author_avatar;
    pocket.author_domain          =     getPocketResponse.author_domain;
    pocket.temperature            =     getPocketResponse.temperature;
    pocket.is_self                =     getPocketResponse.is_self;
    pocket.followState            =     getPocketResponse.follow_state;
    pocket.is_like                =     getPocketResponse.is_like;
    pocket.is_favorite            =     getPocketResponse.is_favorite;
    pocket.is_recommend           =     getPocketResponse.is_recommend;
    block(pocket,nil);
  }
  
  @catch (InvalidOperation *invalid)
  {
    [self debugLogInfor:@"request_GetPocketWithPocketID" NSException:nil InvalidOperation:invalid];
    block(nil,nil);
  }
  @catch (NSException *exception)
  {
    [self debugLogInfor:@"request_GetPocketWithPocketID" NSException:exception InvalidOperation:nil];
    block(nil,nil);
  }
  @finally
  {
    
  }
}

/**
 *  @author J006, 15-06-06 15:06:58
 *
 *  Debug方法
 *
 *  @param funName
 *  @param nsexception
 *  @param invalid
 */
- (ErrorInstnace*)debugLogInfor :(NSString*)funName NSException:(NSException*)nsexception InvalidOperation:(InvalidOperation*)invalid
{
  ErrorInstnace *errorInstance    = [[ErrorInstnace  alloc]init];
  if(nsexception)
  {
    NSString  *errorLog = [funName  stringByAppendingString:@" "];
    errorLog = [errorLog  stringByAppendingString:nsexception.name];
    NSLog(@"%@ NSException = %@",funName,nsexception.name);
    return  errorInstance;
  }
  else  if(invalid)
  {
    NSString  *errorLogCode = [NSString stringWithString:funName];
    errorLogCode = [errorLogCode  stringByAppendingString:invalid.error_code];
    NSString  *errorLogCodeID = [NSString stringWithString:funName];
    errorLogCodeID = [errorLogCodeID  stringByAppendingString:[NSString stringWithFormat:@"%d",invalid.error_id]];
    NSLog(@"%@ invalid error_code= %@",funName,invalid.error_code);
    NSLog(@"%@ invalid code_id= %d",funName,invalid.error_id);
    errorInstance.error_id      = invalid.error_id;
    errorInstance.error_code    = invalid.error_code;
    return  errorInstance;
  }
  return errorInstance;
}


@end
