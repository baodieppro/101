//
//  GSPlayView.m
//  GSPlay
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import "GSPlayView.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Time.h"
#import "GSBrightnessAndVolumeView.h"
#import "GSNewButton.h"
#import "GSDLNAView.h"
#import "GSLoadingView.h"
#import "GSplayListView.h"

#import "GSCoverPictureNode.h"
#import "GSSlider.h"


@interface YGPreviewView : UIView
@property (nonatomic, strong) UIImageView *previewImageView;
@property (nonatomic, strong) UILabel *previewtitleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIProgressView *progressView;
+ (instancetype)sharedPreviewView;
@end

@implementation YGPreviewView
// 单例
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedPreviewView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 懒加载
// 视频缩略图
- (UIImageView *)previewImageView
{
    if (_previewImageView == nil) {
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.layer.cornerRadius = 5;
        _previewImageView.clipsToBounds = YES;
        _previewImageView.backgroundColor = [UIColor colorWithRed:.0f green:.0f blue:.0f alpha:.5f];
        [self addSubview:_previewImageView];
    }
    return _previewImageView;
}

// 进度标签
- (UILabel *)previewtitleLabel
{
    if (_previewtitleLabel == nil) {
        _previewtitleLabel = [[UILabel alloc] init];
        _previewtitleLabel.font = [UIFont systemFontOfSize:20];
        _previewtitleLabel.textColor = [UIColor whiteColor];
        _previewtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_previewtitleLabel];
    }
    return _previewtitleLabel;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.trackTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor redColor];
        [self addSubview:_progressView];
    }
    return _progressView;
}

// 等待菊花
- (UIActivityIndicatorView *)loadingView
{
    if (_loadingView == nil) {
        _loadingView = [[UIActivityIndicatorView alloc] init];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        _loadingView.hidesWhenStopped = YES;
        [self.previewImageView addSubview:_loadingView];
    }
    return _loadingView;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.previewtitleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    if (image == nil) {
        [self.loadingView startAnimating];
        self.previewImageView.image = nil;
    } else {
        [self.loadingView stopAnimating];
        self.previewImageView.image = image;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) { // 转至竖屏
        self.previewImageView.hidden = YES;
        self.progressView.hidden = NO;
    } else if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) { // 转至横屏
        self.previewImageView.hidden = NO;
        self.progressView.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.previewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(self).multipliedBy(9/16.0);
    }];
    
    [self.previewtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.previewImageView).offset(110.f);
        make.height.mas_equalTo(20.f);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.previewImageView);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(100);
    }];
}
@end




@interface GSPlayView ()<UIGestureRecognizerDelegate,MyDLNAViewDelegate,MyGSplayListViewDelegate>
{
    NSString * gsPlayUrl;
}
@property (nonatomic, strong) NSMutableArray *playInfos;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) NSTimeInterval totalTime;
@property (strong, nonatomic) UIImageView *placeHolderView;
@property (nonatomic, assign, getter=isLandscape) BOOL landscape;
@property (nonatomic, assign, getter=controlPanelIsShowing) BOOL controlPanelShow;
//手势
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGuesture;

//UI
/*
 *顶部状态栏
 */
@property (nonatomic, strong) UIView *topView;//!<顶部状态栏view
@property (nonatomic, strong) UIButton *backButton;//!<返回按钮

@property (nonatomic, strong) UIButton *dlnaButton;//!<DLNA投屏按钮
@property (nonatomic, strong) UILabel *listLable;//!<当前列表数量

/*
 *底部状态栏
 */
@property (nonatomic, strong) UIView *bottomView;//!<底部状态栏View
@property (nonatomic, strong) UILabel *currentTimeLabel;//!<当前播放时间
@property (strong, nonatomic) UILabel *totalTimeLabel;//!<视频时长
@property (strong, nonatomic) GSSlider *progressSlider;//!<
@property (strong, nonatomic) UIProgressView *loadedView;//!<进度条

/*
 *中间View
 */
//音乐布局控件
@property (nonatomic, strong) UILabel *titleLable;//!<名称
@property (nonatomic, strong) UILabel *bodyLable;//!<副标题名称

@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) UIButton *episodeCover;
@property (nonatomic, strong) UIButton *replayBtn;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *leftPlayButton;//!<上一首
@property (nonatomic, strong) UIButton *rightPlayButton;//!<下一首
@property (nonatomic, strong) UIButton *sharpnessButton;//!<清晰度按钮
@property (nonatomic, strong) UIButton *cycleButton;//!<循环播放按钮
@property (nonatomic, strong) UIButton *playListButton;//!<播放列表按钮
@property (nonatomic, strong) UIButton *playlrcButton;//!<歌词按钮
@property (nonatomic, strong) UIButton *downloadButton;//!<下载按钮
@property (nonatomic, strong) UIButton *playlikeButton;//!<收藏按钮

@property (nonatomic, assign) NSInteger playIndex;//!<当前播放数据下标
@property (nonatomic, assign) bool isCycleReplay;//!<单曲循环


//手势控制View
@property (nonatomic, strong) GSBrightnessAndVolumeView *brightnessAndVolumeView;

@property (strong, nonatomic)  NSLayoutConstraint *topViewTopConstraint;
@property (strong, nonatomic)  NSLayoutConstraint *bottomViewBottomConstaint;
@property (strong, nonatomic)  NSLayoutConstraint *topViewHeightConstraint;
@property (strong, nonatomic)  NSLayoutConstraint *rotateBtnLeadingConstraint;

@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
/*
 * GSDLNA 投屏
 */
