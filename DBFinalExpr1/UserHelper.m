//
//  UserHelper.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/6.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "UserHelper.h"
#import <Parse/parse.h>
#import "ParseHeader.h"

@implementation UserHelper

+ (instancetype)sharedInstance
{
    static UserHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken , ^{
        instance = [[UserHelper alloc] init];
    });
    return instance;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password withBlock:(CompletionBlock)block
{
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if(block)
            block(error);
    }];
}

- (void)signupWithUsername:(NSString *)username password:(NSString *)password withBlock:(CompletionBlock)block
{
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    [user signUpInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(block)
            block(error);
    }];
}

- (void)purchaseGood:(NSString *)goodID withBlock:(CompletionBlock)block
{
    PFObject *purchaseLog = [PFObject objectWithClassName:kParseShoppingCart];
    [purchaseLog setObject:goodID forKey:kParseShoppingCart];
    [purchaseLog setObject:self.username forKey:kParseShoppingCartUserName];
    [purchaseLog saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        if(block)
            block(error);
    }];
}

@end
