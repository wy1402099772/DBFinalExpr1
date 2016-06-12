//
//  GoodsCollectionViewController.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/5.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "GoodsCollectionViewController.h"
#import "Masonry.h"
#import <Parse/Parse.h>
#import "ParseHeader.h"
#import "GoodModel.h"
#import "UIScrollView+EmptyDataSet.h"
#import "GoodsCollectionViewCell.h"
#import "MJRefresh.h"

#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf
#define CellWidth (([UIScreen mainScreen].bounds.size.width - (collectionViewDisplayMode - 1) * minimumInteritemSpacing - CellInsets * 2 * collectionViewDisplayMode) / collectionViewDisplayMode)

static NSString *GoodsCollectionViewIdentifier = @"GoodsCollectionViewIdentifier";
static CGFloat minimumLineSpacing = 8;
static CGFloat minimumInteritemSpacing = 4;
static NSUInteger collectionViewDisplayMode = 2;
static NSUInteger CellInsets = 1;

@interface GoodsCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation GoodsCollectionViewController

- (void)viewDidLoad
{
    [self initView];
    PFQuery *query = [PFQuery queryWithClassName:ParseGoods];
    WEAK_SELF;
    [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError * _Nullable error) {
        STRONG_SELF;
        NSLog(@"object :%@, \n error: %@", objects, error);
        for(PFObject *object in objects)
            [self.modelArray addObject:[[GoodModel alloc] initWithPFObject:object]];
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image_barbutton_change"] style:UIBarButtonItemStylePlain target:self action:@selector(changeDisplayMode)];
    
    self.navigationItem.leftBarButtonItem = rightButton;
    self.navigationItem.title = @"购物";
}

- (void)initView
{
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-40);
    }];
}

#pragma mark - private

- (void)changeDisplayMode

{
    if(1 == collectionViewDisplayMode)
        collectionViewDisplayMode = 2;
    else
        collectionViewDisplayMode = 1;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:GoodsCollectionViewIdentifier forIndexPath:indexPath];
    [cell loadData:self.modelArray[indexPath.row] withMode:collectionViewDisplayMode];
    
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


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    [self.modelArray removeAllObjects];
//    [self.collectionView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchText = searchText.lowercaseString;
    PFQuery *query0 = [PFQuery queryWithClassName:ParseGoods];
    [query0 whereKey:ParseGoodsName containsString:searchText];
    
    PFQuery *query1 = [PFQuery queryWithClassName:ParseGoods];
    [query1 whereKey:ParseGoodsSellerName containsString:searchText];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[query0, query1]];
    [query findObjectsInBackgroundWithBlock:^(NSArray  *objects, NSError *error) {
        NSLog(@"object :%@, \n error: %@", objects, error);
        [self.modelArray removeAllObjects];
        for(PFObject *object in objects)
            [self.modelArray addObject:[[GoodModel alloc] initWithPFObject:object]];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
    }];
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
            PFQuery *query = [PFQuery queryWithClassName:ParseGoods];
            WEAK_SELF;
            [query findObjectsInBackgroundWithBlock:^(NSArray *_Nullable objects, NSError * _Nullable error) {
                STRONG_SELF;
                NSLog(@"object :%@, \n error: %@", objects, error);
                [self.modelArray removeAllObjects];
                for(PFObject *object in objects)
                    [self.modelArray addObject:[[GoodModel alloc] initWithPFObject:object]];
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView reloadData];
            }];
        }];
        
        [_collectionView registerClass:[GoodsCollectionViewCell class] forCellWithReuseIdentifier:GoodsCollectionViewIdentifier];
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

- (UISearchBar *)searchBar
{
    if(!_searchBar)
    {
        _searchBar = [[UISearchBar alloc] init];
        self.searchBar.delegate = self;
        self.searchBar.backgroundColor = [UIColor whiteColor];
        self.searchBar.placeholder = NSLocalizedString(@"Type good's name to search", nil);
        self.searchBar.tintColor = [UIColor greenColor];
    }
    return _searchBar;
}

@end
