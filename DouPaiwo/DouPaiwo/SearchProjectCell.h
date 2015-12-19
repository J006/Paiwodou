//
//  SearchProjectButton.h
//  TestPaiwo
//  每一个专题条
//  Created by J006 on 15/4/29.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_SearchProjectCell @"SearchProjectCell"
@interface SearchProjectCell  : UITableViewCell

- (void)setTextValue:(NSString *)value;
- (void)setBackGroundImage :(UIImage*)image;
- (void)initSearchProjectCell:(NSString *)value setBackGroundImage :(UIImage*)backGroundImage tapAction:(void(^)(id obj))tapAction;

@end
