//
//  GSPlayView.h
//  GSPlay
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MRDLNA/MRDLNA.h>

typedef NS_ENUM(NSInteger,PlayType){
    playVideoType = 0,       //!<视频类型
    playMusicType,     //!<音频类型
};
typedef NS_ENUM(NSInteger,DataType){
    playRequestType = 0,       //!<正常请求
    playCacheType,     //!<读缓存
};
typedef NS_ENUM(NSInteger,ScreenType){
      playHorizontalLayoutStyleType = 0,     //!<横屏
    playVerticalLayoutStyleType,       //!<竖屏
  
};
typedef NS_ENUM(NSInteger,ClickType){
    backClickType = 0,     //!<返回按钮
    leftClickType,       //!<左切换按钮
    rightClickType,       //!<右切换按钮
    playListClickType,       //!<播放列表按钮
    lrcClickType,       //!<歌词按钮
    likeClickType,       //!<收藏按钮

};
@protocol MyGSPlayViewDelegate <NSObject>

//-(void)gs_BackClick;//!<返回上一级
//-(void)gs_leftClick;//!<向左切换
//-(void)gs_rightClick;//!<向右切换
//-(void)gs_playListClick;

-(void)gs_playWithClick:(ClickType)clickType;//!<响应事件代理

-(void)gs_playVideoWithDLNAStartPlay:(NSString *)model listIndex:(NSInteger)listIndex;//!<投屏成功 开始播放
-(void)gs_RequestFreshloadViewPage:(NSInteger)page listIndex:(NSInteger)index;

@end

@interface GSPlayView : UIView
@property(nonatomic, assign) id<MyGSPlayViewDelegate>delegate;

@property (nonatomic, assign) PlayType playType;//!<播放类型
@property (nonatomic, assign) DataType dataType;//!<数据读取类型
@property (nonatomic, assign) ScreenType screenType;//!<展示样式
@property (nonatomic,assign) PlayStyleType playStyle;//!<数据打开方式

@property (nonatomic, strong) NSNumber *leftConstraint;
@property (nonatomic, strong) NSNumber *topConstraint;
@property (nonatomic, strong) NSNumber *widthConstraint;
@property (nonatomic, strong) NSNumber *heightConstraint;

- (void)playWithPlayName:(NSString *)name;
- (void)playWithPlayInfo:(NSString *)playInfo;
- (void)playWithPlayInfoDataArr:(NSArray *)playInfo indexPage:(NSInteger)pageIndex;
- (void)playListIndex:(NSInteger)index;

- (void)replay;


@end
