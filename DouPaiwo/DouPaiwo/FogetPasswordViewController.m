//
//  FogetPasswordViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/9/21.
//  Copyright © 2015年 paiwo.co. All rights reserved.
//

#import "FogetPasswordViewController.h"
#import <Masonry.h>
#import "NSString+Common.h"
#import "TPKeyboardAvoidingTableView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "DouAPIManager.h"
#import "FogetPasswordCell.h"
#import "GetPasswordBackInstance.h"

@interface FogetPasswordViewController ()

@property (strong,    nonatomic)     TPKeyboardAvoidingTableView  *myTableView;
@property (strong,    nonatomic)     UISegmentedControl           *segmentedControl;
@property (strong,    nonatomic)     UIView                       *headerView;//table顶部view
@property (strong,    nonatomic)     UIButton                     *resetPassWordBtn;//重设按钮
@property (strong,    nonatomic)     UILabel                      *descLabel;//已将包含密码重置说明邮件发送至以下邮箱
@property (strong,    nonatomic)     UIButton                     *resetPassWordBtnForEmail;//重设按钮邮箱
@property (readwrite, nonatomic)     BOOL                         isFindEmailBack;//邮箱找回密码,初始为NO
@property (strong,    nonatomic)     UIView                       *bottomView;//底部view 重设密码按钮
@property (strong,    nonatomic)     GetPasswordBackInstance      *getPWInstance;
@property (readwrite, nonatomic)     BOOL                         isMessageCDForEmail;//读取信息cd Email
@property (strong, nonatomic)        NSTimer                      *nsTimerForEmail;//Email
@property (readwrite, nonatomic)     NSInteger                    timesSetForEmail;//计数器,起始为60 Email

@end

@implementation FogetPasswordViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title  = @"找回密码";
  [self.view  addSubview:self.myTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  [self.myTableView             setFrame:self.view.bounds];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger row =1;
  if(!self.isFindEmailBack)
    row = 3;
  return row;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  FogetPasswordCell   *cell = [[FogetPasswordCell  alloc]init];
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  __weak typeof(self) weakSelf = self;
  if(!self.isFindEmailBack)
  {
    if(indexPath.section==0)
    {
      [cell configWithPlaceholder:@"手机号" valueStr:self.getPWInstance.phone  textfieldType:type_phone_password];
      cell.textValueChangedBlock = ^(NSString *valueStr)
      {
        weakSelf.getPWInstance.phone = valueStr;
      };
      [cell setHeight:40];
    }
    else  if(indexPath.section==1)
    {
      [cell configWithPlaceholder:@"验证码" valueStr:self.getPWInstance.j_captcha textfieldType:type_captcha_password];
      cell.textValueChangedBlock = ^(NSString *valueStr)
      {
        weakSelf.getPWInstance.j_captcha = valueStr;
      };
      [cell setHeight:40];
    }
    else
    {
      [cell configWithPlaceholder:@"密码" valueStr:self.getPWInstance.password textfieldType:type_password_content];
      cell.textValueChangedBlock = ^(NSString *valueStr)
      {
        weakSelf.getPWInstance.password = valueStr;
      };
      [cell setHeight:40];
    }
  }
  else
  {
    [cell configWithPlaceholder:@"邮箱" valueStr:self.getPWInstance.email  textfieldType:type_phone_password];
    cell.textValueChangedBlock = ^(NSString *valueStr)
    {
      weakSelf.getPWInstance.email = valueStr;
    };
    [cell setHeight:40];
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 10;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
  
  //Set the background color of the View
  view.tintColor = [UIColor whiteColor];
  
  //Set the TextLabel Color
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  [header.textLabel setTextColor:[UIColor whiteColor]];
  
}

#pragma event Action
- (void)segmentedControlValueChange
{
  if(self.segmentedControl.selectedSegmentIndex ==  0)
  {
    self.isFindEmailBack  = NO;
    [self.descLabel                 setAlpha:0.0];
    [self.resetPassWordBtnForEmail  setAlpha:0.0];
    [self.resetPassWordBtn  setAlpha:1.0];
    [self.myTableView reloadData];
  }
  else  if(self.segmentedControl.selectedSegmentIndex ==  1)
  {
    self.isFindEmailBack  = YES;
    [self.resetPassWordBtn          setAlpha:0.0];
    [self.descLabel                 setAlpha:1.0];
    [self.resetPassWordBtnForEmail  setAlpha:1.0];
    [self.myTableView reloadData];
  }
}

/**
 *  @author J.006, 15-09-22 11:09:04
 *
 *  重置密码action
 */
- (void)resetThePassWord
{
  if(!self.isFindEmailBack)
  {
  
  }
  else
  {
    self.isMessageCDForEmail  = YES;
    if(!self.nsTimerForEmail)
      self.timesSetForEmail = timeSetOut;
    if(!self.nsTimerForEmail)
      self.nsTimerForEmail  = [NSTimer  scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireForEmailMethod:) userInfo:nil repeats:YES];
    [self.nsTimerForEmail  fire];
    NSString *tipStr = @"已将包含密码重置说明邮件发送至以下邮箱\n";
    NSInteger prevStringLength  = tipStr.length;
    tipStr  = [tipStr stringByAppendingString:self.getPWInstance.email];
    NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc]initWithString:tipStr];
    [mainString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0] range:NSMakeRange(0,prevStringLength)];
    [mainString addAttribute:NSFontAttributeName value:SourceHanSansNormal11 range:NSMakeRange(0,prevStringLength)];
    [mainString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:221/255.0 green:34/255.0 blue:34/255.0 alpha:1.0] range:NSMakeRange(prevStringLength,tipStr.length-prevStringLength)];
    [mainString addAttribute:NSFontAttributeName value:SourceHanSansNormal12 range:NSMakeRange(prevStringLength,tipStr.length-prevStringLength)];
    [self.descLabel  setAttributedText:mainString];
  }
}

