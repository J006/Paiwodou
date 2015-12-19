//
//  LoginInstance.h
//  DouPaiwo
//
//  Created by J006 on 15/6/30.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GiftCode)
{
  GiftCodePhotographer                            = 0,//成功
};//天赋:摄影师,模特,化妆师,与1 &一下就是摄影师

@interface LoginInstance : NSObject

@property (nonatomic, strong)     NSString              *email,*phone,*password;
@property (nonatomic, readwrite)  NSInteger             user_id;
@property (nonatomic, readwrite)  NSInteger             email_state;
@property (nonatomic, readwrite)  GiftCode              gift;
@property (nonatomic, strong)     NSString              *session;
@property (nonatomic, readwrite)  BOOL                  is_first;
@end
