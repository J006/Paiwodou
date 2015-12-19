//
//  AddressCitysSettingViewController.h
//  DouPaiwo
//  根据省份设置城市
//  Created by J006 on 15/9/16.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
@interface AddressCitysSettingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

- (void)initAddressCitysWithCitysDic  :(NSDictionary*)citysDic  user:(UserInstance*)user;
- (void)addBackBlock:(void(^)(id obj))backAction;

@end

