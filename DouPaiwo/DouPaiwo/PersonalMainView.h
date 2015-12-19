//
//  PersonalMainView.h
//  DouPaiwo
//  个人/他人主页
//  Created by J006 on 15/6/25.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
#define kPersonalMainViewSmallFontSize 12
#define kPersonalMainViewMiddleFontSize 14
#define kPersonalMainViewBigFontSize 18
@interface PersonalMainView : BaseViewController

- (void)initPersonalMainViewWithUser  :(UserInstance*)currUser;

@end
