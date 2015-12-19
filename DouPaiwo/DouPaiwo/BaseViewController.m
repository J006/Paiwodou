
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "RootTabViewController.h"
#import <RDVTabBarController.h>
#import "RootTabViewController.h"

typedef NS_ENUM(NSInteger, AnalyseMethodType) {
    AnalyseMethodTypeJustRefresh = 0,
    AnalyseMethodTypeLazyCreate,
    AnalyseMethodTypeForceCreate
};

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadView{
    [super loadView];
  
}

- (void)tabBarItemClicked
{
    //NSLog(@"\ntabBarItemClicked : %@", NSStringFromClass([self class]));
}


+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[RootTabViewController class]]) {
        result = [(RootTabViewController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

+ (CGSize)sizeToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth
{
  CGFloat newHeight   = size.height*newWidth/size.width;
  size  = CGSizeMake(newWidth, newHeight);
  return size;
}

+ (CGFloat)heightToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth
{
  CGFloat newHeight   = size.height*newWidth/size.width;
  return  newHeight;
}

+ (CGFloat)widthToFitHeight  :(CGSize)size newHeight:(CGFloat)newHeight
{
  CGFloat newWidth  = size.width*newHeight/size.height;
  return  newWidth;
}

/**
 *  @author J006, 15-06-03 17:06:20
 *
 *  导航栏push下一个VC
 *
 *  @param vc
 */
+ (void)naviPushViewController:(UIViewController*)vc
{
  assert(vc!=nil);
  UIViewController  *tempVC = [self presentingVC];
  CATransition *animation = [CATransition animation];
  [animation setDuration:kpushViewTime];
  [animation setType:kCATransitionMoveIn];
  [animation setSubtype:kCATransitionFromRight];
  [tempVC.view.window.layer addAnimation:animation forKey:kCATransition];
  [tempVC.navigationController  pushViewController:vc animated:NO];
}

+ (void)naviInsertViewController:(UIViewController*)vc
{
  UIViewController  *tempVC = [self presentingVC];
  [tempVC.navigationController  popViewControllerAnimated:NO];
  CATransition *animation = [CATransition animation];
  [animation setDuration:kpushViewTime];
  [animation setType:kCATransitionMoveIn];
  [animation setSubtype:kCATransitionFromRight];
  [tempVC.view.window.layer addAnimation:animation forKey:kCATransition];
  [tempVC.navigationController  pushViewController:vc animated:NO];
}

+ (void)naviPushViewControllerWithNoAniation:(UIViewController*)vc
{
  assert(vc!=nil);
  UIViewController  *tempVC = [self presentingVC];
  [tempVC.navigationController  pushViewController:vc animated:NO];
}

/**
 *  @author J006, 15-06-03 17:06:43
 *
 *  设置底部导航栏的隐藏和出现
 *
 *  @param isHidden
 *  @param isAnimated
 */
+ (void)setRDVTabHidden:(BOOL)isHidden  isAnimated:(BOOL)isAnimated
{
  UIViewController  *tempVC = [self presentingVC];
  [tempVC.rdv_tabBarController setTabBarHidden:isHidden animated:isAnimated];
}

+ (void)setRDVTabStatusHidden:(BOOL)isHidden
{
  UIViewController  *tempVC = [self presentingVC];
  RootTabViewController *rdv  = (RootTabViewController*)tempVC.rdv_tabBarController;
  [rdv setIsHiddenStatus:isHidden];
  [rdv  setNeedsStatusBarAppearanceUpdate];
  [rdv setIsHiddenStatus:!isHidden];//还原成之前的状态
}

+ (void)setRDVTabStatusHiddenDirect:(BOOL)isHidden
{
  UIViewController  *tempVC = [self presentingVC];
  RootTabViewController *rdv  = (RootTabViewController*)tempVC.rdv_tabBarController;
  [rdv  setNeedsStatusBarAppearanceUpdate];
  [rdv setIsHiddenStatus:isHidden];
}

+ (void)setRDVTabStatusStyle:(UIStatusBarStyle)style  preStyle:(UIStatusBarStyle)preStyle;
{
  UIViewController  *tempVC = [self presentingVC];
  RootTabViewController *rdv  = (RootTabViewController*)tempVC.rdv_tabBarController;
  [rdv setStatusStyle:style];
  [rdv setNeedsStatusBarAppearanceUpdate];
  [rdv setStatusStyle:preStyle];//还原成之前的状态
}

+ (void)setRDVTabStatusStyleDirect:(UIStatusBarStyle)style
{
  UIViewController  *tempVC = [self presentingVC];
  RootTabViewController *rdv  = (RootTabViewController*)tempVC.rdv_tabBarController;
  [rdv setStatusStyle:style];
  [rdv setNeedsStatusBarAppearanceUpdate];
}

+ (BOOL)checkRDVTabIsHidden
{
  BOOL  isHidden  = NO;
  UIViewController  *tempVC = [self presentingVC];
  isHidden  = tempVC.rdv_tabBarController.tabBarHidden;
  return isHidden;
}

/**
 *  @author J006, 15-09-08 17:06:12
 *
 *  设置底部tab栏是否有小红点更新,并设置更新数目
 *
 *  @return
 */
+ (void)setRDVTabAttentionIconHasNewInfo  :(BOOL)hasNewInfo  itemIndex:(NSInteger)index infoNums:(NSInteger)infoNums
{
  UIViewController  *tempVC = [self presentingVC];
  RootTabViewController *rdv  = (RootTabViewController*)tempVC.rdv_tabBarController;
  [rdv setRDVTabItemHasAttentionIconWithItemIndex:index hasAttentionIcon:hasNewInfo attentionNums:infoNums];
}

+ (void)popToTheUIViewController  :(Class)vc
{
  for (UIViewController *temp in [self getNavi].viewControllers) {
    if ([temp isKindOfClass:vc]) {
      [[self getNavi] popToViewController:temp animated:YES];
    }
  }
}

/**
 *  @author J006, 15-06-03 17:06:12
 *
 *  获取导航栏
 *
 *  @return
 */
+ (UINavigationController*)getNavi
{
    UIViewController  *tempVC = [self presentingVC];
    return tempVC.navigationController;
}

+ (void)presentVC:(UIViewController *)viewController{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalViewControllerAnimated:)];
    [[BaseViewController presentingVC] presentViewController:nav animated:YES completion:nil];
}


@end
