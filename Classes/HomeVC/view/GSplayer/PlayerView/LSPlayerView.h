//
//  LSPlayerView.h
//  LSPlayer
//
//  Created by ls on 16/3/8.
//  Copyright © 2016年 song. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSPlayerViewLocationType) {
    LSPlayerViewLocationTypeMiddle = 0, //中间
    LSPlayerViewLocationTypeTop, //顶部
    LSPlayerViewLocationTypeBottom, //底部
    LSPlayerViewLocationTypeDragging
    
};

typedef NS_ENUM(NSInteger, LSPlayerStatus) {
    LSPlayerStatusPlaying = 0,
    LSPlayerStatusPause,
    LSPlayerStatusStop,
    LSPlayerStatusReady,
    LSPlayerStatusFaild
    
};

@protocol MyLSPlayerViewDelegate <NSObject>

-(void)myPrefersStatusBarHidden:(BOOL)isHidden;

@end

@interface LSPlayerView : UIView
@property(nonatomic, assign) id<MyLSPlayerViewDelegate>delegate;

//视频URL
@property (nonatomic, copy) NSString* videoURL;

//返回按钮点击事件
@property (nonatomic, copy) void (^backBlock)();

//当前显示的frame
@property (nonatomic, assign) CGRect currentFrame;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView* tempSuperView;

//创建
+ (instancetype)playerView;
+(LSPlayerView *)instancePlayerView;

//播放器的展示位置
- (void)setLocationType:(LSPlayerViewLocationType)locationType;

#pragma mark - 关闭按钮点击事件
- (void)closeClick;
//- (void)playErrorFaild:(void (^)())failed;
@end
