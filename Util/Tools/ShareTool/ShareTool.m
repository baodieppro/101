//
//  ShareTool.m
//  简易心理
//
//  Created by 巩小鹏 on 2017/6/1.
//  Copyright © 2017年 巩小鹏. All rights reserved.
//

#import "ShareTool.h"
#import "AppDelegate.h"
#import "GSTool.h"
@interface ShareTool()
@property (nonatomic, copy) UIActivityViewControllerCompletionHandler completionHandler;
@end
@implementation ShareTool
- (void)shareWithTitle:(NSString *)title description:(NSString *)description url:(NSString *)url image:(UIImage *)image completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:title?:@""];
    if (image) {
        [items addObject:image];
    }
    if (url) {
        [items addObject:url];
    }
    if(description){
        [items addObject:description];
    }
    
//    NSMutableArray *activities = [[NSMutableArray alloc] init];
    
//    HBShareBaseActivity *weixinActivity = [[HBShareBaseActivity alloc] initWithTitle:@"微信" type:ActivityServiceWeixin];
//    HBShareBaseActivity *weixinFriendsActivity = [[HBShareBaseActivity alloc] initWithTitle:@"朋友圈" type:ActivityServiceWeixinFriends];
//    [@[weixinActivity, weixinFriendsActivity] enumerateObjectsUsingBlock:^(HBShareBaseActivity *activity, NSUInteger idx, BOOL *stop) {
//        activity.urlString = url;
//        activity.shareDescription = description;
//        activity.shareTitle = title;
//        activity.image = image;
//    }];
//    [activities addObjectsFromArray:@[weixinActivity, weixinFriendsActivity]];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypePostToTwitter]];
    
    activityViewController.excludedActivityTypes = excludedActivityTypes;
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
    
    activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completionHandler) {
            completionHandler(activityType, completed);
            self.completionHandler = nil;
        }
    };
//    activityViewController.completionHandler = ^(NSString *activityType, BOOL complted){
//        if (completionHandler) {
//            completionHandler(activityType, complted);
//            self.completionHandler = nil;
//        }
//    };
}



+ (void)itmeTitle:(NSString *)title Icon:(NSString *)icon placeholderImage:(NSString *)image Url:(NSString *)url Complete:(void (^)(NSArray *))complete error:(void (^)(NSString *))error
{
    NSMutableArray * arrItme = [[NSMutableArray alloc]init];
    if (icon != nil) {
        if (![icon isEqualToString:@""]) {
            if ([GSTool newisHttpOrHttps:icon] == YES) {
                UIImageView *imageView = [[UIImageView alloc]init];
//                [imageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:image]];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage *imagerang = [UIImage imageWithData:data];
                imageView.image = imagerang;
                [arrItme addObject:imageView.image];
                //            [arrItme addObject:[ShareTool itmeImageWithUrl:icon imgTag:1]];
            }else{
                [arrItme addObject:[UIImage imageNamed:icon]];
            }
        }else{
            [arrItme addObject:[UIImage imageNamed:image]];
        }
    }else{
        [arrItme addObject:[UIImage imageNamed:image]];
    }
    if (url != nil) {
        if (![url isEqualToString:@""]) {
            [arrItme addObject:[NSURL URLWithString:url]];

//            if([URLTool newIsUrl:icon] == YES){
//                [arrItme addObject:[NSURL URLWithString:url]];
//            }else{
//                error(@"URL地址不符！");
//                 return;
//            }
        }else{
            error(@"URL不能为空！");
             return;
        }
    }else{
        error(@"URL不能为nil！");
        return;
    }
    if (title != nil) {
        if (![title isEqualToString:@""]) {
            [arrItme addObject:title];
        }
    }
    
    complete(arrItme);
}


+ (void)shareWithItem:(NSArray *)item MySelf:(id)mySelf completionHandler:(UIActivityViewControllerCompletionHandler)completionHandler
{

    UIActivityViewController *activityViewController =[[UIActivityViewController alloc] initWithActivityItems:item
                                                                                        applicationActivities:nil];
    
    //尽量不显示其他分享的选项内容
    
//    activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter, UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
    
    if (activityViewController) {
        [mySelf presentViewController:activityViewController animated:TRUE completion:nil];
        activityViewController.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
            if (completionHandler) {
                completionHandler(activityType, completed);
                
            }
        };

    }

}
@end
