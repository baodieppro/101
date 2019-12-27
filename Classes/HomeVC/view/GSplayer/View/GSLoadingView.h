//
//  GSLoadingView.h
//  CCQMEnglish
//
//  Created by Roger on 2019/9/12.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSLoadingView : UIView
@property (nonatomic, assign) BOOL hidesWhenStopped;
- (void)startAnimating;
- (void)stopAnimating;
@end
