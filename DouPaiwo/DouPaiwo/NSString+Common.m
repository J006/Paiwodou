//
//  NSString+Common.m
//  Coding_iOS
//
//  Created by 王 原闯 on 14-7-31.
//  Copyright (c) 2014年 Coding. All rights reserved.
//

#import "NSString+Common.h"
#import <CommonCrypto/CommonDigest.h>
#import "TTTAttributedLabel.h"
#import "sys/utsname.h"


@implementation NSString (Common)
+ (NSString *)userAgentStr{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleExecutableKey] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey], (__bridge id)CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), kCFBundleVersionKey) ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey], deviceString, [[UIDevice currentDevice] systemVersion], ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] ? [[UIScreen mainScreen] scale] : 1.0f)];
}

- (NSString *)URLEncoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)URLDecoding
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)md5Str
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

- (NSString*) sha1Str
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        resultSize = [self boundingRectWithSize:size
                                              options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                           attributes:@{NSFontAttributeName: font}
                                              context:nil].size;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
//        
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:2.0];
//        
//        [attributedStr addAttribute:NSParagraphStyleAttributeName
//                              value:paragraphStyle
//                              range:NSMakeRange(0, [self length])];
//        resultSize = [attributedStr boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

#endif
    }
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
//    if ([self containsEmoji]) {
//        resultSize.height += 10;
//    }
    return resultSize;
}

- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

-(BOOL)containsEmoji{
    if (!self || self.length <= 0) {
        return NO;
    }
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}
#pragma mark emotion_monkey
+ (NSDictionary *)emotion_monkey_dict {
    static NSDictionary *_emotion_monkey_dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emotion_monkey_dict = @{
                                 @"coding_emoji_01": @"哈哈",
                                 @"coding_emoji_02": @"吐",
                                 @"coding_emoji_03": @"压力山大",
                                 @"coding_emoji_04": @"忧伤",
                                 @"coding_emoji_05": @"坏人",
                                 @"coding_emoji_06": @"酷",
                                 @"coding_emoji_07": @"哼",
                                 @"coding_emoji_08": @"你咬我啊",
                                 @"coding_emoji_09": @"内急",
                                 @"coding_emoji_10": @"32个赞",
                                 @"coding_emoji_11": @"加油",
                                 @"coding_emoji_12": @"闭嘴",
                                 @"coding_emoji_13": @"wow",
                                 @"coding_emoji_14": @"泪流成河",
                                 @"coding_emoji_15": @"NO!",
                                 @"coding_emoji_16": @"疑问",
                                 @"coding_emoji_17": @"耶",
                                 @"coding_emoji_18": @"生日快乐",
                                 @"coding_emoji_19": @"求包养",
                                 @"coding_emoji_20": @"吹泡泡",
                                 @"coding_emoji_21": @"睡觉",
                                 @"coding_emoji_22": @"惊讶",
                                 @"coding_emoji_23": @"Hi",
                                 @"coding_emoji_24": @"打发点咯",
                                 @"coding_emoji_25": @"呵呵",
                                 @"coding_emoji_26": @"喷血",
                                 @"coding_emoji_27": @"Bug",
                                 @"coding_emoji_28": @"听音乐",
                                 @"coding_emoji_29": @"垒码",
                                 @"coding_emoji_30": @"我打你哦",
                                 @"coding_emoji_31": @"顶足球",
                                 @"coding_emoji_32": @"放毒气",
                                 @"coding_emoji_33": @"表白",
                                 @"coding_emoji_34": @"抓瓢虫",
                                 @"coding_emoji_35": @"下班",
                                 @"coding_emoji_36": @"冒泡",
                                 @"coding_emoji_38": @"2015",
                                 @"coding_emoji_39": @"拜年",
                                 @"coding_emoji_40": @"发红包",
                                 @"coding_emoji_41": @"放鞭炮",
                                 @"coding_emoji_42": @"求红包",
                                 @"coding_emoji_43": @"新年快乐"
                                 };
    });
    return _emotion_monkey_dict;
}
- (NSString *)emotionMonkeyName{
    return [NSString emotion_monkey_dict][self];
}

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte{
    NSString *sizeDisplayStr;
    if (sizeOfByte < 1024) {
        sizeDisplayStr = [NSString stringWithFormat:@"%.2f bytes", sizeOfByte];
    }else{
        CGFloat sizeOfKB = sizeOfByte/1024;
        if (sizeOfKB < 1024) {
            sizeDisplayStr = [NSString stringWithFormat:@"%.2f KB", sizeOfKB];
        }else{
            CGFloat sizeOfM = sizeOfKB/1024;
            if (sizeOfM < 1024) {
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f M", sizeOfM];
            }else{
                CGFloat sizeOfG = sizeOfKB/1024;
                sizeDisplayStr = [NSString stringWithFormat:@"%.2f G", sizeOfG];
            }
        }
    }
    return sizeDisplayStr;
}

