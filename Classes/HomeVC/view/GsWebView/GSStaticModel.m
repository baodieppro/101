//
//  GSStaticModel.m
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "GSStaticModel.h"
static id _newGS;
@implementation GSStaticModel
+ (instancetype)newModel{
    static dispatch_once_t towToken;
    dispatch_once(&towToken, ^{
        _newGS = [[[self class] alloc] init];
    });
    return _newGS;
}
@end
