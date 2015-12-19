//
//  SettingTextViewController.h
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
typedef NS_ENUM(NSInteger, SettingType)
{
  SettingTypeNickName   = 0,//昵称
  SettingTypeHostDomain = 1,//个人域名
  SettingTypeHostDesc   = 2//签名
};
@interface SettingTextViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

- (void)  initTheSettingTextViewControllerWithTitle :(NSString*)title textValue:(NSString *)textValue :(SettingType)type  doneBlock:(void(^)(NSString *textValue))block;

- (void)  setTextStringMaxLimit  :(NSInteger)limit;
- (void)  setTextStringMinLimit  :(NSInteger)limit;

@end
