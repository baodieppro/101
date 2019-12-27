//
//  UIView+Extension.m
//  YYWMerchantSide
//
//  Created by WJC on 2019/11/14.
//  Copyright © 2019 MerchantSide_Developer. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

+(UIView *)createLineWithColor:(UIColor *)color frame:(CGRect)rect{
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = color;
    line.frame = rect;
    return line;
}
@end
