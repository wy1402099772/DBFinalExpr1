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
#import "ShoppingCartModel.h"

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
            _type = nil;
        }
        else
        {
            _username = [user objectForKey:kParseUserUsername];
            _type = [user objectForKey:kParseUserType];
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
    [user setObject:kParseUserTypeCustomer forKey:kParseUserType];
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

- (void)cancelShoppingCart:(NSArray *)array withBlock:(CompletionBlock)block
{
    __block NSUInteger count = array.count;
    for(ShoppingCartModel *model in array)
    {
        PFQuery *query = [PFQuery queryWithClassName:kParseShoppingCart];
        [query whereKey:kParseShoppingCartUserName equalTo:self.username];
        [query whereKey:kParseShoppingCartGoodID equalTo:model.goodID];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            count --;
            [object deleteInBackground];
            if(count == 0)
                block(nil);
        }];
    }
}

- (void)dealShoppingCart:(NSArray *)array withBlock:(CompletionBlock)block
{
    __block NSUInteger count = array.count;
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for(ShoppingCartModel *model in array)
    {
        PFQuery *qyery0 = [PFQuery queryWithClassName:ParseGoods];
        [qyery0 whereKey:kParseShoppingCartGoodID equalTo:model.goodID];
        [qyery0 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            count --;
            if(error)
                return ;
            if([[object objectForKey:ParseGoodStorageAmount] intValue] > [model.amount intValue])
            {
                [tmpArray addObject:model];
                [object setObject:@([[object objectForKey:ParseGoodStorageAmount] intValue] - [model.amount intValue]) forKey:ParseGoodStorageAmount];
                [object saveInBackground];
                
                PFObject *object1 = [PFObject objectWithClassName:kParsePurchaseLog];
                [object1 setObject:[object objectForKey:ParseGoodsPrice] forKey:kParsePurchaseLogPrice];
                [object1 setObject:model.amount forKey:kParsePurchaseLogAmount];
                [object1 setObject:[object objectForKey:ParseGoodsGoodId] forKey:kParsePurchaseLogGoodID];
                [object1 setObject:[object objectForKey:ParseGoodsName] forKey:kParsePurchaseLogGoodName];
                [object1 setObject:[UserHelper sharedInstance].username forKey:kParsePurchaseLogUserName];
                [object1 setObject:[object objectForKey:ParseGoodsSellerName] forKey:kParsePurchaseLogSellerName];
                [object1 setObject:[NSDate date] forKey:kParsePurchaseLogDate];
                
                [object1 saveInBackground];
                
                PFQuery *query2 = [PFQuery queryWithClassName:kParseShoppingCart];
                [query2 whereKey:kParseShoppingCartUserName equalTo:self.username];
                [query2 whereKey:kParseShoppingCartGoodID equalTo:model.goodID];
                [query2 getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                    [object deleteInBackground];
                }];
            }
            if(count == 0)
            {
                if(block)
                {
                    if(tmpArray.count == array.count)
                        block(nil);
                    else
                        block([NSError new]);
                }
            }
            
        }];
    }
}

@end