@property (nonatomic, strong) GSDLNAView *gsDLNAView;
//亮度View
@property (nonatomic, strong) GSLoadingView *waitingView;
//播放列表
@property (nonatomic, strong) GSplayListView *playlistView;

/*
 * 音频 UI控件
 */
@property (nonatomic, strong) GSCoverPictureNode * coverPictureNode;

/*
 * 数据
 */
@property (nonatomic, strong) NSMutableArray * playDataArr;

@end
@implementation GSPlayView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addGesture];
        [self showOrHideControlPanel];
        [self setupBrightnessAndVolumeView];
        [self gs_CreateUI];
        [self gs_Init];
    }
    return self;
}
-(void)gs_Init{
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"icon_tv_round"] forState:UIControlStateNormal];
    self.progressSlider.value = .0f;
    self.loadedView.progress = .0f;
    self.currentTimeLabel.text = @"00:00";
    self.totalTimeLabel.text = @"00:00";
    self.backgroundColor = [UIColor blackColor];
    self.playIndex = 0;
    self.isCycleReplay = NO;
}
-(void)replaceView{
    //播放音频格式
//    if (self.playType == playMusicType || self.styleType == earStyleType) {
//        [self addSubview:self.titleLable];
//        [self addSubview:self.bodyLable];
//        [self addSubview:self.coverPictureNode];
//        [self addSubview:self.playlrcButton];
//        [self addSubview:self.playlikeButton];
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_voiceplay"]];
//    }else{
        self.backgroundColor = [UIColor blackColor];
//        [self.titleLable removeFromSuperview];
        [self.bodyLable removeFromSuperview];
        [self.coverPictureNode removeFromSuperview];
        [self.playlikeButton removeFromSuperview];
//    }
}
-(void)gs_CreateUI{
    [self replaceView];
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.backButton];
    [self.topView addSubview:self.listLable];
    [self.topView addSubview:self.dlnaButton];
    [self.topView addSubview:self.titleLable];

    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.loadedView];
    [self.bottomView addSubview:self.progressSlider];
    [self.bottomView addSubview:self.currentTimeLabel];
    [self.bottomView addSubview:self.totalTimeLabel];
   
    [self addSubview:self.playButton];
    [self addSubview:self.leftPlayButton];
    [self addSubview:self.rightPlayButton];
    [self addSubview:self.playListButton];
    [self addSubview:self.cycleButton];
    [self addSubview:self.downloadButton];
    [self addSubview:self.waitingView];
    
    [self gs_layoutFrame];

}

-(void)gs_layoutFrame{

        [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(__kNewSize(50*2));
        }];
        [_backButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView);
            make.left.mas_equalTo(self.topView.mas_left).mas_offset(20);
//            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    
        [_listLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView);
            make.right.mas_equalTo(self.topView.mas_right).mas_offset(-__kNewSize(22*2));
            make.width.mas_equalTo(__kNewSize(42*2));
            make.height.mas_equalTo(__kNewSize(22*2));
        }];
    
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(0);
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.height.mas_equalTo(__kNewSize(50*2));
        }];
        
        [_loadedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bottomView);
            make.left.mas_equalTo(self.bottomView.mas_left).mas_offset(__kNewSize(61*2));
            make.right.mas_equalTo(self.bottomView.mas_right).mas_offset(-__kNewSize(61*2));
            make.height.mas_equalTo(__kNewSize(6*2));
        }];
        //滑杆
        [_progressSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bottomView);
            make.left.mas_equalTo(self.bottomView.mas_left).mas_offset(__kNewSize(61*2));
            make.right.mas_equalTo(self.bottomView.mas_right).mas_offset(-__kNewSize(61*2));
            make.height.mas_equalTo(__kNewSize(6*2));
        }];
        [_currentTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(__kNewSize(20*2));
            make.centerY.mas_equalTo(self.progressSlider);
            make.height.mas_equalTo(__kNewSize(17*2));
        }];
        [_totalTimeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(20*2));
            make.centerY.mas_equalTo(self.progressSlider);
            make.height.mas_equalTo(__kNewSize(17*2));
        }];
//        [_gsDLNAView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.left.right.equalTo(self);
//        }];
        [_playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [_playListButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(__kNewSize(115*2));
            make.right.mas_equalTo(self).mas_offset(-__kNewSize(21*2));
        }];
        [_cycleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.playListButton.mas_bottom).mas_offset(__kNewSize(20*2));
            make.centerX.mas_equalTo(self.playListButton);
        }];
        [_downloadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cycleButton.mas_bottom).mas_offset(__kNewSize(20*2));
            make.centerX.mas_equalTo(self.cycleButton);
        }];
        [_dlnaButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView);
            make.right.mas_equalTo(self.listLable.mas_left).mas_offset(-__kNewSize(22*2));
            //            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.topView);
            make.left.mas_equalTo(self.topView).mas_offset(60);
            make.right.mas_equalTo(self.topView.mas_right).mas_offset(-120);
            make.height.mas_equalTo(__kNewSize(22*2));
        }];
    
    if (self.playType == playMusicType) {
        [_titleLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).mas_offset(34);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(__kNewSize(19*2));
        }];
        [_bodyLable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLable.mas_bottom).mas_offset(__kNewSize(6*2));
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(__kNewSize(15*2));
        }];
        [_coverPictureNode mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.bodyLable.mas_bottom).mas_offset(__kNewSize(19*2));
            make.center.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(189, 189));
        }];
        [_leftPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.playButton.mas_left).mas_offset(-__kNewSize(115*2));
            make.centerY.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [_rightPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playButton.mas_right).mas_offset(__kNewSize(115*2));
            make.centerY.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [_playlrcButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cycleButton.mas_bottom).mas_offset(__kNewSize(20*2));
