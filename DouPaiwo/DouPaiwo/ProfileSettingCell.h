//
//  ProfileSettingCell.h
//  DouPaiwo
//
//  Created by J006 on 15/7/28.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_TitleDisclosure @"ProfileSettingCell"
@interface ProfileSettingCell : UITableViewCell

- (void)initProfileSettingCellWithTitile  :(NSString*)title value:(NSString*)value;
- (void)setIsBindTheAccount :(BOOL)isBindTheAccount;

@end
