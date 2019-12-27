//
//  GS_CacheModel.h
//  SuperSearch
//
//  Created by 巩小鹏 on 2018/4/16.
//  Copyright © 2018年 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GS_CacheModel : NSObject


//=============================  FMDB_Model   =========================================

@property (nonatomic,copy) NSString * type;//!<类型
@property (nonatomic,copy) NSString * jsonStr;//!<数据
@property (nonatomic,copy) NSString * updateTime;//!<更新时间

@end