//            make.right.mas_equalTo(self).mas_offset(-__kNewSize(21*2));
            make.centerX.mas_equalTo(self.playListButton);
        }];
        [_playlikeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.playlrcButton.mas_bottom).mas_offset(__kNewSize(20*2));
//            make.right.mas_equalTo(self).mas_offset(-__kNewSize(21*2));
            make.centerX.mas_equalTo(self.playListButton);

        }];
    }else{
    
        [_leftPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.playButton.mas_left).mas_offset(-__kNewSize(24*2));
            make.centerY.mas_equalTo(self);
        }];
        [_rightPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.playButton.mas_right).mas_offset(__kNewSize(24*2));
            make.centerY.mas_equalTo(self);
        }];
    }
//    [self buttonStyle];
}

-(void)buttonStyle{
    if (self.playType == playMusicType) {
        [_playListButton setImage:[UIImage imageNamed:@"icon_music_list"] forState:UIControlStateNormal];
        [_cycleButton setImage:[UIImage imageNamed:@"icon_music_circle"] forState:UIControlStateNormal];

    }else{
        [_playListButton setImage:[UIImage imageNamed:@"icon_tv_list"] forState:UIControlStateNormal];
        [_cycleButton setImage:[UIImage imageNamed:@"icon_tv_circle"] forState:UIControlStateNormal];
        [_sharpnessButton setImage:[UIImage imageNamed:@"icon_tv_hd"] forState:UIControlStateNormal];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(@(0));
    }];
    self.playerLayer.frame = self.bounds;
    self.brightnessAndVolumeView.frame = self.bounds;
    
    [self.waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(__kNewSize(150*2));
    }];

    [self bringSubviewToFront:self.brightnessAndVolumeView];
    [self bringSubviewToFront:self.topView];
    [self bringSubviewToFront:self.bottomView];
    [self bringSubviewToFront:self.leftPlayButton];
    [self bringSubviewToFront:self.rightPlayButton];
    [self bringSubviewToFront:self.playListButton];
    [self bringSubviewToFront:self.cycleButton];
    [self bringSubviewToFront:self.downloadButton];
    [self bringSubviewToFront:self.playlrcButton];
    [self bringSubviewToFront:self.playlikeButton];
    [self bringSubviewToFront:self.playButton];
    [self bringSubviewToFront:self.waitingView];
    [self bringSubviewToFront:self.playlistView];
    [self bringSubviewToFront:self.gsDLNAView];

}
#pragma mark - 播放


#pragma mark - 定位播放数据

#pragma mark - 播放列表数量
-(void)setListWithindex:(NSInteger)index Count:(NSInteger)coun{
    self.listLable.text = [NSString stringWithFormat:@"%ld/%ld",(long)index+1,(long)coun];
    self.playlistView.playListIndex = self.playIndex;
}
-(void)playWithPlayName:(NSString *)name{
    self.titleLable.text = name;
}
- (void)playWithPlayInfo:(NSString *)playInfo
{
    [self replaceView];
    [self gs_layoutFrame];
    gsPlayUrl = playInfo;

    //判断当前播放类型
    [self isPlayType:playInfo];

    // 重置player
    [self resetPlayer];
//    [self addGesture];
    // 切换隐藏控制面板
    [self showOrHideControlPanel];
//    [self showControlPanel];
    
    // 存储当前播放URL到本地 以便后面选集时比较哪个是当前播放的曲目
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:playInfo.url forKey:@"currentPlayingUrl"];
//
    if ([DownloadDataManager isExistAppForPathUrl:playInfo] == YES) {
        [BNHttpLocalServer.shareInstance tryStart];
        self.playerItem =  [AVPlayerItem playerItemWithURL:[NSURL URLWithString:playInfo]];
        self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];

    }else{
        self.asset = [AVURLAsset assetWithURL:[NSURL URLWithString:playInfo]];
        self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    
    // 因为replaceCurrentItemWithPlayerItem在使用时会卡住主线程 重新创建player解决
//    if (self.player) return;

    // 设置播放器标题
//    self.titleLabel.text = playInfo.title;
    self.placeHolderView.hidden = NO;
//
    [self.waitingView stopAnimating];
    
    // 建立串行调度组 确保截图任务的先后完成
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_group_async(group, queue, ^{
        self.totalTime = CMTimeGetSeconds(self.asset.duration);
    });
   
    
//    [self removeFromAllview];
    [self setupPlayer];
//    [self.player play];
    // 添加时间周期OB、OB和通知
    [self addTimerObserver];
    [self addPlayItemObserverAndNotification];

}
#pragma mark - 判断播放格式
-(void)isPlayType:(NSString *)playUrl{
    if ([[playUrl pathExtension] isEqualToString:@"mp4"]||[[playUrl pathExtension] isEqualToString:@"m3u8"]) {
        self.playType = playVideoType;
    }
    else if([[playUrl pathExtension] isEqualToString:@"mp3"])
    {
        self.playType = playMusicType;
    }
}
-(void)setPlayType:(PlayType)playType{
    _playType = playType;
}
#pragma mark - 判断是否从缓存读
-(void)isCache:(NSString *)playUrl{
    
}

