//
//  AddressManager.h
//  DouPaiwo
//  居住地初始化与工具类
//  Created by J006 on 15/9/15.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressManager : NSObject

+ (AddressManager *)sharedManager;
+ (NSMutableArray*)provinceCodeArray;
+ (NSMutableArray*)provinceNameArray;
+ (NSMutableDictionary*)cityDictonary;

/**
 *  @author J.006, 15-09-16 13:09:09
 *
 *  根据指定的省份code获取该省份的名称
 *
 *  @param code
 *
 *  @return
 */
+ (NSString *)getProvinceNameWithProvinceCode:(NSString *)code;
/**
 *  @author J.006, 15-09-16 13:09:35
 *
 *  根据指定的城市code获取该城市的名称
 *
 *  @param code
 *
 *  @return
 */
+ (NSString *)getCityNameWithCityCode:(NSString *)code;
/**
 *  @author J.006, 15-09-16 13:09:56
 *
 *  根据指定的城市code获取该城市的省份的名称
 *
 *  @param code
 *
 *  @return
 */
+ (NSString *)getProvinceNameWithCityCode:(NSString *)code;
/**
 *  @author J.006, 15-09-16 13:09:08
 *
 *  根据指定省份的code获取该省份下的城市集合
 *
 *  @param provinceCode
 *
 *  @return
 */
+ (NSDictionary*)  getCitysInProvinceWithCode :(NSString*)provinceCode;
@end
