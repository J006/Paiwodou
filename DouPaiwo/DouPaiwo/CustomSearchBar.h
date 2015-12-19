//
//  CustomSearchBar.h
//  DouPaiwo
//  顶部搜索栏显示搜索关键字,可删除
//  Created by J006 on 15/8/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol CustomSearchBarDelegate;
@interface CustomSearchBar :  BaseViewController

@property (nonatomic, weak)      id<CustomSearchBarDelegate>       delegate;

- (void)initCustomSearchBarWithKeyWords :(NSString*)keyWords;

@end

@protocol CustomSearchBarDelegate <NSObject>

@optional
/**
 *  @author J006, 15-06-19 12:06:44
 *
 *  删除单个关键字后的代理方法
 *
 *  @param customSearchBar
 *  @param theRemainKeyWords
 *  @param theReaminKeyWordsArray
 */
- (void)removeTheKeyWordWithCustomSearchBar :(CustomSearchBar*)customSearchBar  theRemainKeyWords:(NSString*)theRemainKeyWords  theReaminKeyWordsArray:(NSMutableArray*)array;
/**
 *  @author J006, 15-06-19 12:06:44
 *
 *  编辑该搜索框输入的代理方法
 *
 *  @param customSearchBar
 *  @param theRemainKeyWords
 *  @param theReaminKeyWordsArray
 */
- (void)editTheKeyWordWithCustomSearchBar :(CustomSearchBar*)customSearchBar  theRemainKeyWords:(NSString*)theRemainKeyWords  theReaminKeyWordsArray:(NSMutableArray*)array;
/**
 *  @author J006, 15-06-19 12:06:44
 *
 *  取消该搜索框输入的代理方法
 *
 */
- (void)cancelAndBackToMainViewWithCustomSearchBar  :(CustomSearchBar*)customSearchBar;
@end
