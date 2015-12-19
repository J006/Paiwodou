//
//  SearchMainView.h
//  TestPaiwo
//
//  Created by J006 on 15/4/29.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface SearchMainView : BaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
/**
 *  @author J006, 15-04-29 18:04:12
 *
 *  初始化探索界面
 *
 *  @param customPropertyTools
 */
- (void)initSearchMainView :(NSMutableArray*)projectArray;

@end
