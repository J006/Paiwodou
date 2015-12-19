//
//  UserListViewForPMViewController.h
//  TestPaiwo
//
//  Created by J006 on 15/5/13.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInstance.h"
#import "BaseViewController.h"

@interface UserListViewForPMViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating>

- (void)initUserListView  :(NSMutableArray*)userArray;

@end