#pragma mark -  创建播放器
- (void)setupPlayer
{
    [self.layer insertSublayer:self.playerLayer atIndex:0];
}
-(AVPlayer *)player{
    if (!_player) {
        AVPlayer *player = [[AVPlayer alloc] init];
        _player = player;
    }
    return _player;
}
-(AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        playerLayer.frame = self.bounds;
        playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;
        
//        [self.layer addSublayer:playerLayer];
        _playerLayer = playerLayer;
    }
    return _playerLayer;
}
#pragma mark -  重置播放器
- (void)resetPlayer
{
    if (self.playerItem) {
        [self.player pause];
        [self removePlayItemObserverAndNotification];
        [self removeTimeObserver];
        [self.player.currentItem cancelPendingSeeks];
        [self.player.currentItem.asset cancelLoading];
        //    self.imageGenerator = nil;
        self.player.rate = .0f;
        self.totalTime = .0f;
        self.progressSlider.value = .0f;
        [self dragProgressAction:self.progressSlider];
        [self.player replaceCurrentItemWithPlayerItem:nil];
        [self.playerLayer removeFromSuperlayer];
        self.playerItem = nil;
        self.placeHolderView.image = nil;
        self.player = nil;
        self.playerLayer = nil;
    }
}

#pragma mark -  播放或暂停按钮点击
- (void)playOrPauseAction
{
    [self playOrPause];
}

#pragma mark -  中间大的播放或站厅按钮点击
- (void)centerPlayOrPauseAction
{
    [self playOrPause];
}

#pragma mark -  点击按钮旋转屏幕
- (void)rotateScreen:(UIButton *)sender
{
    [self reShowControlPanel];
    
    if (self.isLandscape) { // 转至竖屏
        [self setForceDeviceOrientation:UIDeviceOrientationPortrait];
    } else { // 转至横屏
        [self setForceDeviceOrientation:UIDeviceOrientationLandscapeLeft];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

#pragma mark -  拖拽进度条
- (void)dragProgressAction:(UISlider *)sender {
    // 把播放器控制面板显示属性设置为NO 避免拖动时触发手势隐藏面板
    [self reShowControlPanel];
    
    [self.player pause];
    [self removeTimeObserver];
    self.currentTimeLabel.text = [NSString formatTimeWithTimeInterVal:sender.value];
    
}
#pragma mark -  添加亮度和音量调节View
- (void)setupBrightnessAndVolumeView
{
    GSBrightnessAndVolumeView *brightnessAndVolumeView = [GSBrightnessAndVolumeView sharedBrightnessAndAudioView];
    brightnessAndVolumeView.progressChangeHandle = ^(CGFloat delta) {
        [self gestureDragProgress:delta];
    };
    brightnessAndVolumeView.progressPortraitEnd = ^{
        [self gestureDragEnd];
    };
    brightnessAndVolumeView.progressLandscapeEnd = ^{
        [self progressDragEnd:self.progressSlider];
    };
    [self addSubview:brightnessAndVolumeView];
    self.brightnessAndVolumeView = brightnessAndVolumeView;
}

#pragma mark -  给playItem添加观察者KVO
- (void)addPlayItemObserverAndNotification
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:NULL];
    [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:NULL];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusBarStyle:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

#pragma mark - 移除观察者和通知
- (void)removePlayItemObserverAndNotification
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 给进度条Slider添加时间OB
- (void)addTimerObserver
{
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        weakSelf.currentTimeLabel.text = [NSString formatTimeWithTimeInterVal:CMTimeGetSeconds(weakSelf.player.currentTime)];
        weakSelf.progressSlider.value = CMTimeGetSeconds(weakSelf.player.currentTime);
    }];
}

#pragma mark - 移除时间OB
- (void)removeTimeObserver
{
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
    }
}

#pragma mark - KVO监测到播放完调用
- (void)playFinished:(NSNotification *)note {
    
    if (self.isCycleReplay == YES) {
        [self replay];
    }else{
        if (self.playDataArr.count != 0) {
            self.playIndex ++;
            if (self.playDataArr.count <= self.playIndex) {
                GSLog(@"播放结束");
                self.playerItem = [note object];
//                [self removeGestureRecognizer:self.tapGesture];
            }else{
                [self playListIndex:self.playIndex];
            }
        }else{
            GSLog(@"播放结束");
            self.playerItem = [note object];
//            [self removeGestureRecognizer:self.tapGesture];
        }
    }
    
   
 
}

#pragma mark - 播放完后重播
- (void)replay
{
//    [self.replayBtn removeFromSuperview];
//    if (self.player) {
        [self hideControlPanel];
        [self.playerItem seekToTime:kCMTimeZero];
        [self.player play];
        [self addGesture];
//    }else{
//        [self playListIndex:0];
//    }
   
}

#pragma mark - KVO检测播放器各种状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    AVPlayerItem *playItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) { // 检测播放器状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) { // 达到能播放的状态
            self.totalTimeLabel.text = [NSString formatTimeWithTimeInterVal:self.totalTime];
            self.progressSlider.maximumValue = self.totalTime;
            self.placeHolderView.image = nil;
            [self playOrPauseAction];
