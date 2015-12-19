//
//  AddressSettingViewCellTableViewCell.h
//  DouPaiwo
//
//  Created by J006 on 15/9/14.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_TitleDisclosure @"AddressSettingViewCellTableViewCell"
@interface AddressSettingViewCellTableViewCell : UITableViewCell

@property (readwrite,nonatomic)BOOL                   isSelected;//是否选中
@property (readwrite,nonatomic)BOOL                   hasSecondLevelToChoose;//是否有第二层市级可以选
/**
 *  @author J.006, 15-09-14 12:09:33
 *
 *  初始化每一个地址的cell
 *
 *  @param addressTitle 中国省份/国家名称
 */
- (void)initAddressSettingViewCellTableViewCellWithTitle  :(NSString*)addressTitle;


@end
