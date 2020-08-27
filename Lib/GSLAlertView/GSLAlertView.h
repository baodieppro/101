//
//  GSLAlertView.h
//  MoxtraBinder
//
//  Created by 巩少鹏 on 2018/8/2.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface GSLAlertView : UIView

@property (nonatomic,copy) AlertResult resultIndex;//!<1：取消  2：确定

+(instancetype)alertManager;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)createInitWithTitle:(NSString *)title message:(NSString *)message sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;

- (void)showGSAlertView;

@end