//            [self.coverPictureNode startAnimating];
            [self.waitingView stopAnimating];
        } else if (status == AVPlayerStatusFailed) { // 播放错误 资源不存在 网络问题等等
            [self.waitingView startAnimating];
            GSLog(@"播放错误 资源不存在");
        } else if (status == AVPlayerStatusUnknown) { // 未知错误
            [self.waitingView stopAnimating];
            GSLog(@"播放错误 未知错误");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) { // 检测缓存状态
//        NSArray *loadedTimeRanges = [playItem loadedTimeRanges];
//        CMTimeRange timeRange = [[loadedTimeRanges firstObject] CMTimeRangeValue];
//        NSTimeInterval bufferingTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        // 计算缓冲进度
        NSTimeInterval bufferingTime = [self availableDuration];
        CMTime duration             = self.playerItem.duration;
        CGFloat totalDuration       = CMTimeGetSeconds(duration);
        self.totalTime = totalDuration;
        [self.loadedView setProgress:bufferingTime / self.totalTime animated:YES];

        if (bufferingTime >= CMTimeGetSeconds(playItem.currentTime) + 5.f) {
            [self.waitingView stopAnimating];
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {  // 缓存为空
        if (playItem.playbackBufferEmpty) {
            [self.waitingView startAnimating];
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) { // 缓存足够能播放
        if (playItem.playbackLikelyToKeepUp) {
            [self.waitingView stopAnimating];
        }
    } else if ([keyPath isEqualToString:@"thumbImages"]) {
       
    } else if ([keyPath isEqualToString:@"rate"]) {
        CGFloat rate = [[change objectForKey:@"new"] intValue];
        if (rate == .0f) {
            self.placeHolderView.hidden = YES;
            if (self.playType == playMusicType) {
                [self.coverPictureNode stopAnimating];
            }
            [self.playButton setImage:[UIImage imageNamed:@"icon_tv_play"] forState:UIControlStateNormal];
        } else if (rate > .0f) {
            self.placeHolderView.hidden = NO;
            if (self.playType == playMusicType) {
                [self.coverPictureNode startAnimating];
            }
            [self.playButton setImage:[UIImage imageNamed:@"icon_tv_stop"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 横竖屏适配
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
    [super traitCollectionDidChange:previousTraitCollection];
    if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) { // 转至竖屏
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topConstraint);
            make.left.equalTo(self.leftConstraint);
            make.width.equalTo(self.widthConstraint);
            make.height.equalTo(self.heightConstraint);
        }];

        self.landscape = NO;
    } else if (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact) { // 转至横屏
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.left.equalTo(@(0));
        }];

        self.landscape = YES;
    }
}
#pragma mark - 计算缓冲进度
- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange     = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds        = CMTimeGetSeconds(timeRange.start);
    float durationSeconds     = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result     = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}
#pragma mark - 横向手势拖拽时显示进度条或者缩略图
- (void)gestureDragProgress:(CGFloat)delta
{
    self.controlPanelShow = NO;
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    currentTime = currentTime + delta;
    self.progressSlider.value = currentTime;
    [self dragProgressAction:self.progressSlider];
}

#pragma mark - 进度条拖拽结束
- (void)progressDragEnd:(UISlider *)sender
{
    // 把播放器控制面板显示属性设置为NO 避免拖动时触发手势隐藏面板
    self.controlPanelShow = NO;
    
//    [UIView animateWithDuration:.5f animations:^{
////        self.previewView.alpha = .0f;
//    }];
    [self.player seekToTime:CMTimeMake(self.progressSlider.value, 1.0) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self addTimerObserver];
//    [self.player play];
    // 延迟10.0秒后隐藏播放控制面板
    [self performSelector:@selector(autoFadeOutControlPanelAndStatusBar) withObject:nil afterDelay:10.f];
}

#pragma mark -  横向手势拖拽手势结束
- (void)gestureDragEnd
{
//    [UIView animateWithDuration:.5f animations:^{
////        self.previewView.alpha = .0f;
//    }];
}

#pragma mark - 获取AVURLAsset的任意一帧图片
//- (UIImage *)thumbImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
//    [self.imageGenerator cancelAllCGImageGeneration];
//    self.imageGenerator.appliesPreferredTrackTransform = YES;
//    self.imageGenerator.maximumSize = CGSizeMake(160, 90);
//    CGImageRef thumbImageRef = NULL;
//    NSError *thumbImageGenerationError = nil;
//    thumbImageRef = [self.imageGenerator copyCGImageAtTime:CMTimeMake(time, 1) actualTime:NULL error:&thumbImageGenerationError];
//    //    NSLog(@"%@", thumbImageGenerationError);
//    UIImage *thumbImage = [[UIImage alloc] initWithCGImage:thumbImageRef];
//    // 用完要释放 不然会存在内存泄漏
//    CGImageRelease(thumbImageRef);
//    if (thumbImageRef) {
//        return thumbImage;
//    } else {
//        return nil;
//    }
//}
#pragma mark - 强制切换屏幕方向
- (void)setForceDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:deviceOrientation] forKey:@"orientation"];
}

#pragma mark - 播放或暂停
- (void)playOrPause
{
    if ([self isPlaying]) {
        [self.player pause];
        if(self.playType == playMusicType){
//            [self.coverPictureNode stopAnimating];
        }
        [_playButton setImage:[UIImage imageNamed:@"icon_tv_play"] forState:UIControlStateNormal];
    } else {
        [self.player play];
        if(self.playType == playMusicType){
//            [self.coverPictureNode startAnimating];
        }
        [_playButton setImage:[UIImage imageNamed:@"icon_tv_stop"] forState:UIControlStateNormal];
//        [self hideControlPanel];
    }
    
}

#pragma mark - 判断播放器是否播放
- (BOOL)isPlaying
{
//    if([[UIDevice currentDevice] systemVersion].intValue>=10){
//        AVPlayerTimeControlStatus status = self.player.timeControlStatus;
//        switch (status) {
//            case AVPlayerTimeControlStatusPlaying:
//
//                return YES;
//                break;
//
//            case AVPlayerTimeControlStatusPaused:
//
//                return NO;
//                break;
//
//            case AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate:
//                return NO;
//                break;
//        }
//    }else{
        if (self.player.rate == 1.0) {
            return YES;
        }else if (self.player.rate == 0.0)
        {
            return NO;
        }
            return NO;
    
//    }
//    return self.player.rate==1.0;
}

