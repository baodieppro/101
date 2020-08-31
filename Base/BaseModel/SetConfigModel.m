//
//  SetConfigModel.m
//  GSDlna
//
//  Created by 巩少鹏 on 2020/8/29.
//  Copyright © 2020 GSDlna_Developer. All rights reserved.
//

#import "SetConfigModel.h"

@implementation SetConfigModel

@end
@interface SetConfigManager ()
@property (nonatomic,strong)NSMutableArray<SetConfigModel *> * users;
@property (nonatomic,strong) SetConfigModel* currenUser;
@end

@implementation SetConfigManager

//非标准单例
static SetConfigManager *manager = nil;
+ (SetConfigManager *)sharedManager {
    @synchronized(self) {//同步 执行 防止多线程操作
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    }
    return manager;
}
//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        if (!__isFullScreen__) {
//            SetConfigModel * model = [[SetConfigModel alloc] init];
//            model.isTrace = @"0";
//            model.isRecord = @"0";
//            model.isFullScreen = @"0";
//            [self insertUserInfo:model];
//        }
//
//    }
//    return self;
//}
#pragma mark - 初始化
-(void)initManager{
    if (!__isUserId__) {
        SetConfigModel * model = [[SetConfigModel alloc] init];
          model.isTrace = @"0";
          model.isRecord = @"0";
          model.isFullScreen = @"0";
        [self insertUserInfo:model];
    }
 
}
#pragma mark - new upData
-(void)updataModel:(SetConfigModel *)model
{
    [[SetConfigManager sharedManager] deleteAllUserInfo];
    [[SetConfigManager sharedManager] insertUserInfo:model];
}

#pragma mark - public function

- (void)insertUserInfo:(SetConfigModel *)model{
    //遍历有没有已经存在的
    for (int i = (int)self.users.count - 1; i >= 0; i--) {
        SetConfigModel * user = self.users[i];
        if ([user.isTrace isEqualToString:model.isTrace]) {
            [self.users removeObjectAtIndex:i];
        }
    }
    if (model != nil) {
        [self.users insertObject:model atIndex:0];
        self.currenUser = model;
        [self save];
    }
   
}
- (SetConfigModel *)getUserInfo{
    return self.currenUsers;
}

- (void)deleteUserInfo{
    if (self.currenUsers) {
        if ([self.users containsObject:self.currenUsers]) {
            [self.users removeObject:self.currenUsers];
        }
    }
    [self save];
    self.currenUser = nil;
}

- (NSArray<SetConfigModel *> *)getAllUserInfo{
    return self.users;
}

- (void)deleteAllUserInfo{
    if (self.users != nil) {
        [self.users removeAllObjects];
    }
       [self save];
}

- (BOOL)isExistUserId:(NSString *)isFullScreen{
    for (SetConfigModel *user in self.users) {
        if ([user.isFullScreen isEqualToString:isFullScreen]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark -- private function

- (NSMutableArray *)load
{
    NSString * path = [self path];
    NSMutableArray * users = [NSMutableArray array];
    if (!path) {
        return users;
    }
    
    NSMutableArray * localUsers = [NSMutableArray arrayWithContentsOfFile:path];
    if (!localUsers) {
        return users;
    }
    
    for (int i = 0; i < localUsers.count;i++) {
        NSData * data = localUsers[i];
        SetConfigModel * model;
//         if (@available(iOS 11.0, *)) {
//             model =  [NSKeyedUnarchiver unarchivedObjectOfClass:[NSData class] fromData:data error:nil];
//         }else{
             model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//         }
        if (model != nil) {
            [users addObject:model];
        }
    }
    return users;
}

- (BOOL)save{
    NSString * path = [self path];
    if (!path) {
        return NO;
    }
    
    NSMutableArray * archeveArray = [NSMutableArray array];
    for (int i = 0; i < self.users.count; i++) {
        SetConfigModel * user = self.users[i];
        NSData * data;
//         if (@available(iOS 11.0, *)) {
//             data = [NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:YES error:nil];
//         }else{
             data = [NSKeyedArchiver archivedDataWithRootObject:user];
//         }
        if (data != nil) {
            [archeveArray addObject:data];
        }
    }
    BOOL success = [archeveArray writeToFile:path atomically:YES];
    return success;
}


- (NSString *)path
{
    NSString * path = nil;
    NSString * userDic =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [userDic stringByAppendingPathComponent:@"GS_SetConfig"];
    return path;
}

#pragma mark -- get
- (NSMutableArray<SetConfigModel *> *)users{
    if (!_users) {
        _users = [self load];
    }
    return _users;
}
- (SetConfigModel *)currenUsers
{
    return self.users.firstObject;
}

@end
