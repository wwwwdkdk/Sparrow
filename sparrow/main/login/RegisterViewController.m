//
//  RegisterViewController.m
//  注册页面
//  sparrow
//
//  Created by hwy on 2021/11/17.
//
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "RegisterViewController.h"
#import "UserHttpRequest.h"
#import <MBProgressHUD.h>
#import "BaseUITabBarController.h"
#import "TcpRequest.h"
#import "BaseData.h"
#import"HttpAddressModel.h"

@interface RegisterViewController ()

@property(strong, nonatomic) UITextField *usernameField;            //用户名输入框
@property(strong, nonatomic) UITextField *password1Field;           //密码输入框
@property(strong, nonatomic) UITextField *password2Field;           //二次密码输入框
@property(strong, nonatomic) UITextField *verificationCodeField;    //验证码输入框
@property(strong, nonatomic) UIButton    *verificationCodeBtn;      //获取验证码按钮
@property(strong, nonatomic) UIButton    *registerBtn;              //注册按钮
@property(strong, nonatomic) UIButton    *backToLoginBtn;           //返回登录页面按钮

@end

@implementation RegisterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initStyle];
	[self initView];
}

#pragma mark - View

//初始化视图样式
- (void)initStyle {
	self.view.backgroundColor = UIColor.whiteColor;

	//立即注册标签
	UILabel *registerLabel = [[UILabel alloc] init];
	[self.view addSubview:registerLabel];
	registerLabel.text = @"立即注册";
	[registerLabel setTextColor:UIColor.blackColor];
	[registerLabel setFont:[UIFont boldSystemFontOfSize:30]];
	[registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(200);
		make.height.mas_equalTo(30);
		make.top.mas_equalTo(50);
		make.left.mas_equalTo(15);
	}];

	//返回登录页面按钮样式
	_backToLoginBtn = [[UIButton alloc] init];
	[self.view addSubview:_backToLoginBtn];
	_backToLoginBtn.layer.cornerRadius = 8;
	_backToLoginBtn.layer.masksToBounds = YES;
	[_backToLoginBtn setTitle:@"返回登录" forState:UIControlStateNormal];
	[_backToLoginBtn setBackgroundColor:PRIMARY_COLOR];
	[_backToLoginBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[_backToLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(80);
		make.height.mas_equalTo(30);
		make.top.mas_equalTo(50);
		make.right.mas_equalTo(-20);
	}];

	//用户名输入框样式
	_usernameField = [[UITextField alloc] init];
	[self.view addSubview:_usernameField];
	_usernameField.placeholder = @"请输入手机号";
	_usernameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	_usernameField.leftViewMode = UITextFieldViewModeAlways;
	_usernameField.returnKeyType = UIReturnKeyNext;
	[_usernameField setFont:[UIFont systemFontOfSize:20]];
	[_usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(self.view);
		make.height.mas_equalTo(50);
		make.top.equalTo(registerLabel.mas_bottom).offset(20);
	}];
	[_usernameField layoutIfNeeded];
	CALayer *bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0, _usernameField.frame.size.height, _usernameField.frame.size.width, 1);
	bottomBorder.backgroundColor = RGB(237, 237, 237).CGColor;
	[_usernameField.layer addSublayer:bottomBorder];

	//密码输入框样式
	_password1Field = [[UITextField alloc] init];
	[self.view addSubview:_password1Field];
	_password1Field.placeholder = @"请输入要设置的密码";
	_password1Field.secureTextEntry = YES;
	_password1Field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	_password1Field.leftViewMode = UITextFieldViewModeAlways;
	_password1Field.returnKeyType = UIReturnKeyNext;
	[_password1Field setFont:[UIFont systemFontOfSize:20]];
	[_password1Field mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.usernameField);
		make.top.equalTo(self.usernameField.mas_bottom).offset(10);
	}];
	[_password1Field layoutIfNeeded];
	bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0, _password1Field.frame.size.height, _password1Field.frame.size.width, 1);
	bottomBorder.backgroundColor = RGB(237, 237, 237).CGColor;
	[_password1Field.layer addSublayer:bottomBorder];

	//二次密码输入框样式
	_password2Field = [[UITextField alloc] init];
	[self.view addSubview:_password2Field];
	_password2Field.placeholder = @"请再次输入要设置的密码";
	_password2Field.secureTextEntry = YES;
	_password2Field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	_password2Field.leftViewMode = UITextFieldViewModeAlways;
	_password2Field.returnKeyType = UIReturnKeyNext;
	[_password2Field setFont:[UIFont systemFontOfSize:20]];
	[_password2Field mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.usernameField);
		make.top.equalTo(self.password1Field.mas_bottom).offset(10);
	}];
	[_password2Field layoutIfNeeded];
	bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0, _password2Field.frame.size.height, _password2Field.frame.size.width, 1);
	bottomBorder.backgroundColor = RGB(237, 237, 237).CGColor;
	[_password2Field.layer addSublayer:bottomBorder];

	//验证码输入框样式
	_verificationCodeField = [[UITextField alloc] init];
	[self.view addSubview:_verificationCodeField];
	_verificationCodeField.placeholder = @"请输入验证码";
	_verificationCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	_verificationCodeField.leftViewMode = UITextFieldViewModeAlways;
	_verificationCodeField.returnKeyType = UIReturnKeyDone;
	[_verificationCodeField setFont:[UIFont systemFontOfSize:20]];
	[_verificationCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.usernameField);
		make.top.equalTo(self.password2Field.mas_bottom).offset(10);
	}];
	[_verificationCodeField layoutIfNeeded];
	bottomBorder = [CALayer layer];
	bottomBorder.frame = CGRectMake(0, _verificationCodeField.frame.size.height, _verificationCodeField.frame.size.width, 1);
	bottomBorder.backgroundColor = RGB(237, 237, 237).CGColor;
	[_verificationCodeField.layer addSublayer:bottomBorder];

	//注册按钮样式
	_registerBtn = [[UIButton alloc] init];
	[self.view addSubview:_registerBtn];
	_registerBtn.layer.cornerRadius = 10;
	_registerBtn.layer.masksToBounds = YES;
	[_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
	[_registerBtn setBackgroundColor:Ban_CLICK_COLOR];
	[_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(self.view).multipliedBy(0.6);
		make.height.mas_equalTo(50);
		make.centerX.equalTo(self.view);
		make.top.equalTo(self.verificationCodeField.mas_bottom).offset(80);
	}];
}

