//
//  SearchResultSinlgeView.h
//  DouPaiwo
//  搜索结果单个结果条
//  Created by J006 on 15/6/19.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//
typedef enum
{
  resultType_photographer=1,
  resultType_pocket=2,
  resultType_album=3,
} resultType;

#import "BaseViewController.h"
#define kSearchResultSinlgeViewSmallFontSize 12
#define kSearchResultSinlgeViewMiddleFontSize 15
#define kSearchResultSinlgeViewBigFontSize 18
@interface SearchResultSinlgeView : BaseViewController<UIScrollViewDelegate>

- (void)initSearchResultSinlgeViewWithType:(NSInteger)resultType  resultArray:(NSMutableArray*)resultArray totalSearchNums:(NSInteger)totalSearchNums searchTags:(NSString*)searchTags;

@end
