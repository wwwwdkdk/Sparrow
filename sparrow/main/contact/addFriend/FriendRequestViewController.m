////
////  FriendRequestViewController.m
////  sparrow
////
////  Created by hwy on 2021/12/24.
////
//
//#import "FriendRequestViewController.h"
//#import <Masonry/MASConstraintMaker.h>
//#import <Masonry/View+MASAdditions.h>
//#import "UITextView+Placeholder.h"
//
////文本框高度
//#define MINE_POST_TEXT_VIEW_HEIGHT               APP_SCREEN_WIDTH * 0.5
////按钮宽度
//#define MINE_POST_BUTTON_WIDTH                   APP_SCREEN_WIDTH * 0.2
////按钮高度
//#define MINE_POST_BUTTON_HEIGHT                  MINE_POST_BUTTON_WIDTH * 0.4
////添加图片按钮尺寸
//#define MINE_POST_ADD_BUTTON_SIZE                APP_SCREEN_WIDTH * 0.3
////主视图高度
//#define MINE_POST_CONTENT_HEIGHT                 (MINE_POST_TEXT_VIEW_HEIGHT + APP_PRIMARY_MARGIN * 2 + MINE_POST_ADD_BUTTON_SIZE)
//
//@interface FriendRequestViewController ()
//
//@property(nonatomic, strong) UserModel *userModel;
//@property(nonatomic, strong) UIButton *backBtn;                     //返回按钮
//@property(nonatomic, strong) UIButton *postBtn;                     //发表按钮
//
//@end
//
//@implementation FriendRequestViewController
//
//- (void)viewDidLoad {
//	[super viewDidLoad];
//	[self initStyle];
//	[self initView];
//
//}
//
//- (instancetype)initWithUserInfo:(UserModel *)userModel {
//	if (self = [super init]) {
//		_userModel = userModel;
//	}
//	return self;
//}
//
//- (void)initStyle {
//	[self initNavigation];
//}
//
//
//// 初始化导航
//- (void)initNavigation {
//	self.navigationItem.title = @"发帖";
//	UIView *rightView = [[UIView alloc] init];
//	rightView.frame = CGRectMake(0, 0, MINE_POST_BUTTON_WIDTH, MINE_POST_BUTTON_HEIGHT);
//	_postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//	_postBtn.layer.cornerRadius = 8;
//	_postBtn.layer.masksToBounds = YES;
//	[_postBtn setTitle:@"发表" forState:UIControlStateNormal];
//	[_postBtn setBackgroundColor:PRIMARY_COLOR];
//	[_postBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//	[rightView addSubview:_postBtn];
//	_postBtn.frame = rightView.frame;
//	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
//	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLast)];
//}
//
//
//- (void)initView {
//	[self.backBtn addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)backToLast {
//	[self dismissViewControllerAnimated:YES completion:nil];
//}


//@end
