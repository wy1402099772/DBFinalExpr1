//
//  GoodModel.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/5.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "GoodModel.h"
#import <Parse/Parse.h>
#import "ParseHeader.h"

@implementation GoodModel

- (instancetype)initWithPFObject:(PFObject *)object
{
    if(self = [super init])
    {
        self.goodID = [object objectForKey:ParseGoodsGoodId];
        self.name = [object objectForKey:ParseGoodsName];
        self.price = [object objectForKey:ParseGoodsPrice];
        self.score = [object objectForKey:ParseGoodsScore];
        self.classify = [object objectForKey:ParseGoodsClassify];
        self.images = [object objectForKey:ParseGoodsImages];
    }
    return self;
}

@end
