//
//  CommentViewController.m
//  DouPaiwo
//
//  Created by J006 on 15/6/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableViewCell.h"
#import "CommentTableViewCell.h"
#import "DouAPIManager.h"
#import <Masonry.h>
#import "NSString+Common.h"

#define kColorTopView [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]
@interface CommentViewController ()

@property (strong   ,nonatomic)   UILabel                       *titleLabel;//评论数字
@property (strong   ,nonatomic)   UIBarButtonItem               *closeButton;//关闭
@property (strong   ,nonatomic)   UITableView                   *commentTableView;//评论
@property (strong   ,nonatomic)   UILabel                       *noCommentLabel;//无评论
@property (strong   ,nonatomic)   UIButton                      *maskButton;

@property (strong   ,nonatomic)   NSMutableArray                *commentArray;//评论总集合
@property (strong   ,nonatomic)   NSString                      *noCommentString;//喜欢这张照片/兜吗？写条评论吧。
@property (strong   ,nonatomic)   AlbumPhotoInstance            *currAlbumPhoto;//当前受评论照片对象
@property (strong   ,nonatomic)   PocketItemInstance            *pocket;//当前受评论兜对象

@property (strong   ,nonatomic)   UIMessageInputViewController  *myMsgInputView;

@property (strong   ,nonatomic)   UISwipeGestureRecognizer      *swipGestureRecognizer;//右划后退

@property (strong   ,nonatomic)   UIActivityIndicatorView       *activityIndicatorView;
@end

@implementation CommentViewController

#pragma life cycle
- (void)viewDidLoad
{
  [self.view          setBackgroundColor:kColorBackGround];
  self.navigationItem.titleView = self.titleLabel;
  [self.view          addSubview:self.titleLabel];
  self.navigationItem.rightBarButtonItem  = self.closeButton;
  self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem  alloc]initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
  [self.view          addSubview:self.commentTableView];

  [self.view          addGestureRecognizer:self.swipGestureRecognizer];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^{
                   if(weakSelf.currAlbumPhoto)
                   {
                     [[DouAPIManager  sharedManager]request_GetPhotoCommentWithPhotoID :weakSelf.currAlbumPhoto.photo_id page_no:1 page_size:pageSizeDefault :^(NSMutableArray *commentsData, NSError *error)
                      {
                        NSString  *noCommentString  = nil;
                        if(!commentsData)
                        {
                          noCommentString  = @"喜欢这张照片吗？写条评论吧。";
                          dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.view        addSubview:weakSelf.noCommentLabel];
                          });
                        }
                        [weakSelf initCommentViewControllerWithCommentArray:commentsData noCommentString:noCommentString];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                          [weakSelf.myMsgInputView  prepareToShow];
                          [weakSelf.commentTableView  reloadData];
                          [weakSelf.view setNeedsLayout];
                        });
                      }];
                   }
                   else if(weakSelf.pocket)
                   {
                     [[DouAPIManager  sharedManager]request_GetPocketCommentWithPocketID: weakSelf.pocket.pocket_id page_no:1 page_size:pageSizeDefault :^(NSMutableArray *commentsData, NSError *error)
                      {
                        NSString  *noCommentString  = nil;
                        if(!commentsData)
                        {
                          noCommentString  = @"喜欢这个图文吗？写条评论吧。";
                          dispatch_sync(dispatch_get_main_queue(), ^{
                            [weakSelf.view        addSubview:weakSelf.noCommentLabel];
                          });
                        }
                        [weakSelf initCommentViewControllerWithCommentArray:commentsData noCommentString:noCommentString];
                        dispatch_sync(dispatch_get_main_queue(), ^{
                          [weakSelf.myMsgInputView  prepareToShow];
                          [weakSelf.commentTableView  reloadData];
                          [weakSelf.view setNeedsLayout];
                        });
                      }];
                   }
                 });
}

