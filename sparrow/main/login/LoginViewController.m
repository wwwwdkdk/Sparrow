//
//  LoginViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/5.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "LoginViewController.h"
#import "BaseUITabBarController.h"
#import "BaseModel.h"
#import "RegisterViewController.h"
#import <MBProgressHUD.h>
#import "HttpRequestUtil.h"
#import "TcpRequest.h"
#import "UserHttpRequest.h"
#include "BaseData.h"

#define LOGIN_TEXT_FIELD_WIDTH               APP_SCREEN_WIDTH * 0.7               //文本框宽度
#define LOGIN_TEXT_FIELD_HEIGHT              APP_TEXT_FIELD_HEIGHT * 1.2          //文本框高度
#define LOGIN_LOGO_WIDTH                     APP_SCREEN_WIDTH * 0.76              //logo宽度
#define LOGIN_LOGO_HEIGHT                    APP_SCREEN_WIDTH * 0.25              //logo高度

@interface LoginViewController ()

@property (nonatomic,strong)UIImageView      *logoView;                           //logo
@property (nonatomic,strong)UITextField      *usernameField;                      //账号输入框
@property (nonatomic,strong)UITextField      *passwordField;                      //密码输入框
@property (nonatomic,strong)UIButton         *loginBtn;                           //登录按钮
@property (nonatomic,strong)UIButton         *registerBtn;                        //注册按钮
@property (nonatomic,copy)  void             (^loginBlock)(NSDictionary *data);   //发起登录后回调
     
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
    [self initView];
    [self initBlocks];
    
}

#pragma mark -View

//初始化样式
-(void)initStyle{
    self.view.backgroundColor = PRIMARY_COLOR;
    //logo样式
    _logoView = [[UIImageView alloc]init];
    _logoView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:_logoView];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_SCREEN_HEIGHT*0.18);
        make.height.mas_equalTo(LOGIN_LOGO_HEIGHT);
        make.width.mas_equalTo(LOGIN_LOGO_WIDTH);
        make.centerX.equalTo(self.view);
    }];
    
    //账号输入框样式
    _usernameField = [[UITextField alloc]init];
    [self.view addSubview:_usernameField];
    _usernameField.layer.cornerRadius = 10;
    _usernameField.layer.masksToBounds = YES;
    _usernameField.backgroundColor = UIColor.whiteColor;
    _usernameField.placeholder = @"请输入用户名";
    _usernameField.returnKeyType = UIReturnKeyNext;
    _usernameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    [_usernameField setValue:UIColor.grayColor forKeyPath:@"placeholderLabel.textColor"];
    [_usernameField setTextColor:UIColor.blackColor];
    [_usernameField
    mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(LOGIN_TEXT_FIELD_WIDTH);
        make.height.mas_equalTo(LOGIN_TEXT_FIELD_HEIGHT);
        make.top.equalTo(self.logoView.mas_bottom).offset(APP_SCREEN_HEIGHT*0.1);
    }];
    
    //密码输入框样式
    _passwordField = [[UITextField alloc]init];
    [self.view addSubview:_passwordField];
    _passwordField.layer.cornerRadius = 10;
    _passwordField.layer.masksToBounds = YES;
    _passwordField.backgroundColor = UIColor.whiteColor;
    _passwordField.placeholder = @"请输入密码";
    _passwordField.secureTextEntry = YES;
    _passwordField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.returnKeyType = UIReturnKeyDone;
    [_passwordField setTextColor:UIColor.blackColor];
    [_passwordField setValue:UIColor.grayColor forKeyPath:@"placeholderLabel.textColor"];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self.usernameField);
        make.top.equalTo(self.usernameField.mas_bottom).offset(APP_PRIMARY_MARGIN);
    }];
   
    //登录按钮样式
    _loginBtn = [[UIButton alloc]init];
    [self.view addSubview:_loginBtn];
    _loginBtn.layer.cornerRadius = 10;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.backgroundColor = Ban_CLICK_COLOR;
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self.usernameField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(APP_PRIMARY_MARGIN*2);
    }];
    
    //注册按钮样式
    _registerBtn = [[UIButton alloc]init];
    [self.view addSubview:_registerBtn];
    [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(50);
        make.right.mas_equalTo(-20);
    }];
    
    
}

#pragma mark - Controller
//添加视图,添加事件
-(void)initView{
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    [self.loginBtn addTarget:self action:@selector(checkInputFormat)forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn addTarget:self action:@selector(pushToRegister)forControlEvents:(UIControlEventTouchUpInside)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"触发didend");
}

//正在编辑文本框触发
- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if(![self.usernameField.text isEqual:@""]&&![self.passwordField.text isEqual:@""]){
        self.loginBtn.backgroundColor = CORRECT_COLOR;
        [self.loginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }else{
        self.loginBtn.backgroundColor = Ban_CLICK_COLOR;
        [self.loginBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    }
}

//初始化登录成功和登录失败闭包
-(void)initBlocks{
    __weak typeof(self) weakSelf = self;
    self.loginBlock = ^(NSDictionary *data){
        __weak typeof(weakSelf) strongSelf = weakSelf;
        if([data[@"code"]  isEqual: @"10000"]){
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:data[@"data"][@"token"] forKey:@"token"];
            NSString *id = data[@"data"][@"id"];
            [defaults setObject:id forKey:@"userId"];

            BaseUITabBarController *tabBarController = [[BaseUITabBarController alloc]init];
            [strongSelf.navigationController pushViewController:tabBarController animated:YES];
            [strongSelf.view.window setRootViewController:tabBarController];
            
            TcpRequest *tcpRequest = [[TcpRequest alloc]init];
            [tcpRequest connectToHost:APP_TCP_BASE_ADDRESS onPort:APP_TCP_BASE_PORT];
            BaseData *baseData = [[BaseData alloc]init];
            [baseData getNewUserInfo];
            
        }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:strongSelf.view];
            hud.progress = 1;
            [strongSelf.view addSubview:hud];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = @"账户名或密码错误";
            [hud showAnimated:YES];
            [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer *timer) {
                [hud hideAnimated:YES];
            }];
        }
    };
}

//检查输入的格式
-(void)checkInputFormat{
    if([_usernameField.text isEqual:@""]){ //用户名判空
        NSLog(@"用户名为空");
    }else if([_passwordField.text isEqual:@""]){ //密码判空
        NSLog(@"密码为空");
    }else{
        [self userLogin:_usernameField.text password:_passwordField.text];
    }
}

//跳转注册
-(void)pushToRegister{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    registerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:registerViewController animated:YES completion:nil];
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//键盘return按钮设置
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField){
        [self checkInputFormat];
    }
    return YES;
}


#pragma mark - Model

//发起登录请求
-(void)userLogin :(NSString *)username
         password:(NSString *)password{
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.progress = 1;
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"登录中...";
    [hud showAnimated:YES];
    
    [UserHttpRequest userLogin:^(NSDictionary * _Nonnull data) {
        [hud hideAnimated:YES];
            self.loginBlock(data);

        } username:username password:password failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            hud.label.text = @"碰到了一点问题";
            [NSTimer scheduledTimerWithTimeInterval:0.2 repeats:NO block:^(NSTimer *timer) {
                [hud hideAnimated:YES];
           }];
        }];
    
}



@end
