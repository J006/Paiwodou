//
//  AddressSettingViewCellTableViewCell.m
//  DouPaiwo
//
//  Created by J006 on 15/9/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "AddressSettingViewCellTableViewCell.h"
#import <Masonry.h>
@interface AddressSettingViewCellTableViewCell ()

@property (strong, nonatomic) UILabel                 *titleLabel;
@property (strong, nonatomic) NSString                *title;
@property (strong, nonatomic) UILabel                 *selectedLabel;

@end
@implementation AddressSettingViewCellTableViewCell
@synthesize isSelected,hasSecondLevelToChoose;
#pragma life cycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
    [self.contentView  addSubview:self.titleLabel];
    [self.contentView  addSubview:self.selectedLabel];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  _titleLabel.text = _title;
  [_titleLabel setFrame:CGRectMake(25, 0, 200, self.frame.size.height)];
  if(hasSecondLevelToChoose)
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  else
    self.accessoryType = UITableViewCellAccessoryNone;    
  if(isSelected)
  {
    [_selectedLabel  setFrame:CGRectMake(kScreen_Width-30-100, 0, 100, self.frame.size.height)];
  }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma init
- (void)initAddressSettingViewCellTableViewCellWithTitle  :(NSString*)addressTitle
{
  self.title  = addressTitle;
}

#pragma getter setter
- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    [_titleLabel setFont:SourceHanSansNormal15];
    [_titleLabel setTextColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0]];
  }
  return _titleLabel;
}
- (UILabel*)selectedLabel
{
  if(_selectedLabel  ==  nil)
  {
    _selectedLabel = [[UILabel  alloc]init];
    _selectedLabel.backgroundColor = [UIColor clearColor];
    [_selectedLabel setText:@"已选地区"];
    [_selectedLabel setTextAlignment:NSTextAlignmentRight];
    [_selectedLabel setFont:SourceHanSansLight13];
    [_selectedLabel setTextColor:[UIColor  colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0]];
  }
  return _selectedLabel;
}

@end
