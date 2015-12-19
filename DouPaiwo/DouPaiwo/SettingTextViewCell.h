//
//  SettingTextViewCell.h
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#define kCellIdentifier_SettingText @"SettingTextViewCell"
@interface SettingTextViewCell : UITableViewCell<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) UITextField       *textField;
@property (strong, nonatomic) UITextView        *textView;
@property (strong, nonatomic) NSString          *textValue;
@property (nonatomic,readwrite)BOOL             isTextField;
@property (copy, nonatomic) void(^textChangeBlock)(NSString *textValue);
- (void)setTextValue:(NSString *)textValue isTextField :(BOOL)isTextField andTextChangeBlock:(void(^)(NSString *textValue))block;
- (void)setTextStringMaxLimit  :(NSInteger)limit;
- (void)setTextStringMinLimit  :(NSInteger)limit;
@end
