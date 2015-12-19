//
//  CommentTableViewCell.h
//  DouPaiwo
//
//  Created by J006 on 15/6/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentInstance.h"
#define kCommentTableViewCellSmallFontSize 10
#define kCommentTableViewCellMiddleFontSize 12
#define kCommentTableViewCellBigFontSize 18

@interface CommentTableViewCell : UITableViewCell

- (void)initCommentTableViewCellWithComment  :(CommentInstance*)commentInstance;

@end
