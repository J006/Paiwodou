//
//  PocketDetailHTML.m
//  DouPaiwo
//
//  Created by J006 on 15/6/3.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "PocketDetailHTML.h"
#import "PocketItemInstance.h"
#import "UserInstance.h"
#import "PocketLikeCommentToolBar.h"
#import <Masonry.h>
#import "PersonalProfile.h"
#import <WebViewJavascriptBridge.h>
#import "DouAPIManager.h"
#import "ShareTotalViewController.h"
typedef NS_ENUM(NSInteger, ScrollDirection) {
  ScrollDirectionNone=0,
  ScrollDirectionRight=1,
  ScrollDirectionLeft=2,
  ScrollDirectionUp=3,
  ScrollDirectionDown=4,
  ScrollDirectionCrazy=5,
} ;
@interface PocketDetailHTML ()

@property (nonatomic,strong)    UIWebView                     *webView;
@property (nonatomic,strong)    UIButton                      *backButton;  //后退按钮
@property (nonatomic,strong)    UIButton                      *shareButton;//分享按钮


@property (nonatomic,readwrite) BOOL                          isLoadingFinished;
@property (readwrite, nonatomic)NSInteger                     pocketID;//当前pocketID
@property (readwrite, nonatomic)NSInteger                     userID;//当前userID
@property (nonatomic,strong)    NSString                      *htmlString;
@property (nonatomic,strong)    PocketItemInstance            *pocket;
@property (nonatomic,strong)    UserInstance                  *author;
@property (nonatomic,strong)    PocketLikeCommentToolBar      *pocketLikeCommentToolBar;

@property (nonatomic,readwrite) BOOL                          scrollToBottom;
@property (nonatomic,readwrite) CGFloat                       lastContentOffset;
@property (nonatomic,readwrite) ScrollDirection               scrollDirection;

@property (nonatomic,readwrite) BOOL                          isFading;//后退按钮和分享按钮正在动画

@property (nonatomic,readwrite) WebViewJavascriptBridge       *bridge;
@property (strong, nonatomic)   UISwipeGestureRecognizer      *swipGestureRecognizer;//右划后退

@property (strong, nonatomic)   ShareTotalViewController      *shareVC;
@property (nonatomic, copy)     void(^backAction)(id);


@end

@implementation PocketDetailHTML

#pragma life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.webView];
  [self.view  addSubview:self.backButton];
  [self.view  addSubview:self.shareButton];
  [self.view  addGestureRecognizer:self.swipGestureRecognizer];
  self.automaticallyAdjustsScrollViewInsets = NO;
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
  ^{
    [[DouAPIManager  sharedManager] request_GetPocketWithPocketID:weakSelf.pocketID :^(PocketItemInstance *pocketItemInstance, NSError *error)
     {
       if(!pocketItemInstance)
         return;
       weakSelf.pocket = pocketItemInstance;
       NSString  *domain;
       if(pocketItemInstance.pocket_type ==  publish_pocket)
         domain  = pocketItemInstance.user_domain;
       else
         domain  = pocketItemInstance.author_domain;
       [[DouAPIManager  sharedManager] request_GetUserProfileWithDomain:domain :^(UserInstance *userInstance, NSError *error)
        {
          if(!userInstance)
            return;
          [weakSelf  initPocketDetailHTMLWithPocketContent:pocketItemInstance.pocket_content pocketItemInstance:pocketItemInstance userInstance:userInstance];
          dispatch_sync(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadHTMLString:weakSelf.htmlString baseURL:[NSURL URLWithString:defaultMainUrl]];
            [weakSelf.pocketLikeCommentToolBar initPhotoLikeCommentToolBarWithPocketItem:pocketItemInstance];
            [weakSelf.view  addSubview:weakSelf.pocketLikeCommentToolBar.view];
            [weakSelf.view  setNeedsLayout];
          });
        }];
     }];
  });
}

- (void)viewDidLayoutSubviews
{
  [super                                viewDidLayoutSubviews];
  [self.webView                         setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height-50)];
  [self.webView                         setScalesPageToFit:YES];
  if(self.pocket)
    [self.pocketLikeCommentToolBar.view   setFrame:CGRectMake(0, kScreen_Height-50, kScreen_Width, 50)];
  [self.backButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.left.equalTo(self.view).offset(10);
    make.top.equalTo(self.view).offset(20);
    make.size.mas_equalTo(CGSizeMake(40,40));
  }];
  [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make){
    make.right.equalTo(self.view).offset(-10);
    make.top.equalTo(self.view).offset(20);
    make.size.mas_equalTo(CGSizeMake(40,40));
  }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}