- (void)viewDidLayoutSubviews
{
  [self updateTheTitleCommentNums];
  
  [self.titleLabel  sizeToFit];
  
  [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.view);
    make.right.equalTo(self.view);
    make.top.equalTo(self.view).offset(pageToolBarHeight+20);
    make.bottom.equalTo(self.view);
  }];
  
  if(self.noCommentString)
    [self.noCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(self.view);
      make.centerY.equalTo(self.view).offset(-50);
    }];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [[CommentViewController getNavi] setNavigationBarHidden:NO];
  [[CommentViewController getNavi].navigationBar setTintColor:[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0]];
  [[CommentViewController getNavi].navigationBar setBarTintColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
  [[CommentViewController getNavi].navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil]];
  [CommentViewController  setRDVTabStatusStyleDirect:UIStatusBarStyleDefault];
}

#pragma Tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSInteger row = 1;
  return row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger row = 0;
  if(self.commentArray)
    row = [self.commentArray count];
  return row;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(self.commentArray)
  {
    CommentTableViewCell  *cell = [[CommentTableViewCell alloc]init];
    CommentInstance       *comment  = [self.commentArray  objectAtIndex:indexPath.section];
    [cell initCommentTableViewCellWithComment:comment];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //以下方法主要用以让分割线全屏
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
      [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
      [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
      [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
  }
  return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSInteger selectIndex = indexPath.section;
  CommentInstance       *comment  = [self.commentArray  objectAtIndex:selectIndex];
  if(comment.is_self)
    return;
  NSString  *placeHold  = @"回复@";
  [self.myMsgInputView setPlaceHolder:[placeHold stringByAppendingString:comment.comment_user_name]];
  [self.myMsgInputView  prepareToAtSomeOne];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  float height=0;
  CommentInstance    *comment  = [self.commentArray  objectAtIndex:indexPath.section];
  CGSize  textSize = [comment.comment_text getSizeWithFont:SourceHanSansNormal14 constrainedToSize:CGSizeMake(kScreen_Width-75-25, CGFLOAT_MAX)];
  height  = 61+textSize.height+5;
  return  height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  CommentInstance       *comment  = [self.commentArray  objectAtIndex:indexPath.section];
  if(comment.is_self)
    return YES;
  else
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    [self.activityIndicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      CommentInstance    *comment  = [self.commentArray  objectAtIndex:indexPath.section];
      if(self.currAlbumPhoto)
      {
        [[DouAPIManager  sharedManager] request_DelPhotoCommentWithCommentID: comment.comment_id photo_id:self.currAlbumPhoto.photo_id :^(BOOL isSuccess, NSError *error) {
          if(isSuccess)
            dispatch_sync(dispatch_get_main_queue(), ^{
              [weakSelf.commentArray removeObjectAtIndex:indexPath.section];
              [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
              [weakSelf.activityIndicatorView stopAnimating];
            });
          else
            dispatch_sync(dispatch_get_main_queue(), ^{
              [weakSelf.activityIndicatorView stopAnimating];
            });
        }];
      }
      else  if(self.pocket)
      {
        [[DouAPIManager  sharedManager] request_DelPocketCommentWithCommentID:comment.comment_id pocket_id:self.pocket.pocket_id :^(BOOL isSuccess, NSError *error) {
          if(isSuccess)
            dispatch_sync(dispatch_get_main_queue(), ^{
              [weakSelf.commentArray removeObjectAtIndex:indexPath.section];
              [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
              [weakSelf.activityIndicatorView stopAnimating];
            });
          else
            dispatch_sync(dispatch_get_main_queue(), ^{
              [weakSelf.activityIndicatorView stopAnimating];
            });
        }];
      }
    });
  }
}



#pragma UIMessageInputView delegate
- (void)messageInputView:(UIMessageInputViewController *)inputView heightToBottomChenged:(CGFloat)heightToBottom
{
  [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
    UIEdgeInsets contentInsets= UIEdgeInsetsMake(0.0, 0.0, heightToBottom, 0.0);;
    self.commentTableView.contentInset = contentInsets;
  } completion:nil];
  if(heightToBottom>100)
  {
    if(!_maskButton && _myMsgInputView)
    {
      [self.view  insertSubview:self.maskButton belowSubview:_myMsgInputView];
      
    }
  }
  
}

- (void)messageInputView:(UIMessageInputViewController *)inputView sendText:(NSString *)text
{
  if(![text isEmpty])
  {
    [self.activityIndicatorView startAnimating];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      if(weakSelf.currAlbumPhoto)
      {
        [[DouAPIManager  sharedManager]request_AddPhotoCommentWithPhotoID :weakSelf.currAlbumPhoto.photo_id reply_user_id:weakSelf.currAlbumPhoto.author_id comment_text:text :^(CommentInstance *comment, NSError *error)
         {
           if(comment)
           {
             [[DouAPIManager  sharedManager]request_GetPhotoCommentWithPhotoID  :weakSelf.currAlbumPhoto.photo_id page_no:1 page_size:pageSizeDefault :^(NSMutableArray *commentsData, NSError *error)
              {
                if(commentsData)
                  weakSelf.commentArray  = commentsData;
                dispatch_sync(dispatch_get_main_queue(), ^{
                  if(weakSelf.noCommentLabel && !commentsData)
                  {
                    [weakSelf.noCommentLabel removeFromSuperview];
                    weakSelf.noCommentLabel  = nil;
                  }
                  [weakSelf.commentTableView reloadData];
                  [weakSelf.activityIndicatorView stopAnimating];
                });
              }];
           }
         }];
      }
      else  if(weakSelf.pocket)
      {
        [[DouAPIManager  sharedManager]request_AddPocketCommentWithPocketID :weakSelf.pocket.pocket_id reply_user_id:weakSelf.pocket.author_id comment_text:text :^(CommentInstance *comment, NSError *error)
         {
           if(comment)
           {
             [[DouAPIManager  sharedManager]request_GetPocketCommentWithPocketID  :weakSelf.pocket.pocket_id page_no:1 page_size:pageSizeDefault :^(NSMutableArray *commentsData, NSError *error)
              {
                if(commentsData)
                  weakSelf.commentArray  = commentsData;
                dispatch_sync(dispatch_get_main_queue(), ^{
                  if(weakSelf.noCommentLabel && !commentsData)
                  {
                    [weakSelf.noCommentLabel removeFromSuperview];
                    weakSelf.noCommentLabel  = nil;
                  }
                  [weakSelf.commentTableView reloadData];
                  [weakSelf.activityIndicatorView stopAnimating];
                });
              }];
           }
         }];
      }
    });
  }
}

