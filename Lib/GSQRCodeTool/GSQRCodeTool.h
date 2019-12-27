//
//  GSQRCodeTool.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>
#import <AVFoundation/AVFoundation.h>

@interface GSQRCodeTool : NSObject
/** 生成一张普通的二维码 */
+ (UIImage *)SG_generateWithDefaultQRCodeData:(NSString *)data imageViewWidth:(CGFloat)imageViewWidth;
/** 生成一张带有logo的二维码（logoScaleToSuperView：相对于父视图的缩放比取值范围0-1；0，不显示，1，代表与父视图大小相同） */
+ (UIImage *)SG_generateWithLogoQRCodeData:(NSString *)data logoImageName:(NSString *)logoImageName logoScaleToSuperView:(CGFloat)logoScaleToSuperView;
/** 生成一张彩色的二维码 */
+ (UIImage *)SG_generateWithColorQRCodeData:(NSString *)data backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;

//关于二维码
+(void)setQRRequest:(NSString *)url image:(void (^)(UIImage *image))img;

+(UIImage *)setQRurl:(NSString *)url withSize:(CGFloat)size;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) urlStr;

@end
