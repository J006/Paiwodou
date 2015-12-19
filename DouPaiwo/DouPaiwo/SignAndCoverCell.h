//
//  SignCell.h
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//
#import <UIKit/UIKit.h>
#define kCellIdentifier_SignCoverCell @"SignCoverCell"

@interface SignAndCoverCell : UITableViewCell
- (void)setTitleStr:(NSString *)title;
- (void)setTextValue:(NSString *)value;
- (void)setImageURL :(NSURL*)imageURL;
@end
