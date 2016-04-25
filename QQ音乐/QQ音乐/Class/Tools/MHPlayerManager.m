//
//  MHPlayerManager.m
//  QQ音乐
//
//  Created by 莫煌 on 16/4/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "MHPlayerManager.h"
#import <AVFoundation/AVFoundation.h>
#import "MHMusic.h"

#define HMMusicUpdateInterval 0.05

@interface MHPlayerManager ()<AVAudioPlayerDelegate>

/**
 *  音乐播放器
 */
@property (strong, nonatomic) AVAudioPlayer *player;

/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MHPlayerManager

+ (instancetype)sharedManager {
    static MHPlayerManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

/**
 *  准备播放歌曲
 */
- (void)preparePlayWithMusic:(MHMusic *)music {
    [self stopUpdateMusicProgress];
    NSLog(@"%@",music.mp3);
    NSURL *URL = [[NSBundle mainBundle] URLForResource:music.mp3 withExtension:nil];
    NSError *error = nil;
    // 创建播放器
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:&error];
    if (error) {
        NSLog(@"音乐播放器创建失败:%@",error);
        return;
    }
    self.player.delegate = self;
    [self.player prepareToPlay];
}

/**
 *  播放
 */
- (void)play {
    [self.player play];
    
    [self startUpdateMusicProgress];
}

/**
 *  暂停
 */
- (void)pause {
    [self.player pause];
    
    [self stopUpdateMusicProgress];
}

/**
 *  当前歌曲的持续时间
 */
- (NSTimeInterval)durationTime {
    return self.player.duration;
}

/**
 *  当前歌曲的播放时间
 */
- (NSTimeInterval)currentTime {
    return self.player.currentTime;
}
/**
 *  设置当前播放的时间
 */
- (void)setCurrentTime:(NSTimeInterval)currentTime {
    self.player.currentTime = currentTime;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        if ([self.delegate respondsToSelector:@selector(playerDidFinished)]) {
            [self.delegate playerDidFinished];
        }
    }
}

/**
 *  更新音乐播放进度
 */
- (void)updateMusicProgress {
    if ([self.delegate respondsToSelector:@selector(updateMusicProgress:withUpdateInterval:)]) {
        // 计算当前进度
        CGFloat progress = self.currentTime / self.durationTime;
        [self.delegate updateMusicProgress:progress withUpdateInterval:HMMusicUpdateInterval];
    }
}

/**
 *  开始更新播放进度
 */
- (void)startUpdateMusicProgress {
    // 创建定时器
    self.timer = [NSTimer timerWithTimeInterval:HMMusicUpdateInterval target:self selector:@selector(updateMusicProgress) userInfo:nil repeats:YES];
    // 添加到运行循环中
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  停止更新播放进度
 */
- (void)stopUpdateMusicProgress {
    [self.timer invalidate];
    self.timer = nil;
}

@end
