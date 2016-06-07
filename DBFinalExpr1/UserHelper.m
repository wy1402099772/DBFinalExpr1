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
        if(error)
        {
            _username = nil;
        }
        else
        {
            _username = [user objectForKey:kParseUserUsername];
        }
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

- (void)addGood:(NSString *)goodID withBlock:(CompletionBlock)block
{
    PFQuery *query = [PFQuery queryWithClassName:kParseShoppingCart];
    [query whereKey:kParseShoppingCartUserName equalTo:self.username];
    [query whereKey:kParseShoppingCartGoodID equalTo:goodID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(error)
        {
            PFObject *purchaseLog = [PFObject objectWithClassName:kParseShoppingCart];
            [purchaseLog setObject:goodID forKey:kParseShoppingCartGoodID];
            [purchaseLog setObject:self.username forKey:kParseShoppingCartUserName];
            [purchaseLog setObject:@1 forKey:kParseShoppingAmount];
            [purchaseLog saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if(block)
                    block(error);
            }];
        }
        else
        {
            [object incrementKey:kParseShoppingAmount byAmount:@1];
            [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if(block)
                    block(error);
            }];
        }
    }];
}

@end
