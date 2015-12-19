//
//  SettingCell.h
//  TestPaiwo
//
//  Created by J006 on 15/5/21.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_TitleDisclosure @"SettingMainCell"

@interface SettingCell : UITableViewCell

- (void)initSettingCellWithTitle  :(NSAttributedString*)title imageUrl:(NSURL*)imageURL;

- (void)setIsNeedDoAddBottomLine  :(BOOL)isAddBottomLine;

- (void)setIsNeedDoAddTopLine     :(BOOL)isAddTopLine;

- (void)setIsNeedLogOutBtn     :(BOOL)isLogOutBtn;

- (void)setTheMainValue     :(NSString*)value;
@end
