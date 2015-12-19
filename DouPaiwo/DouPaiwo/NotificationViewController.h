//
//  NotificationViewController.h
//  DouPaiwo
//  自定义消息提醒框
//  Created by J006 on 15/7/31.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#define kNotificationViewControllerSmallFontSize 10
#define kNotificationViewControllerMiddleFontSize 12
#define kNotificationViewControllerBigFontSize 16
@interface NotificationViewController : BaseViewController

- (void)initNotificationViewControllerWithTitle  :(NSString*)title;

- (void)confirmTheBackGroundColor :(UIColor*)color;

@end
