//
//  BaseModel.h
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : JSONModel

//+(id) instanceFromJSONNSArray:(NSArray*)arr;

+(id) instanceFromJSONDictionary:(NSDictionary*) dic;

@end

NS_ASSUME_NONNULL_END
