//
//  UserListViewForPMViewController.m
//  TestPaiwo
//
//  Created by J006 on 15/5/13.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "UserListViewForPMViewController.h"
#import "UserCellTableViewCell.h"
#import <RDVTabBarController.h>
#define kCellIdentifier_UserCell @"UserCellXib"

@interface UserListViewForPMViewController ()<UINavigationControllerDelegate>

@property (nonatomic,strong)  NSMutableArray                    *userArray;//可发起聊天的对象集合
@property (strong, nonatomic) UISearchController                *mySearchController;
@property (strong, nonatomic) UITableView                       *myTableView;//可发起聊天的用户tableview
@property (strong, nonatomic) NSMutableArray                    *searchResults;//搜索结果
@property (strong, nonatomic) NSDictionary                      *groupedDict;
@property (strong, nonatomic) NSArray                           *userAndPinyingArray;
@property (readwrite, nonatomic) BOOL                           isSearch;
@property (strong, nonatomic) UserInstance                      *curUser;//当前user
@end

@implementation UserListViewForPMViewController

- (void)initUserListView  :(NSMutableArray*)userArray
{
  self.title  =   @"发起聊天";
  self.view.backgroundColor = kColorBackGround;
  _userArray  =   userArray;
  [self initTableView];
  [self initSearchBarController];
  [self initPinying];
  _myTableView.frame  = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
  [self.view  addSubview:_myTableView];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if ([_userAndPinyingArray count]> section && section > 0)
    {
      return [_userAndPinyingArray objectAtIndex:section];
    }else
    {
      return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  NSInteger section = 1;
  if (self.groupedDict && !_searchResults)
  {
      section = [_userAndPinyingArray count];
  }
  else  if(_searchResults)
  {
      section = 1;
  }
  return section;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_userArray removeObjectAtIndex:indexPath.row];
    // Delete the row from the data source.
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  return @"删除";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   NSInteger row=0;
  if (_userAndPinyingArray && [_userAndPinyingArray  count] > section && !_searchResults)
  {
    NSArray *dataList = [self.groupedDict objectForKey:[_userAndPinyingArray objectAtIndex:section]];
    row = [dataList count];
  }
  else  if(_searchResults)
  {
    row = [_searchResults count];
  }
  return row;
  //return [_userArray  count];
}

//设置单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return defaultCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UserCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserCell];

  NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"UserCellXib" owner:self options:nil];
  cell= (UserCellTableViewCell *)[nib objectAtIndex:0];
  __weak typeof(self) weakSelf = self;
  if (!_searchResults)
  {

    NSArray *dataList = [self.groupedDict objectForKey:[_userAndPinyingArray objectAtIndex:indexPath.section]];
    weakSelf.curUser = [dataList objectAtIndex:indexPath.row];
  }
  else
  {
    weakSelf.curUser = [_searchResults objectAtIndex:indexPath.row];
  }
  if(weakSelf.curUser.host_name!=nil)
  {
    cell.curUser  = weakSelf.curUser;
    [cell initUserCell];
  }
  return cell;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  @author J006, 15-05-15 11:05:00
 *
 *  初始化搜索人员列表tableview
 */
- (void)  initTableView
{
  _myTableView = ({
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    tableView.sectionIndexColor = [UIColor whiteColor];
    tableView.delegate  = self;
    tableView.dataSource  = self;
    tableView;
  });
}

/**
 *  @author J006, 15-05-15 11:05:14
 *
 *  初始化搜索栏
 */
- (void)  initSearchBarController
{
  _mySearchController = ({
    UISearchController *searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchVC.dimsBackgroundDuringPresentation = NO;
    [searchVC.searchBar  sizeToFit];
    [searchVC.searchBar setPlaceholder:@"姓名/个性后缀"];
    self.myTableView.tableHeaderView  = searchVC.searchBar;
    searchVC.searchBar.translucent = YES;
    searchVC.searchBar.showsScopeBar = YES;
    [searchVC.searchBar resignFirstResponder];
    searchVC.searchResultsUpdater  = self;
    searchVC;
  });
}

- (void)initPinying
{
  _groupedDict = [self dictGroupedByPinyin: _userArray];
  [self groupedKeyList];
}

#pragma mark Table M
- (void)  groupedKeyList
{
  if (self.groupedDict.count <= 0)
    return ;
  NSMutableArray *keyList = [NSMutableArray arrayWithArray:self.groupedDict.allKeys];
  [keyList sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
    return [obj1 compare:obj2];
  }];
  if ([keyList containsObject:@"#"])
  {
    [keyList removeObject:@"#"];
    [keyList addObject:@"#"];
  }
  [keyList insertObject:UITableViewIndexSearch atIndex:0];
  _userAndPinyingArray = keyList;
}

/**
 *  @author J006, 15-05-15 20:05:55
 *
 *  更新搜索信息的代理方法
 *
 *  @param searchController
 */
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
  NSString  *searchString = searchController.searchBar.text;
  searchString  = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if([searchString isEqualToString:@""])
    self.searchResults  = nil;
  else
    [self updateFilteredContentForSearchString:searchString];
  [_myTableView reloadData];
}

