//
//  GSBrightnessAndVolumeView.m
//  GSPlay
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import "GSBrightnessAndVolumeView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMusicPlayerController.h>

#define GSGridCount 16
#define GSProgressScale 15

@interface GSBrightnessEchoView : UIView
@property (nonatomic, strong) NSMutableArray *gridArray;
@property (nonatomic, weak) UIToolbar *toolbar;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, weak) UIView *brightnessProgressView;
@property (nonatomic, assign) CGFloat currentBrightness;

@end

@implementation GSBrightnessEchoView

// 回显View单例
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedBrightnessEchoView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 懒加载
- (NSMutableArray *)gridArray
{
    if (_gridArray == nil) {
        _gridArray = [NSMutableArray array];
    }
    return _gridArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 初始化亮度回显图标
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.alpha = .0f;
        
        // UIToolbar用做毛玻璃背景
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        toolbar.backgroundColor = [UIColor lightGrayColor];
        toolbar.alpha = 0.9;
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
        // 亮度回显图标标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
        titleLabel.textColor = [UIColor colorWithRed:66/255.0 green:66/255.0f blue:66/255.0 alpha:1.00f];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"亮度";
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        // 亮度回显图标背景图片
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.image = [UIImage imageNamed:@"playerBrightness"];
        [self addSubview:bgImageView];
        self.bgImageView = bgImageView;
        
        // 亮度回显图标进度条
        UIView *brightnessProgressView = [[UIView alloc] init];
        brightnessProgressView.backgroundColor = [UIColor colorWithRed:66/255.0 green:66/255.0f blue:66/255.0 alpha:1.00f];
        [self addSubview:brightnessProgressView];
        self.brightnessProgressView = brightnessProgressView;
        
        // KVO 监控亮度的变化
        [self addObserver];
        
        [self setupBrightnessGrid];
    }
    return self;
}

- (void)setupBrightnessGrid
{
    for (int i = 0; i < 16; i++) {
        UIView *grid = [[UIView alloc] init];
        grid.backgroundColor = [UIColor whiteColor];
        [self.brightnessProgressView addSubview:grid];
        [self.gridArray addObject:grid];
    }
    [self updateBrightnessGrid:[UIScreen mainScreen].brightness];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // toolbar毛玻璃背景布局
    self.toolbar.frame = self.bounds;
    
    // 标题布局
    self.titleLabel.frame = CGRectMake(0, 5, self.bounds.size.width, 30);
    
    // 亮度图标布局
    self.bgImageView.frame = CGRectMake(38, CGRectGetMaxY(self.titleLabel.frame) + 5, 79, 76);
    
    // 亮度进度条布局
    CGRect brightnessProgressViewRect = self.brightnessProgressView.frame;
    brightnessProgressViewRect.origin.x = 12;
    brightnessProgressViewRect.origin.y = CGRectGetMaxY(self.bgImageView.frame) + 16;
    brightnessProgressViewRect.size.width = self.bounds.size.width - 2 * 12;
    brightnessProgressViewRect.size.height = 7;
    self.brightnessProgressView.frame = brightnessProgressViewRect;
    
    // 亮度进度条内小格子布局
    CGFloat gridW = (self.brightnessProgressView.bounds.size.width - (GSGridCount + 1)) / GSGridCount;
    CGFloat gridH = 5;
    CGFloat gridY = 1;
    
    for (int i = 0; i < GSGridCount; i++) {
        CGFloat gridX = i * (gridW + 1) + 1;
        UIView *gridView = self.gridArray[i];
        gridView.frame = CGRectMake(gridX, gridY, gridW, gridH);
    }
}

// 添加观察者
- (void)addObserver
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    [mainScreen addObserver:self forKeyPath:@"brightness" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGFloat brightness = [change[@"new"] floatValue];
    [self updateBrightnessGrid:brightness];
}

// 更新亮度回显
- (void)updateBrightnessGrid:(CGFloat)brightness
{
    CGFloat stage = 1 / 16.0;
    NSInteger level = brightness / stage;
    for (int i = 0; i < self.gridArray.count; i++) {
        UIView *grid = self.gridArray[i];
        if (i <= level) {
            grid.hidden = NO;
        } else {
            grid.hidden = YES;
        }
    }
}

- (void)dealloc
{
    [self removeObserver:[UIScreen mainScreen] forKeyPath:@"brightness"];
}
@end


// 移动的方向 枚举类型
typedef enum {
    kGSMoveTypePortrait,  // 竖向滑动手势
    kGSMoveTypeLandscape, // 横向滑动手势
    kGSMoveTypeUnknow, // 未知手势
} GSMoveType;

@interface GSBrightnessAndVolumeView ()
@property (nonatomic, weak) UIView *brightnessView;
@property (nonatomic, weak) UIView *volumeView;
@property (nonatomic, assign) CGFloat currentBrightnessValue;
@property (nonatomic, assign) CGFloat currentVolumeValue;
@property (nonatomic, weak) UIView *brightnessEchoView;
@property (nonatomic, strong) UISlider* volumeViewSlider; // 获取MediaPlayer的Slider

@end

@implementation GSBrightnessAndVolumeView

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

