//
//  PocketDetailHTML.h
//  DouPaiwo
//
//  Created by J006 on 15/6/3.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "PocketItemInstance.h"
#import "UserInstance.h"

@interface PocketDetailHTML : BaseViewController<UIWebViewDelegate,UIScrollViewDelegate>

- (void)initPocketDetailHTMLWithPocketID  :(NSInteger)pocketContent;

- (void)addBackBlock:(void(^)(id obj))backAction;
@end
