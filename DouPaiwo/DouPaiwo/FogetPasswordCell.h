//
//  FogetPasswordCell.h
//  DouPaiwo
//
//  Created by J006 on 15/9/21.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, forgetPasswordCellType) {
  type_phone_password   = 1,//电话
  type_captcha_password = 2,//电话短信验证码
  type_password_content = 3,//电话返回的密码
  type_email_password   = 4//邮箱找回
};
@interface FogetPasswordCell : UITableViewCell

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);

- (void)configWithPlaceholder:(NSString *)phStr  valueStr:(NSString *)valueStr textfieldType:(NSInteger)textfieldType;

@end
