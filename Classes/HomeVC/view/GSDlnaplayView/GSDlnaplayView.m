//
//  GSDlnaView.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/13.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSDlnaplayView.h"
#import "GSSlider.h"
#import "GSplayListView.h"

@interface GSDlnaplayView ()<DLNADelegate,MyGSplayListViewDelegate>
{
    NSString * gsPlayUrl;
    BOOL isPlayVideo;//!<是否只播放视频
}
@property(nonatomic,strong) LBManager *dlnaManager;
@property (nonatomic,strong) UIImageView * centerImager;//!<中间投屏图
@property (nonatomic,strong) UILabel * statusLable;//!<状态
@property (nonatomic,strong) UILabel * titleLable;//!<设备名
@property (nonatomic, strong) UIButton *playButton;//!<播放按钮
@property (nonatomic, strong) UIButton *leftPlayButton;//!<上一首
@property (nonatomic, strong) UIButton *rightPlayButton;//!<下一首
@property (nonatomic, strong) UIButton *cycleButton;//!<循环播放按钮
@property (nonatomic, strong) UIButton *playListButton;//!<播放列表按钮
@property (nonatomic,strong) UIButton * outPlayButton;//!<退出投屏
@property (nonatomic, strong) UILabel *currentTimeLabel;//!<当前播放时间
@property (strong, nonatomic) UILabel *totalTimeLabel;//!<视频时长
@property (strong, nonatomic) GSSlider *progressSlider;//!<
@property (strong, nonatomic) UIProgressView *loadedView;//!<进度条
@property (nonatomic,strong) UIButton * allPlayButton;//!<退出投屏
@property (nonatomic,strong) UIButton * videoPlayButton;//!<退出投屏

//播放列表
@property (nonatomic, strong) GSplayListView *playlistView;
@property (nonatomic, assign) bool isCycleReplay;//!<单曲循环
@end
@implementation GSDlnaplayView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self g_Init];
        [self g_CreateUI];
        [self g_LayoutFrame];
    }
    return self;
}

