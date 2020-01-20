//
//  HistoryManager.h
//  GSDlna
//
//  Created by ios on 2020/1/20.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class History_FMDBDataModel;
NS_ASSUME_NONNULL_BEGIN

@interface HistoryManager : NSObject

@end
//模型
@interface History_FMDBDataModel : NSObject

@property (nonatomic,copy) NSString * title;//!<视频名
@property (nonatomic,copy) NSString * url;//!<历史地址
@property (nonatomic,copy) NSString * time;//!<记录时间

@end


NS_ASSUME_NONNULL_END
