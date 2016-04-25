//
//  MHFormatter.m
//  QQ音乐
//
//  Created by 莫煌 on 16/4/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "MHFormatter.h"

@implementation MHFormatter

+ (NSString *)minuteSecondWithTimeInterval:(NSTimeInterval)timeInterval {
    NSInteger minete = timeInterval / 60;
    NSInteger second = (NSInteger)timeInterval % 60;
    return [NSString stringWithFormat:@"%02zd:%02zd",minete,second];
}
@end
