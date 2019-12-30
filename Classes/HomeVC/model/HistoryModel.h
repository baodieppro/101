//
//  HistoryModel.h
//  GSDlna
//
//  Created by ios on 2019/12/11.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseModel.h"
@class HistoryItmeModel;
@class SearchHistoryItmeModel;
NS_ASSUME_NONNULL_BEGIN

@interface HistoryModel : BaseModel

@property (nonatomic,strong) NSArray * items;
//存
+(void)addCacheName:(NSString *)cacheName title:(NSString *)title url:(NSString *)url arr:(NSMutableArray *)arr;
//读
+(void)writeResponseDict:(id)responseObject dataArrName:(NSMutableArray *)arrName cacheName:(NSString *)cacheName;
//有没有收藏
+(BOOL)isFavoriteList:(NSMutableArray *)favoriteList url:(NSString *)url;

@end
@interface HistoryItmeModel : BaseModel

@property (nonatomic,strong) NSString * h_Id;
@property (nonatomic,strong) NSString * h_name;
@property (nonatomic,strong) NSString * h_image;
@property (nonatomic,strong) NSString * h_url;
@property (nonatomic,strong) NSString * item_time;
@property (nonatomic,strong) NSString * serction_time;

@property (nonatomic,assign) BOOL isSeleted;//!<选择


@end
@interface SearchHistoryItmeModel : BaseModel

@property (nonatomic,strong) NSString * h_Id;
@property (nonatomic,strong) NSString * keyword;
@property (nonatomic,strong) NSString * item_time;
@property (nonatomic,strong) NSString * serction_time;

//存
+(void)addCacheName:(NSString *)cacheName title:(NSString *)title arr:(NSMutableArray *)arr;
+(void)writeResponseDict:(id)responseObject dataArrName:(NSMutableArray *)arrName cacheName:(NSString *)cacheName;
@end
NS_ASSUME_NONNULL_END