- (void)updateFilteredContentForSearchString:(NSString *)searchString
{
  // start out with the entire list
  self.searchResults = [_userArray mutableCopy];
  
  // break up the search terms (separated by spaces)
  NSArray *searchItems = nil;
  if (searchString.length > 0)
    searchItems = [searchString componentsSeparatedByString:@" "];
  
  // build all the "AND" expressions for each value in the searchString
  NSMutableArray *andMatchPredicates = [NSMutableArray array];
  
  for (NSString *searchString in searchItems)
  {
    // each searchString creates an OR predicate for: name, global_key
    NSMutableArray *searchItemsPredicate = [NSMutableArray array];
    
    // name field matching
    NSExpression *lhs = [NSExpression expressionForKeyPath:@"host_name"];
    NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
    NSPredicate *finalPredicate = [NSComparisonPredicate
                                   predicateWithLeftExpression:lhs
                                   rightExpression:rhs
                                   modifier:NSDirectPredicateModifier
                                   type:NSContainsPredicateOperatorType
                                   options:NSCaseInsensitivePredicateOption];
    [searchItemsPredicate addObject:finalPredicate];
    //        pinyinName field matching
    lhs = [NSExpression expressionForKeyPath:@"pinyinName"];
    rhs = [NSExpression expressionForConstantValue:searchString];
    finalPredicate = [NSComparisonPredicate
                      predicateWithLeftExpression:lhs
                      rightExpression:rhs
                      modifier:NSDirectPredicateModifier
                      type:NSContainsPredicateOperatorType
                      options:NSCaseInsensitivePredicateOption];
    [searchItemsPredicate addObject:finalPredicate];
    //        global_key field matching
    lhs = [NSExpression expressionForKeyPath:@"global_key"];
    rhs = [NSExpression expressionForConstantValue:searchString];
    finalPredicate = [NSComparisonPredicate
                      predicateWithLeftExpression:lhs
                      rightExpression:rhs
                      modifier:NSDirectPredicateModifier
                      type:NSContainsPredicateOperatorType
                      options:NSCaseInsensitivePredicateOption];
    [searchItemsPredicate addObject:finalPredicate];
    // at this OR predicate to ourr master AND predicate
    NSCompoundPredicate *orMatchPredicates = (NSCompoundPredicate *)[NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
    [andMatchPredicates addObject:orMatchPredicates];
  }
  
  NSCompoundPredicate *finalCompoundPredicate = (NSCompoundPredicate *)[NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
  
  self.searchResults = [[self.searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
}


/**
 *  @author J006, 15-05-15 19:05:10
 *
 *  将名字拼音根据26字母分类
 *
 *  @param list
 *
 *  @return
 */
- (NSDictionary *)dictGroupedByPinyin :(NSMutableArray*)list{
  if (list.count <= 0) {
    return @{@"#" : [NSMutableArray array]};
  }
  
  NSMutableDictionary *groupedDict = [[NSMutableDictionary alloc] init];
  
  NSMutableArray *allKeys = [[NSMutableArray alloc] init];
  for (char c = 'A'; c < 'Z'+1; c++) {
    char key[2];
    key[0] = c;
    key[1] = '\0';
    [allKeys addObject:[NSString stringWithUTF8String:key]];
  }
  [allKeys addObject:@"#"];
  
  for (NSString *keyStr in allKeys) {
    [groupedDict setObject:[[NSMutableArray alloc] init] forKey:keyStr];
  }
  
  [list enumerateObjectsUsingBlock:^(UserInstance *obj, NSUInteger idx, BOOL *stop) {
    NSString *keyStr = nil;
    NSMutableArray *dataList = nil;
    
    if (obj.pinyinName.length > 1) {
      keyStr = [obj.pinyinName substringToIndex:1];
      if ([[groupedDict allKeys] containsObject:keyStr]) {
        dataList = [groupedDict objectForKey:keyStr];
      }
    }
    
    if (!dataList) {
      keyStr = @"#";
      dataList = [groupedDict objectForKey:keyStr];
    }
    
    [dataList addObject:obj];
    [groupedDict setObject:dataList forKey:keyStr];
  }];
  
  for (NSString *keyStr in allKeys) {
    NSMutableArray *dataList = [groupedDict objectForKey:keyStr];
    if (dataList.count <= 0) {
      [groupedDict removeObjectForKey:keyStr];
    }else if (dataList.count > 1){
      [dataList sortUsingComparator:^NSComparisonResult(UserInstance *obj1, UserInstance *obj2) {
        return [obj1.pinyinName compare:obj2.pinyinName];
      }];
    }
  }
  
  return groupedDict;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _userAndPinyingArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
    // back button was pressed.  We know this is true because self is no longer
    // in the navigation stack.
    [[UserListViewForPMViewController  presentingVC].rdv_tabBarController setTabBarHidden:NO animated:YES];
  }
  [super viewWillDisappear:animated];
}

- (void)dealloc
{
  _myTableView.delegate = nil;
  _myTableView.dataSource = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