-(void)setServiceName:(NSString *)serviceName{
    _serviceName = serviceName;
    _titleLable.text = serviceName;
}
-(void)setPlayIndex:(NSInteger)playIndex{
    _playIndex = playIndex;
    _playlistView.playListIndex = playIndex;
    [self setListDataIndex:playIndex];
}
-(void)setPlayListData:(NSArray *)playListData{
    _playListData = playListData;
    _playlistView.playListData = playListData;
}
-(void)g_Init{
    self.dlnaManager = [LBManager sharedDLNAManager];
    self.dlnaManager.delegate = self;
    self.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"icon_tv_round"] forState:UIControlStateNormal];
    self.progressSlider.value = .0f;
    self.loadedView.progress = .0f;
    self.currentTimeLabel.text = @"00:00";
    self.totalTimeLabel.text = @"00:00";
    self.isCycleReplay = NO;
    isPlayVideo = NO;
}
-(void)g_CreateUI{
    [self addSubview:self.centerImager];
    [self addSubview:self.outPlayButton];
    [self addSubview:self.statusLable];
    [self addSubview:self.titleLable];
    [self addSubview:self.playListButton];
    [self addSubview:self.cycleButton];
    [self addSubview:self.playButton];
    [self addSubview:self.leftPlayButton];
    [self addSubview:self.rightPlayButton];
    [self addSubview:self.loadedView];
    [self addSubview:self.progressSlider];
    [self addSubview:self.totalTimeLabel];
    [self addSubview:self.currentTimeLabel];
    [self addSubview:self.allPlayButton];
    [self addSubview:self.videoPlayButton];

}
-(void)g_LayoutFrame{
    [_statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(40);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(24*2));
    }];
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLable.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(self);
        make.height.mas_equalTo(__kNewSize(20*2));
    }];
    [_centerImager mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.mas_bottom).mas_offset(__kNewSize(30*2));
        make.center.mas_equalTo(self);
        
    }];
    [_outPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(20);
        make.left.mas_equalTo(self).mas_offset(20);
//        make.size.mas_equalTo(CGSizeMake(188, 50));
    }];
    [_loadedView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-28);
        make.left.mas_equalTo(self.mas_left).mas_offset(__kNewSize(61*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(61*2));
        make.height.mas_equalTo(__kNewSize(6*2));
    }];
    //滑杆
    [_progressSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-28);
        make.left.mas_equalTo(self.mas_left).mas_offset(__kNewSize(61*2));
        make.right.mas_equalTo(self.mas_right).mas_offset(-__kNewSize(61*2));
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
   
    [_playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerImager.mas_bottom).mas_offset(35);
        make.centerX.mas_equalTo(self);
    }];
    [_leftPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.playButton.mas_left).mas_offset(-__kNewSize(24*2));
        make.centerY.mas_equalTo(self.playButton);
    }];
    [_rightPlayButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playButton.mas_right).mas_offset(__kNewSize(24*2));
        make.centerY.mas_equalTo(self.playButton);
    }];
    [_playListButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(115*2));
        make.right.mas_equalTo(self).mas_offset(-__kNewSize(21*2));
    }];
    [_cycleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.playListButton.mas_bottom).mas_offset(__kNewSize(20*2));
        make.centerX.mas_equalTo(self.playListButton);
    }];
    [_allPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(__kNewSize(20*2));
        make.right.mas_equalTo(self).mas_offset(-__kNewSize(20*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(100*2), __kNewSize(35*2)));
    }];
    [_videoPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allPlayButton.mas_bottom).mas_offset(__kNewSize(10*2));
        make.right.mas_equalTo(self).mas_offset(-__kNewSize(20*2));
        make.size.mas_equalTo(CGSizeMake(__kNewSize(100*2), __kNewSize(35*2)));
    }];
}
#pragma mark - 投屏代理回掉
-(void)dlna_lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus{
    switch (playStatus) {
        case LBLelinkPlayStatusCommpleted:
            {
                if (self.isCycleReplay == YES) {
                    if (_playIndex == self.playListData.count-1) {
                        _playIndex = 0;
                        [self setListDataIndex:self.playIndex];
                    }else{
                         [self rightPlayClick];
                    }
                }else{
                    [self rightPlayClick];
                }
            }
            break;
        case LBLelinkPlayStatusLoading:
            {
               
            }
            break;
        case LBLelinkPlayStatusPlaying:
            {
                
            }
            break;
        case LBLelinkPlayStatusPause:
            {
                
            }
            break;
        case LBLelinkPlayStatusError:
            {
                
            }
            break;
        default:
            break;
    }
}
-(void)dlna_lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo{
    self.currentTimeLabel.text = [NSString stringWithTime:progressInfo.currentTime];
    self.progressSlider.maximumValue = progressInfo.duration;
    self.progressSlider.value = progressInfo.currentTime;
    self.totalTimeLabel.text = [NSString stringWithTime:progressInfo.duration];
}
#pragma mark - 播放列表代理
-(void)mylistCell_didSelectRowAtIndexPath:(NSInteger)index{
    self.playIndex = index;
    [self setListDataIndex:_playIndex];
}
-(void)myplaylistRequestLoadPage:(NSInteger)page{
    if ([self.delegate respondsToSelector:@selector(gs_RequestFreshloadViewPage:listIndex:)]) {
        [self.delegate gs_RequestFreshloadViewPage:page listIndex:self.playIndex];
    }
}
#pragma mark - click
-(void)outDlanClick{
    [self.dlnaManager stop];
    if([self.delegate respondsToSelector:@selector(gs_outDLNAPlay)]){
        [self.delegate gs_outDLNAPlay];
    }
}
-(void)playClick:(UIButton *)btn{
    if (btn.selected == YES) {
        [self.playButton setImage:[UIImage imageNamed:@"icon_tv_stop"] forState:UIControlStateNormal];
        [self.dlnaManager pause];
      }else{
        [self.playButton setImage:[UIImage imageNamed:@"icon_tv_play"] forState:UIControlStateNormal];
        [self.dlnaManager resumePlay];
      }
    btn.selected = !btn.selected;
}

