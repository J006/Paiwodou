//
//  UserCellTableViewCell.h
//  TestPaiwo
//
//  Created by J006 on 15/5/14.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInstance.h"

@interface UserCellTableViewCell : UITableViewCell

@property (strong, nonatomic) UserInstance *curUser;

@property (nonatomic,copy) void(^leftBtnClickedBlock)(UserInstance *curUser);

@property (assign, nonatomic) BOOL isInProject, isQuerying;

- (void)initUserCell;

+ (CGFloat)cellHeight;

@end