- (BOOL)validatePhone
{
  /**
   * 手机号码
   * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
   * 联通：130,131,132,152,155,156,185,186
   * 电信：133,1349,153,180,189
   */
  NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
  /**
   10         * 中国移动：China Mobile
   11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
   12         */
  NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
  /**
   15         * 中国联通：China Unicom
   16         * 130,131,132,152,155,156,185,186
   17         */
  NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
  /**
   20         * 中国电信：China Telecom
   21         * 133,1349,153,180,189
   22         */
  NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
  /**
   25         * 大陆地区固话及小灵通
   26         * 区号：010,020,021,022,023,024,025,027,028,029
   27         * 号码：七位或八位
   28         */
  // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
  
  NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
  NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
  NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
  NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
  
  if (([regextestmobile evaluateWithObject:self] == YES)
      || ([regextestcm evaluateWithObject:self] == YES)
      || ([regextestct evaluateWithObject:self] == YES)
      || ([regextestcu evaluateWithObject:self] == YES))
  {
    if([regextestcm evaluateWithObject:self] == YES) {
      //NSLog(@"China Mobile");
    } else if([regextestct evaluateWithObject:self] == YES) {
      //NSLog(@"China Telecom");
    } else if ([regextestcu evaluateWithObject:self] == YES) {
      //NSLog(@"China Unicom");
    } else {
      //NSLog(@"Unknow");
    }
    
    return YES;
  }
  else
  {
    return NO;
  }
}

- (BOOL)validateEmail
{
  NSString  *reg  = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest      =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
  return  [emailTest evaluateWithObject:self];
}

- (BOOL)validateNickName
{
  NSString  *reg  = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
  NSPredicate *nickNameTest     =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
  return  [nickNameTest evaluateWithObject:self];
}

- (BOOL)validateHostDomain
{
  NSString  *reg  = @"^[a-zA-Z0-9][a-zA-Z0-9_-]+$";
  NSPredicate *hostTest     =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
  return  [hostTest evaluateWithObject:self];
}

- (BOOL)validatePassword
{
  NSString  *reg  = @"^[A-Za-z0-9]{6,15}$";
  NSPredicate *pwTest     =  [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
  return  [pwTest evaluateWithObject:self];
}


- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [[self trimWhitespace] isEqualToString:@""];
}

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (location = 0; location < length; location++) {
        if (![characterSet characterIsMember:charBuffer[location]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet{
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    for (length = [self length]; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    return NSMakeRange(location, length - location);
}

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingLeftCharactersInSet:characterSet]];
}

- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet {
    return [self substringWithRange:[self rangeByTrimmingRightCharactersInSet:characterSet]];
}

//转换拼音
- (NSString *)transformToPinyin {
    if (self.length <= 0) {
        return self;
    }
    NSMutableString *tempString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)tempString, NULL, kCFStringTransformToLatin, false);
    tempString = (NSMutableString *)[tempString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [tempString uppercaseString];
}
@end
