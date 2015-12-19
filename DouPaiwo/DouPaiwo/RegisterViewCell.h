//
//  RegisterViewCell.h
//  DouPaiwo
//
//  Created by J006 on 15/7/1.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kRegisterViewCellSmallFontSize 10
#define kRegisterViewCellMiddleFontSize 14
#define kRegisterViewCellBigFontSize 18
typedef NS_ENUM(NSInteger, textfieldType) {
  type_phone  = 1,//电话
  type_captcha = 2,//验证码
  type_password  = 3,//密码
};

@interface RegisterViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);

- (void)configWithPlaceholder:(NSString *)phStr  valueStr:(NSString *)valueStr textfieldType:(NSInteger)textfieldType;

@end
