//
//  ShoppingCartModel.h
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/7.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface ShoppingCartModel : NSObject

@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, strong) NSNumber *amount;

- (instancetype)initWithPFObject:(PFObject *)object;

@end
