//
//  SettingAccountView.h
//  TestPaiwo
//  个人信息
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
@interface SettingAccountView : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

- (void)initSettingAccountView  :(UserInstance*)myUser;

@end