- (void)timerFireForEmailMethod:(NSTimer *)timer
{
  self.timesSetForEmail = self.timesSetForEmail-1;
  if(self.timesSetForEmail  ==  0)
  {
    [self.nsTimerForEmail  invalidate];
    [self.resetPassWordBtnForEmail setTitle:@"重设密码" forState:UIControlStateNormal];
    self.isMessageCDForEmail  = NO;
    self.nsTimerForEmail  = nil;
    self.timesSetForEmail = timeSetOut;
    return;
  }
  [self.resetPassWordBtnForEmail setTitle:[NSString stringWithFormat:@"%ld秒",self.timesSetForEmail] forState:UIControlStateNormal];
}

#pragma getter setter
- (TPKeyboardAvoidingTableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView  = [[TPKeyboardAvoidingTableView  alloc]init];
    [_myTableView setBackgroundColor:kColorBackGround];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_myTableView  setTableFooterView:self.bottomView];
    [_myTableView  setTableHeaderView:self.headerView];
  }
  return _myTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 68)];
    [_headerView addSubview:self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(160, 30));
      make.center.equalTo(_headerView);
    }];
  }
  
  return _headerView;
}

- (UIView*)bottomView
{
  if(_bottomView  ==  nil)
  {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
    _bottomView.backgroundColor = [UIColor clearColor];
    [_bottomView addSubview:self.resetPassWordBtn];
    [_bottomView addSubview:self.resetPassWordBtnForEmail];
    [_bottomView addSubview:self.descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.size.mas_equalTo(CGSizeMake(kScreen_Width-40*2, 50));
      make.centerX.equalTo(_bottomView);
      make.top.equalTo(self.resetPassWordBtn.mas_bottom);
    }];
    
  }
  return _bottomView;
}

- (UILabel*)descLabel
{
  if(_descLabel ==  nil)
  {
    _descLabel  =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width-2*40, 50)];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.font = SourceHanSansNormal11;
    _descLabel.numberOfLines = 2;
    _descLabel.text =@"";
    /*
    NSString *tipStr = @"已将包含密码重置说明邮件发送至以下邮箱\n";
    NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc]initWithString:tipStr];
    [mainString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:182/255.0 green:179/255.0 blue:170/255.0 alpha:1.0] range:NSMakeRange(0,tipStr.length-1)];
    [mainString addAttribute:NSFontAttributeName value:SourceHanSansNormal11 range:NSMakeRange(0,mainString.length-1)];
    NSInteger prevStringLength  = mainString.length;
    */
  }
  return _descLabel;
}

