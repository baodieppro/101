//
//  LBManager.m
//  CCQMEnglish
//
//  Created by Roger on 2019/10/28.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "LBManager.h"

NSString * const LBAPPID = @"12640";                                    // APP id
NSString * const LBSECRETKEY = @"f957a543807a05b620857b877021320d";     // 密钥

@interface LBManager ()<LBLelinkBrowserDelegate,LBLelinkConnectionDelegate,LBLelinkPlayerDelegate,DLNADelegate>


@end

@implementation LBManager
+(void)newLBManager{
        [LBLelinkKit enableLog:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError * error = nil;
        BOOL result = [LBLelinkKit authWithAppid:LBAPPID secretKey:LBSECRETKEY error:&error];
        [self sharedDLNAManager].isLBResult = result;
        if (result) {
            NSLog(@"授权成功");
    
        }else{
            NSLog(@"授权失败：error = %@",error);
        }
    });
}

static LBManager *instance = nil;
+ (LBManager *)sharedDLNAManager{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (self.isLBResult == YES) {
            [self setLBLelinkBrowser];
            [self setLBLelinkConnection];
            [self setLBLelinkPlayer];
            [self setplayItme];
        }else{
            [self newDlnaManager];
        }
      
    }
    return self;
}

//=============================================== 搜索服务 =========================================================================

#pragma mark - 搜索服务
-(void)setLBLelinkBrowser{
    self.lelinkBrowser = [[LBLelinkBrowser alloc] init];
    self.lelinkBrowser.delegate = self;
}
-(void)searchService{
    if (_isLBResult == YES) {
        [self.lelinkBrowser searchForLelinkService];
    }else{
        [self.dlnaManager startSearch];
    }

}
-(void)endService{
    if (_isLBResult == YES) {
        [self.lelinkBrowser stop];
    }else{
//        [self.dlnaManager startDLNAAfterStop];
    }
}
#pragma mark - LBLelinkBrowserDelegate

// 方便调试，错误信息会在此代理方法中回调出来
- (void)lelinkBrowser:(LBLelinkBrowser *)browser onError:(NSError *)error {
    NSLog(@"lelinkBrowser onError error = %@",error);
    if ([self.delegate respondsToSelector:@selector(gs_searchDLNAError:)]) {
        [self.delegate gs_searchDLNAError:error];
    }
    
}
-(void)searchDLNAWithError:(NSError *)error{
    if ([self.delegate respondsToSelector:@selector(gs_searchDLNAError:)]) {
        [self.delegate gs_searchDLNAError:error];
    }
}
// 搜索到服务时，会调用此代理方法，将设备列表在此方法中回调出来
// 注意：如果不调用stop，则当有服务信息和状态更新以及新服务加入网络或服务退出网络时，会调用此代理，将新的设备列表回调出来
- (void)lelinkBrowser:(LBLelinkBrowser *)browser didFindLelinkServices:(NSArray<LBLelinkService *> *)services {
    NSLog(@"搜索到设备数 %zd", services.count);
    self.services = services;
    NSMutableArray * serviceNames = [[NSMutableArray alloc]init];
    [services enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LBLelinkService * leService = (LBLelinkService *)obj;
        [serviceNames addObject:leService.lelinkServiceName];
    }];
    // 更新UI
    if ([self.delegate respondsToSelector:@selector(gs_searchDLNAResult:)]) {
        [self.delegate gs_searchDLNAResult:serviceNames];
    }
    
}

//====================================== 建立连接 ==================================================================================
#pragma mark - 建立连接

-(void)setLBLelinkConnection{
    self.lelinkConnection = [[LBLelinkConnection alloc] init];
    self.lelinkConnection.delegate = self;
}
-(void)startLBLelinkConnection:(NSInteger)index{
    if (self.isLBResult == YES) {
        self.lelinkConnection.lelinkService = self.services[index];
        [self startConnect];
    }else{
        CLUPnPDevice *model = self.serviceList[index];
        self.dlnaManager.device = model;
    }
   
}
-(void)startLBLelinkConnectionService:(LBLelinkService *)service{
    self.lelinkConnection.lelinkService = service;
    [self startConnect];
}
-(void)startConnect{
    [self.lelinkConnection connect];
}
-(void)endConnect{
    if (self.isLBResult == YES) {
        [self.lelinkConnection disConnect];
    }else{
        [self.dlnaManager startDLNAAfterStop];
    }
}

#pragma mark - LBLelinkConnectionDelegate

- (void)lelinkConnection:(LBLelinkConnection *)connection onError:(NSError *)error {
    if (error) {
        NSLog(@"LBLelinkConnection onError error = %@",error);
        if([self.delegate respondsToSelector:@selector(dlnaErrorPlay)]){
            [self.delegate dlnaErrorPlay];
        }
    }
}

- (void)lelinkConnection:(LBLelinkConnection *)connection didConnectToService:(LBLelinkService *)service {
    NSLog(@"已连接到服务：%@",service.lelinkServiceName);
    if ([self.delegate respondsToSelector:@selector(dlnaStartPlay_new)]) {
        [self.delegate dlnaStartPlay_new];
    }
}

- (void)lelinkConnection:(LBLelinkConnection *)connection disConnectToService:(LBLelinkService *)service {
    NSLog(@"已断开服务连接：%@",service.lelinkServiceName);
    
    if ([self.delegate respondsToSelector:@selector(dlnaEndPlay)]) {
        [self.delegate dlnaEndPlay];
    }
}

