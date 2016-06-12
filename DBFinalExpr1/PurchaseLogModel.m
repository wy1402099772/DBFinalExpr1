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
        self.objectID = [object objectId];
        self.date = [object objectForKey:kParsePurchaseLogDate];
        self.purchasePrice = [object objectForKey:kParsePurchaseLogPrice];
        self.purchaseAmount = [object objectForKey:kParsePurchaseLogAmount];
        self.goodID = [object objectForKey:kParsePurchaseLogGoodID];
        self.goodName = [object objectForKey:kParsePurchaseLogGoodName];
        self.userName = [object objectForKey:kParsePurchaseLogUserName];
        self.state = [object objectForKey:kParsePurchaseLogState];
        
    }
    return self;
}

@end
