

/**
 *  @author J006, 15-06-02 14:06:04
 *
 *
 */
#import <UIKit/UIKit.h>
@interface BaseViewController : UIViewController

- (void)tabBarItemClicked;


+ (UIViewController *)presentingVC;
+ (void)presentVC:(UIViewController *)viewController;
+ (void)naviPushViewController:(UIViewController*)vc;
+ (void)naviInsertViewController:(UIViewController*)vc;
+ (void)naviPushViewControllerWithNoAniation:(UIViewController*)vc;
+ (void)setRDVTabStatusHidden:(BOOL)isHidden;
+ (void)setRDVTabStatusHiddenDirect:(BOOL)isHidden;
+ (void)setRDVTabStatusStyle:(UIStatusBarStyle)style  preStyle:(UIStatusBarStyle)preStyle;
+ (void)setRDVTabStatusStyleDirect:(UIStatusBarStyle)style;
+ (void)setRDVTabHidden:(BOOL)isHidden  isAnimated:(BOOL)isAnimated;
+ (BOOL)checkRDVTabIsHidden;
+ (void)setRDVTabAttentionIconHasNewInfo  :(BOOL)hasNewInfo  itemIndex:(NSInteger)index infoNums:(NSInteger)infoNums;
+ (UINavigationController*)getNavi;
/**
 *  @author J.006, 15-09-16 14:09:33
 *
 *  
 *
 *  @param vc
 */
+ (void)popToTheUIViewController  :(Class)vc;
/**
 *  @author J006, 15-06-11 11:06:13
 *
 *  根据size的宽度来适配整个高度
 *
 *  @param size     原size
 *  @param newWidth 新的目标宽度
 *
 *  @return 最新的size
 */
+ (CGSize)sizeToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth;
/**
 *  @author J006, 15-06-11 11:06:51
 *
 *  根据size的宽度来适配整个高度
 *
 *  @param size     原size
 *  @param newWidth 新的目标宽度
 *
 *  @return 最新的高度
 */
+ (CGFloat)heightToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth;
/**
 *  @author J006, 15-06-11 11:06:51
 *
 *  根据size的宽度来适配整个高度
 *
 *  @param size     原size
 *  @param newWidth 新的目标高度
 *
 *  @return 最新的宽度
 */
+ (CGFloat)widthToFitHeight  :(CGSize)size newHeight:(CGFloat)newHeight;
@end
