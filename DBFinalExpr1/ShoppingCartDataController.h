//
//  ShoppingCartDataController.h
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/7.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodModel.h"
#import "ShoppingCartModel.h"
#import "PurchaseLogModel.h"

typedef void (^ShoppingCartDataCompletion) (GoodModel *good, NSError *error);

@interface ShoppingCartDataController : NSObject

+ (void)createGoodFromShopCart:(ShoppingCartModel *)model withBlock:(ShoppingCartDataCompletion)block;

+ (void)createGoodFromPurchaseLog:(PurchaseLogModel *)model withBlock:(ShoppingCartDataCompletion)block;

@end
