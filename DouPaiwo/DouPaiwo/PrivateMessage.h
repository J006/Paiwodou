//
//  PrivateMessage.h
//  TestPaiwo
//
//  Created by J006 on 15/5/14.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInstance.h"
typedef NS_ENUM(NSInteger, PrivateMessageSendStatus) {
  PrivateMessageStatusSendSucess = 0,
  PrivateMessageStatusSending,
  PrivateMessageStatusSendFail
};

@interface PrivateMessage : NSObject
@property (readwrite, nonatomic, strong) NSString *content, *extra;
@property (readwrite, nonatomic, strong) UserInstance *friend, *sender;
@property (readwrite, nonatomic, strong) NSNumber *count, *unreadCount, *id, *read_at, *status;
@property (readwrite, nonatomic, strong) NSDate *created_at;
@property (assign, nonatomic) PrivateMessageSendStatus sendStatus;
@property (strong, nonatomic) UIImage *nextImg;

//- (BOOL)hasMedia;

//+ (instancetype)privateMessageWithObj:(id)obj andFriend:(UserInstance *)curFriend;

//- (NSString *)toSendPath;
//- (NSDictionary *)toSendParams;

//- (NSString *)toDeletePath;
@end
