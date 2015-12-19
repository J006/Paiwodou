//
//  PMInformationCell.m
//  TestPaiwo
//
//  Created by J006 on 15/5/13.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "PMInformationCell.h"
#import "PersonalProfile.h"

@interface PMInformationCell()

@property (nonatomic,strong)  PMInformationInstance             *pm;
@property (strong, nonatomic) IBOutlet UIButton                 *userAvatar;
@property (strong, nonatomic) IBOutlet UIButton                 *userName;
@property (strong, nonatomic) IBOutlet UILabel                  *lastestInfor;
@property (strong, nonatomic) IBOutlet UILabel                  *lastestTime;
@property (strong, nonatomic) PersonalProfile                   *ppView;


@end

@implementation PMInformationCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initCell  :(PMInformationInstance*)pm;
{
  //_pm = pm;
  //_userAvatar.imageView.image = useAva
  //_userName.text = _pm.user.userName;
  //_lastestInfor.text = _pm.latestPM;
  
}
- (IBAction)jumpToProfileAction:(id)sender
{
  _ppView = [[PersonalProfile  alloc]init];
  CGRect  frame = self.ppView.view.frame;
  frame.origin.x  = 0;
  frame.origin.y  = 0;
  frame.size.width  = kScreen_Width;
  frame.size.height = kScreen_Height-pageToolBarHeight;

  [_ppView  initPersonalProfileWithUser:_pm.user];
  
  
  CATransition *animation = [CATransition animation];
  [animation setDuration:kpushViewTime];
  [animation setType:kCATransitionMoveIn];
  [animation setSubtype:kCATransitionFromRight];
  _ppView.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  _ppView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self.window.layer addAnimation:animation forKey:kCATransition];
  UIViewController  *tempVC  = [self presentingVC];
  [tempVC  presentViewController:_ppView animated:NO completion:^{
    _ppView.view.frame  = frame;
  }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UIViewController *)presentingVC{
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
  return result;
}
@end
