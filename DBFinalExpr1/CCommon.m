//
//  CCommon.m
//  SnapUpload
//
//  Created by Jason on 15/9/8.
//  Copyright (c) 2015年 JellyKit Inc. All rights reserved.
//

#import "CCommon.h"
#import "AFNetworking.h"
#import <AdSupport/ASIdentifierManager.h>


#define kIPServer                           @"https://api.padgramoauth.com/healthy/ip"
#define kAppleDeviceInfoServer              @"https://www.preferapp.me/applog"
#define kAppleDeviceCheckServer             @"https://www.preferapp.me/isInReivewMode"

@implementation CCommon

+ (UIViewController *)getTopmostViewController {
    
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    BOOL isPresenting = NO;
    do {
        UIViewController *presented = [rootController presentedViewController];
        isPresenting = presented != nil;
        if(presented != nil) {
            rootController = presented;
        }
    } while (isPresenting);
    
    return rootController;
}

@end