#pragma init
- (void)initCommentViewControllerWithCommentArray :(NSMutableArray*)commentArray  noCommentString:(NSString*)noCommentString;
{
  self.commentArray     = commentArray;
  self.noCommentString  = noCommentString;
}

- (void)initCommentViewControllerWithAlbumPhoto  :(AlbumPhotoInstance*)albumPhoto;
{
  self.currAlbumPhoto   = albumPhoto;
}

- (void)initPocketCommentViewControllerWithCommentArray :(NSMutableArray*)commentArray  noCommentString:(NSString*)noCommentString
{
  self.commentArray     = commentArray;
  self.noCommentString  = noCommentString;
}

- (void)initCommentViewControllerWithPocket  :(PocketItemInstance*)pocket
{
  self.pocket           = pocket;
}

#pragma private methods
- (void)backToLastView  :(id)sender
{
  [[CommentViewController  getNavi]popViewControllerAnimated:YES];
  [self.myMsgInputView  prepareToDismiss];
}

- (void)maskButtonToDismissAction
{
  [self.myMsgInputView prepareToHold];
  [_maskButton  removeFromSuperview];
  _maskButton = nil;
}

- (void)updateTheTitleCommentNums
{
  NSMutableAttributedString *string_title = [[NSMutableAttributedString alloc]initWithString:@"评论  "];
  [string_title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,string_title.length)];
  if(!self.commentArray || [self.commentArray count]==0)
  {
    NSString  *content  = @"0";
    NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
    [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:45/255.0 green:216/255.0 blue:136/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
    [string_title appendAttributedString:string_content];
    [self.titleLabel  setAttributedText:string_title];
    return;
  }
  NSString  *content  = [NSString stringWithFormat:@"%ld",[self.commentArray count]];
  NSMutableAttributedString *string_content = [[NSMutableAttributedString alloc]initWithString:content];
  [string_content addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:45/255.0 green:216/255.0 blue:136/255.0 alpha:1.0] range:NSMakeRange(0,content.length)];
  [string_title appendAttributedString:string_content];
  [self.titleLabel  setAttributedText:string_title];
}

