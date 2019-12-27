//
//  GSSlider.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/26.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSSlider.h"

@implementation GSSlider

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), __kNewSize(6*2));
    
}

@end
