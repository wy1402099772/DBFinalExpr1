//
//  PurchaseLogCollectionViewCell.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/8.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "PurchaseLogCollectionViewCell.h"
#import "ParseHeader.h"
#import <Parse.h>
#import "GoodModel.h"
#import "PurchaseLogModel.h"
#import "ShoppingCartDataController.h"
#import "Masonry.h"
#import "CCommon.h"
#import "UIView+Toast.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserHelper.h"

@interface PurchaseLogCollectionViewCell ()

@property (nonatomic, strong) UILabel           *nameLabel;
@property (nonatomic, strong) UILabel           *priceLabel;
@property (nonatomic, strong) UIImageView       *avatarImage;
@property (nonatomic, strong) UILabel           *amountlabel;
@property (nonatomic, strong) UILabel           *sellername;
@property (nonatomic, strong) UILabel           *dateLabel;
@property (nonatomic, strong) UIButton          *confirmButton;
//@property (nonatomic, strong) UIButton           *selectButton;
//@property (nonatomic, strong) UILabel            *storageLabel;

@property (nonatomic, strong) GoodModel         *good;
@property (nonatomic, strong) PurchaseLogModel  *purchaseLog;

@end

@implementation PurchaseLogCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        
    }
    return self;
}

- (void)configureView
{
    self.contentView.backgroundColor = [UIColor whiteColor];
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
        make.height.mas_equalTo(20);
        make.left.equalTo(self.nameLabel.mas_left);
        make.width.mas_equalTo(100);
    }];
    self.priceLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15];
    
    [self.contentView addSubview:self.sellername];
    [self.sellername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel);
        make.bottom.equalTo(self.priceLabel);
        make.left.equalTo(self.priceLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
    }];
    
//    [self.contentView addSubview:self.selectButton];
//    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(40);
//        make.height.mas_equalTo(40);
//        make.right.equalTo(self.contentView).offset(-8);
//        make.bottom.equalTo(self.contentView).offset(-8);
//    }];
    
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImage.mas_right).offset(3);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(160);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    [self.contentView addSubview:self.amountlabel];
    [self.amountlabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(8);
        make.height.mas_equalTo(20);
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.equalTo(self.contentView).offset(-30);
    }];
    
    [self.contentView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.amountlabel).offset(-3);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.amountlabel.mas_bottom).offset(3);
        make.height.mas_equalTo(24);
    }];
    
//    [self.avatarImage addSubview:self.storageLabel];
//    [self.storageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.avatarImage);
//        make.right.equalTo(self.avatarImage);
//        make.bottom.equalTo(self.avatarImage);
//        make.height.mas_equalTo(21);
//    }];
}

#pragma mark - public

