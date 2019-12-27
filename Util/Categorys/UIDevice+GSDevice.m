//
//  UIDevice+GSDevice.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import "UIDevice+GSDevice.h"

@implementation UIDevice (GSDevice)

+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:interfaceOrientation];
    
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
}
@end
