//
//  AddressSettingViewController.h
//  DouPaiwo
//  个人地区设置
//  Created by J006 on 15/9/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
@interface AddressSettingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

- (void)initAddressSettingVCWithCurrentCityCode :(NSString*)code  user:(UserInstance*)user;
- (void)addBackBlock:(void(^)(id obj))backAction;

@end