#pragma mark - Controller

- (void)initView {
	self.usernameField.delegate = self;
	self.password1Field.delegate = self;
	self.password2Field.delegate = self;
	self.verificationCodeField.delegate = self;
	[self.usernameField becomeFirstResponder];
	[self.backToLoginBtn addTarget:self action:@selector(backToLogin) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registerBtn addTarget:self action:@selector(userRegister) forControlEvents:(UIControlEventTouchUpInside)];
}

//跳转回登录
- (void)backToLogin {
	[self dismissViewControllerAnimated:YES completion:nil];
}

//正在编辑文本框触发
- (void)textFieldDidChangeSelection:(UITextField *)textField {
	if ([self.usernameField.text isEqualToString:@""] ||
		[self.password1Field.text isEqualToString:@""] ||
		[self.password2Field.text isEqualToString:@""] ||
		[self.verificationCodeField.text isEqualToString:@""]) {
		self.registerBtn.backgroundColor = Ban_CLICK_COLOR;
	} else {
		self.registerBtn.backgroundColor = PRIMARY_COLOR;
	}
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

//键盘return按钮设置
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == self.usernameField) {
		[self.password1Field becomeFirstResponder];
	} else if (textField == self.password1Field) {
		[self.password2Field becomeFirstResponder];
	} else if (textField == self.password2Field) {
		[self.verificationCodeField becomeFirstResponder];
	} else if (textField == self.verificationCodeField) {

	}
	return YES;
}

- (void)userRegister{
    [self userRegister:self.usernameField.text password:self.password1Field.text verificationCode:self.verificationCodeField.text];
}

#pragma mark - Model

- (void)userRegister:(NSString *)username
            password:(NSString *)password
    verificationCode:(NSString *)code {
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.progress = 1;
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"注册中...";
    [hud showAnimated:YES];
    [UserHttpRequest userRegister:^(NSDictionary * _Nonnull data) {
        [hud hideAnimated:YES];

            if([data[@"code"]  isEqual: @"200"]){
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                [defaults setObject:data[@"token"] forKey:@"token"];
                NSString *id = data[@"id"];
                [defaults setObject:id forKey:@"userId"];

                BaseUITabBarController *tabBarController = [[BaseUITabBarController alloc]init];
                [self.navigationController pushViewController:tabBarController animated:YES];
                [self.view.window setRootViewController:tabBarController];
                
                TcpRequest *tcpRequest = [[TcpRequest alloc]init];
                [tcpRequest connectToHost:APP_TCP_BASE_ADDRESS onPort:APP_TCP_BASE_PORT];
                BaseData *baseData = [[BaseData alloc]init];
                [baseData getNewUserInfo];
                
            }else{
                MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
                hud.progress = 1;
                [self.view addSubview:hud];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = @"账户名或密码错误";
                [hud showAnimated:YES];
                [NSTimer scheduledTimerWithTimeInterval:0.3 repeats:NO block:^(NSTimer *timer) {
                    [hud hideAnimated:YES];
                }];
            }
            
        
        } username:username password:password failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [hud hideAnimated:YES];
    }];
}

@end
