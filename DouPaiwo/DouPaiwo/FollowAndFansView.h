//
//  FollowAndFansView.h
//  DouPaiwo
//
//  Created by J006 on 15/7/9.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, UserFollowOrFan) {
  fans  = 1,//粉丝
  follow = 2,//关注
};
@interface FollowAndFansView : BaseViewController

- (void)initFollowAndFansViewWithUserDomain :(NSString*)userDomain  withTitle:(NSString*)title  withType:(UserFollowOrFan)userType;

//- (void)addBackBlock:(void(^)(id obj))backAction;
@end
