//
//  AddressManager.m
//  DouPaiwo
//
//  Created by J006 on 15/9/15.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import "AddressManager.h"
#import "NSString+Common.h"
@interface AddressManager ()

@property (strong, nonatomic) NSArray *addressArray;
@property (strong, nonatomic) NSMutableArray *provinceCodeArray;
@property (strong, nonatomic) NSMutableArray *provinceNameArray;
@property (strong, nonatomic) NSMutableDictionary *cityDictonary;

@end

@implementation AddressManager
+ (AddressManager *)sharedManager
{
  static AddressManager *shared_manager = nil;
  static dispatch_once_t pred;
  dispatch_once(&pred, ^{
    shared_manager = [[self alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"allArea" ofType:@"json"];
    NSError *error = nil;
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *jsonDictionary = [[NSDictionary alloc] init];
    jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingAllowFragments
                                                           error:&error];
    if (error)
      DebugLog(@"address.json - fail: %@", error.description);
    if (jsonDictionary)
    {
      NSDictionary *provinceDictionary = [[NSDictionary alloc] init];
      provinceDictionary            = [jsonDictionary objectForKey:@"province"];
      NSDictionary *cityDictionary  = [[NSDictionary alloc] init];
      cityDictionary                = [provinceDictionary objectForKey:@"02-00-00"];
      shared_manager.provinceCodeArray             = [[NSMutableArray alloc]init];
      shared_manager.provinceNameArray             = [[NSMutableArray alloc]init];
      for (NSString *key in cityDictionary)
      {
        [shared_manager.provinceCodeArray addObject:key];
        [shared_manager.provinceNameArray addObject:[cityDictionary objectForKey:key]];
      }
      shared_manager.cityDictonary = [[NSMutableDictionary alloc] init];
      shared_manager.cityDictonary = [jsonDictionary objectForKey:@"city"];
    }
  });
  return shared_manager;
}

#pragma private methods
+ (NSMutableArray *)provinceCodeArray
{
  return [self sharedManager].provinceCodeArray;
}

+ (NSMutableArray *)provinceNameArray
{
  return [self sharedManager].provinceNameArray;
}

+ (NSMutableDictionary *)cityDictonary
{
  return [self sharedManager].cityDictonary;
}

+ (NSString *)getProvinceNameWithProvinceCode:(NSString *)code
{
  NSInteger index = 0;
  NSInteger count = [[self sharedManager].provinceCodeArray count];
  for (NSInteger i =0 ; i<count; i++)
  {
    if([[[self sharedManager].provinceCodeArray objectAtIndex:i] isEqualToString:code])
    {
      index = i;
      break;
    }
  }
  NSString  *name = [[self sharedManager].provinceNameArray objectAtIndex:index];
  return name;
}

+ (NSString *)getCityNameWithCityCode:(NSString *)code
{
  NSDictionary  *dic  = [self sharedManager].cityDictonary;
  for (NSString *key in dic)
  {
    NSDictionary      *tempCityDic    = [dic objectForKey:key];
    for (NSString *keyCode in tempCityDic)
    {
      if([keyCode isEqualToString:code])
      {
        return [tempCityDic objectForKey:keyCode];
      }
    }
  }
  return @"";
}

+ (NSString *)getProvinceNameWithCityCode:(NSString *)code
{
  NSDictionary  *dic  = [self sharedManager].cityDictonary;
  NSString      *provinceCode;
  for (NSString *key in dic)
  {
    NSDictionary      *tempCityDic    = [dic objectForKey:key];
    for (NSString *keyCode in tempCityDic)
    {
      if([keyCode isEqualToString:code])
      {
        provinceCode  = key;
        break;
      }
      else
        continue;
    }
  }
  if(provinceCode)
  {
    return [self  getProvinceNameWithProvinceCode:provinceCode];
  }
  else
  {
    NSString  *tempProvinceName   = [self  getProvinceNameWithProvinceCode:code];
    if(tempProvinceName && ![tempProvinceName isEmpty])
      return  tempProvinceName;
  }
  return @"";
}

+ (NSDictionary*)  getCitysInProvinceWithCode :(NSString*)provinceCode;
{
  NSDictionary *citysDic = [[NSDictionary  alloc]init];
  NSDictionary  *allCitysDic  = [self sharedManager].cityDictonary;
  for (NSString *key in allCitysDic)
  {
    if([key isEqualToString:provinceCode])
    {
      citysDic  = [allCitysDic  objectForKey:key];
      return citysDic;
    }
  }
  return  nil;
}
@end
