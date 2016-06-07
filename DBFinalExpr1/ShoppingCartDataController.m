//
//  ShoppingCartDataController.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/7.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "ShoppingCartDataController.h"
#import "ParseHeader.h"
#import <Parse.h>

@implementation ShoppingCartDataController

+ (void)createGoodFromShopCart:(ShoppingCartModel *)model withBlock:(ShoppingCartDataCompletion)block
{
    PFQuery *query = [PFQuery queryWithClassName:ParseGoods];
    [query whereKey:ParseGoodsGoodId equalTo:model.goodID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(error)
        {
            if(block)
                block(nil, error);
        }
        else
        {
            if(block)
                block([[GoodModel alloc] initWithPFObject:object], nil);
        }
    }];
}

@end
