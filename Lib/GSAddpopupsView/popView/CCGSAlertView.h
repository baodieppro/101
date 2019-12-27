//
//  CCGSAlertView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completeAlert)(NSInteger code);//1:确定 0:取消
@interface CCGSAlertView : UIView
@property (nonatomic,strong) UILabel * titleLable;
@property (nonatomic,strong) UILabel * subtitleLable;
@property (nonatomic,strong) UIButton * determineButton;
@property (nonatomic,strong) UIButton * cancelButton;
@property(nonatomic, strong) completeAlert blockAlert;
-(void)customInitWithTitle:(NSString *)title subTitle:(NSString *)subtitle Complete:(void (^)(NSInteger type))complete;

//
@end
