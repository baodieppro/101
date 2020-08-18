//
//  CCGSAlertView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/10/10.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCGSAlertView : UIView
-(void)customInitWithTitle:(NSString *)title
                  subTitle:(NSString *)subtitle
                   sureBtn:(NSString *)sureTitle
                 cancleBtn:(NSString *)cancleTitle
                  Complete:(void (^)(NSInteger type))complete;

+(void)initWithTitle:(NSString *)title
            subTitle:(NSString *)subtitle
             sureBtn:(NSString *)sureTitle
           cancleBtn:(NSString *)cancleTitle
            Complete:(void (^)(NSInteger))complete;
@end
