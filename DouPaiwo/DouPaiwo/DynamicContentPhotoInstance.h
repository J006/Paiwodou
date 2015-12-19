//
//  DynamicContentPhoto.h
//  DouPaiwo
//  动态图
//  Created by J006 on 15/6/16.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicContentPhotoInstance : NSObject
/**
 *  @author J006, 15-06-06 16:06:28
 *
 *  图片id
 */
@property (nonatomic,readwrite)  NSInteger       photo_id;
/**
 *  @author J006, 15-06-06 16:06:37
 *
 *  图片地址
 */
@property (nonatomic,strong)     NSString        *photo_path;
/**
 *  @author J006, 15-06-06 16:06:55
 *
 *  是否是封面
 */
@property (nonatomic,readwrite)  BOOL            is_cover;
@end
