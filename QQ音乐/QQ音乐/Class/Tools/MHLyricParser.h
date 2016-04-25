//
//  MHLyricParser.h
//  QQ音乐
//
//  Created by 莫煌 on 16/4/25.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MHLyric;

@interface MHLyricParser : NSObject

/**
 *  解析歌词
 *
 *  @param fileName 歌词文件名称
 *
 *  @return 含有歌词模型的数组
 */
+ (NSArray <MHLyric *>*)lyricsWithFileName:(NSString *)fileName;
@end
