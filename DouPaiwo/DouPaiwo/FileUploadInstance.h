//
//  FileUploadInstance.h
//  DouPaiwo
//  文件/图片 上传对象
//  Created by J006 on 15/8/7.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUploadInstance : NSObject

@property (strong,    nonatomic)  NSString          *policy;
@property (strong,    nonatomic)  NSString          *signature;
@property (strong,    nonatomic)  NSString          *key_id;
@property (strong,    nonatomic)  NSString          *object_key;

@end
