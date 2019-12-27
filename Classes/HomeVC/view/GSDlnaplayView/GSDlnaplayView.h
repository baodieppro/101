//
//  GSDlnaView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/9/13.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "BaseView.h"
//#import <MRDLNA/MRDLNA.h>
@protocol MyGSDlnaViewDelegate <NSObject>

-(void)gs_outDLNAPlay;//!<退出投屏
//-(void)gs_pauseDLNA:(BOOL)isplayOrPause;//!<暂停/播放
-(void)gs_RequestFreshloadViewPage:(NSInteger)page listIndex:(NSInteger)index;

@end
@interface GSDlnaplayView : BaseView
@property(nonatomic, assign) id<MyGSDlnaViewDelegate>delegate;
@property (nonatomic,strong) NSString *serviceName;
@property (nonatomic,strong) NSArray *playListData;
@property (nonatomic, assign) NSInteger playIndex;//!<当前播放数据下标

@end