#pragma mark - 添加手势识别器
- (void)addGesture
{
    // 添加Tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideControlPanel)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    self.tapGesture = tapGesture;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 判断是不是UIButton的类
    NSLog(@"gestureRecognizer:%@",NSStringFromClass([touch.view class]));

    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }else if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
         return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - 显示或隐藏播放器控制面板
- (void)showOrHideControlPanel
{
    if (self.controlPanelIsShowing) {
        [self hideControlPanel];
        if (self.isLandscape) {
            [self hideStatusBar];
        }
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [UIView animateWithDuration:.5f animations:^{
            [self showControlPanel];
            [self showStatusBar];
        }];
        [self performSelector:@selector(autoFadeOutControlPanelAndStatusBar) withObject:nil afterDelay:10.f];
    }
}

#pragma mark - 重新显示播放器控制面板
- (void)reShowControlPanel
{
    self.controlPanelShow = NO;
    [self showOrHideControlPanel];
}

#pragma mark - 显示播放控制面板
- (void)showControlPanel
{
    self.controlPanelShow = YES;
    self.topViewTopConstraint.constant = 0;
    self.topView.alpha = 1.f;
    self.bottomViewBottomConstaint.constant = 0;
    self.bottomView.alpha = 1.f;
    self.playButton.alpha = 1.f;
    self.leftPlayButton.alpha = 1.f;
    self.rightPlayButton.alpha = 1.f;
    self.playListButton.alpha = 1.f;
    self.cycleButton.alpha = 1.f;
    self.playlrcButton.alpha = 1.f;
    self.playlikeButton.alpha = 1.f;
    self.downloadButton.alpha = 1.f;

}

#pragma mark - 隐藏播放控制面板
- (void)hideControlPanel
{
    self.controlPanelShow = NO;
    self.topViewTopConstraint.constant = -self.topView.bounds.size.height;
    self.topView.alpha = .0f;
    self.bottomViewBottomConstaint.constant = -self.bottomView.bounds.size.height;
    self.bottomView.alpha = .0f;
     self.playButton.alpha = .0f;
    self.leftPlayButton.alpha = 0.f;
    self.rightPlayButton.alpha = 0.f;
    self.playListButton.alpha = 0.f;
    self.cycleButton.alpha = 0.f;
    self.playlrcButton.alpha = 0.f;
    self.playlikeButton.alpha = 0.f;
    self.downloadButton.alpha = 0.f;

}

#pragma mark - 自动淡出播放控制面板
- (void)autoFadeOutControlPanelAndStatusBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self hideControlPanel];
    if (!self.isLandscape) return;
    [self hideStatusBar];
}

