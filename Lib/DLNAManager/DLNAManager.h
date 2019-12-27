//
//  DLNAManager.h
//  GSDlna
//
//  Created by ios on 2019/12/10.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MRDLNA/MRDLNA.h>

NS_ASSUME_NONNULL_BEGIN

@interface DLNAManager : NSObject
@property(nonatomic,strong) MRDLNA *dlnaManager;

@end

NS_ASSUME_NONNULL_END
