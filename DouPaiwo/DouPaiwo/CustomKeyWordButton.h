//
//  CustomKeyWordButton.h
//  DouPaiwo
//  自定义关键字按钮:需要带一个删除按钮
//  Created by J006 on 15/8/27.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCustomKeyWordButtonSmallFontSize 14
#define kCustomKeyWordButtonMiddleFontSize 16
#define kCustomKeyWordButtonBigFontSize 18

@interface CustomKeyWordButton : UIButton

- (void)initCustomKeyWordButtonWithBtnString  :(NSString*)btnString;

- (void)addEditTapBlock:(void(^)(id obj))tapAction;

- (void)addCancelTapBlock:(void(^)(id obj))tapAction;

@end