- (void)loadData:(PurchaseLogModel *)purchaseLog withCellMode:(PurchaseControllerType)type
{
    [self configureView];
    self.purchaseLog = purchaseLog;
//    [self.selectButton setSelected:shoppingCart.selected];
    switch (type) {
        case PurchaseControllerTypePurchase: {
            self.amountlabel.text = [NSString stringWithFormat:@"购买数量：%@", purchaseLog.purchaseAmount];
            if([purchaseLog.state isEqualToString:kParsePurchaseLogStateOrder])
            {
                self.confirmButton.enabled = NO;
                [self.confirmButton setTitle:@"等待发货" forState:UIControlStateNormal];
            }
            else if([purchaseLog.state isEqualToString:kParsePurchaseLogStateSend])
            {
                self.confirmButton.enabled = YES;
                [self.confirmButton setTitle:@"确认收货" forState:UIControlStateNormal];
            }
            else if([purchaseLog.state isEqualToString:kParsePurchaseLogStateComplete])
            {
                self.confirmButton.enabled = NO;
                [self.confirmButton setTitle:@"订单已完成" forState:UIControlStateNormal];
            }
            break;
        }
        case PurchaseControllerTypeSell: {
            self.amountlabel.text = [NSString stringWithFormat:@"卖出数量：%@", purchaseLog.purchaseAmount];
            if([purchaseLog.state isEqualToString:kParsePurchaseLogStateOrder])
            {
                self.confirmButton.enabled = YES;
                [self.confirmButton setTitle:@"确认发货" forState:UIControlStateNormal];
            }
            else if([purchaseLog.state isEqualToString:kParsePurchaseLogStateSend])
            {
                self.confirmButton.enabled = NO;
                [self.confirmButton setTitle:@"已发货" forState:UIControlStateNormal];
            }
            else if([purchaseLog.state isEqualToString:kParsePurchaseLogStateComplete])
            {
                self.confirmButton.enabled = NO;
                [self.confirmButton setTitle:@"订单已完成" forState:UIControlStateNormal];
            }
            break;
        }
    }
    self.priceLabel.text = [NSString stringWithFormat:@"成交价格：%@", purchaseLog.purchasePrice];
    self.nameLabel.text = purchaseLog.goodName;
    
    NSDate *currentDate = purchaseLog.date;
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    NSLog(@"%@",currentDateString);
    self.dateLabel.text = currentDateString;
    
    
    [ShoppingCartDataController createGoodFromPurchaseLog:purchaseLog withBlock:^(GoodModel *good, NSError *error) {
        if(error)
        {
            NSString *message = @"加载购物信息失败！请检查网络";
            [[CCommon getTopmostViewController].view makeToast:message duration:1.5 position:CSToastPositionCenter];
        }
        else
        {
            switch (type) {
                case PurchaseControllerTypePurchase: {
                    self.sellername.text = [NSString stringWithFormat:@"卖家：%@", good.sellerName];
                    break;
                }
                case PurchaseControllerTypeSell: {
                    self.sellername.text = [NSString stringWithFormat:@"买家：%@", purchaseLog.userName];
                    break;
                }
            }
            
            if(good.images.count)
                [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:(NSString *)good.images[0]] placeholderImage:[[UIImage imageNamed:@"Image_goods_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            else
            {
                [self.avatarImage setImage:[[UIImage imageNamed:@"Image_goods_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            }
//            if(shoppingCart.amount <= good.amount)
//                self.storageLabel.hidden = YES;
//            else
//                self.storageLabel.text = @"库存不足";
        }
    }];
}

#pragma mark - private

- (void)confirmAction:(UIButton *)sender
{
    [[UserHelper sharedInstance] dealPurchaseLog:self.purchaseLog withBlock:^(NSError *error) {
        NSString *message;
        if(error)
            message = @"操作失败";
        else
            message = @"操作成功";
        [[CCommon getTopmostViewController].view makeToast:message duration:1.5f position:CSToastPositionCenter];
            
    }];
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

- (UIImageView *)avatarImage
{
    if(!_avatarImage)
    {
        _avatarImage = [[UIImageView alloc] init];
        _avatarImage.tintColor = [UIColor grayColor];
    }
    return _avatarImage;
}

- (UILabel *)amountlabel
{
    if(!_amountlabel)
    {
        _amountlabel = [[UILabel alloc] init];
        _amountlabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15];
    }
    return _amountlabel;
}

- (UILabel *)sellername
{
    if(!_sellername)
    {
        _sellername = [[UILabel alloc] init];
    }
    return _sellername;
}

- (UILabel *)dateLabel
{
    if(!_dateLabel)
    {
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:15];
    }
    return _dateLabel;
}

- (UIButton *)confirmButton
{
    if(!_confirmButton)
    {
        _confirmButton = [UIButton new];
        [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundColor:[UIColor colorWithRed:1.000 green:0.033 blue:0.015 alpha:0.100]];
        [_confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

//- (UIButton *)selectButton
//{
//    if(!_selectButton)
//    {
//        _selectButton = [[UIButton alloc] init];
//        [_selectButton setImage:[UIImage imageNamed:@"image_login_showpassword_off"] forState:UIControlStateNormal];
//        [_selectButton setImage:[UIImage imageNamed:@"image_login_showpassword_on"] forState:UIControlStateSelected];
//        [_selectButton addTarget:self action:@selector(selectButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _selectButton;
//}
//
//- (UILabel *)storageLabel
//{
//    if(!_storageLabel)
//    {
//        _storageLabel = [UILabel new];
//        _storageLabel.backgroundColor = [UIColor colorWithRed:0.964 green:1.000 blue:0.950 alpha:0.8000];
//        _storageLabel.opaque = NO;
//        _storageLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _storageLabel;
//}

@end
