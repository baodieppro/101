//
//  GSCoverPictureNode.h
//  CCQMEnglish
//
//  Created by Roger on 2019/9/12.
//  Copyright © 2019 Roger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSCoverPictureNode : UIControl
@property (nonatomic,strong) UIImageView * pictImage;//!<图片
- (void)startAnimating;
- (void)stopAnimating;
@end
