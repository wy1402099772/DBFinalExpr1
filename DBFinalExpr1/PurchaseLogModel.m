//
//  PurchaseLogModel.m
//  DBFinalExpr1
//
//  Created by wyan assert on 16/6/11.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "PurchaseLogModel.h"
#import "ParseHeader.h"

@implementation PurchaseLogModel

- (instancetype)initWithPFObject:(PFObject *)object
{
    if(self = [super init])
    {
        self.purchasePrice = [object objectForKey:kParsePurchaseLogPrice];
        self.purchaseAmount = [object objectForKey:kParsePurchaseLogAmount];
        self.goodID = [object objectForKey:kParsePurchaseLogGoodID];
        self.goodName = [object objectForKey:kParsePurchaseLogGoodName];
        self.userName = [object objectForKey:kParsePurchaseLogUserName];
    }
    return self;
}

@end
