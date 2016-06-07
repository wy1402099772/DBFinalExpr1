//
//  ShoppingCartCollectionViewController.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/7.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "ShoppingCartCollectionViewController.h"
#import "Masonry.h"
#import <Parse/Parse.h>
#import "ParseHeader.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ShoppingCartCollectionViewCell.h"
#import "UserHelper.h"
#import "ShoppingCartModel.h"
#import "MJRefresh.h"

#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf
#define CellWidth (([UIScreen mainScreen].bounds.size.width - (collectionViewDisplayMode - 1) * minimumInteritemSpacing - CellInsets * 2 * collectionViewDisplayMode) / collectionViewDisplayMode)

static NSString *GoodsCollectionViewIdentifier = @"GoodsCollectionViewIdentifier";
static CGFloat minimumLineSpacing = 8;
static CGFloat minimumInteritemSpacing = 4;
static NSUInteger collectionViewDisplayMode = 1;
static NSUInteger CellInsets = 1;

@interface ShoppingCartCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation ShoppingCartCollectionViewController

- (void)viewDidLoad
{
    [self initView];
    PFQuery *query = [PFQuery queryWithClassName:kParseShoppingCart];
    [query whereKey:kParseShoppingCartUserName equalTo:[UserHelper sharedInstance].username];
    WEAK_SELF;
    [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError * _Nullable error) {
        STRONG_SELF;
        NSLog(@"object :%@, \n error: %@", objects, error);
        for(PFObject *object in objects)
            [self.modelArray addObject:[[ShoppingCartModel alloc] initWithPFObject:object]];
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)initView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private



#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCartCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionViewIdentifier forIndexPath:indexPath];
    [cell loadData:self.modelArray[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionViewDisplayMode == 1)
        return CGSizeMake(CellWidth, CellWidth / 3);
    else
        return CGSizeMake(CellWidth, CellWidth * 1.4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(CellInsets, CellInsets, CellInsets, CellInsets);
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    return [[NSAttributedString alloc] initWithString:@"loading..."];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"image_loading"];
}
#pragma mark - DZNEmptyDataSetDelegate

#pragma mark - getter

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        _collectionView.emptyDataSetSource = self;
        _collectionView.emptyDataSetDelegate = self;
        
        WEAK_SELF;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            STRONG_SELF;
            PFQuery *query = [PFQuery queryWithClassName:kParseShoppingCart];
            [query whereKey:kParseShoppingCartUserName equalTo:[UserHelper sharedInstance].username];
            WEAK_SELF;
            [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError * _Nullable error) {
                STRONG_SELF;
                NSLog(@"object :%@, \n error: %@", objects, error);
                [self.modelArray removeAllObjects];
                for(PFObject *object in objects)
                    [self.modelArray addObject:[[ShoppingCartModel alloc] initWithPFObject:object]];
                [self.collectionView reloadData];
                [self.collectionView.mj_header endRefreshing];
            }];
        }];
        
        [_collectionView registerClass:[ShoppingCartCollectionViewCell class] forCellWithReuseIdentifier:GoodsCollectionViewIdentifier];
    }
    return _collectionView;
}

- (NSMutableArray *)modelArray
{
    if(!_modelArray)
    {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

@end
