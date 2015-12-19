//
//  SearchKeyWordsTableViewCell.h
//  DouPaiwo
//
//  Created by J006 on 15/8/24.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSearchKeyWordsTableViewCellSmallFontSize 12
#define kSearchKeyWordsTableViewCellMiddleFontSize 14
#define kSearchKeyWordsTableViewCellBigFontSize 18
#define SearchKeyWordsTableViewCellIdentify @"SearchKeyWordsTableViewCellIdentify"
typedef NS_ENUM (NSInteger, SearchKeyType)
{
  SearchUsers             = 1,//用户
  SearchPhotos            = 2,//照片
  SearchDou               = 3,//图文
};
@interface SearchKeyWordsTableViewCell : UITableViewCell

- (void)initSearchKeyWordsTableViewCellWithType :(SearchKeyType)sType  title:(NSString*)title  avatarURL:(NSURL*)avatarURL  value:(NSString*)value;
- (void)addUserTapBlockWithAction:(void(^)(id obj))tapAction;

@end
