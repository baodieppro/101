//
//  UIDevice+GSDevice.h
//  CCQMEnglish
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (GSDevice)
/**
 * @interfaceOrientation 输入要强制转屏的方向
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
