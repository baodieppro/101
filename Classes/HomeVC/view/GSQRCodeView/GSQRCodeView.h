//
//  GSQRCodeView.h
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GSScanViewDelegate <NSObject>

-(void)getScanDataString:(NSString*)scanDataString;
@optional
-(void)newGsBack;
-(void)newGSOpenPhoto;
-(void)newGsOpenFlash;

@end


@interface GSQRCodeView : BaseView

@property (nonatomic,assign) id<GSScanViewDelegate> delegate;
@property (nonatomic,assign) int scanW; //扫描框的宽
@property (nonatomic,strong) UIView * beijingView;
@property (nonatomic,strong) UIButton * fanhui;
@property (nonatomic,strong) UIButton * fuzhi;
@property (nonatomic,strong) UILabel * headline;
@property (nonatomic,strong) UILabel * subtitle;
@property (nonatomic,strong) UILabel * bodyLable;

- (void)startRunning; //开始扫描
- (void)stopRunning; //停止扫描

@end

NS_ASSUME_NONNULL_END
