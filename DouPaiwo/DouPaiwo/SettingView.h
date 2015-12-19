//
//  SettingView.h
//  个人设置界面
//
//  Created by J006 on 15/5/19.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInstance.h"
#import "BaseViewController.h"

@interface SettingView : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

- (void)initSettingView :(UserInstance*)myUser;

@end
