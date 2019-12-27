//
//  PlayViewController.m
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "PlayViewController.h"
#import "GSPlayView.h"
#import "HistoryModel.h"

@interface PlayViewController ()<MyGSPlayViewDelegate>
@property (nonatomic,strong) GSPlayView *playerView;
@property (nonatomic,strong) NSMutableArray * playHistoryDataList;

@end

@implementation PlayViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    GSLog(@"path:%@",path);
    
    self.myView.backgroundColor = [UIColor colorWithHexString:@"#333333"];

    [self.playerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.myView);
    }];
    [self historyData];
    [self.playerView playWithPlayName:self.topName];
    [self.playerView playWithPlayInfo:self.playUrl];
    
}
-(void)historyData{
    static BOOL isHistory;
    if (self.playStyle == playStyleTypeNormal) {
        if (self.playHistoryDataList.count != 0) {
            for (HistoryItmeModel * model in self.playHistoryDataList) {
                if ([self.playUrl isEqualToString:model.h_url]) {
                    isHistory = NO;
                }else{
                    isHistory = YES;
                }
            }
        }else{
            isHistory = YES;
        }
       
        if (isHistory == YES) {
             [HistoryModel addCacheName:PLAY_History_Cache title:self.topName url:self.playUrl arr:self.playHistoryDataList];
        }
    }
}
#pragma mark -代理响应事件
-(void)gs_playWithClick:(ClickType)clickType{
    switch (clickType) {
        case backClickType:
            [self gs_BackClick];
            break;
        case leftClickType:

            break;
        case rightClickType:

            break;
        case likeClickType:
        {
            
        }
            break;
        case lrcClickType:
        {
           
            
        }
            break;
        default:
            break;
    }
}
-(void)gs_BackClick{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissVC];
    
}
#pragma mark - 投屏协议
-(void)gs_playVideoWithDLNAStartPlay:(NSString *)model listIndex:(NSInteger)listIndex{

}
#pragma mark - UI
-(GSPlayView *)playerView{
    if (!_playerView) {
        GSPlayView *playerView = [[GSPlayView alloc]init];
        playerView.leftConstraint = @(0);
        playerView.topConstraint = @(0);
//            playerView.widthConstraint = @(__kScreenWidth__);
//            playerView.heightConstraint = @(__kScreenHeight__);
            playerView.widthConstraint = @(__kScreenHeight__);
            playerView.heightConstraint = @(__kScreenWidth__);
        playerView.delegate = self;
        _playerView = playerView;
        [self.myView addSubview:_playerView];
        
    }
    return _playerView;
}
-(NSMutableArray *)playHistoryDataList{
    if (!_playHistoryDataList) {
        _playHistoryDataList = [[NSMutableArray alloc]init];
        //查询浏览器访问历史
        if ([EntireManageMent isExisedManager:PLAY_History_Cache]) {
            [HistoryModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent readCacheDataWithName:PLAY_History_Cache]] dataArrName:_playHistoryDataList cacheName:PLAY_History_Cache];
        }
    }
    return _playHistoryDataList;
}
@end
