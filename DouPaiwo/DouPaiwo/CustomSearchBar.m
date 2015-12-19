//
//  CustomSearchBar.m
//  DouPaiwo
//
//  Created by J006 on 15/8/26.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "CustomSearchBar.h"
#import <Masonry.h>
#import "CustomKeyWordButton.h"

@interface CustomSearchBar ()

@property (strong,  nonatomic)  NSString              *keyWords;
@property (strong,  nonatomic)  UIImageView           *backGroundBar;//背景图
@property (strong,  nonatomic)  UIScrollView          *contentScrollView;
@property (strong,  nonatomic)  UIButton              *cancelButton;//取消按钮
@property (strong,  nonatomic)  NSMutableArray        *keyWordsArray;
@property (strong,  nonatomic)  NSMutableArray        *keyWordsButtonArray;
@end

@implementation CustomSearchBar

#pragma life cycle
- (void)viewDidLoad
{
  [super      viewDidLoad];
  [self.view  setFrame:CGRectMake(0, 0, kScreen_Width, 44)];
  [self.view  setBackgroundColor:[UIColor clearColor]];
  [self.view  addSubview:self.backGroundBar];
  [self.view  addSubview:self.cancelButton];
  [self.view  addSubview:self.contentScrollView];

  self.keyWordsButtonArray  = [[NSMutableArray alloc]init];
  for (NSInteger i=0;i<[self.keyWordsArray count];i++)
  {
    CustomKeyWordButton  *button = [self customBtnForKeyWord:[self.keyWordsArray objectAtIndex:i] keyWordIndex:i];
    [self.contentScrollView  addSubview:button];
    [self.keyWordsButtonArray  addObject:button];
  }
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];
  
  [self.backGroundBar mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.height.mas_equalTo(29);
    make.right.equalTo(self.cancelButton.mas_left).offset(-10);
    make.left.equalTo(self.view);
  }];
  
  [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.height.equalTo(self.backGroundBar);
    make.left.equalTo(self.backGroundBar);
    make.right.equalTo(self.backGroundBar);
  }];
  
  [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.view);
    make.right.equalTo(self.view);
  }];
  
  CustomKeyWordButton  *tempButton;
  CGFloat   scrollViewWidth = 0;
  for (NSInteger i=0;i<[self.keyWordsButtonArray count];i++)
  {
    CustomKeyWordButton  *button = [self.keyWordsButtonArray objectAtIndex:i];
    if(!tempButton)
    {
      [button  setOrigin:CGPointMake(3, 2)];
    }
    else
    {
      [button  setOrigin:CGPointMake(tempButton.frame.origin.x+tempButton.frame.size.width+3, 2)];
    }
    tempButton  = button;
    scrollViewWidth = button.frame.origin.x+button.frame.size.width+2;
  }
  [self.contentScrollView  setContentSize:CGSizeMake(scrollViewWidth, self.contentScrollView.frame.size.height)];
}

#pragma init
- (void)initCustomSearchBarWithKeyWords :(NSString*)keyWords
{
  NSArray *tagArray = [keyWords componentsSeparatedByString:@" "];//根据空格分割字符串
  NSMutableArray  *searchTags     = [tagArray mutableCopy];
  self.keyWordsArray  = [[NSMutableArray alloc]init];
  NSString        *searchStringTemp=@"";
  for (NSString *string in searchTags)
  {
    if([string isEqualToString:@""])
      continue;
    searchStringTemp  = [searchStringTemp   stringByAppendingString:string];
    searchStringTemp  = [searchStringTemp   stringByAppendingString:@" "];
    [self.keyWordsArray  addObject:string];
  }
  self.keyWords = searchStringTemp;
}

#pragma private methods
- (CustomKeyWordButton*)customBtnForKeyWord :(NSString*)singleKeyWord keyWordIndex:(NSInteger)keyWordIndex
{
  NSString    *btnString  = singleKeyWord;
  CustomKeyWordButton *btn  = [[CustomKeyWordButton  alloc]init];
  [btn  initCustomKeyWordButtonWithBtnString:btnString];
  [btn  addEditTapBlock:^(id obj) {
    [self editTheKeyWords];
  }];
  [btn  addCancelTapBlock:^(id obj) {
    for (NSInteger i=0; i<[self.keyWordsArray count]; i++)
    {
      if([[self.keyWordsArray objectAtIndex:i] isEqualToString:btnString])
      {
        [self.keyWordsArray  removeObjectAtIndex:i];
        [self.keyWordsButtonArray removeObjectAtIndex:i];
        break;
      }
      else
        continue;
    }
    NSString  *newKeyWord = [self refineTheStringWithWhiteSpace:self.keyWordsArray];
    self.keyWords = newKeyWord;
    if (_delegate && [_delegate respondsToSelector:@selector(removeTheKeyWordWithCustomSearchBar:theRemainKeyWords:theReaminKeyWordsArray:)])
    {
      [self.delegate removeTheKeyWordWithCustomSearchBar:self theRemainKeyWords:self.keyWords theReaminKeyWordsArray:self.keyWordsArray];
    }
  }];
  return btn;
}

- (void)editTheKeyWords
{
  if (_delegate && [_delegate respondsToSelector:@selector(editTheKeyWordWithCustomSearchBar:theRemainKeyWords:theReaminKeyWordsArray:)])
  {
    [self.delegate editTheKeyWordWithCustomSearchBar:self theRemainKeyWords:self.keyWords theReaminKeyWordsArray:self.keyWordsArray];
  }
}

- (NSString*)refineTheStringWithWhiteSpace  :(NSMutableArray*)keyWordsArray
{
  if(!keyWordsArray || [keyWordsArray count]==0)
    return nil;
  NSString        *searchStringTemp=@"";
  for (NSInteger i=0; i<[keyWordsArray count]; i++)
  {
    NSString  *keyWordTemp  = [keyWordsArray objectAtIndex:i];
    if([keyWordTemp isEqualToString:@""])
      continue;
    searchStringTemp  = [searchStringTemp   stringByAppendingString:keyWordTemp];
  }
  return searchStringTemp;
}


//取消按钮
- (void)backToMainTheSearchBar
{
  if (_delegate && [_delegate respondsToSelector:@selector(cancelAndBackToMainViewWithCustomSearchBar:)])
  {
    [self.delegate cancelAndBackToMainViewWithCustomSearchBar:self];
  }
}

#pragma getter setter

- (UIScrollView*)contentScrollView
{
  if(_contentScrollView ==  nil)
  {
    _contentScrollView  = [[UIScrollView alloc]init];
    [_contentScrollView   setBackgroundColor:[UIColor clearColor]];
    [_contentScrollView   setShowsHorizontalScrollIndicator:NO];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTheKeyWords)];
    [_contentScrollView addGestureRecognizer:tap];
  }
  return _contentScrollView;
}

- (UIButton*)cancelButton
{
  if(_cancelButton  ==  nil)
  {
    _cancelButton = [[UIButton alloc]init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:SourceHanSansNormal15];
    [_cancelButton setTitleColor:[UIColor colorWithRed:138/255.0 green:136/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_cancelButton sizeToFit];
    [_cancelButton addTarget:self action:@selector(backToMainTheSearchBar) forControlEvents:UIControlEventTouchUpInside];
  }
  return _cancelButton;
}

- (UIImageView*)backGroundBar
{
  if(_backGroundBar ==  nil)
  {
    _backGroundBar  = [[UIImageView  alloc]init];
    [_backGroundBar  setImage:[UIImage imageNamed:@"keywordsBar"]];
  }
  return  _backGroundBar;
}

@end
