//
//  MHMusic.h
//  QQ音乐
//
//  Created by 莫煌 on 16/4/24.
//  Copyright © 2016年 MH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MHMusicTypeLocal,
    MHMusicTypeRemote
} MHMusicType;

@interface MHMusic : NSObject

@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *lrc;
@property (copy, nonatomic) NSString *mp3;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *singer;
@property (copy, nonatomic) NSString *album;
@property (nonatomic, assign) MHMusicType type;

@end
