//
//  GoodsCollectionViewCell.h
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/5.
//  Copyright © 2016年 万延. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodModel;

@interface GoodsCollectionViewCell : UICollectionViewCell

- (void)loadData:(GoodModel *)model withMode:(NSUInteger)mode;

@end
