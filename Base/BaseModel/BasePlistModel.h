//
//  BasePlistModel.h
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/29.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BasePlistModel : BaseModel

@end
@interface SetPlistModel : BaseModel
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * img;
@property (nonatomic,strong) NSString * isSel;
@property (nonatomic,strong) NSString * type;

@end

NS_ASSUME_NONNULL_END