- (GetPasswordBackInstance*)getPWInstance
{
  if(_getPWInstance ==  nil)
  {
    _getPWInstance  = [[GetPasswordBackInstance  alloc]init];
  }
  return _getPWInstance;
}

- (UIButton*)resetPassWordBtn
{
  if(_resetPassWordBtn  ==  nil)
  {
    _resetPassWordBtn = [[UIButton alloc]init];
    [_resetPassWordBtn    setBackgroundImage:[UIImage imageNamed:@"nextStepButton.png"] forState:UIControlStateNormal];
    [_resetPassWordBtn    setTitle:@"重设密码" forState:UIControlStateNormal];
    [_resetPassWordBtn    setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resetPassWordBtn.titleLabel setFont:SourceHanSansNormal16];
    [_resetPassWordBtn    setFrame:CGRectMake(40, 0, kScreen_Width-80, 40)];
    [_resetPassWordBtn  addTarget:self action:@selector(resetThePassWord) forControlEvents:UIControlEventTouchUpInside];
    RAC(self, resetPassWordBtn.enabled) = [RACSignal combineLatest:@[RACObserve(self, getPWInstance.phone), RACObserve(self, getPWInstance.password),RACObserve(self, getPWInstance.j_captcha),RACObserve(self, getPWInstance.email),RACObserve(self, isFindEmailBack)] reduce:^id(NSString *phone, NSString *password,NSString *j_captcha,NSString *email){
        return @((_getPWInstance.phone && _getPWInstance.phone.length>0 && [_getPWInstance.phone validatePhone]) && (_getPWInstance.password && _getPWInstance.password.length > 0) && (_getPWInstance.j_captcha && _getPWInstance.j_captcha.length > 0));
    }];
  }
  return _resetPassWordBtn;
}

- (UIButton*)resetPassWordBtnForEmail
{
  if(_resetPassWordBtnForEmail  ==  nil)
  {
    _resetPassWordBtnForEmail = [[UIButton alloc]init];
    [_resetPassWordBtnForEmail    setAlpha:0.0];
    [_resetPassWordBtnForEmail    setBackgroundImage:[UIImage imageNamed:@"nextStepButton.png"] forState:UIControlStateNormal];
    [_resetPassWordBtnForEmail    setTitle:@"重设密码" forState:UIControlStateNormal];
    [_resetPassWordBtnForEmail    setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_resetPassWordBtnForEmail.titleLabel setFont:SourceHanSansNormal16];
    [_resetPassWordBtnForEmail    setFrame:CGRectMake(40, 0, kScreen_Width-80, 40)];
    [_resetPassWordBtnForEmail    addTarget:self action:@selector(resetThePassWord) forControlEvents:UIControlEventTouchUpInside];
    RAC(self, resetPassWordBtnForEmail.enabled) = [RACSignal combineLatest:@[RACObserve(self, getPWInstance.email),RACObserve(self, isFindEmailBack),RACObserve(self, isMessageCDForEmail)] reduce:^id(NSString *email){
      return @((self.isFindEmailBack && _getPWInstance.email && _getPWInstance.email.length>0 && [_getPWInstance.email validateEmail] && !self.isMessageCDForEmail));
    }];
  }
  return _resetPassWordBtnForEmail;
}

- (UISegmentedControl*)segmentedControl
{
  if(_segmentedControl  ==  nil)
  {
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"手机",@"邮箱",nil];
    _segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentedControl.selectedSegmentIndex  = 0;
    [_segmentedControl.layer setMasksToBounds:YES];
    [_segmentedControl.layer setCornerRadius:15.0];//设置矩圆角半径,数值越大圆弧越大，反之圆弧越小
    [_segmentedControl.layer setBorderWidth:1.0];//边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef      colorref = CGColorCreate(colorSpace,(CGFloat[]){ 45.0/255.0, 216.0/255.0, 136.0/255.0, 1 });
    [_segmentedControl.layer setBorderColor:colorref];//边框颜色
    
    [_segmentedControl setTintColor:[UIColor colorWithRed:45/255.0 green:216/255.0 blue:136/255.0 alpha:1.0]];
    [_segmentedControl addTarget:self
                         action:@selector(segmentedControlValueChange)
               forControlEvents:UIControlEventValueChanged];
  }
  return _segmentedControl;
}
@end
