//
//  SettingAccountView.m
//  TestPaiwo
//
//  Created by J006 on 15/6/2.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "SettingAccountView.h"
#import "SettingAccountCell.h"
#import "SignAndCoverCell.h"
#import <ActionSheetStringPicker.h>
#import "Helper.h"
#import "SettingTextViewController.h"
#import "DouAPIManager.h"
#import <MBProgressHUD.h>
#import <AFNetworking.h>
#import <ALBB_OSS_IOS_SDK/OSSService.h>
#import "AddressSettingViewController.h"
#import "AddressManager.h"

#define kPaddingLeftWidth 15.0
@interface SettingAccountView ()

@property UserInstance  *myUser;
@property (nonatomic,readwrite) BOOL                    isAvatar;//avatar换图片
@property (strong,  nonatomic)  UIView                  *headerView;//table顶部view
@property (nonatomic,strong)    UITableView             *myTableView;
@property (strong, nonatomic)   MBProgressHUD           *mbProgHUD;
@property (strong, nonatomic)   AddressSettingViewController  *addressSetting;

@end

@implementation SettingAccountView

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view  addSubview:self.myTableView];
}

- (void)viewDidLayoutSubviews
{
  [super            viewDidLayoutSubviews];
  [self.myTableView setFrame:self.view.bounds];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
}

-(void) viewWillDisappear:(BOOL)animated
{
  if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
  {

  }
  [super viewWillDisappear:animated];
}

#pragma init
- (void)initSettingAccountView  :(UserInstance*)myUser
{

  _myUser = myUser;
  self.title  = @"个人资料";
}

#pragma private methods
- (void)updateTheUserProfile
{
  [self.view addSubview:self.mbProgHUD];
  [self.mbProgHUD showAnimated:YES whileExecutingBlock:^{
    [[DouAPIManager  sharedManager]request_ModifyUserInfoWithUser:self.myUser :^(UserInstance *userInstance, ErrorInstnace *error)
    {
      if(!userInstance)
        return;
    }];
  } completionBlock:^{
    [self.mbProgHUD removeFromSuperview];
    self.mbProgHUD = nil;
  }];
}

