//
//  UIMessageInputViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/6/27.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "UIMessageInputViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIPlaceHolderTextView.h"
#import <Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "NSString+Common.m"


static NSMutableDictionary *_inputStrDict, *_inputMediaDict;

@interface UIMessageInputViewController ()


@property (strong, nonatomic) NSMutableArray                *mediaList;
@property (strong, nonatomic) NSMutableArray                *uploadMediaList;
@property (strong, nonatomic) NSString                      *uploadingPhotoName;
@property (assign, nonatomic) CGFloat                       viewHeightOld;

@property (strong, nonatomic) UIButton                      *addButton;
@property (strong, nonatomic) UIScrollView                  *contentView;

@property (strong, nonatomic) MBProgressHUD                 *HUD;
@property (assign, nonatomic) UIMessageInputViewState       inputState;
@property (strong, nonatomic) UIPlaceHolderTextView         *inputTextView;
@end

@implementation UIMessageInputViewController

#pragma life cycle
- (void)setFrame:(CGRect)frame
{
  CGFloat oldheightToBottom = kScreen_Height - CGRectGetMinY(self.frame);
  CGFloat newheightToBottom = kScreen_Height - CGRectGetMinY(frame);
  [super setFrame:frame];
  if (fabs(oldheightToBottom - newheightToBottom) > 0.1)
  {
    if (oldheightToBottom > newheightToBottom) {//降下去的时候保存
      //[self saveInputStr];
      //[self saveInputMedia];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(messageInputView:heightToBottomChenged:)]) {
      [self.delegate messageInputView:self heightToBottomChenged:newheightToBottom];
    }
  }
  //NSLog(@"self.view height=%f",self.frame.size.height);
  //NSLog(@"inputTextView height=%f",self.inputTextView.frame.size.height);
}
- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
    [self addLineUp:YES andDown:NO andColor:[UIColor lightGrayColor]];
    
    _viewHeightOld = CGRectGetHeight(frame);
    _inputState = UIMessageInputViewStateSystem;
    _isAlwaysShow = YES;
  }
  return self;
}

#pragma init

+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type
{
  return [self messageInputViewWithType:type placeHolder:nil];
}

+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type placeHolder:(NSString *)placeHolder
{
  UIMessageInputViewController *messageInputView = [[UIMessageInputViewController alloc] init];
  [messageInputView  setFrame:CGRectMake(0, kScreen_Height, kScreen_Width, kMessageInputView_Height)];
  if (placeHolder)
    messageInputView.placeHolder = placeHolder;
  else
    messageInputView.placeHolder = @"";
  [messageInputView customUIWithType:type];
  return messageInputView;
}

- (void)customUIWithType:(UIMessageInputViewContentType)type
{
  _contentType = type;
  BOOL hasEmotionBtn, hasAddBtn, hasPhotoBtn;
  BOOL showBigEmotion;
  NSInteger toolBtnNum = 0;
  CGFloat contentViewHeight = kMessageInputView_Height -2*kMessageInputView_PadingHeight;
  __weak typeof(self) weakSelf = self;
  switch (_contentType)
  {
    case UIMessageInputViewContentTypeComment:
    {
      toolBtnNum = 0;
      hasEmotionBtn = YES;
      hasAddBtn = NO;
      hasPhotoBtn = NO;
      showBigEmotion = NO;
    }
      break;
    case UIMessageInputViewContentTypePriMsg:
    {
      toolBtnNum = 2;
      hasEmotionBtn = YES;
      hasAddBtn = YES;
      hasPhotoBtn = NO;
      showBigEmotion = YES;
    }
      break;
    case UIMessageInputViewContentTypeTopic:
    case UIMessageInputViewContentTypeTask:
    {
      toolBtnNum = 1;
      hasEmotionBtn = NO;
      hasAddBtn = NO;
      hasPhotoBtn = YES;
      showBigEmotion = NO;
    }
      break;
    default:
      toolBtnNum = 1;
      hasEmotionBtn = NO;
      hasAddBtn = NO;
      hasPhotoBtn = NO;
      showBigEmotion = NO;
      break;
  }
  
  if (!_contentView) {
    _contentView = [[UIScrollView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.borderWidth = 0.5;
    _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _contentView.layer.cornerRadius = contentViewHeight/6;
    _contentView.layer.masksToBounds = YES;
    _contentView.alwaysBounceVertical = YES;
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self).insets(UIEdgeInsetsMake(kMessageInputView_PadingHeight, kPaddingLeftWidth, kMessageInputView_PadingHeight, kPaddingLeftWidth + toolBtnNum *kMessageInputView_Width_Tool));
    }];
  }
  
  if (!_inputTextView)
  {
    _inputTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width -2*kPaddingLeftWidth - toolBtnNum *kMessageInputView_Width_Tool, contentViewHeight)];
    _inputTextView.font = SourceHanSansNormal14;
    _inputTextView.returnKeyType = UIReturnKeySend;
    _inputTextView.scrollsToTop = NO;
    _inputTextView.delegate = self;
    _inputTextView.placeholder  = self.placeHolder;
    
    //输入框缩进
    UIEdgeInsets insets = _inputTextView.textContainerInset;
    insets.left += 8.0;
    insets.right += 8.0;
    insets.top  +=4.0;
    _inputTextView.textContainerInset = insets;
    
    [self.contentView addSubview:_inputTextView];
  }
  
  if (_inputTextView) {
    [[RACObserve(self.inputTextView, contentSize) takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSValue *contentSize) {
      [weakSelf updateContentViewBecauseOfMedia:NO];
    }];
  }
}

