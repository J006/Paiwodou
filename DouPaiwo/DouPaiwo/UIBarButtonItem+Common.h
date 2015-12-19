
/**
 *  @author J006, 15-06-04 11:06:15
 *
 *  UIBarButtonItem自定义
 *
 *  @param Common
 *
 *  @return 
 */
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)
+ (UIBarButtonItem *)itemWithBtnTitle:(NSString *)title target:(id)obj action:(SEL)selector;
@end
