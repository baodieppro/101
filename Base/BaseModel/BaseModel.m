//
//  BaseModel.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

//使用kvc时，如果代码中的key值不存在，会抛出异常，可以在类中通过重写它提供下面的这个方法来解决这个问题。
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(id) instanceFromJSONDictionary:(NSDictionary*) dic{
    
    id instance;
    
    instance = [[self alloc] initWithDictionary:dic error:nil];
    
    return instance;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"cc_id",
                                                       }];
}
@end
