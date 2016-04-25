//
//  MHPlayerManager.h
//  QQ音乐
//
//  Created by 莫煌 on 16/4/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHMusic;

@protocol MHPlayerManagerDelegate <NSObject>
// 播放进度
- (void)updateMusicProgress:(CGFloat)progress withUpdateInterval:(NSTimeInterval)timeInterval;
// 播放完成
- (void)playerDidFinished;

@end

@interface MHPlayerManager : NSObject

@property (weak, nonatomic) id<MHPlayerManagerDelegate> delegate;
/**
 *  当前歌曲播放时间
 */
@property (nonatomic, assign) NSTimeInterval currentTime;
/**
 *  歌曲持续时间
 */
@property (nonatomic, assign) NSTimeInterval durationTime;

+ (instancetype)sharedManager;

/**
 *  准备播放
 */
- (void)preparePlayWithMusic:(MHMusic *)music;
/**
 *  播放
 */
- (void)play;
/**
 *  暂停
 */
- (void)pause;
@end
