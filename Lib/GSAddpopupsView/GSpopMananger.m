//
//  GSpopMananger.m
//  CCQMEnglish
//
//  Created by Roger on 2019/9/25.
//  Copyright © 2019 Roger. All rights reserved.
//

#import "GSpopMananger.h"



@interface GSpopMananger ()

@property (nonatomic,strong) GSAddpopupsView * gsAddpopupsView;

@end

@implementation GSpopMananger

static GSpopMananger *shareInstance;
+ (GSpopMananger *)defaultManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[GSpopMananger alloc] init];
    });
    return shareInstance;
}



-(void)addPopView:(UIView *)view  popView:(void (^)(GSAddpopupsView * popView))popView{
                GSAddpopupsView *  gsAddpopupsView = [[GSAddpopupsView alloc] initWithCustomView:view popStyle:GSAnimationPopStyleScale dismissStyle:GSAnimationDismissStyleScale newStyle:GSAnimationPopStyleTapYes];
                gsAddpopupsView.popBGAlpha = 0.5f;
                gsAddpopupsView.isClickBGDismiss = NO;
                [gsAddpopupsView pop];
                popView(gsAddpopupsView);      
    
 
}

@end
