//
//  InformationMainViewViewController.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "InformationMainViewViewController.h"
#import "PMInformationCell.h"
#import "UserListViewForPMViewController.h"
#import <RDVTabBarController.h>
@interface InformationMainViewViewController ()
@property (strong, nonatomic) UIBarButtonItem        *addButton;//添加按钮
@property (strong, nonatomic) UIView                 *dynamicView;//动态主view
@property (strong, nonatomic) UILabel                *dynamicLabel;//动态label
@property (strong, nonatomic) UILabel                *dynamicNumsLabel;//动态数量
@property (strong, nonatomic) UITableView            *inforTableView;//信息tableview
@property (nonatomic,strong)  NSMutableArray         *cellArray;
@end

@implementation InformationMainViewViewController

- (void)initInformationMainView :(NSMutableArray*)inforArray
{
  self.title  = @"消息";
  _addButton  = [[UIBarButtonItem  alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToUserListView:)];
  self.navigationItem.rightBarButtonItem=_addButton;
  //动态主view
  self.dynamicView  = [[UIView alloc]initWithFrame:CGRectMake(0, pageToolBarHeight, kScreen_Width, 60)];
  //动态label
  self.dynamicLabel = [[UILabel  alloc]initWithFrame:CGRectMake(60, 18, 34, 21)];
  self.dynamicLabel.text  = @"动态";
  self.dynamicLabel.font = [UIFont  fontWithName:@"HelveticaNeue-Light" size:17.0];
  self.dynamicLabel.textColor = [UIColor  blackColor];
  //动态数量
  self.dynamicNumsLabel = [[UILabel  alloc]initWithFrame:CGRectMake(220, 18, 40, 21)];
  self.dynamicNumsLabel.text  = @"100+";
  self.dynamicNumsLabel.font = [UIFont  fontWithName:@"HelveticaNeue-Light" size:17.0];
  self.dynamicNumsLabel.textColor = [UIColor  blackColor];
  self.dynamicNumsLabel.backgroundColor = [UIColor  redColor];
  [self.dynamicView   addSubview:self.dynamicLabel];
  [self.dynamicView  addSubview:self.dynamicNumsLabel];
  //信息tableview
  self.cellArray  = inforArray;
  self.inforTableView = [[UITableView  alloc]initWithFrame:CGRectMake(0, pageToolBarHeight+self.dynamicView.frame.size.height, kScreen_Width, kScreen_Height-self.dynamicView.frame.size.height-pageToolBarHeight)];
  _inforTableView.delegate  = self;
  _inforTableView.dataSource  = self;
  
  [self.view  addSubview:self.dynamicView];
  [self.view  addSubview:self.inforTableView];
}

- (void)jumpToUserListView  :(id)sender
{
  NSMutableArray  *userArray  = [[NSMutableArray alloc]init];
  UserListViewForPMViewController *userListView = [[UserListViewForPMViewController  alloc]init];
  for (int i =0; i<5; i++)
  {
    UserInstance  *user = [[UserInstance alloc]init];
    switch (i) {
      case 0:
        [user setHost_name:@"朱子杰"];
        break;
      case  1:
        [user setHost_name:@"徐润"];
        break;
      case 2:
        [user setHost_name:@"张榆炜"];
        break;
      case 3:
        [user setHost_name:@"张榆炜"];
        break;
      case 4:
        [user setHost_name:@"徐润"];
        break;
    }
    [userArray  addObject:user];
  }
  [userListView initUserListView:userArray];
  UIViewController  *tempVC  = [InformationMainViewViewController presentingVC];
  [tempVC.rdv_tabBarController setTabBarHidden:YES animated:YES];
  CATransition *animation = [CATransition animation];
  [animation setDuration:kpushViewTime];
  [animation setType:kCATransitionMoveIn];
  [animation setSubtype:kCATransitionFromRight];
  [self.view.window.layer addAnimation:animation forKey:kCATransition];
  [tempVC.navigationController  pushViewController:userListView animated:NO];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_cellArray removeObjectAtIndex:indexPath.row];
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
  return [_cellArray  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"InformationCell";
  
  PMInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PMInformationCellXib" owner:self options:nil];
    cell= (PMInformationCell *)[nib objectAtIndex:0];
  }
  
  // Configure the cell...
  //cell.textLabel.text = [_cellArray objectAtIndex:indexPath.row];
  return cell;
}

//设置单元格高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return defaultCellHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)backToLastView:(id)sender
{
  CATransition *animation = [CATransition animation];
  [animation setDuration:kpushViewTime];
  [animation setType:kCATransitionPush];
  [animation setSubtype:kCATransitionFromLeft];
  [self.view.window.layer addAnimation:animation forKey:kCATransition];
  [self dismissViewControllerAnimated:NO completion: nil];
  
  [[InformationMainViewViewController presentingVC].rdv_tabBarController setTabBarHidden:NO animated:YES];
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