#pragma mark UIMessageInputViewDelegate

#pragma getter setter

- (UILabel*)titleLabel
{
  if(_titleLabel  ==  nil)
  {
    _titleLabel = [[UILabel  alloc]init];
    [_titleLabel setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:17]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
  }
  return _titleLabel;
}

- (UIButton*)maskButton
{
  if(_maskButton  ==  nil)
  {
    _maskButton = [[UIButton alloc]init];
    [_maskButton setFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [_maskButton setBackgroundColor:[UIColor clearColor]];
    [_maskButton addTarget:self action:@selector(maskButtonToDismissAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _maskButton;
}

- (UIBarButtonItem*)closeButton
{
  if(_closeButton ==  nil)
  {
    _closeButton  = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(backToLastView:)];
    [_closeButton  setTintColor:[UIColor colorWithRed:45/255.0 green:216/255.0 blue:136/255.0 alpha:1.0]];
    NSDictionary  *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"STHeitiSC-Light" size:17]};
    [_closeButton  setTitlePositionAdjustment:UIOffsetMake(-10, 0) forBarMetrics:UIBarMetricsDefault];
    [_closeButton  setTitleTextAttributes:attributes forState:UIControlStateNormal];
  }
  return  _closeButton;
}

- (UITableView*)commentTableView
{
  if(_commentTableView  ==  nil)
  {
    _commentTableView = [[UITableView  alloc]init];
    [_commentTableView setBackgroundColor:kColorBackGround];
    _commentTableView.delegate    = self;
    _commentTableView.dataSource  = self;
    _commentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];//解决UITableViewStyleGrouped类型,会填满整个UITableView的多cell问题
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_commentTableView setSeparatorInset:UIEdgeInsetsZero];
    [_commentTableView setSeparatorColor:[UIColor  colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]];
  }
  return _commentTableView;
}

- (UILabel*)noCommentLabel
{
  if(_noCommentLabel  ==  nil)
  {
    _noCommentLabel = [[UILabel  alloc]init];
    [_noCommentLabel  setText:self.noCommentString];
    [_noCommentLabel  setTextColor:[UIColor lightGrayColor]];
    [_noCommentLabel  setFont:[UIFont systemFontOfSize:kCommentViewControllerMiddleFontSize]];
  }
  return _noCommentLabel;
}

- (UIMessageInputViewController*)myMsgInputView
{
  if(_myMsgInputView  ==  nil)
  {
    _myMsgInputView = [UIMessageInputViewController messageInputViewWithType:UIMessageInputViewContentTypeComment placeHolder:@"添加回复"];
    _myMsgInputView.delegate = self;
    [_myMsgInputView setHeight:kMessageInputView_Height];
  }
  return _myMsgInputView;
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

- (UIActivityIndicatorView*)activityIndicatorView
{
  if(_activityIndicatorView ==  nil)
  {
    _activityIndicatorView  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_activityIndicatorView setCenter:self.view.center];
  }
  return _activityIndicatorView;
}

@end
