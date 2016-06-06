//
//  LoginViewController.m
//  DBFinalExpr1
//
//  Created by 万延 on 16/6/6.
//  Copyright © 2016年 万延. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "UIView+Toast.h"

@interface LoginTextView ()

@property (nonatomic, strong)   UIImageView     *imageView;
@property (nonatomic, strong)   UIView          *separationLine;
@property (nonatomic, strong)   UITextField     *textField;

@end

@implementation LoginTextView

#pragma mark - Init

- (instancetype)initWithCategory:(LoginTextViewCategory)category {
    if (self = [super init]) {
        [self commonInit];
        [self configureWithCategory:category];
    }
    return self;
}

- (void)commonInit {
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 5.0f;
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(11);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(14);
        make.height.mas_equalTo(14);
    }];
    
    [self addSubview:self.separationLine];
    [self.separationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.offset(10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(16);
    }];
    
    [self addSubview:self.textField];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.separationLine.mas_right).with.offset(10);
        make.centerY.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(18);
    }];
}

- (void)configureWithCategory:(LoginTextViewCategory)category {
    
    switch (category) {
        case LoginTextViewCategoryUsername: {
            self.imageView.image = [UIImage imageNamed:@"image_login_username_icon"];
            self.textField.placeholder = NSLocalizedString(@"Username", nil);
            self.textField.secureTextEntry = NO;
        }
            break;
        case LoginTextViewCategoryPassword: {
            self.imageView.image = [UIImage imageNamed:@"image_login_password_icon"];
            self.textField.placeholder = NSLocalizedString(@"Password", nil);
            self.textField.secureTextEntry = YES;
        }
            break;
            
        default:
            NSLog(@"Should never reach here!");
            break;
    }
}

#pragma mark - Public methods
- (NSString *)text {
    return self.textField.text;
}

#pragma mark - Getters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIView *)separationLine {
    if (!_separationLine) {
        _separationLine = [[UIView alloc] init];
        _separationLine.backgroundColor = [UIColor grayColor];
    }
    return _separationLine;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor whiteColor];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _textField.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14];
    }
    return _textField;
}

@end

@interface LoginViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView            *containerView;
@property (nonatomic, strong) LoginTextView     *usernameTextField;
@property (nonatomic, strong) LoginTextView     *passwordTextField;
@property (nonatomic, strong) UIButton          *loginButton;
@property (nonatomic, strong) UIButton          *showPasswordButton;
@property (nonatomic, strong) UILabel           *showPasswordLable;

@property (nonatomic, assign) BOOL              showPasswordButtonCliecked;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureViews];
}

- (void)onLogin:(UIButton *)sender
{
    if (0 == self.usernameTextField.text.length || 0 == self.passwordTextField.text.length)
    {
        [self.view makeToast:NSLocalizedString(@"Username and Password can't be empty!", nil) duration:2.0 position:@"center"];
        return;
    }
    
    
}

- (void)showPassword:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    
    BOOL isFirstResponder = self.passwordTextField.textField.isFirstResponder;
    if (isFirstResponder){
        [self.passwordTextField.textField resignFirstResponder];
    }
    
    self.passwordTextField.textField.secureTextEntry = !self.passwordTextField.textField.secureTextEntry;
    
    if (isFirstResponder){
        [self.passwordTextField.textField becomeFirstResponder];
    }
    
}

#pragma mark - Configure
- (void)configureViews {
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.size.equalTo(self.view);
    }];

    
    [self.view addSubview:self.usernameTextField];
    self.usernameTextField.textField.delegate = self;
    self.usernameTextField.textField.returnKeyType = UIReturnKeyNext;
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.equalTo(self.view).offset(48);
        make.right.equalTo(self.view).offset(-48);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.passwordTextField];
    self.passwordTextField.textField.delegate = self;
    self.passwordTextField.textField.returnKeyType = UIReturnKeyDone;
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(16);
        make.left.equalTo(self.view).offset(48);
        make.right.equalTo(self.view).offset(-48);
        make.height.mas_equalTo(40);
    }];
    
    [self.view addSubview:self.showPasswordButton];
    [self.showPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).with.offset(12);
        make.right.equalTo(self.passwordTextField);
        make.width.mas_equalTo(22);
        make.height.mas_equalTo(20);
    }];
    
    
    [self.view addSubview:self.showPasswordLable];
    [self.showPasswordLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.showPasswordButton.mas_left).with.offset(-7);
        make.centerY.equalTo(self.showPasswordButton);
        make.width.mas_equalTo(116);
        make.height.mas_equalTo(18);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.showPasswordButton.mas_bottom).offset(10);
        make.left.equalTo(self.containerView).with.offset(60);
        make.right.equalTo(self.containerView).with.offset(-60);
        make.height.mas_equalTo(36);
    }];
}

#pragma mark - getter

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithRed:0.636 green:0.857 blue:1.000 alpha:1.000];
    }
    return _containerView;
}

- (LoginTextView *)usernameTextField {
    if (!_usernameTextField) {
        _usernameTextField = [[LoginTextView alloc] initWithCategory:LoginTextViewCategoryUsername];
    }
    return _usernameTextField;
}

- (LoginTextView *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[LoginTextView alloc] initWithCategory:LoginTextViewCategoryPassword];
    }
    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        _loginButton.backgroundColor = [UIColor whiteColor];
        _loginButton.layer.cornerRadius = 5.0f;
        _loginButton.titleLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Medium" size:16];
        [_loginButton setTitleColor:[UIColor colorWithRed:0.436 green:0.670 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
        [_loginButton setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
        
        [_loginButton addTarget:self action:@selector(onLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)showPasswordButton {
    if (!_showPasswordButton) {
        _showPasswordButton  = [[UIButton alloc] init];
        [_showPasswordButton setImage:[UIImage imageNamed:@"image_login_showpassword_off"] forState:UIControlStateNormal];
        [_showPasswordButton setImage:[UIImage imageNamed:@"image_login_showpassword_on"] forState:UIControlStateSelected];
        [_showPasswordButton addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPasswordButton;
}

- (UILabel *)showPasswordLable{
    if (!_showPasswordLable) {
        _showPasswordLable = [[UILabel alloc] init];
        _showPasswordLable.text = NSLocalizedString(@"Show Password", nil) ;
        _showPasswordLable.textColor = [UIColor blackColor];
        _showPasswordLable.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    }
    return _showPasswordLable;
}

@end
