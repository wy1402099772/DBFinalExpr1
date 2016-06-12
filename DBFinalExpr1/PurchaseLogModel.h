//
//  PurchaseLogModel.h
//  DBFinalExpr1
//
//  Created by wyan assert on 16/6/11.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse.h>
@interface PurchaseLogModel : NSObject

@property (nonatomic, strong) NSNumber *purchaseAmount;
@property (nonatomic, strong) NSString *goodID;
@property (nonatomic, strong) NSString *goodName;
@property (nonatomic, strong) NSNumber *purchasePrice;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *objectID;

- (instancetype)initWithPFObject:(PFObject *)object;

@end
