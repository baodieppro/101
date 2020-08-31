//
//  GSLoadingView.h
//  SonDelivery
//
//  Created by 巩少鹏 on 2020/4/16.
//  Copyright © 2020 巩少鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSTextLoading : UIView
@property (nonatomic,strong) NSString * text;
+(instancetype)loadingManager;
-(void)startLoading;
-(void)stopLoading;

+(void)showGSLoadingView:(UIView *)newView;

+(void)reomveGSLoadingView:(UIView*)newView;

@end

NS_ASSUME_NONNULL_END
