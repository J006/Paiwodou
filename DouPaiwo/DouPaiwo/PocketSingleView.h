//
//  PocketSingleView.h
//  TestPaiwo
//  单个pocket  view
//  Created by J006 on 15/4/23.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PocketItemInstance.h"
#import "BaseViewController.h"
#define kdefaultScreen_Width 320
#define kpocketViewHeight 338
#define kpocketSmallFontSize 11
#define kpocketBigFontSize 15

@interface PocketSingleView : BaseViewController<UIScrollViewDelegate>

@property (nonatomic,readwrite) float       photoY;

- (void)  initPocketSingleView:(PocketItemInstance*)pockItem;

@end
