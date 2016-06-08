//
//  SellerEditViewController.h
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/8.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodModel.h"

typedef NS_ENUM(NSUInteger, SellerEditType) {
    SellerTypeAdd,
    SellerTypeEdit
};

@interface SellerEditViewController : UIViewController

- (instancetype)initWithGoodModel:(GoodModel *)model mode:(SellerEditType)type;

@end
