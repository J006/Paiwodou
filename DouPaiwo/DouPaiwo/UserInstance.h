//
//  UserInstance.h
//  TestPaiwo
//
//  Created by J006 on 15/5/13.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, follow_state) {
  follow_NO  = 1,//未关注
  follow_YES = 2,//是你关注了他
  follow_HE  = 3,//是他关注了你
  follow_EACH  = 4,//是互相关注
};

typedef NS_ENUM(NSInteger, email_state) {
  email_noactive  = 0,//未激活
  email_actived = 1,//已激活
};

@interface UserInstance : NSObject

@property (nonatomic,strong)  NSString        *host_name, *global_key, *location, *job_str, *job, *email, *birthday, *pinyinName,*host_domain,*qq,*weixin,*weibo;
@property (nonatomic,strong)  NSString        *host_avatar;//头像地址
@property (nonatomic,strong)  UIImage         *profileAvatar;//个人头像
@property (nonatomic,strong)  UIImage         *coverImage;//封面
@property (nonatomic,strong)  NSString        *host_desc;//个人简介,签名
@property (nonatomic,strong)  NSString        *banner_photo;//个人封面图片地址
@property (nonatomic,strong)  NSString        *address;//地址的编码
@property (nonatomic,strong)  NSMutableArray  *photograph_address;//拍摄地址
@property (nonatomic,strong)  NSString        *domain;//个人域
@property (readwrite, nonatomic, strong) NSString *curPassword, *resetPassword, *resetPasswordConfirm, *phone, *introduction;

@property (readwrite, nonatomic) NSInteger  host_gender, follow, followed, follower_count, follow_count;
@property (readwrite, nonatomic) NSInteger  host_id;//用户id
@property (readwrite, nonatomic) NSInteger  dynamic_count;//动态数
@property (readwrite, nonatomic) NSInteger  follow_state;//1是未关注,2是你关注了他,3是他关注了你,4是互相关注
@property (readwrite, nonatomic) NSInteger  gift;//天赋:摄影师,模特,化妆师,与1 &一下就是摄影师
@property (readwrite, nonatomic) NSInteger  photograph_type;//拍摄类型
@property (readwrite, nonatomic) BOOL       is_self;//是否是自己
@property (readwrite, nonatomic) NSInteger  email_state;//0未激活,1激活
@property (nonatomic,strong)  NSString        *follow_date;//关注时间

@property (readwrite, nonatomic, strong) NSDate *created_at, *last_logined_at, *last_activity_at, *updated_at;
@end
