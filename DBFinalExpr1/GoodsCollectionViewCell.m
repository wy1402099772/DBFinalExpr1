//
//  GoodsCollectionViewCell.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/5.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "GoodsCollectionViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GoodModel.h"
#import "UserHelper.h"
#import "UIView+Toast.h"
#import "CCommon.h"

@interface GoodsCollectionViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *scorelabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *classifyLabel;
@property (nonatomic, strong) UIImageView *avatarImage;
@property (nonatomic, strong) UIButton *addToShopCar;
@property (nonatomic, strong) GoodModel *model;

@end

@implementation GoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)configureViewWithMode:(NSUInteger)mode
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    if(1 == mode)
    {
        [self.contentView addSubview:self.avatarImage];
        [self.avatarImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(10);
            make.left.equalTo(self.contentView.mas_left).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
            make.width.equalTo(self.avatarImage.mas_height);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImage.mas_top);
            make.height.mas_equalTo(35);
            make.left.equalTo(self.avatarImage.mas_right).offset(10);
            make.right.equalTo(self.contentView).offset(-8);
        }];
        self.nameLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30];
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(30);
            make.left.equalTo(self.nameLabel.mas_left);
            make.width.mas_equalTo(100);
        }];
        self.priceLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15];
        
        [self.contentView addSubview:self.scorelabel];
        [self.scorelabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(30);
            make.left.equalTo(self.priceLabel.mas_right).offset(8);
            make.width.mas_equalTo(80);
        }];
        self.scorelabel.hidden = NO;
        
        [self.contentView addSubview:self.classifyLabel];
        [self.classifyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
            make.bottom.equalTo(self.avatarImage);
            make.width.mas_equalTo(100);
            make.left.equalTo(self.priceLabel);
        }];
        self.classifyLabel.hidden = NO;
    }
    else
    {
        [self.contentView addSubview:self.avatarImage];
        [self.avatarImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(self.avatarImage.mas_width);
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImage.mas_bottom);
            make.height.mas_equalTo(20);
            make.left.equalTo(self.avatarImage);
            make.right.equalTo(self.avatarImage);
        }];
        self.nameLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15];
        
        [self.contentView addSubview:self.priceLabel];
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        self.priceLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15];
        
        self.scorelabel.hidden = YES;
        self.classifyLabel.hidden = YES;
    }
    [self.contentView addSubview:self.addToShopCar];
    [self.addToShopCar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.right.equalTo(self.contentView).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
}

- (void)addIntoShoppingCart:(UIButton *)sender
{
    [[CCommon getTopmostViewController].view makeToastActivity:CSToastPositionCenter];
    [[UserHelper sharedInstance] addGood:self.model.goodID withBlock:^(NSError *error) {
        NSString *message;
        if(error)
            message = @"加入失败";
        else
            message = @"已加入购物车";
        [[CCommon getTopmostViewController].view hideToastActivity];
        
        [[CCommon getTopmostViewController].view makeToast:message duration:1.5f position:CSToastPositionCenter];
    }];
}

- (void)loadData:(GoodModel *)model withMode:(NSUInteger)mode
{
    self.model = model;
    [self configureViewWithMode:mode];
    
    if(model.images.count)
        [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:(NSString *)model.images[0]] placeholderImage:[[UIImage imageNamed:@"Image_goods_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    else
    {
        [self.avatarImage setImage:[[UIImage imageNamed:@"Image_goods_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    }
    
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ RMB", [model.price stringValue]];
    self.scorelabel.text = [NSString stringWithFormat:@"%@ 分", [model.score stringValue]];
    self.classifyLabel.text = [NSString stringWithFormat:@"分类：%@", model.classify];
}

#pragma mark - getter

- (UILabel *)nameLabel
{
    if(!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:30];
        _nameLabel.textColor = [UIColor blueColor];
    }
    return _nameLabel;
}

- (UILabel *)scorelabel
{
    if(!_scorelabel)
    {
        _scorelabel = [[UILabel alloc] init];
        _scorelabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:21];
        _scorelabel.textColor = [UIColor blackColor];
    }
    return _scorelabel;
}

- (UILabel *)priceLabel
{
    if(!_priceLabel)
    {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:21];
        _priceLabel.textColor = [UIColor blackColor];
    }
    return _priceLabel;
}

- (UILabel *)classifyLabel
{
    if(!_classifyLabel)
    {
        _classifyLabel = [[UILabel alloc] init];
        _classifyLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:21];
        _classifyLabel.textColor = [UIColor blackColor];
    }
    return _classifyLabel;
}

- (UIImageView *)avatarImage
{
    if(!_avatarImage)
    {
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.tintColor = [UIColor grayColor];
    }
    return _avatarImage;
}

- (UIButton *)addToShopCar
{
    if(!_addToShopCar)
    {
        _addToShopCar = [[UIButton alloc] init];
        [_addToShopCar setImage:[UIImage imageNamed:@"image_shop_add"] forState:UIControlStateNormal];
        [_addToShopCar addTarget:self action:@selector(addIntoShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addToShopCar;
}

@end
