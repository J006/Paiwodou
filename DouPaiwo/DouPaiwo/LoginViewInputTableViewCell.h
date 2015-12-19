//
//  LoginViewInputTableViewCell.h
//  DouPaiwo
//
//  Created by J006 on 15/6/30.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewInputTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,copy) void(^textValueChangedBlock)(NSString*);

- (void)configWithPlaceholder:(NSString *)phStr valueStr:(NSString *)valueStr secureTextEntry:(BOOL)isSecure;

@end
