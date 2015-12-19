//
//  UserCellTableViewCell.m
//  TestPaiwo
//
//  Created by J006 on 15/5/14.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "UserCellTableViewCell.h"
#import "UIImageView+Common.h"
#import <TTTAttributedLabel.h>
#define kPaddingLeftWidth 15.0

@interface UserCellTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel              *userName;
@property (strong, nonatomic) IBOutlet UIButton             *userAvatar;

@end

@implementation UserCellTableViewCell

- (void)initUserCell
{

  self.userName.text  = self.curUser.host_name;
  [self.userAvatar.imageView  doCircleFrame];
}


- (void)rightBtnClicked:(id)sender
{

}

- (void)awakeFromNib {
    // Initialization code
}

+ (CGFloat)cellHeight{
  return defaultCellHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
