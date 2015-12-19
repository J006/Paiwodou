//
//  UserInstance.m
//  TestPaiwo
//
//  Created by J006 on 15/5/13.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "UserInstance.h"

@implementation UserInstance




//转换拼音
- (NSString *)transformToPinyin :(NSString*)string
{
  if ([string length] <= 0)
    return string;
  NSMutableString *tempString = [NSMutableString stringWithString:string];
  CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
  tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
  return [tempString uppercaseString];
}

- (void)setHost_name:(NSString *)host_name
{
  _host_name = host_name;
  if (_host_name) {
    _pinyinName = [self transformToPinyin :_host_name];
  }
}

- (NSString *)pinyinName{
  if (!_pinyinName) {
    return @"";
  }
  return _pinyinName;
}


@end
