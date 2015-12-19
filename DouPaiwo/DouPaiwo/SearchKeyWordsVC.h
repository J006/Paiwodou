//
//  SearchKeyWordsVC.h
//  DouPaiwo
//
//  Created by J006 on 15/8/24.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearchKeyWordsTableViewCell.h"
@protocol SearchKeyWordsVCDelegate;
@interface SearchKeyWordsVC : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak)      id<SearchKeyWordsVCDelegate>       delegate;
/**
 *  @author J006
 *
 *  初始化
 *  @param image    背景图截图
 *  @param keyWord  搜索关键字
 */
- (void)initSearchKeyWordsVCWithSnapshot  :(UIImage*)image  keyWords:(NSString*)keyWords;

- (void)setRefresh;

- (void)jumpToUserProfileView;
@end

@protocol SearchKeyWordsVCDelegate <NSObject>

@optional
- (void)clickTheSearchTypeWithSearchType:(SearchKeyWordsVC *)searchKeyWordsVC photoImageWallHeight:(CGFloat)photoImageWallHeight photoImageWallWidth:(CGFloat)photoImageWallWidth;

@end
