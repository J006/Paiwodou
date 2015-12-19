//
//  middleButtonInstance.h
//  TestPaiwo
//
//  Created by J006 on 15/5/4.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiddleButtonInstance : NSObject

@property (nonatomic,strong)      NSString                  *buttonName;
@property (nonatomic,readwrite)   CGFloat                   buttonWidth;
@property (nonatomic,readwrite)   CGFloat                   buttonHeight;

@end
