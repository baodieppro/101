//
//  BaseNavigationBar.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/20.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseNavigationBar.h"

@interface BaseNavigationBar()
@property (nonatomic, copy) NSArray* leftButtonArr;
@property (nonatomic, copy) NSArray* righButtonArr;
@end
@implementation BaseNavigationBar
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftBarButtons = [[NSArray alloc] init];
        _rightBarButtons = [[NSArray alloc] init];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(__kNewSize(60), 0, __kScreenWidth__-__kNewSize(120), __kNavigationBarHeight__-20)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.center = CGPointMake(__kScreenWidth__/2, 20+(__kNavigationBarHeight__-20)/2);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:__kNewSize(16*2)];
        //        _titleLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_titleLabel];
        //            _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __kScreenWidth__-__kNewSize(220), frame.size.height-20)];
        //            _centerView.center = CGPointMake(__kScreenWidth__/2, 20+(frame.size.height-20)/2);
        //            [self addSubview:_centerView];
        
    }
    return self;
}
-(void)setLeftBarButtons:(NSArray *)leftBarButtons{
    if (self.leftBarButtons.count > 0) {
        for (UIButton* button in self.leftBarButtons) {
            [button removeFromSuperview];
        }
    }
    int i=0;
    for (UIButton* button in leftBarButtons) {
        button.frame = CGRectMake(0, 0, __kNewSize(60), button.frame.size.height);
        button.center = CGPointMake(10+button.frame.size.width/2+i*(button.frame.size.width/2+10), 20+(self.frame.size.height-20)/2);
        //        button.backgroundColor = [UIColor greenColor];
        [self addSubview:button];
        i++;
    }
    _leftBarButtons = leftBarButtons;
}

-(void)setRightBarButtons:(NSArray *)rightBarButtons{
    if (self.rightBarButtons.count > 0) {
        for (UIButton* button in self.rightBarButtons) {
            [button removeFromSuperview];
        }
    }
    int i=0;
    for (UIButton* button in rightBarButtons) {
        button.frame = CGRectMake(0, 0, button.frame.size.width, button.frame.size.height);
        button.center = CGPointMake(__kScreenWidth__-20-button.frame.size.width/2-i*(10+button.frame.size.width), 20+(self.frame.size.height-20)/2);
        [self addSubview:button];
        i++;
    }
    _rightBarButtons = rightBarButtons;
}
-(void)setIsHidden:(BOOL)isHidden{
    [self setBarHidden:isHidden];
}
- (void)setBarHidden:(BOOL)isHidden{
//    CGSize size = self.frame.size;
    if (isHidden) {
        //        [UIView animateWithDuration:0.5 animations:^{
//        self.frame = CGRectMake(0, -size.height, size.width, size.height);
        //        }];
        self.alpha = 0;
    }else{
        //        [UIView animateWithDuration:0.5 animations:^{
//        self.frame = CGRectMake(0, 0, size.width, size.height);
        //        }];
        self.alpha = 1;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width,__kNavigationBarHeight__);
}

@end
