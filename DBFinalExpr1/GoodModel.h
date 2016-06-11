//
//  GoodModel.h
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/5.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PFObject;

@interface GoodModel : NSObject

@property (nonatomic, strong) NSString  *goodID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSNumber  *price;
@property (nonatomic, strong) NSNumber  *score;
@property (nonatomic, strong) NSString  *classify;
@property (nonatomic, strong) NSArray   *images;
@property (nonatomic, strong) NSNumber  *amount;
@property (nonatomic, strong) NSString  *sellerName;

- (instancetype)initWithPFObject:(PFObject *)object;

@end
