//
//  ShoppingCartModel.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/7.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "ShoppingCartModel.h"
#import <Parse/Parse.h>
#import "ParseHeader.h"

@implementation ShoppingCartModel

- (instancetype)initWithPFObject:(PFObject *)object
{
    if(self = [super init])
    {
        _amount = [object objectForKey:kParseShoppingAmount];
        _goodID = [object objectForKey:kParseShoppingCartGoodID];
        _selected = NO;
    }
    return self;
}

@end
