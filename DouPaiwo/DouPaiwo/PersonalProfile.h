//
//  PersonalProfile.h
//  TestPaiwo
//  个人主页/他人主页
//  Created by J006 on 15/5/18.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInstance.h"
#import "BaseViewController.h"
#define kPersonalProfileSmallFontSize 12
#define kPersonalProfileMiddleFontSize 14
#define kPersonalProfileBigFontSize 18
@interface PersonalProfile : BaseViewController<UIGestureRecognizerDelegate>

@property (readwrite,nonatomic) BOOL  dragging;

@property (readwrite,nonatomic) float oldX, oldY;


- (void)initPersonalProfileWithUserDomain :(NSString*)userDomain  isSelf:(BOOL)isSelf;

- (void)initPersonalProfileWithUser :(UserInstance*)currentUser;

- (void)addBackBlock:(void(^)(id obj))backAction;

- (void)setValueIsNoNeedToBack :(BOOL)isNoNeedToBack;

@end
