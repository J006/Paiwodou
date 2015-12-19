//
//  PMInformationInstance.h
//  TestPaiwo
//
//  Created by J006 on 15/5/13.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInstance.h"

@interface PMInformationInstance : NSObject

@property (nonatomic,strong)  UserInstance      *user;
@property (nonatomic,strong)  NSString          *latestPM;//最近一条的内容
@property (nonatomic,strong)  NSString          *timeLatestPM;//最近一条信息的时间

@end