#pragma mark - 显示状态栏
- (void)showStatusBar
{
    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark - 隐藏状态栏
- (void)hideStatusBar
{
    [UIApplication sharedApplication].statusBarHidden = YES;
}

#pragma mark - 根据方向改变状态栏的风格
- (void)changeStatusBarStyle:(NSNotification *)note
{
    UIInterfaceOrientation statusOrientation = [note.userInfo[@"UIApplicationStatusBarOrientationUserInfoKey"] integerValue];
    if (statusOrientation == UIInterfaceOrientationPortrait) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}


- (void)dealloc
{
    [self removeFromAllview];
//    [self removePlayItemObserverAndNotification];
//    [self removeTimeObserver];
    GSLog(@"play_dealloc");
//    [self removeObserver:self forKeyPath:@"thumbImages"];
}
-(void)removeFromAllview{
//    [self playOrPause];
    [self resetPlayer];
//    [self removePlayItemObserverAndNotification];
//    [self removeTimeObserver];
    [self removeGestureRecognizer:_tapGesture];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [_gsDLNAView removeFromSuperview];
    [_brightnessAndVolumeView removeFromSuperview];
    [_topView removeFromSuperview];
    [_backButton removeFromSuperview];
    [_titleLable removeFromSuperview];
    [_dlnaButton removeFromSuperview];
    [_bottomView removeFromSuperview];
    [_progressSlider removeFromSuperview];
    [_currentTimeLabel removeFromSuperview];
    [_totalTimeLabel removeFromSuperview];
    _gsDLNAView = nil;
    _brightnessAndVolumeView = nil;
    _topView = nil;
    _backButton = nil;
    _titleLable = nil;
    _dlnaButton = nil;
    _bottomView = nil;
    _progressSlider = nil;
    _currentTimeLabel = nil;
    _totalTimeLabel = nil;

}
#pragma mark - CLick
-(void)backClick{
    NSLog(@"返回");
    [self.player pause];
    [self removeFromAllview];
    [self set_delegateClickType:backClickType];
}
-(void)dlanClick{
    NSLog(@"投屏");
    [self.player pause];
    [self addSubview:self.gsDLNAView];
    self.gsDLNAView.playUrl = gsPlayUrl;
    self.gsDLNAView.listIndex = self.playIndex;
    [self.gsDLNAView startSearchDLNA];
}

-(void)playClick{
    [self playOrPause];
}
-(void)leftPlayClick{
    GSLog(@"上一首");
    self.playIndex --;
    if(self.playIndex < 0){
        self.playIndex = 0;
        GSLog(@"没有上一首");
          [self.player pause];
         [self.coverPictureNode stopAnimating];
        [self set_delegateClickType:leftClickType];

    }else{
        [self resetPlayer];
        [self playListIndex:self.playIndex];
    }
}
-(void)rightPlayClick{
    GSLog(@"下一首");
    self.playIndex ++;
    if (self.playIndex >= self.playDataArr.count) {
        self.playIndex = self.playDataArr.count-1;
        GSLog(@"没有下一首");
        [self.player pause];
        [self.coverPictureNode stopAnimating];
        [self set_delegateClickType:rightClickType];

    }else{
        [self resetPlayer];
        [self playListIndex:self.playIndex];
    }

}
-(void)cycleReplayClick:(UIButton *)btn{
    if (self.isCycleReplay == YES) {
        [btn setImage:[UIImage imageNamed:@"icon_tv_circle"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"icon_music_singlecircle"] forState:UIControlStateNormal];
    }
    self.isCycleReplay = !self.isCycleReplay;
}
-(void)lrcPlayClick:(UIButton *)btn{
    [self showImageBrowser];
    [self set_delegateClickType:lrcClickType];
}
-(void)likePlayClick:(UIButton *)btn{
    if (btn.selected == NO) {
        [btn setImage:[UIImage imageNamed:@"icon_period_like2"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"icon_period_like1"] forState:UIControlStateNormal];
    }
    btn.selected = !btn.selected;
    [self set_delegateClickType:likeClickType];
}
-(void)downloadClick:(UIButton *)btn{
    GSLog(@"下载 %@\n%@",self.titleLable.text,gsPlayUrl);
//    if ([DownloadDataManager isisExistAppForUrl:gsPlayUrl] == YES) {
    
        [DownLoadManager start:gsPlayUrl Name:self.titleLable.text progressBlock:^(CGFloat progress) {
            NSLog(@"%@",[NSString stringWithFormat:@"%.00f%%",progress * 100]);
        }];

//    }else{
//        
//    }
  
    
}
#pragma mark - 获取要展示的图片
-(void)showImageBrowser{
   
}

#pragma mark - 数据集合下标重置（防崩溃）
-(NSInteger)protectionListIndexMaxCount:(NSInteger)count{
    if (self.playIndex < 0) {
       return self.playIndex = 0;
    }else if(self.playIndex >= self.playDataArr.count){
      return self.playIndex = self.playDataArr.count-1;
    }
    return count;
}
-(void)playListClick{
    [self.player pause];
//    if ([self.delegate respondsToSelector:@selector(gs_playListClick)]) {
//        [self.delegate gs_playListClick];
//    }
    [self addSubview:self.playlistView];
    [_playlistView setPlayListData:self.playDataArr];
}
#pragma mark - delegate(代理实现)
-(void)mylistCell_didSelectRowAtIndexPath:(NSInteger)index{
    self.playIndex = index;
    [self playListIndex:index];
}
-(void)myplaylistRequestLoadPage:(NSInteger)page{
    if ([self.delegate respondsToSelector:@selector(gs_RequestFreshloadViewPage:listIndex:)]) {
        [self.delegate gs_RequestFreshloadViewPage:page listIndex:self.playIndex];
    }
}
-(void)gs_dlnaStartPlay:(NSString *)serviceName listIndex:(NSInteger)listIndex{
    if ([self.delegate respondsToSelector:@selector(gs_playVideoWithDLNAStartPlay:listIndex:)])
    {
        [self.delegate gs_playVideoWithDLNAStartPlay:serviceName listIndex:listIndex];
    }
}
-(void)set_delegateClickType:(ClickType)type{
    if ([self.delegate respondsToSelector:@selector(gs_playWithClick:)]) {
        [self.delegate gs_playWithClick:type];
    }
}

#pragma mark - CreateUI
-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    }
    return _topView;
}
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"icon_subject_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel];
    }
    return _backButton;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.text = @"音频名称";
        _titleLable.textColor = [UIColor whiteColor];
        _titleLable.font = [UIFont systemFontOfSize:__kNewSize(17*2)];
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}
-(UILabel *)bodyLable{
    if (!_bodyLable) {
        _bodyLable = [[UILabel alloc]init];
//        _bodyLable.text = @"副标题名称啦啦啦啦啦啦绿绿绿啦啦啦啦啦啦lalalalallala";
        _bodyLable.textColor = [UIColor whiteColor];
        _bodyLable.font = [UIFont systemFontOfSize:__kNewSize(14*2)];
        _bodyLable.textAlignment = NSTextAlignmentCenter;
    }
    return _bodyLable;
}
-(UIButton *)dlnaButton{
    if (!_dlnaButton) {
        _dlnaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dlnaButton setImage:[UIImage imageNamed:@"icon_tv_s2l"] forState:UIControlStateNormal];
        [_dlnaButton addTarget:self action:@selector(dlanClick) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel];
    }
    return _dlnaButton;
}

