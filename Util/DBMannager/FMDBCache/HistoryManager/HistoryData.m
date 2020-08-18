//
//  HistoryData.m
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/14.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "HistoryData.h"

@implementation HistoryData
#pragma mark - 储存历史缓存数据

+(void)addHistoryData:(NSDictionary *)dict{
    BOOL _isExised;
    BOOL _isExisedUrl;
    //无痕浏览
        [self addTimeDay];
        History_FMDBDataModel * hisModel = [[History_FMDBDataModel alloc]init];
        hisModel.historyId = [dict objectForKey:@"historyId"];
        hisModel.title = [dict objectForKey:@"title"];
        hisModel.url = [dict objectForKey:@"url"];
        hisModel.time = [GSTimeTools getPresentTime];
        hisModel.detailedTime = [GSTimeTools getCurrentTimes];
        hisModel.isSeleted =  @"0";

        if (![hisModel.title isEqualToString:@""] && ![hisModel.url isEqualToString:@""] ) {
            
            _isExised  = [[HistoryManager historyManager] isExistAppForTime:[GSTimeTools getCurrentTimes]];
            if (_isExised == NO) {
                _isExisedUrl  = [[HistoryManager historyManager] isExistAppForName:hisModel.url];
                if (_isExisedUrl == NO) {
                    [[HistoryManager historyManager] insertModel:hisModel];
                                  GSLog(@"====================================哔哩吧啦,历史存进去了=========================================");
                    
                }else{
                    [[HistoryManager historyManager] updataExistNewModel:hisModel complete:^{
                                                GSLog(@"====================修改浏览历史成功");
                    } failed:^{
                                                GSLog(@"====================修改浏览历史失败");
                        
                    }];
                }
                
                
            }else if (_isExised ==YES){
                                GSLog(@"已有相同历史");
                
            }
            //            [STCModel stcModel].isHistory = 1;
        }else{
            //            [STCModel stcModel].isHistory = 0;
        }
    
    
    
}
+(void)addTimeDay{
    BOOL _isExised;
    TimeModel * timeModel = [[TimeModel alloc]init];
    timeModel.time = [GSTimeTools getCurrentTimes];
    timeModel.day = [GSTimeTools getPresentTime];
    _isExised  = [[TimeManager timeManager] isExistAppForName:timeModel.day];
    
    if (_isExised == NO) {
        [[TimeManager timeManager] insertModel:timeModel];
    }else if (_isExised ==YES){
                GSLog(@"已经存过时间了笨蛋");
    }
}
+(NSInteger)allCount{
    return [[HistoryManager historyManager] allTimeArray].count;
}
+(NSInteger)readDayCount{
    return [[HistoryManager historyManager] timeModelArrayfromeKey:[GSTimeTools getCurrentTimes] classificationId:@"1"];
}
@end