-(void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
  [[PocketDetailHTML getNavi]setNavigationBarHidden:YES];
  [PocketDetailHTML setRDVTabStatusHidden:YES];
}

#pragma init
- (void)initPocketDetailHTMLWithPocketContent  :(NSString*)pocketContent pocketItemInstance :(PocketItemInstance*)pocketItemInstance userInstance :(UserInstance*)userInstance;
{
  pocketContent = [pocketContent  stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
  pocketContent = [pocketContent  stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
  pocketContent = [pocketContent  stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
  NSString* path = [[NSBundle mainBundle] pathForResource:@"pocket" ofType:@"html"];
  NSString* content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
  content = [content  stringByReplacingOccurrencesOfString:@"我是标题XXX..."       withString:pocketItemInstance.pocket_title==nil ? @"" : pocketItemInstance.pocket_title];
  content = [content  stringByReplacingOccurrencesOfString:@"我是一个副标题XXX..."  withString:pocketItemInstance.pocket_second_title==nil ? @"" : pocketItemInstance.pocket_second_title];
  content = [content  stringByReplacingOccurrencesOfString:@"图片地址..."          withString:pocketItemInstance.cover_photo==nil ? @"" : [[defaultImageHeadUrl stringByAppendingString:pocketItemInstance.cover_photo] stringByAppendingString:imageBannerUrl]];
  content = [content  stringByReplacingOccurrencesOfString:@"头像..."             withString: userInstance.host_avatar==nil ? @"" : [defaultImageHeadUrl stringByAppendingString:userInstance.host_avatar]];
  content = [content  stringByReplacingOccurrencesOfString:@"我是作者名..."        withString: userInstance.host_name==nil ? @"" : userInstance.host_name];
  content = [content  stringByReplacingOccurrencesOfString:@"我是contet-box"      withString: pocketContent==nil ? @"" : pocketContent];
  self.htmlString = content;
  self.pocket     = pocketItemInstance;
  self.author     = userInstance;
}

- (void)initPocketDetailHTMLWithPocketID  :(NSInteger)pocketID
{
  self.pocketID = pocketID;
}

#pragma private method
//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
  NSMutableString *str = [NSMutableString stringWithString:html];
  //计算要缩放的比例
  CGFloat initialScale = webView.frame.size.width/pageWidth;
  //将</head>替换为meta+head
  NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
  
  NSRange range =  NSMakeRange(0, str.length);
  //替换
  [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
  return str;
}

#pragma webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
  if(self.author.is_self)
  {
    [webView stringByEvaluatingJavaScriptFromString:@"is_self()"];
  }
  else  if(self.author.follow_state ==  follow_NO || self.author.follow_state ==  follow_HE)
  {
    [webView stringByEvaluatingJavaScriptFromString:@"addFocus()"];
  }
  else
  {
    [webView stringByEvaluatingJavaScriptFromString:@"removeFocus()"];  
  }
}

- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error
{

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  if ([request.URL.absoluteString hasSuffix:@"po://jump_profile"])
  {
    PersonalProfile *ppView = [[PersonalProfile  alloc]init];
    BOOL      isSelf = NO;
    NSString  *currentDomain  = [DouAPIManager  currentDomainData];
    if([self.author.host_domain isEqualToString:currentDomain])
      isSelf  = YES;
    [ppView  initPersonalProfileWithUserDomain:self.author.host_domain isSelf:isSelf];
    [ppView.view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [PocketDetailHTML naviPushViewController:ppView];
    return NO;
  }
  else  if ([request.URL.absoluteString hasSuffix:@"po://adddel_friends"])
  {
    if(self.author.follow_state ==  follow_NO || self.author.follow_state ==  follow_HE)
    {
      [self followAction    :webView];
    }
    else
    {
      [self unFollowAction  :webView];
    }
    return NO;
  }
  return  YES;
}

#pragma UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGFloat   height          = scrollView.frame.size.height;
  CGFloat   contentYoffset  = scrollView.contentOffset.y;
  CGFloat   distanceFromBottom  = scrollView.contentSize.height-contentYoffset;
  if(distanceFromBottom<=height || contentYoffset<=0)
    return;
  if (self.lastContentOffset > scrollView.contentOffset.y)
    self.scrollDirection = ScrollDirectionUp;
  else if (self.lastContentOffset < scrollView.contentOffset.y)
    self.scrollDirection = ScrollDirectionDown;
  self.lastContentOffset = scrollView.contentOffset.y;

  if(!self.isFading)
  {
    if(self.scrollDirection ==  ScrollDirectionDown)
      [UIView animateWithDuration:0.7
                            delay:0.0
                          options:UIViewAnimationOptionTransitionFlipFromBottom
                       animations:^{
                         [self.backButton   setAlpha:0.0];
                         [self.shareButton  setAlpha:0.0];
                       }completion:^(BOOL finished){
                         self.isFading  = NO;
                       }];
    else  if(self.scrollDirection ==  ScrollDirectionUp)
      [UIView animateWithDuration:0.7
                            delay:0.0
                          options:UIViewAnimationOptionTransitionFlipFromBottom
                       animations:^{
                         [self.backButton   setAlpha:1.0];
                         [self.shareButton  setAlpha:1.0];
                       }completion:^(BOOL finished){
                         self.isFading  = NO;
                       }];
  }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  //scrollView.scrollsToTop;

}

#pragma event
/**
 *  @author J006, 15-05-19 18:05:03
 *
 *  返回上层
 *
 *  @param sender
 */
- (void)backToLastView:(id)sender
{
  [self.view removeGestureRecognizer:_swipGestureRecognizer];
  if(self.backAction)
    self.backAction(self);
  else
    [[PocketDetailHTML  getNavi]popViewControllerAnimated:YES];
}

- (void)addBackBlock:(void(^)(id obj))backAction
{
  self.backAction = backAction;
  [self.backButton  addTarget:self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  @author J006, 15-06-29 14:06:21
 *
 *  关注对方
 *
 *  @param sender
 */
- (void)followAction  :(UIWebView*)webView
{
  NSInteger   host_id  = self.author.host_id;
  [[DouAPIManager  sharedManager]request_FollowWithFollowID:host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      //[webView stringByEvaluatingJavaScriptFromString:@"removeFocus()"];
      [self.author              setFollow_state:follow_state];
    }
  }];
}

- (void)unFollowAction  :(UIWebView*)webView
{
  NSInteger   host_id  = self.author.host_id;
  [[DouAPIManager  sharedManager]request_UnFollowWithFollowID:host_id :^(NSInteger follow_state, NSError *error) {
    if(follow_state!=0)
    {
      //[webView stringByEvaluatingJavaScriptFromString:@"addFocus()"];
      [self.author              setFollow_state:follow_state];
    }
  }];
}

- (void)shareTheCurrentPhotoAction
{
  self.shareVC  = [[ShareTotalViewController alloc]init];
  UIImage *image  = [[UIImage  alloc]init];
  image = [image  takeSnapshotOfView:self.view];
  [self.shareVC  initSharePocketWithSnapshot:image pocket:self.pocket shareContentType:ShareContentTypePocket];
  [self.shareVC .view  setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
  [PocketDetailHTML naviPushViewControllerWithNoAniation:self.shareVC];
}

#pragma getter setter
- (UIWebView*)webView
{
  if(_webView ==  nil)
  {
    _webView  = [[UIWebView  alloc]init];
    _webView.backgroundColor  = kColorBackGround;
    _webView.delegate = self;
    _webView.scrollView.delegate  = self;
  }
  return _webView;
}

- (WebViewJavascriptBridge*)bridge
{
  if(_bridge  ==  nil)
  {
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self  handler:^(id data, WVJBResponseCallback responseCallback)
               {
                 NSLog(@"Received message from javascript: %@", data);
                 responseCallback(@"Right back atcha");
               }];
    [WebViewJavascriptBridge enableLogging];
  }
  return _bridge;
}

- (PocketLikeCommentToolBar*)pocketLikeCommentToolBar
{
  if(_pocketLikeCommentToolBar  ==  nil)
  {
    _pocketLikeCommentToolBar = [[PocketLikeCommentToolBar alloc]init];
  }
  return _pocketLikeCommentToolBar;
}

- (UIButton*)backButton
{
  if(_backButton  ==  nil)
  {
    _backButton  = [[UIButton alloc]init];
    [_backButton setImage:[UIImage imageNamed:@"backCircleButton"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backToLastView:) forControlEvents:UIControlEventTouchUpInside];
  }
  return _backButton;
}

- (UIButton*)shareButton
{
  if(_shareButton  ==  nil)
  {
    _shareButton  = [[UIButton alloc]init];
    [_shareButton setImage:[UIImage imageNamed:@"shareButtonCircleButton"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(shareTheCurrentPhotoAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _shareButton;
}

- (UISwipeGestureRecognizer*)swipGestureRecognizer
{
  if(_swipGestureRecognizer ==  nil)
  {
    _swipGestureRecognizer  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(backToLastView:)];
    [_swipGestureRecognizer   setDirection:UISwipeGestureRecognizerDirectionRight];
  }
  return _swipGestureRecognizer;
}
@end