-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"icon_tv_play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}
-(UIButton *)leftPlayButton{
    if (!_leftPlayButton) {
        _leftPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftPlayButton setImage:[UIImage imageNamed:@"icon_tv_last"] forState:UIControlStateNormal];
        [_leftPlayButton addTarget:self action:@selector(leftPlayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftPlayButton;
}
-(UIButton *)rightPlayButton{
    if (!_rightPlayButton) {
        _rightPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightPlayButton setImage:[UIImage imageNamed:@"icon_tv_next"] forState:UIControlStateNormal];
        [_rightPlayButton addTarget:self action:@selector(rightPlayClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightPlayButton;
}
-(UIButton *)replayBtn{
    if (!_replayBtn) {
        UIButton *replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [replayBtn setImage:[UIImage imageNamed:@"replay"] forState:UIControlStateNormal];
        replayBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        [replayBtn setTitle:@"重播" forState:UIControlStateNormal];
        [replayBtn setTitleColor:[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1.0] forState:UIControlStateNormal];
        replayBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        replayBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [replayBtn addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
        replayBtn.frame = CGRectMake(0, 0, 200, 155);
        replayBtn.center = self.center;
        _replayBtn = replayBtn;
    }
    return _replayBtn;
}
-(UIView *)cover{
    if (!_cover) {
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor blackColor];
        cover.alpha = 0.2;
        _cover = cover;
    }
    return _cover;
}
-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1];
    }
    return _bottomView;
}
//当前播放时间
- (UILabel *) currentTimeLabel{
    if (_currentTimeLabel == nil){
        _currentTimeLabel                           = [[UILabel alloc] init];
        _currentTimeLabel.textColor                 = [UIColor whiteColor];
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
        _currentTimeLabel.text                      = @"00:00";
        _currentTimeLabel.textAlignment             = NSTextAlignmentCenter;
        _currentTimeLabel.font = [UIFont systemFontOfSize:__kNewSize(12*2)];

    }
    return _currentTimeLabel;
}
//总时间
- (UILabel *) totalTimeLabel{
    if (_totalTimeLabel == nil){
        _totalTimeLabel                           = [[UILabel alloc] init];
        _totalTimeLabel.textColor                 = [UIColor whiteColor];
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
        _totalTimeLabel.text                      = @"00:00";
        _totalTimeLabel.textAlignment             = NSTextAlignmentCenter;
        _totalTimeLabel.font = [UIFont systemFontOfSize:__kNewSize(12*2)];
    }
    return _totalTimeLabel;
}
//缓冲条
- (UIProgressView *) loadedView{
    if (!_loadedView){
        _loadedView = [[UIProgressView alloc] init];
        _loadedView.progressViewStyle = UIProgressViewStyleDefault;
        _loadedView.trackTintColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
        _loadedView.progressTintColor = [[UIColor whiteColor]colorWithAlphaComponent:0.4];

    }
    return _loadedView;
}
-(GSSlider *)progressSlider{
    if (!_progressSlider) {
        GSSlider * slider = [[GSSlider alloc]init];
//        // slider开始滑动事件
//        [slider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
//        // slider滑动中事件
//        [slider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        // slider结束滑动事件
        [slider addTarget:self action:@selector(progressDragEnd:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
//        //小于当前滑动的颜色
        slider.minimumTrackTintColor=[UIColor colorWithHexString:@"#FFD454"];
//        //大于当前滑动的颜色
        slider.maximumTrackTintColor= [[UIColor whiteColor]colorWithAlphaComponent:0.2];
//        //当前滑动值的颜色
        slider.thumbTintColor=[UIColor colorWithHexString:@"#FFD454"];

        _progressSlider = slider;
 
    }
    return _progressSlider;
}


-(UIButton *)sharpnessButton{
    if (!_sharpnessButton) {
        _sharpnessButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sharpnessButton setTitle:@"高清" forState:UIControlStateNormal];
        [_sharpnessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sharpnessButton.backgroundColor = [UIColor redColor];
        //        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sharpnessButton;
}

-(UIButton *)cycleButton{
    if (!_cycleButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_tv_circle"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cycleReplayClick:) forControlEvents:UIControlEventTouchUpInside];
        _cycleButton = button;
    }
    return _cycleButton;
}
-(UIButton *)playListButton{
    if (!_playListButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_tv_list"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(playListClick) forControlEvents:UIControlEventTouchUpInside];
        _playListButton = button;
    }
    return _playListButton;
}
-(UIButton *)downloadButton{
    if (!_downloadButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
//        if ([DownloadDataManager isisExistAppForUrl:gsPlayUrl] == YES) {
//            [button setImage:[UIImage imageNamed:@"icon_music_order"] forState:UIControlStateNormal];
//            button.selected = NO;
//        }else{
//            [button setImage:[UIImage imageNamed:@"icon_tv_order"] forState:UIControlStateNormal];
//            button.selected = YES;
//        }
        [button setImage:[UIImage imageNamed:@"icon_tv_order"] forState:UIControlStateNormal];

        _downloadButton = button;
    }
    return _downloadButton;
}
-(UIButton *)playlrcButton{
    if (!_playlrcButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_period_word"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(lrcPlayClick:) forControlEvents:UIControlEventTouchUpInside];
        _playlrcButton = button;
    }
    return _playlrcButton;
}
-(UIButton *)playlikeButton{
    if (!_playlikeButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_period_like1"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(likePlayClick:) forControlEvents:UIControlEventTouchUpInside];
        _playlikeButton = button;
    }
    return _playlikeButton;
}
-(UILabel *)listLable{
    if (!_listLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"1/1";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:__kNewSize(12*2)];
        // 文字颜色
        label.textColor = [UIColor whiteColor];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = __kNewSize(22);
        label.layer.borderWidth =1.0f;
        label.layer.borderColor = [UIColor whiteColor].CGColor;
        _listLable = label;
    }
    return _listLable;
}
-(GSDLNAView *)gsDLNAView{
    if (!_gsDLNAView) {
        _gsDLNAView = [[GSDLNAView alloc]init];
        _gsDLNAView.delegate = self;
    }
    return _gsDLNAView;
}
- (GSLoadingView *)waitingView
{
    if (_waitingView == nil) {
        _waitingView = [[GSLoadingView alloc] init];
        _waitingView.hidesWhenStopped = NO;
    }
    return _waitingView;
}
-(GSCoverPictureNode *)coverPictureNode{
    if (!_coverPictureNode) {
        _coverPictureNode = [[GSCoverPictureNode alloc]init];
    }
    return _coverPictureNode;
}
-(GSplayListView *)playlistView{
    if (!_playlistView) {
        _playlistView  = [[GSplayListView alloc]init];
        _playlistView.delegate = self;
    }
    return _playlistView;
}
-(NSMutableArray *)playDataArr{
    if (!_playDataArr) {
       _playDataArr = [[NSMutableArray alloc]init];
    }
    return _playDataArr;
}

@end
