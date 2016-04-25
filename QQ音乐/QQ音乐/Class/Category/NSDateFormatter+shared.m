//
//  NSDateFormatter+shared.m
//  QQ音乐
//
//  Created by 莫煌 on 16/4/25.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "NSDateFormatter+shared.h"

@implementation NSDateFormatter (shared)

+ (instancetype)shared {
    static NSDateFormatter *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
@end
