//
//  LBManager.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/28.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LBLelinkKit/LBLelinkKit.h>
#import <MRDLNA/MRDLNA.h>

NS_ASSUME_NONNULL_BEGIN


@protocol GSDLNADelegate <NSObject>

@optional
/**
 DLNA局域网搜索设备结果
 @param devicesArray  搜索到的设备 名称
 */
- (void)gs_searchDLNAResult:(NSArray *)devicesArray;
/**
 搜索失败
 */
- (void)gs_searchDLNAError:(NSError *)error;

/**
 投屏成功开始播放
 */
- (void)dlnaStartPlay_new;
/**
 退出投屏成功
 */
- (void)dlnaEndPlay;
/**
 投屏失败
 */
- (void)dlnaErrorPlay;
/**
 播放状态代理回调
 */
- (void)dlna_lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus;
/**
 播放进度信息回调
 */
- (void)dlna_lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo;
// 播放错误代理回调，根据错误信息进行相关的处理
- (void)dlna_lelinkPlayer:(LBLelinkPlayer *)player onError:(NSError *)error;


@end
@interface LBManager : NSObject

@property(nonatomic,weak)id<GSDLNADelegate> delegate;

@property (nonatomic,strong) LBLelinkBrowser * lelinkBrowser;
@property (nonatomic,strong) LBLelinkConnection * lelinkConnection;
@property (nonatomic,strong) LBLelinkPlayer * player;
@property (nonatomic,strong) LBLelinkPlayerItem * item ;
@property (nonatomic,strong) NSArray<LBLelinkService *> *services;

@property(nonatomic,strong) MRDLNA *dlnaManager;
@property(nonatomic,assign) BOOL isLBResult;//乐播投屏授权成功：yes 失败：no
@property (nonatomic,strong) NSArray<CLUPnPDevice *> *serviceList;

//初始化配置
+(void)newLBManager;

+ (LBManager *)sharedDLNAManager;

/**
 搜索投屏服务
 */
-(void)searchService;
/**
 结束搜索投屏服务
 */
-(void)endService;

#pragma mark - 建立连接
/**
 初始化建立链接
 @param index 投放设备list下标
 */
-(void)startLBLelinkConnection:(NSInteger)index;
/**
 初始化建立链接
 @param service 服务信息
 */
-(void)startLBLelinkConnectionService:(LBLelinkService *)service;

/**
 开始链接
 */
-(void)startConnect;
/**
 结束连接
 */
-(void)endConnect;



#pragma mark - 播放控制
/**
 初始化播放
 @param playUrl 播放地址
 */
-(void)setLBLelinkPlayerItemPlayUrl:(NSString *)playUrl;
/**
 初始化播放
 @param playUrl 播放地址
 @param startPosition 播放进度 （秒）
 */
-(void)setLBLelinkPlayerItemPlayUrl:(NSString *)playUrl startPosition:(NSInteger)startPosition;
/**
 进度调节
 @param startPosition 调节进度的位置，单位秒
 */
-(void)setStartPosition:(NSInteger)startPosition;
//判断是音频还是视频
-(BOOL)isPlayType:(NSString *)playUrl;

/**
 播放
 */
-(void)play;
/**
 暂停播放
 */
- (void)pause;

/**
 继续播放
 */
- (void)resumePlay;

/**
 进度调节
 
 @param seekTime 调节进度的位置，单位秒
 */
- (void)seekTo:(NSInteger)seekTime;

/**
 退出播放
 */
- (void)stop;

/**
 设置音量值
 
 @param value 音量值，范围0 ~ 100
 */
- (void)setVolume:(NSInteger)value;

/**
 增加音量
 */
- (void)addVolume;

/**
 减小音量
 */
- (void)reduceVolume;


@end

NS_ASSUME_NONNULL_END