//====================================== 投屏及播放控制 ==================================================================================
#pragma mark - 投屏及播放控制
-(void)setLBLelinkPlayer{
    self.player = [[LBLelinkPlayer alloc] init];
    self.player.delegate = self;
}
-(void)setplayItme{
    self.item = [[LBLelinkPlayerItem alloc] init];
}
-(void)setLBLelinkPlayerItemPlayUrl:(NSString *)playUrl{
    if (self.isLBResult == YES) {
        [self setLBLelinkPlayerItemPlayUrl:playUrl startPosition:0];
    }else{
        self.dlnaManager.playUrl = playUrl;
        [self.dlnaManager startDLNA];
    }
}

-(void)setLBLelinkPlayerItemPlayUrl:(NSString *)playUrl startPosition:(NSInteger)startPosition{
    if (self.isLBResult == YES) {
        self.player.lelinkConnection = self.lelinkConnection;
        // 实例化媒体对象
        if ([self isPlayType:playUrl] == YES) {
            // 设置媒体类型
            self.item.mediaType = LBLelinkMediaTypeVideoOnline;
        }else{
            // 设置媒体类型
            self.item.mediaType = LBLelinkMediaTypeAudioOnline;
        }
        
        // 设置媒体的URL
        self.item.mediaURLString = playUrl;
        // 设置开始播放位置
        self.item.startPosition = startPosition?:0;
        // 推送
        [self.player playWithItem:self.item];
    }else{
        [self.dlnaManager setPlayUrl:playUrl];
        [self.dlnaManager dlnaPlay];
    }
   

}
/**
 进度调节
 @param startPosition 调节进度的位置，单位秒
 */
-(void)setStartPosition:(NSInteger)startPosition{
    [self.player seekTo:startPosition];
}
#pragma mark - 判断播放格式
-(BOOL)isPlayType:(NSString *)playUrl{
    if ([[playUrl pathExtension] isEqualToString:@"mp4"]) {
        return YES;
    }
    else if([[playUrl pathExtension] isEqualToString:@"mp3"])
    {
        return NO;
    }
    return YES;
}
#pragma mark - LBLelinkPlayerDelegate
// 播放错误代理回调，根据错误信息进行相关的处理
- (void)lelinkPlayer:(LBLelinkPlayer *)player onError:(NSError *)error {
    if (error) {
        NSLog(@"LBLelinkPlayer error: %@",error);
        if ([self.delegate respondsToSelector:@selector(dlna_lelinkPlayer:onError:)]) {
            [self.delegate dlna_lelinkPlayer:player onError:error];
        }
    }
}

// 播放状态代理回调
- (void)lelinkPlayer:(LBLelinkPlayer *)player playStatus:(LBLelinkPlayStatus)playStatus {
//    NSLog(@"%d",playStatus);
    // 根据状态设置播放器的UI
    if ([self.delegate respondsToSelector:@selector(dlna_lelinkPlayer:playStatus:)]) {
        [self.delegate dlna_lelinkPlayer:player playStatus:playStatus];
    }
}

// 播放进度信息回调
- (void)lelinkPlayer:(LBLelinkPlayer *)player progressInfo:(LBLelinkProgressInfo *)progressInfo {
//    NSLog(@"current time = %d, duration = %d",progressInfo.currentTime,progressInfo.duration);
    if ([self.delegate respondsToSelector:@selector(dlna_lelinkPlayer:progressInfo:)]) {
        [self.delegate dlna_lelinkPlayer:player progressInfo:progressInfo];
    }
}
/**
 播放
 */
-(void)play{
    [self.player play];
}
/**
 暂停播放
 */
- (void)pause{
    [self.player pause];
}

/**
 继续播放
 */
- (void)resumePlay{
    [self.player resumePlay];
}

/**
 进度调节
 
 @param seekTime 调节进度的位置，单位秒
 */
- (void)seekTo:(NSInteger)seekTime{
    [self.player seekTo:seekTime];
}

/**
 退出播放
 */
- (void)stop{
    [self.player stop];
}

/**
 设置音量值
 
 @param value 音量值，范围0 ~ 100
 */
- (void)setVolume:(NSInteger)value{
    [self.player setVolume:value];
}

/**
 增加音量
 */
- (void)addVolume{
    [self.player addVolume];
}

/**
 减小音量
 */
- (void)reduceVolume{
    [self.player reduceVolume];
}
#pragma mark - 乐播授权失败启用MRDLNA

-(void)newDlnaManager{
    self.dlnaManager = [MRDLNA sharedMRDLNAManager];
    self.dlnaManager.delegate = self;
}
- (void)searchDLNAResult:(NSArray *)devicesArray{
    NSLog(@"发现设备%@",devicesArray);
    self.serviceList = devicesArray;
    NSMutableArray * deviceNameList = [[NSMutableArray alloc] init];
    for (CLUPnPDevice *model  in devicesArray) {
        [deviceNameList addObject:model.friendlyName];
    }
    if ([self.delegate respondsToSelector:@selector(gs_searchDLNAResult:)]) {
        [self.delegate gs_searchDLNAResult:deviceNameList];
    }
}
-(void)dlnaStartPlay{
    if ([self.delegate respondsToSelector:@selector(dlnaStartPlay_new)]) {
        [self.delegate dlnaStartPlay_new];
    }
}
@end
