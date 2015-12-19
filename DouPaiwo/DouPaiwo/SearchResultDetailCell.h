//
//  SearchResultDetailCell.h
//  DouPaiwo
//  搜索结果详细界面cell
//  Created by J006 on 15/6/23.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInstance.h"
#define kSearchResultDetailCellSmallFontSize 11
#define kSearchResultDetailCellMiddleFontSize 14
#define kSearchResultDetailCellBigFontSize 18
@interface SearchResultDetailCell : UITableViewCell

- (void)initSearchResultDetailCellWithUserInstance  :(UserInstance*)userInstance  :(UINavigationController*)navi;

@end
