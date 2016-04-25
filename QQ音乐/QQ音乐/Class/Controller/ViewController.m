//
//  ViewController.m
//  QQ音乐
//
//  Created by 莫煌 on 16/4/23.
//  Copyright © 2016年 MH. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NSObject+Model.h"
#import "MHMusic.h"
#import "MHPlayerManager.h"
#import "MHFormatter.h"

@interface ViewController () <MHPlayerManagerDelegate>

/****************通用控件****************/
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

/****************竖屏****************/
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UIView *vCenterView;
@property (weak, nonatomic) IBOutlet UILabel *vLaricLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vImageView;

/****************横屏****************/
@property (weak, nonatomic) IBOutlet UIImageView *hCenterImageView;
@property (weak, nonatomic) IBOutlet UILabel *hLyricLabel;

/****************私有属性****************/
/**
 *  歌曲模型数组
 */
@property (nonatomic, strong) NSArray<MHMusic *> *musics;

/**
 *  当前歌曲索引
 */
@property (nonatomic, assign) NSInteger currentMusicIndex;
/**
 *  播放器
 */
@property (weak, nonatomic) MHPlayerManager *playerManager;
/**
 *  记录是否需要更新滑块
 */
@property (nonatomic, assign) BOOL isUpdateMusicProgress;

@end

@implementation ViewController

#pragma mark - View的生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUpdateMusicProgress = YES;
    self.playerManager = [MHPlayerManager sharedManager];
    self.playerManager.delegate = self;
//  添加毛玻璃效果
    [self addBlurEffect];
    // 一进来就显示歌曲信息
    [self changeMusic];
}

// 当控制器的view将要布局子控制器的时候调用
- (void)viewWillLayoutSubviews {
    self.vImageView.layer.cornerRadius = self.vImageView.bounds.size.width * 0.5;
//    self.vImageView.layer.masksToBounds = YES;
    self.vImageView.clipsToBounds = YES;
}

#pragma mark - 点击事件
- (IBAction)puaseAndPlay {
    if (self.playBtn.selected) {
        [self.playerManager pause];
    }else {
        [self.playerManager play];
    }
    self.playBtn.selected = !self.playBtn.selected;
}
- (IBAction)previous:(id)sender {
    if (self.currentMusicIndex == 0) {
        self.currentMusicIndex = self.musics.count - 1;
    }else {
        self.currentMusicIndex--;
    }
    [self changeMusic];

}
- (IBAction)next:(id)sender {
    if (self.currentMusicIndex == self.musics.count - 1) {
        self.currentMusicIndex = 0;
    }else {
        self.currentMusicIndex++;
    }
    [self changeMusic];
}
- (IBAction)sliderTouchDown:(id)sender {
//    [self.playerManager pause];
    self.isUpdateMusicProgress = NO;
}
- (IBAction)sliderTouchUpInside:(id)sender {
    self.playerManager.currentTime = self.musicSlider.value * self.playerManager.durationTime;
    self.isUpdateMusicProgress = YES;
}

#pragma mark - 私有方法
// 添加毛玻璃效果
- (void)addBlurEffect {
    UINavigationBar *navBar = [[UINavigationBar alloc] init];
    navBar.barStyle = UIBarStyleBlack;
    [self.bgImageView addSubview:navBar];
    
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    
    // 第二种
    // 毛玻璃效果
//    UIBlurEffect *blurtEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    // 具有毛玻璃效果的视图
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurtEffect];
//    
//    [self.bgImageView addSubview:effectView];
//    [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.bgImageView);
//    }];
}

- (void)changeMusic {
    // 读取歌曲信息
    MHMusic *music = self.musics[self.currentMusicIndex];
    // 设置歌曲信息
    self.title = music.name;
    self.singerLabel.text = music.singer;
    UIImage *image = [UIImage imageNamed:music.image];
    self.bgImageView.image = image;
    self.vImageView.image = image;
    self.hCenterImageView.image = image;
    self.albumLabel.text = music.album;
    
    [self.playerManager preparePlayWithMusic:music];
    [self.playerManager play];
    self.playBtn.selected = YES;
    
    // 设置持续时间
    self.durationTimeLabel.text = [MHFormatter minuteSecondWithTimeInterval:self.playerManager.durationTime];
//    NSLog(@"%@",)
}

#pragma mark - MHPlayerManagerDelegate
// 播放进度更新
- (void)updateMusicProgress:(CGFloat)progress withUpdateInterval:(NSTimeInterval)timeInterval {
    if (self.isUpdateMusicProgress) {
        self.musicSlider.value = progress;
    }
    
    self.currentTimeLabel.text = [MHFormatter minuteSecondWithTimeInterval:self.playerManager.currentTime];
    
    self.vImageView.transform = CGAffineTransformRotate(self.vImageView.transform, M_PI_4 * timeInterval);
}

// 播放完成
- (void)playerDidFinished {
    [self next:nil];
}

#pragma mark - Setter & Getter
- (NSArray<MHMusic *> *)musics {
    if (_musics == nil) {
        // plist名字不需要添加plist后缀
        _musics = [MHMusic objectArrayWithPlistName:@"mlist"];
    }
    return _musics;
}

@end
