//
//  SellerEditViewController.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/8.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "SellerEditViewController.h"
#import "Masonry.h"
#import "ParseHeader.h"
#import <Parse.h>
#import "UIView+Toast.h"

@interface SellerEditViewController ()

@property (nonatomic, strong) GoodModel *model;
@property (nonatomic, assign) SellerEditType type;

@property (nonatomic, strong) UITextField *nameText;
@property (nonatomic, strong) UITextField *goodIDText;
@property (nonatomic, strong) UITextField *priceText;
@property (nonatomic, strong) UITextField *storageText;

@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SellerEditViewController

- (instancetype)initWithGoodModel:(GoodModel *)model mode:(SellerEditType)type
{
    if(self = [super init])
    {
        _model = model;
        _type = type;
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    self.view.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    
    [self.view addSubview:self.nameText];
    [self.view addSubview:self.goodIDText];
    [self.view addSubview:self.priceText];
    [self.view addSubview:self.storageText];
    [self.view addSubview:self.confirmButton];
    
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.goodIDText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameText.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.priceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodIDText.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.storageText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceText.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-50);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(50);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.type == SellerTypeEdit)
    {
        self.nameText.text = self.model.name;
        self.goodIDText.text = self.model.goodID;
        self.priceText.text = self.model.price.stringValue;
        self.storageText.text = self.model.amount.stringValue;
    }
}

- (void)buttonDidClicked:(UIButton *)button
{
    switch (self.type) {
        case SellerTypeAdd: {
            
            break;
        }
        case SellerTypeEdit: {
            [self.view makeToastActivity:CSToastPositionCenter];
            PFQuery *query = [PFQuery queryWithClassName:ParseGoods];
            [query whereKey:ParseGoodsGoodId equalTo:self.model.goodID];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if(nil == error)
                {
                    [object setObject:self.nameText.text forKey:ParseGoodsName];
                    [object setObject:self.goodIDText.text forKey:ParseGoodsGoodId];
                    [object setObject:@(self.priceText.text.intValue) forKey:ParseGoodsPrice];
                    [object setObject:@(self.storageText.text.intValue) forKey:ParseGoodStorageAmount];
                    
                    [object saveInBackground];
                    [self.view hideToastActivity];
                }
            }];
            
            break;
        }
    }
}

#pragma mark - getter

- (UITextField *)nameText
{
    if(!_nameText)
    {
        _nameText = [[UITextField alloc] init];
        _nameText.placeholder = @"商品名";
    }
    return _nameText;
}

- (UITextField *)goodIDText
{
    if(!_goodIDText)
    {
        _goodIDText = [[UITextField alloc] init];
        _goodIDText.placeholder = @"商品ID";
    }
    return _goodIDText;
}

- (UITextField *)priceText
{
    if(!_priceText)
    {
        _priceText = [[UITextField alloc] init];
        _priceText.placeholder = @"单价";
    }
    return _priceText;
}

- (UITextField *)storageText
{
    if(!_storageText)
    {
        _storageText = [[UITextField alloc] init];
        _storageText.placeholder = @"库存";
    }
    return _storageText;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [[UIButton alloc] init];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        _confirmButton.titleLabel.textColor = [UIColor blackColor];
        _confirmButton.backgroundColor = [UIColor greenColor];
        [_confirmButton addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
