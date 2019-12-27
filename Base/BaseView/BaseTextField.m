//
//  BaseTextField.m
//  LycheeWallet
//
//  Created by 巩小鹏 on 2019/5/22.
//  Copyright © 2019 巩小鹏. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = self.leftLable;
        CALayer * leftBorder = [CALayer layer];
        leftBorder.frame = CGRectMake(0,__kNewSize(98), __kScreenWidth__-__kNewSize(60), __kNewSize(1));
        leftBorder.backgroundColor = [UIColor colorWithHexString:@"#E3E3E3"].CGColor;
        [self.layer addSublayer:leftBorder];
    }
    return self;
}


@end
