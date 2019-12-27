//
//  HistoryModel.m
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel

#pragma mark - 数据映射与缓存
+(void)addCacheName:(NSString *)cacheName title:(NSString *)title url:(NSString *)url arr:(NSMutableArray *)arr
{
        [EntireManageMent removeCacheWithName:cacheName];
        if (!kStringIsEmpty(title)&&!kStringIsEmpty(url)) {
            //增加访问历史
            HistoryItmeModel * model = [[HistoryItmeModel alloc]init];
            model.h_Id = [NSString stringWithFormat:@"%ld",arr.count+1];
            model.h_name = title;
            model.h_url = url;
            
            model.isSeleted = NO;
            model.item_time = [GSTimeTools getCurrentTimes];
            model.serction_time = [GSTimeTools getPresentTime];
            [arr addObject:[EntireManageMent dicFromObject:model]];
        }
        HistoryModel * hmodel = [[HistoryModel alloc]init];
        hmodel.items = arr;
        [self writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent jsonStringWithDict:[EntireManageMent dicFromObject:hmodel]]] dataArrName:arr cacheName:cacheName];
    
    
   
}
+(void)writeResponseDict:(id)responseObject dataArrName:(NSMutableArray *)arrName cacheName:(NSString *)cacheName{
    if (responseObject != nil) {
        NSError *error;
        HistoryModel * model = [[HistoryModel alloc]initWithDictionary:responseObject error:&error];
        if (model.items.count != 0) {
            if (arrName.count != 0) {
                [arrName removeAllObjects];
            }
            for (NSDictionary *dict in model.items) {
                HistoryItmeModel * itemsModel = [[HistoryItmeModel alloc]initWithDictionary:dict error:&error];
                [arrName addObject:itemsModel];
            }
        }
        if (cacheName != nil) {
            //缓存
            //            NSString * jsonOne = [EntireManageMent onjson:responseObject];
            //            NSLog(@"jsonOne:%@",jsonOne);
            [EntireManageMent addCacheName:cacheName jsonString:[EntireManageMent onjson:responseObject] updataTime:nil];
        }
    }
}
+(BOOL)isFavoriteList:(NSMutableArray *)favoriteList url:(NSString *)url{
    if (favoriteList.count != 0) {
        for ( HistoryItmeModel * itemsModel in favoriteList) {
            if ([itemsModel.h_url isEqualToString:url]) {
                return YES;
            }
        }
    }
    return NO;
}
@end
@implementation HistoryItmeModel


@end
@implementation SearchHistoryItmeModel

+(void)addCacheName:(NSString *)cacheName title:(NSString *)title arr:(NSMutableArray *)arr
{
    [EntireManageMent removeCacheWithName:cacheName];
    if (title) {
        //增加访问历史
        SearchHistoryItmeModel * model = [[SearchHistoryItmeModel alloc]init];
        model.h_Id = [NSString stringWithFormat:@"%ld",arr.count+1];
        model.keyword = title;
        model.item_time = [GSTimeTools getCurrentTimes];
        model.serction_time = [GSTimeTools getPresentTime];
        [arr addObject:[EntireManageMent dicFromObject:model]];
        
    }
        HistoryModel * hmodel = [[HistoryModel alloc]init];
        hmodel.items = arr;
        [SearchHistoryItmeModel writeResponseDict:[EntireManageMent dictionaryWithJsonString:[EntireManageMent jsonStringWithDict:[EntireManageMent dicFromObject:hmodel]]] dataArrName:arr cacheName:cacheName];
    
   
}
+(void)writeResponseDict:(id)responseObject dataArrName:(NSMutableArray *)arrName cacheName:(NSString *)cacheName{
    if (responseObject != nil) {
        NSError *error;
        HistoryModel * model = [[HistoryModel alloc]initWithDictionary:responseObject error:&error];
        if (model.items.count != 0) {
            if (arrName.count != 0) {
                [arrName removeAllObjects];
            }
            for (NSDictionary *dict in model.items) {
                SearchHistoryItmeModel * itemsModel = [[SearchHistoryItmeModel alloc]initWithDictionary:dict error:&error];
                [arrName addObject:itemsModel];
            }
        }
        if (cacheName != nil) {
            //缓存
            //            NSString * jsonOne = [EntireManageMent onjson:responseObject];
            //            NSLog(@"jsonOne:%@",jsonOne);
            [EntireManageMent addCacheName:cacheName jsonString:[EntireManageMent onjson:responseObject] updataTime:nil];
        }
    }
}
@end
