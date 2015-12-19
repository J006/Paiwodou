//
//  SearchBackGroundViewController.h
//  DouPaiwo
//  背景界面
//  Created by J006 on 15/6/12.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"

@interface SearchBackGroundViewController : BaseViewController
/**
 *  @author J006, 15-06-12 11:06:36
 *
 *  初始化背景蒙版
 *
 *  @param doneBlock 蒙版点击返回事件
 */
- (void)initSearchBackGroundView  :(void(^)(id))tapAction;

@end
