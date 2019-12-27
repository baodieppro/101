//
//  GSNewButton.h
//  GSPlay
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSNewButton : UIControl
@property (nonatomic,strong) UIImageView * iconMB;//!<图片
@property (nonatomic,strong) UILabel * titleMB;//!<标题
-(void)m_initWithIcon:(NSString *)img titleM:(NSString *)title color:(NSString *)colorStr;
@end