-(void)leftPlayClick{
    GSLog(@"上一首");
    self.playIndex --;
    if(self.playIndex < 0){
        self.playIndex = 0;
        [self gs_showTextHud:@" 已经是第一个了！"];
    }else{
        [self setListDataIndex:self.playIndex];
    }
}
-(void)rightPlayClick{
    GSLog(@"下一首");
    self.playIndex ++;
    if (self.playIndex >= self.playListData.count) {
        self.playIndex = self.playListData.count-1;
        [self gs_showTextHud:@"已经是最后一个了！"];
    }else{
        [self setListDataIndex:self.playIndex];
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
-(void)playListClick{
//    [self.dlnaManager pause];
    [self addSubview:self.playlistView];
    _playlistView.playListIndex = _playIndex;
    [_playlistView setPlayListData:self.playListData];
}
-(void)playAllStyleClick:(UIButton *)button{
    if (isPlayVideo == YES) {
        [_allPlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _allPlayButton.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        [_videoPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _videoPlayButton.backgroundColor = [UIColor clearColor];
        isPlayVideo = NO;

    }else{
        [_videoPlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _videoPlayButton.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        [_allPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allPlayButton.backgroundColor = [UIColor clearColor];
        isPlayVideo = YES;
    }
   
   
}
-(void)playViewStyleClick:(UIButton *)button{
    if (isPlayVideo == YES) {
        [_allPlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _allPlayButton.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        [_videoPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _videoPlayButton.backgroundColor = [UIColor clearColor];
        isPlayVideo = NO;
    }else{
        [_videoPlayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _videoPlayButton.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        [_allPlayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allPlayButton.backgroundColor = [UIColor clearColor];
         isPlayVideo = YES;
    }
    
   
}
#pragma mark - 进度条拖拽结束
- (void)progressDragEnd:(UISlider *)sender
{
    [self.dlnaManager setStartPosition:sender.value];
}


-(NSInteger)protectionListIndexMaxCount:(NSInteger)count{
    if (self.playIndex < 0) {
        return self.playIndex = 0;
    }else if(self.playIndex >= self.playListData.count){
        return self.playIndex = self.playListData.count-1;
    }
    return count;
}
#pragma mark - 播放投屏
-(void)setListDataIndex:(NSInteger)index{
    _playIndex = [self protectionListIndexMaxCount:index];
    [self new_DlnaPlay:[self setPlayVideoUrl:_playIndex]];

}
//是否跳过MP3,只播放视频
-(NSString *)setPlayVideoUrl:(NSInteger)index{
   
    return gsPlayUrl;
}
-(void)new_DlnaPlay:(NSString *)url{
    gsPlayUrl = url;
    [self.dlnaManager setLBLelinkPlayerItemPlayUrl:[self playVideoUrl_Sharpness:url]];  
}
-(NSString *)playVideoUrl_Sharpness:(NSString *)url{
    NSString *newUrl ;
    if ([self.dlnaManager isPlayType:url] == YES) {
        newUrl = [url stringByReplacingOccurrencesOfString:@".mp4"withString:@"_1280.mp4"];//替换
    }else{
        newUrl = url;
    }
    return newUrl;
}
#pragma mark - UI
-(UILabel *)statusLable{
    if (!_statusLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"正在投屏中";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:17];
        // 文字颜色
        label.textColor = [UIColor colorWithHexString:@"#999999"];

        _statusLable = label;
    }
    return _statusLable;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        // 创建对象
        UILabel *label = [[UILabel alloc] init];
        // 颜色
        label.backgroundColor = [UIColor clearColor];
        // 内容
        label.text = @"投屏中";
        // 对齐方式
        label.textAlignment =  NSTextAlignmentCenter;
        // 字体大小
        label.font = [UIFont systemFontOfSize:14];
        // 文字颜色
        label.textColor = [UIColor whiteColor];

        _titleLable = label;
    }
    return _titleLable;
}
-(UIImageView *)centerImager{
    if (!_centerImager) {
        UIImageView * imgaeView = [[UIImageView alloc]init];
        imgaeView.image = [UIImage imageNamed:@"bg_screen"];
        imgaeView.backgroundColor = [UIColor clearColor];
        _centerImager = imgaeView;
    }
    return _centerImager;
}
-(UIButton *)outPlayButton{
    if (!_outPlayButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"btn_screen"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(outDlanClick) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel];
        _outPlayButton = button;
    }
    return _outPlayButton;
}
-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"icon_tv_play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.selected = YES;
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
-(UIButton *)allPlayButton{
    if (!_allPlayButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(15*2)];
        [button setTitle:@"视音频教学" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#FFD454"];
        button.layer.cornerRadius =__kNewSize(35*2)/2;
        [button addTarget:self action:@selector(playAllStyleClick:) forControlEvents:UIControlEventTouchUpInside];
        _allPlayButton = button;
    }
    return _allPlayButton;
}
-(UIButton *)videoPlayButton{
    if (!_videoPlayButton) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:__kNewSize(15*2)];
        [button setTitle:@"视频教学" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.layer.cornerRadius =__kNewSize(35*2)/2;
        [button addTarget:self action:@selector(playViewStyleClick:) forControlEvents:UIControlEventTouchUpInside];
        _videoPlayButton = button;
    }
    return _videoPlayButton;
}
//-(GSplayListView *)playlistView{
//    if (!_playlistView) {
//        _playlistView  = [[GSplayListView alloc]init];
//        _playlistView.delegate = self;
//        _playlistView.styleType = self.styleType;
//        _playlistView.playListData = self.playListData;
//        _playlistView.playListIndex = _playIndex;
//    }
//    return _playlistView;
//}
@end
