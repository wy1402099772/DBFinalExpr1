//
//  PurchaseLogCollectionViewController.h
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/8.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger ,PurchaseControllerType) {
    PurchaseControllerTypePurchase,
    PurchaseControllerTypeSell
};

@interface PurchaseLogCollectionViewController : UIViewController

- (instancetype)initWithType:(PurchaseControllerType)type;

@end