+ (instancetype)sharedBrightnessAndAudioView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 初始化 加入亮度View和音量View
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        // 获取系统音量
        [self configureVolume];
        // 初始化左边一半的亮度调节的View
        UIView *brightnessView = [[UIView alloc] init];
        brightnessView.backgroundColor = [UIColor clearColor];
        self.brightnessView = brightnessView;
        [self addSubview:brightnessView];

        // 初始化右边的音量调节的View
        UIView *volumeView = [[UIView alloc] init];
        volumeView.backgroundColor = [UIColor clearColor];
        [self addSubview:volumeView];
        self.volumeView = volumeView;
        
        // 添加手势识别器
        [self addPanGesture];
//        [BrightnessView sharedBrightnessView];

        // 初始化音量回显图标
        GSBrightnessEchoView *brightnessEchoView = [GSBrightnessEchoView sharedBrightnessEchoView];
        [self addSubview:brightnessEchoView];
        [self bringSubviewToFront:brightnessEchoView];
        self.brightnessEchoView = brightnessEchoView;
    
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
     //布局亮度调节View
    [self.brightnessView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(self.bounds.size.width * 0.5);
    }];
    
    // 布局BrightnessEchoView
    [self.brightnessEchoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(155.0);
        make.center.equalTo([UIApplication sharedApplication].keyWindow);
    }];
    
     //布局音量调节View
    [self.volumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.mas_equalTo(self.bounds.size.width * 0.5);
    }];
}

- (void)addPanGesture
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(decideWhatToChange:)];
    [self addGestureRecognizer:panGesture];
}



// 通过pan拖拽时的移动位置的绝对值判断手势类型 |pointT.x| > |pointT.y| 横向手势  |pointT.y| < |pointT.x| 竖向手势
- (GSMoveType)judgeMoveType:(UIPanGestureRecognizer *)sender
{
    CGPoint pointT = [sender translationInView:self];
    CGFloat deltaTX = fabs(pointT.x);
    CGFloat deltaTY = fabs(pointT.y);
    if (MAX(deltaTX, deltaTY) < 20) return kGSMoveTypeUnknow;
    if (deltaTX > deltaTY) {
        return kGSMoveTypeLandscape;
    } else return kGSMoveTypePortrait;
}

// 通过相应的手势执行相应的操作
- (void)decideWhatToChange:(UIPanGestureRecognizer *)sender
{
    CGPoint p = [sender locationInView:self];
    
    if ([self judgeMoveType:sender] == kGSMoveTypePortrait) {
        if (CGRectContainsPoint(self.brightnessView.frame, p)) {
            [self brightnessChange:sender];
        } else if (CGRectContainsPoint(self.volumeView.frame, p)) {
            [self volumeChange:sender];
        }
    } else if ([self judgeMoveType:sender] == kGSMoveTypeLandscape) {
        [self progressChange:sender handle:self.progressChangeHandle];
    } else if ([self judgeMoveType:sender] == kGSMoveTypeUnknow) return;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if ([self judgeMoveType:sender] == kGSMoveTypePortrait) {
            self.progressPortraitEnd();
        }
        if ([self judgeMoveType:sender] == kGSMoveTypeLandscape) {
            self.progressLandscapeEnd();
        }
    }
}
//调节亮度
- (void)brightnessChange:(UIPanGestureRecognizer *)recognizer
{
    CGPoint panPoint = [recognizer translationInView:self.brightnessView];
    CGFloat delta = - panPoint.y / (recognizer.view.bounds.size.height) * 0.5;
    self.currentBrightnessValue = [UIScreen mainScreen].brightness;
    if (self.currentVolumeValue < 0) self.currentVolumeValue = 0;
    [[UIScreen mainScreen] setBrightness:self.currentBrightnessValue + delta];
    [UIView animateWithDuration:.2f animations:^{
        [self showBrightnessEchoView];
    } completion:^(BOOL finished) {
        [self autoFadeoutBrightnessEchoView];
    }];
    
}

- (void)progressChange:(UIPanGestureRecognizer *)sender handle:(void(^)(CGFloat))handle
{
    CGPoint panPoint = [sender translationInView:self.brightnessView];
    CGFloat delta = panPoint.x / GSProgressScale;
    handle(delta);
}

- (void)showBrightnessEchoView
{
    self.brightnessEchoView.alpha = 1.f;
}

- (void)hideBrightnessEchoView
{
    [UIView animateWithDuration:.5f animations:^{
        self.brightnessEchoView.alpha = .0f;
    }];
}

- (void)autoFadeoutBrightnessEchoView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideBrightnessEchoView) withObject:self afterDelay:3.f];
}
//调节音量
- (void)volumeChange:(UIPanGestureRecognizer *)sender
{
    CGPoint veloctyPoint  = [sender velocityInView:self];
    [self verticalMoved:veloctyPoint.y];
    
}
#pragma mark -滑动调节音量和亮度
- (void)verticalMoved:(CGFloat)value {
    (self.volumeViewSlider.value -= value / 10000);
}
#pragma mark - 获取系统音量
- (void)configureVolume {
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    _volumeViewSlider        = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}


- (void)dealloc
{
    [[UIScreen mainScreen] removeObserver:self forKeyPath:@"brightness"];
}

@end
