//
//  UIMessageInputViewController.h
//  DouPaiwo
//
//  Created by J006 on 15/6/27.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "BaseViewController.h"
#import "UserInstance.h"
#define kKeyboardView_Height 216.0
#define kMessageInputView_Height 50.0
#define kMessageInputView_HeightMax 120.0
#define kMessageInputView_PadingHeight 7.0
#define kMessageInputView_Width_Tool 35.0
#define kMessageInputView_MediaPadding 1.0
#define kPaddingLeftWidth 15.0
#define kKeyWindow [UIApplication sharedApplication].keyWindow
typedef NS_ENUM(NSInteger, UIMessageInputViewContentType) {
  UIMessageInputViewContentTypeComment = 0,
  UIMessageInputViewContentTypePriMsg,
  UIMessageInputViewContentTypeTopic,
  UIMessageInputViewContentTypeTask
};

typedef NS_ENUM(NSInteger, UIMessageInputViewState) {
  UIMessageInputViewStateSystem,
  UIMessageInputViewStateEmotion,
  UIMessageInputViewStateAdd
};
@protocol UIMessageInputViewControllerDelegate;
@interface UIMessageInputViewController : UIView<UITextViewDelegate>
@property (strong, nonatomic)           NSString                                    *placeHolder;
@property (assign, nonatomic)           BOOL                                        isAlwaysShow;
@property (assign, nonatomic, readonly) UIMessageInputViewContentType               contentType;
@property (strong, nonatomic)           UserInstance                                *toUser;
@property (strong, nonatomic)           NSNumber                                    *commentOfId;

@property (nonatomic, weak) id<UIMessageInputViewControllerDelegate> delegate;

+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type;
+ (instancetype)messageInputViewWithType:(UIMessageInputViewContentType)type placeHolder:(NSString *)placeHolder;

- (void)prepareToShow;
- (void)prepareToDismiss;
- (void)prepareToHold;
- (BOOL)notAndBecomeFirstResponder;
- (BOOL)isAndResignFirstResponder;
- (BOOL)isCustomFirstResponder;
- (void)prepareToAtSomeOne;
@end

@protocol UIMessageInputViewControllerDelegate <NSObject>
@optional
- (void)messageInputView:(UIMessageInputViewController *)inputView sendText:(NSString *)text;
- (void)messageInputView:(UIMessageInputViewController *)inputView sendBigEmotion:(NSString *)emotionName;
- (void)messageInputView:(UIMessageInputViewController *)inputView addIndexClicked:(NSInteger)index;
- (void)messageInputView:(UIMessageInputViewController *)inputView heightToBottomChenged:(CGFloat)heightToBottom;
@end


