//
//  QRCodeViewController.h
//  GSDlna
//
//  Created by ios on 2019/12/27.
//  Copyright © 2019 GSDlna_Developer. All rights reserved.
//

#import "BaseViewController.h"
@protocol QRDelegate <NSObject>
@optional
-(void)getQRDataString:(NSString*_Nullable)QRDataString;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeViewController : BaseViewController
@property (nonatomic,assign) id<QRDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
