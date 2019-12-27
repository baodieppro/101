//
//  GSBrightnessAndVolumeView.h
//  GSPlay
//
//  Created by Roger on 2019/9/10.
//  Copyright © 2019年 Roger. All rights reserved.
//
#define ZLSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#import <UIKit/UIKit.h>

@interface GSBrightnessAndVolumeView : UIView
@property (nonatomic, copy) void(^progressChangeHandle)(CGFloat);
@property (nonatomic, copy) void(^progressLandscapeEnd)(void);
@property (nonatomic, copy) void(^progressPortraitEnd)(void);
+ (instancetype)sharedBrightnessAndAudioView;
@end