- (void)updateContentViewBecauseOfMedia:(BOOL)becauseOfMedia
{
  
  CGSize  textSize  = _inputTextView.contentSize;
  CGSize  mediaSize = CGSizeZero;
  if (!becauseOfMedia)
  {
    if (ABS(CGRectGetHeight(_inputTextView.frame) - textSize.height) > 0.5)
      [_inputTextView setHeight:textSize.height];
  }
  CGSize contentSize = CGSizeMake(textSize.width, textSize.height + mediaSize.height);
  CGFloat selfHeight = MAX(kMessageInputView_Height, contentSize.height + 2*kMessageInputView_PadingHeight);
  
  CGFloat maxSelfHeight = kScreen_Height/2;
  if (kDevice_Is_iPhone5)
    maxSelfHeight = 230;
  else if (kDevice_Is_iPhone6)
    maxSelfHeight = 290;
  else if (kDevice_Is_iPhone6Plus)
    maxSelfHeight = kScreen_Height/2;
  else
    maxSelfHeight = 140;
  
  selfHeight = MIN(maxSelfHeight, selfHeight);
  CGFloat diffHeight = selfHeight - _viewHeightOld;
  if (ABS(diffHeight) > 0.5)
  {
    CGRect selfFrame = self.frame;
    selfFrame.size.height += diffHeight;
    selfFrame.origin.y -= diffHeight;
    [self setFrame:selfFrame];
    self.viewHeightOld = selfHeight;
  }

  [self.contentView setContentSize:contentSize];
  CGFloat bottomY = becauseOfMedia? contentSize.height: textSize.height;
  CGFloat offsetY = MAX(0, bottomY - (CGRectGetHeight(self.frame)- 2* kMessageInputView_PadingHeight));
  [self.contentView setContentOffset:CGPointMake(0, offsetY) animated:YES];
}

#pragma self function

- (void)prepareToShow
{
  [self setY:kScreen_Height];
  [kKeyWindow addSubview:self];
  if (_isAlwaysShow)
  {
    if ([self isCustomFirstResponder])
    {
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    else
    {
      [UIView animateWithDuration:0.25 animations:^{
        [self setY:kScreen_Height - CGRectGetHeight(self.frame)];
      } completion:^(BOOL finished) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
      }];
    }
  }
  else
  {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
  }
}

- (void)prepareToAtSomeOne
{
  [self.inputView becomeFirstResponder];
}

