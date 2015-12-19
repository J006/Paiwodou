//
//  SearchMainResultView.h
//  DouPaiwo
//  搜索主结果界面
//  Created by J006 on 15/6/19.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchMainResultView : BaseViewController<UIScrollViewDelegate>

- (void)initSearchMainResultViewWithSearchTags  :(NSString*)searchTags withSearchTagsArray:(NSMutableArray*)searchTagsArray;

@end
