//
//  GSStaticModel.h
//  TestPods
//
//  Created by 巩小鹏 on 2019/4/29.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSStaticModel : NSObject
    + (instancetype)newModel;
    /**
     *  web前进或者后退 1:后退 0:前进
     */
    @property (nonatomic,strong) NSString *  goIsBack;//!<前进还是后退
@end

NS_ASSUME_NONNULL_END