- (void)prepareToDismiss
{
  [self isAndResignFirstResponder];
  [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
    [self setY:kScreen_Height];
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareToHold
{
  [self isAndResignFirstResponder];
  [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
    [self setY:kScreen_Height - CGRectGetHeight(self.frame)];
  } completion:^(BOOL finished) {

  }];
}


- (BOOL)notAndBecomeFirstResponder
{
  self.inputState = UIMessageInputViewStateSystem;
  if ([_inputTextView isFirstResponder])
    return NO;
  else
    [_inputTextView becomeFirstResponder];
    return YES;
}

- (BOOL)isAndResignFirstResponder
{
  if ([_inputTextView isFirstResponder])
  {
    [_inputTextView resignFirstResponder];
    return YES;
  }
  return NO;
}

- (BOOL)isCustomFirstResponder
{
  return ([_inputTextView isFirstResponder] || self.inputState == UIMessageInputViewStateAdd || self.inputState == UIMessageInputViewStateEmotion);
}

#pragma mark UITextViewDelegate
- (void)sendTextStr
{
  //[self deleteInputData];
  NSMutableString *sendStr = [NSMutableString stringWithString:self.inputTextView.text];
  if (sendStr && ![sendStr isEmpty] && _delegate && [_delegate respondsToSelector:@selector(messageInputView:sendText:)]) {
    [self.delegate messageInputView:self sendText:sendStr];
  }
  _inputTextView.selectedRange = NSMakeRange(0, _inputTextView.text.length);
  [_inputTextView insertText:@""];
  [self updateContentViewBecauseOfMedia:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  if ([text isEqualToString:@"\n"])
  {
    [self sendTextStr];
    return NO;
  }else if ([text isEqualToString:@"@"])
  {
    return NO;
  }
  return YES;
}

- (void)atSomeUser:(UserInstance *)curUser inTextView:(UITextView *)textView andRange:(NSRange)range{
  NSString *appendingStr;
  if (curUser)
  {
    appendingStr = [NSString stringWithFormat:@"@%@ ", curUser.host_name];
  }
  else
  {
    appendingStr = @"@";
  }
  [textView insertText:appendingStr];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  if (self.inputState != UIMessageInputViewStateSystem) {
    self.inputState = UIMessageInputViewStateSystem;
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
    } completion:^(BOOL finished) {
      self.inputState = UIMessageInputViewStateSystem;
    }];
  }
  return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
  if (self.inputState == UIMessageInputViewStateSystem) {
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
      if (_isAlwaysShow) {
        [self setY:kScreen_Height- CGRectGetHeight(self.frame)];
      }else{
        [self setY:kScreen_Height];
      }
    } completion:^(BOOL finished) {
    }];
  }
  return YES;
}


#pragma mark - KeyBoard Notification Handlers
- (void)keyboardChange:(NSNotification*)aNotification{
  if (self.inputState == UIMessageInputViewStateSystem && [self.inputTextView isFirstResponder]) {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardEndFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0f options:[self animationOptionsForCurve:animationCurve] animations:^{
      CGFloat keyboardY =  keyboardEndFrame.origin.y;
      if (ABS(keyboardY - kScreen_Height) < 0.1) {
        if (_isAlwaysShow) {
          [self setY:kScreen_Height- CGRectGetHeight(self.frame)];
        }else{
          [self setY:kScreen_Height];
        }
      }else{
        [self setY:keyboardY-CGRectGetHeight(self.frame)];
      }
      
    } completion:^(BOOL finished) {
    }];
  }
}

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
  switch (curve) {
    case UIViewAnimationCurveEaseInOut:
      return UIViewAnimationOptionCurveEaseInOut;
      break;
    case UIViewAnimationCurveEaseIn:
      return UIViewAnimationOptionCurveEaseIn;
      break;
    case UIViewAnimationCurveEaseOut:
      return UIViewAnimationOptionCurveEaseOut;
      break;
    case UIViewAnimationCurveLinear:
      return UIViewAnimationOptionCurveLinear;
      break;
  }
  
  return kNilOptions;
}

#pragma UIMessageInputViewControllerDelegate



#pragma getter setter

- (NSMutableDictionary *)shareInputStrDict
{
  if (!_inputStrDict)
  {
    _inputStrDict = [[NSMutableDictionary alloc] init];
  }
  return _inputStrDict;
}

- (NSMutableDictionary *)shareInputMediaDict{
  if (!_inputMediaDict)
  {
    _inputMediaDict = [[NSMutableDictionary alloc] init];
  }
  return _inputMediaDict;
}


@end
