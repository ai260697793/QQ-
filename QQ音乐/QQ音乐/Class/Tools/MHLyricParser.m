//
//  MHLyricParser.m
//  QQ音乐
//
//  Created by 莫煌 on 16/4/25.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "MHLyricParser.h"
#import "NSDateFormatter+shared.h"
#import "MHLyric.h"

@implementation MHLyricParser

+ (NSArray<MHLyric *> *)lyricsWithFileName:(NSString *)fileName {
    
    NSString *lyricPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSError *error = nil;
    NSString *lyricStr = [NSString stringWithContentsOfFile:lyricPath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"加载歌词失败:%@",error);
        return nil;
    }
   
    NSDateFormatter *dateFormatter = [NSDateFormatter shared];
    dateFormatter.dateFormat = @"[mm:ss.SS]";
    // 创建一个原始时间
    NSDate *originDate = [dateFormatter dateFromString:@"[00:00.00]"];
   
    NSArray *lyrics = [lyricStr componentsSeparatedByString:@"\n"];
    
    NSMutableArray <MHLyric *> *lyricArray = [NSMutableArray array];

    for (NSString *lyricStr in lyrics) {
        NSString *pattern = @"\\[\\d{2}:\\d{2}.\\d{2}\\]";
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        if (error) {
            NSLog(@"创建正则表达式失败:%@",error);
            return nil;
        }
        
        // 获取匹配结果
        NSArray <NSTextCheckingResult *> *checkingResults = [regularExpression matchesInString:lyricStr options:0 range:NSMakeRange(0, lyricStr.length)];
        // 获取歌词内容
        NSRange lastResultRange = checkingResults.lastObject.range;
        NSString *content = [lyricStr substringFromIndex:lastResultRange.location + lastResultRange.length];
        
        for (NSTextCheckingResult *chekingResult in checkingResults) {
            NSString *beginTimeStr = [lyricStr substringWithRange:chekingResult.range];
            
            // 将获取的时间转换为 NSTimeInterval 格式
            NSDate *beginDate = [dateFormatter dateFromString:beginTimeStr];
            
            NSTimeInterval beginTime = [beginDate timeIntervalSinceDate:originDate];
            
            // 创建模型并赋值
            MHLyric *lyric = [[MHLyric alloc] init];
            lyric.beginTime = beginTime;
            lyric.content = content;
            
            [lyricArray addObject:lyric];
        }
    }
    
    // 可变数组内部排序
    [lyricArray sortUsingComparator:^NSComparisonResult(MHLyric *obj1, MHLyric *obj2) {
        return obj1.beginTime > obj2.beginTime;
    }];
    
    return lyricArray.copy;
}

@end
