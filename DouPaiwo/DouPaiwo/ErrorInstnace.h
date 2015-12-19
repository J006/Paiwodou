//
//  ErrorInstnace.h
//  DouPaiwo
//
//  Created by J006 on 15/7/1.
//  Copyright (c) 2015年 paiwo.co. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorInstnace : NSObject

@property (nonatomic, readwrite)    NSInteger             error_id;
@property (nonatomic, strong)       NSString              *error_code;

@end
