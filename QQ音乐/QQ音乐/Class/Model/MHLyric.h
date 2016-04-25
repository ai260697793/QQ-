//
//  MHLyric.h
//  QQ音乐
//
//  Created by 莫煌 on 16/4/25.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHLyric : NSObject

/**
 *  开始时间
 */
@property (nonatomic, assign) NSTimeInterval beginTime;

/**
 *  歌词内容
 */
@property (nonatomic, strong) NSString *content;

@end
