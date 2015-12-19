//
//  ProfileSettingView.h
//  DouPaiwo
//  账号安全
//  Created by J006 on 15/7/28.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
@interface ProfileSettingView : BaseViewController<UITableViewDelegate,UITableViewDataSource>

- (void)initAccountSettingViewWithUser  :(UserInstance*)user;

@end
