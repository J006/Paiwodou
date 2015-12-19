//
//  InformationMainViewViewController.h
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "BaseViewController.h"

@interface InformationMainViewViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>


- (void)initInformationMainView :(NSMutableArray*)inforArray;


@end
