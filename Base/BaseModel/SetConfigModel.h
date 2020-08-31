//
//  SetConfigModel.h
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/29.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define __isTrace__                    [[SetConfigManager sharedManager] getUserInfo].isTrace
#define __isRecord__                   [[SetConfigManager sharedManager] getUserInfo].isRecord
#define __isFullScreen__               [[SetConfigManager sharedManager] getUserInfo].isFullScreen
#define __isUserId__                   [[SetConfigManager sharedManager] isExistUserId:__isFullScreen__]

NS_ASSUME_NONNULL_BEGIN

@interface SetConfigModel : BaseModel
@property (nonatomic,strong) NSString * isTrace;//!<无痕浏览
@property (nonatomic,strong) NSString * isRecord;//!<最后浏览页面
@property (nonatomic,strong) NSString * isFullScreen;//!<全屏
@end
@interface SetConfigManager : NSObject

+ (SetConfigManager *)sharedManager;
#pragma mark - 初始化
-(void)initManager;
- (void)insertUserInfo:(SetConfigModel*)model;
//更新数据
-(void)updataModel:(SetConfigModel *)model;

//当前登录用户操作
- (SetConfigModel *)getUserInfo;
- (void)deleteUserInfo;

- (NSArray<SetConfigModel *> *)getAllUserInfo;
- (void)deleteAllUserInfo;
- (BOOL)isExistUserId:(NSString *)isFullScreen;

@end
NS_ASSUME_NONNULL_END
