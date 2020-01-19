//
//  UMConfigInstance.m
//  DSBrowser
//
//  Created by 巩小鹏 on 2016/11/24.
//  Copyright © 2016年 巩小鹏. All rights reserved.
//

#import "GSUMConfigInstance.h"

@implementation GSUMConfigInstance
+(void)newGSUMConfigInstance{
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
}
+(void)newGSmobClickEcentID:(NSString *)clickEventId typeName:(NSString *)name quantityTitle:(NSString *)title{
    NSDictionary *dict = @{name : title};
    [MobClick event:clickEventId attributes:dict];
}
+(void)newGSmobClickEcentID:(NSString *)clickEventId dict:(NSDictionary *)dict{
    [MobClick event:clickEventId attributes:dict];
}
+(void)newGSprofileSignInWithPUID:(NSString *)puid name:(NSString *)name{
    [MobClick profileSignInWithPUID:puid provider:name];
}
+(void)newGSevent:(NSString *)eventId{
    [MobClick event:eventId];
}
+(void)newBeginLogPageView:(NSString *)viewName{
    [MobClick beginLogPageView:viewName];
}
+(void)newEndLogPageView:(NSString *)viewName{
    [MobClick endLogPageView:viewName];
}
@end
