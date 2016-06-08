//
//  PurchaseLogCollectionViewController.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/8.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "PurchaseLogCollectionViewController.h"
#import "Masonry.h"
#import <Parse/Parse.h>
#import "ParseHeader.h"
#import "UIScrollView+EmptyDataSet.h"
#import "PurchaseLogCollectionViewCell.h"
#import "UserHelper.h"
#import "ShoppingCartModel.h"
#import "MJRefresh.h"
#import "UIView+Toast.h"

#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf
#define CellWidth (([UIScreen mainScreen].bounds.size.width - (collectionViewDisplayMode - 1) * minimumInteritemSpacing - CellInsets * 2 * collectionViewDisplayMode) / collectionViewDisplayMode)

static NSString *GoodsCollectionViewIdentifier = @"PurchaseLogCollectionViewIdentifier";
static CGFloat minimumLineSpacing = 8;
static CGFloat minimumInteritemSpacing = 4;
static NSUInteger collectionViewDisplayMode = 1;
static NSUInteger CellInsets = 1;

@interface PurchaseLogCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation PurchaseLogCollectionViewController

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
    self.navigationItem.title = @"购买记录";
    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image_barbutton_cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectCancelBarButton:)];
//    
//    self.navigationItem.rightBarButtonItem = rightButton;
//    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image_barbutton_shop"] style:UIBarButtonItemStylePlain target:self action:@selector(didSelectShoppingBarButton:)];
//    
//    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)initView
{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - private

- (void)didSelectShoppingBarButton:(UIBarButtonItem *)sender
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for(ShoppingCartModel *model in self.modelArray)
    {
        if(model.selected == YES)
            [tmpArray addObject:model];
    }
    if(tmpArray.count == 0)
    {
        [self.view makeToast:@"你没有选中任何物品，无法购买" duration:1.5f position:CSToastPositionCenter];
    }
    else
    {
        [[UserHelper sharedInstance] dealShoppingCart:[tmpArray copy] withBlock:^(NSError *error) {
            
            NSString *message;
            if(error)
            {
                message = @"不是所有的都成功购买，依旧留在购物车中";
            }
            else
            {
                message = @"购买成功";
            }
            [self.view makeToast:message duration:1.5f position:CSToastPositionCenter];
            
            PFQuery *query = [PFQuery queryWithClassName:kParseShoppingCart];
            [query whereKey:kParseShoppingCartUserName equalTo:[UserHelper sharedInstance].username];
            WEAK_SELF;
            [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError * _Nullable error) {
                STRONG_SELF;
                [self.modelArray removeAllObjects];
                NSLog(@"object :%@, \n error: %@", objects, error);
                for(PFObject *object in objects)
                    [self.modelArray addObject:[[ShoppingCartModel alloc] initWithPFObject:object]];
                [self.collectionView reloadData];
            }];
        }];
    }
}

- (void)didSelectCancelBarButton:(UIBarButtonItem *)sender
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    for(ShoppingCartModel *model in self.modelArray)
    {
        if(model.selected == YES)
            [tmpArray addObject:model];
    }
    if(tmpArray.count == 0)
    {
        [self.view makeToast:@"你没有选中任何物品，无法删除" duration:1.5f position:CSToastPositionCenter];
    }
    else
    {
        [[UserHelper sharedInstance] cancelShoppingCart:[tmpArray copy] withBlock:^(NSError *error) {
            PFQuery *query = [PFQuery queryWithClassName:kParseShoppingCart];
            [query whereKey:kParseShoppingCartUserName equalTo:[UserHelper sharedInstance].username];
            WEAK_SELF;
            [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError * _Nullable error) {
                STRONG_SELF;
                [self.modelArray removeAllObjects];
                NSLog(@"object :%@, \n error: %@", objects, error);
                for(PFObject *object in objects)
                    [self.modelArray addObject:[[ShoppingCartModel alloc] initWithPFObject:object]];
                [self.collectionView reloadData];
            }];
            [self.view makeToast:@"操作已完成" duration:1.5f position:CSToastPositionCenter];
        }];
    }
}


#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PurchaseLogCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionViewIdentifier forIndexPath:indexPath];
//    [cell loadData:self.modelArray[indexPath.row]];
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
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}


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
        
        [_collectionView registerClass:[PurchaseLogCollectionViewCell class] forCellWithReuseIdentifier:GoodsCollectionViewIdentifier];
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
