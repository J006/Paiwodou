//
//  SearchResultDetailView.h
//  DouPaiwo
//  搜索结果点击更多后的详细界面
//  Created by J006 on 15/6/23.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSInteger, SearchType)
{
  AlbumSearchType                                 = 1,//专辑
  ProjectSearchType                               = 2,//专题
  UserSearchType                                  = 3,//用户
};
#define kSearchResultDetailViewSmallFontSize 12
#define kSearchResultDetailViewMiddleFontSize 15
#define kSearchResultDetailViewBigFontSize 18
@interface SearchResultDetailView : BaseViewController<UITableViewDelegate,UITableViewDataSource>

- (void)initSearchResultDetailViewWithOriginalSearchTags:(NSMutableArray*)originalSearchTags searchTags:(NSString*)searchTags searchType:(SearchType)searchType;

- (void)initTheProjectTitle  :(NSString*)title;

@end