- (void)updateUIImageWithImage  :(UIImage*)image
{
  [self.view addSubview:self.mbProgHUD];
  [self.mbProgHUD showAnimated:YES whileExecutingBlock:^{
    [[DouAPIManager  sharedManager]request_GetUpload:^(FileUploadInstance *fileUploadInstance, ErrorInstnace *error) {
      if(!fileUploadInstance)
        return;
      NSMutableDictionary  *postDic  = [NSMutableDictionary dictionary];
      NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
      [postDic  setValue:fileUploadInstance.policy forKey:@"policy"];
      [postDic  setValue:fileUploadInstance.signature forKey:@"Signature"];
      [postDic  setValue:fileUploadInstance.key_id forKey:@"OSSAccessKeyId"];
      [postDic  setValue:fileUploadInstance.object_key forKey:@"key"];
      [postDic  setValue:[NSNumber  numberWithInteger:201] forKey:@"success_action_status"];
      //[postDic  setValue:imageData forKey:@"file"];
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      
      [manager POST:kdefaultUploadPostURL parameters:postDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
      {
        [formData  appendPartWithFormData:imageData name:@"file"];
      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
          NSLog(@"JSON: %@", responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
      }];
      
      /*
      [manager POST:kdefaultUploadPostURL parameters:postDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
      }];
      */
    }];
  } completionBlock:^{
    [self.mbProgHUD removeFromSuperview];
    self.mbProgHUD = nil;
  }];
}


#pragma tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSInteger row = 0;
  switch (section)
  {
    case 0:
      row = 5;
      break;
    case 1:
      row = 2;
      break;
  }
  return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(!self.myUser)
    return  nil;

  if(indexPath.section==0)
  {
    SettingAccountCell *cell = [[SettingAccountCell  alloc]init];
    switch (indexPath.row)
    {
      case 0:
      {
        NSURL *url  = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.myUser.host_avatar]];
        [cell setTitleStr:@"头像"];
        [cell setHeight:80];
        [cell setImageURL:url];
        [cell  setAccessoryType:UITableViewCellAccessoryNone];
      }
        break;
      case 1:
      {
        [cell setTitleStr:@"昵称"];
        [cell setTextValue:self.myUser.host_name];
        [cell setHeight:45];
        [cell  setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
      case 2:
      {
        [cell setTitleStr:@"性别"];
        if(self.myUser.host_gender==1)
          [cell setTextValue:@"男"];
        else  if(self.myUser.host_gender==2)
          [cell setTextValue:@"女"];
        else
          [cell setTextValue:@"保密"];
        [cell setHeight:45];
        [cell  setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
      case 3:
      {
        [cell setTitleStr:@"居住地"];
        NSString  *cityName     = [AddressManager getCityNameWithCityCode:self.myUser.address];
        NSString  *provinceName = [AddressManager getProvinceNameWithCityCode:self.myUser.address];
        [cell setTextValue:[[provinceName  stringByAppendingString:@" "]stringByAppendingString:cityName]];
        [cell setHeight:45];
        [cell  setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
      case 4:
      {
        [cell setTitleStr:@"个性域名"];
        [cell setTextValue:[defaultSelfUserUrlPrefix stringByAppendingString:self.myUser.host_domain]];
        [cell setHeight:45];
        [cell  setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
    }
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
  }
  else  if(indexPath.section==1)
  {
    SignAndCoverCell  *cell = [[SignAndCoverCell alloc] init];
    switch (indexPath.row)
    {
      case 0:
      {
        [cell setTitleStr:@"签名"];
        [cell setTextValue:self.myUser.host_desc];
        [cell setHeight:45];
        [cell  setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
      }
        break;
      case 1:
      {
        [cell setTitleStr:@"封面图片"];
        NSURL *url  = [[NSURL  alloc]initWithString:[defaultImageHeadUrl stringByAppendingString:self.myUser.banner_photo]];
        [cell setImageURL:url];
        [cell setHeight:80];
         [cell  setAccessoryType:UITableViewCellAccessoryNone];
      }
        break;
    }
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
  }
  return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if(indexPath.section==0)
  {
    if(indexPath.row==0)
    {
      //暂时取消
      /*
      _isAvatar  = YES;
      UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
      [actionSheet showInView:self.view];
       */
    }
    else  if(indexPath.row==1)
    {
      SettingTextViewController *vc  =  [[SettingTextViewController  alloc]init];
      [vc initTheSettingTextViewControllerWithTitle:@"昵称" textValue:self.myUser.host_name :SettingTypeNickName doneBlock:^(NSString *textValue) {
        self.myUser.host_name= textValue;
        [self updateTheUserProfile];
        [self.myTableView reloadData];
      }];
      [vc  setTextStringMaxLimit:22];
      [vc  setTextStringMinLimit:4];
      [SettingAccountView  naviPushViewController:vc];
    }
    else  if(indexPath.row==2)
    {
      NSArray *sexArray = [NSArray arrayWithObjects:@"男", @"女", @"保密",  nil];
      NSInteger sexInit = _myUser.host_gender-1;
      [ActionSheetStringPicker showPickerWithTitle:@"请选择性别" rows:sexArray initialSelection:sexInit doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        _myUser.host_gender = selectedIndex+1;
        [self updateTheUserProfile];
        [self.myTableView  reloadData];
      }cancelBlock:^(ActionSheetStringPicker *picker) {
      }origin:self.view];
    }
    else  if(indexPath.row==3)
    {
      //居住地
      __weak typeof(self) weakSelf = self;
      self.addressSetting = [[AddressSettingViewController alloc]init];
      [self.addressSetting initAddressSettingVCWithCurrentCityCode:self.myUser.address user:self.myUser];
      [self.addressSetting  addBackBlock:^(id obj) {
        [weakSelf updateTheUserProfile];
        [weakSelf.myTableView reloadData];
      }];
      [SettingAccountView  naviPushViewController:self.addressSetting];
    }
    else  if(indexPath.row==4)
    {
      SettingTextViewController *vc  =  [[SettingTextViewController  alloc]init];
      [vc initTheSettingTextViewControllerWithTitle:@"个性域名" textValue:self.myUser.host_domain :SettingTypeHostDomain doneBlock:^(NSString *textValue) {
        self.myUser.host_domain= textValue;
        [self updateTheUserProfile];
        [self.myTableView reloadData];
      }];
      [vc  setTextStringMaxLimit:33];
      [vc  setTextStringMinLimit:5];
      [SettingAccountView  naviPushViewController:vc];
    }
  }
  else  if(indexPath.section==1)
  {
    if(indexPath.row==0)
    {
      SettingTextViewController *vc  =  [[SettingTextViewController  alloc]init];
      [vc initTheSettingTextViewControllerWithTitle:@"签名" textValue:self.myUser.host_desc :SettingTypeHostDesc doneBlock:^(NSString *textValue) {
        self.myUser.host_desc= textValue;
        [self updateTheUserProfile];
        [self.myTableView reloadData];
      }];
      [vc  setTextStringMaxLimit:100];
      [vc  setTextStringMinLimit:0];
      [SettingAccountView  naviPushViewController:vc];
    }
    else  if(indexPath.row==1)
    {
      //暂时取消
      /*
      _isAvatar  = NO;
      UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更换封面图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
      [actionSheet showInView:self.view];
       */
    }
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  CGFloat height  = 20;
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, height)];
  headerView.backgroundColor  = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
  return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  CGFloat height  = 20;
  if(section==0)
    height  = 0;
  return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  float height=45;
  if (indexPath.section==0)
  {
    if(indexPath.row==0)
      height  = 80;
  }
  else  if(indexPath.section==1)
  {
    if(indexPath.row==1)
      height  = 80;
  }
  return  height;
}

#pragma UIActoinSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
  if (buttonIndex == 2) {
    return;
  }
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.allowsEditing = YES;//设置可编辑
  
  if (buttonIndex == 0) {
    //        拍照
    if (![Helper checkCameraAuthorizationStatus]) {
      return;
    }
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  }else if (buttonIndex == 1){
    //        相册
    if (![Helper checkPhotoLibraryAuthorizationStatus]) {
      return;
    }
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  }
  [self presentViewController:picker animated:YES completion:nil];//进入照相界面
  
}

#pragma UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker  dismissViewControllerAnimated:YES completion:^{
    UIImage *editedImage;
    //UIImage *originalImage;
    editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 保存原图片到相册中
    /*
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
      originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
      UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }
     */
    [self updateUIImageWithImage :editedImage];
    
    if(_isAvatar)
      _myUser.profileAvatar = editedImage;
    else
      _myUser.coverImage = editedImage;
    [_myTableView reloadData];
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma getter setter
- (UITableView*)myTableView
{
  if(_myTableView ==  nil)
  {
    _myTableView                  = [[UITableView  alloc]init];
    _myTableView.backgroundColor  = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _myTableView.dataSource       = self;
    _myTableView.delegate         = self;
    [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    [_myTableView setSeparatorColor:[UIColor  colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0]];
 
    _myTableView.tableHeaderView  = self.headerView;
  }
  return _myTableView;
}

- (UIView*)headerView
{
  if(_headerView  ==  nil)
  {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 15)];
    [_headerView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
  }
  return _headerView;
}

- (MBProgressHUD*)mbProgHUD
{
  if(_mbProgHUD ==  nil)
  {
    _mbProgHUD = [[MBProgressHUD alloc] initWithView:self.view];
    _mbProgHUD.mode = MBProgressHUDModeIndeterminate;
  }
  return _mbProgHUD;
}

@end
