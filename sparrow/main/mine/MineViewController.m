//
//  MineViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/8.
//
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import <MJRefreshConfig.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MineViewController.h"
#import "SettingViewController.h"
#import "UserInfoViewController.h"
#import "MineTableViewCell.h"
#import "PostViewController.h"
#import "DynamicViewController.h"
#import "NSString+Size.h"
#import "HttpRequestUtil.h"
#import "BaseModel.h"
#import "UserModel.h"
#import "DynamicModel.h"
#import "UserHttpRequest.h"
#import "DynamicHttpRequest.h"
#import "MJRefresh.h"
#import "UIView+Size.h"
#import "MessageCache.h"
#import "DynamicCache.h"
#import "UserCache.h"
#import "UINavigationController+Switch.h"

//用户头像尺寸
#define MINE_HEAD_PORTRAIT_HEIGHT    APP_SCREEN_WIDTH * 0.22
//头部视图高度
#define MINE_HEAD_HEIGHT             (APP_SCREEN_WIDTH * 0.5 + MINE_HEAD_PORTRAIT_HEIGHT)
//按钮组高度
#define MINE_BUTTON_GROUP_HEIGHT     APP_SCREEN_WIDTH * 0.2
//按钮组按钮宽度
#define MINE_BUTTON_GROUP_BTN_WIDTH  APP_VIEW_WITH_MARGIN_WIDTH / 4
//表头高度
#define MINE_TABLE_HEAD_HEIGHT       (MINE_BUTTON_GROUP_HEIGHT + MINE_HEAD_HEIGHT + APP_PRIMARY_MARGIN * 2)
//按钮中图片和标签间的间距
#define MINE_IMAGE_AND_LABEL_MARGIN  APP_SCREEN_WIDTH * 0.01
//按钮中标签间高度
#define MINE_LABEL_HEIGHT            APP_FONT_SIZE

@interface MineViewController ()

@property (nonnull,strong)CustomNavigationBarView     *navigationBar;                          //导航栏
@property (nonatomic, strong) UITableView             *tableView;                              //页面表格
@property (nonatomic, strong) UIView                  *tableHeaderView;                        //表头视图
@property (nonatomic, strong) UIView                  *headView;                               //头部视图
@property (nonatomic, strong) UIImageView             *headViewBG;                             //头部视图背景
@property (nonatomic, strong) UIView                  *buttonGroupView;
@property (nonatomic, strong) UIImageView             *headPortraitImageView;                  //头像
@property (nonatomic, strong) UIImageView             *headPortraitBGImageView;                //头像背景
@property (nonatomic, strong) UILabel                 *nicknameLabel;                          //昵称
@property (nonatomic, strong) UILabel                 *ageLabel;                               //年龄
@property (nonatomic, strong) UIButton                *naviSettingBtn;                         //导航设置按钮
@property (nonatomic, strong) UIButton                *settingBtn;                             //设置按钮
@property (nonatomic, strong) UIButton                *postBtn;                                //发帖按钮
@property (nonatomic, strong) UIButton                *dynamicBtn;                             //动态按钮
@property (nonatomic, strong) UIButton                *collectionBtn;                          //收藏按钮
@property (nonatomic, strong) UIButton                *agreeBtn;                               //点赞按钮
@property (nonatomic, strong) UIAlertController       *actionSheet;                            //底部选择菜单
@property (nonatomic, strong) UIImagePickerController *pickController;                         //照片选择
@property (nonatomic, assign) CGFloat                  navigationAlpha;                        //导航栏透明度
@property (nonatomic, strong) NSMutableDictionary     *userInfoDictionary;                     //用户信息字典
@property (nonatomic, copy)   void                    (^userInfoBlock)(NSDictionary *data);    //获取到用户信息后回调
@property (nonatomic, copy)   void                    (^userDynamicBlock)(NSDictionary *data); //获取到用户动态后回调
@property (nonatomic, strong) UserModel               *userModel;
@property (nonatomic, strong) NSMutableArray<DynamicModel*> *userDynamicArray;                 //用户动态字典
@property (nonatomic,assign)  bool                    hasMore;                                 //是否有下一页
@property (nonatomic,assign)  NSInteger               page;

@end

@implementation MineViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
	[self initStyle];
	[self initAlertView];
	[self initPhotoChoose];
//    self.userDynamicArray = [[DynamicCache getDynamic] mutableCopy];
	[self initView];
	[self initBlocks];
	[self getUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getUserDynamic];
}

- (void)initNavigation {
    _navigationBar = [[CustomNavigationBarView alloc]init];
    _navigationBar.bgView.alpha = 0;
    [_navigationBar.leftButton setHidden:YES];
    [self.view addSubview:_navigationBar];
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@APP_NAVIGATION_BAR_HEIGHT);
        make.left.top.equalTo(@0);
    }];
    
	[_navigationBar.rightButton addTarget:self action:@selector(pushToSetting) forControlEvents:UIControlEventTouchUpInside];
	[_navigationBar.rightButton  setImage:[UIImage imageNamed:@"settingBlack"] forState:UIControlStateNormal];
}

//初始化样式
- (void)initStyle {
	self.view.backgroundColor = UIColor.whiteColor;
	[self initTableView];
	[self initHeadView];
    [self initNavigation];
}

- (void)initTableView {
	_tableView = [[UITableView alloc] init];
	_tableView.backgroundColor = PRIMARY_BG_COLOR;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:_tableView];
    _tableView.width = self.view.width;
    _tableView.height = APP_SCREEN_HEIGHT - APP_TAG_BAR_HEIGHT;
	if (@available(iOS 15.0, *)) {
		_tableView.sectionHeaderTopPadding = 0;
	}
	 //设置tableview从状态栏开始显示
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MineTableViewCell"];

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //网络请求加载数据完成后在停止刷新
        [self getUserDynamic];
//        [self.tableView.mj_footer endRefreshing];
    }];
    [self.tableView.mj_footer setHidden:YES];

    MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter*)self.tableView.mj_footer;
    [footer setTitle:@"上拉加载" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
    
    
}

- (void)initHeadView {
	_tableHeaderView = [[UIView alloc] init];
	self.tableView.tableHeaderView = _tableHeaderView;
    [self.tableView addSubview:_tableHeaderView];
	_tableHeaderView.backgroundColor = PRIMARY_BG_COLOR;
    _tableHeaderView.top = 0;
    _tableHeaderView.width = self.view.width;
    _tableHeaderView.height = MINE_TABLE_HEAD_HEIGHT;

	//头部视图样式
	_headView = [[UIView alloc] init];
	[self.tableHeaderView addSubview:_headView];
	_headView.backgroundColor = UIColor.whiteColor;
    _headView.width = self.tableHeaderView.width;
    _headView.height = MINE_HEAD_HEIGHT;
    _headView.top = 0;
    
    //头部视图背景
	_headViewBG = [[UIImageView alloc] init];
	[self.headView addSubview:_headViewBG];
	_headViewBG.userInteractionEnabled = YES;
	_headViewBG.contentMode = UIViewContentModeScaleAspectFill;
    [_headViewBG setClipsToBounds:YES];
    _headViewBG.width = self.headView.width;
    _headViewBG.height = MINE_HEAD_HEIGHT - MINE_HEAD_PORTRAIT_HEIGHT / 2;
    _headViewBG.top = 0;

	//头像背景框样式
	_headPortraitBGImageView = [[UIImageView alloc] init];
	_headPortraitBGImageView.layer.cornerRadius = 20;
	_headPortraitBGImageView.layer.masksToBounds = YES;
	_headPortraitBGImageView.backgroundColor = RGB(255, 255, 255);
	_headPortraitBGImageView.userInteractionEnabled = YES;
	[self.headView addSubview:_headPortraitBGImageView];
    _headPortraitBGImageView.width = MINE_HEAD_PORTRAIT_HEIGHT;
    _headPortraitBGImageView.height = MINE_HEAD_PORTRAIT_HEIGHT;
    _headPortraitBGImageView.top = self.headViewBG.bottom - MINE_HEAD_PORTRAIT_HEIGHT / 2;
    _headPortraitBGImageView.centerX = self.headView.centerX;

	//头像样式
	_headPortraitImageView = [[UIImageView alloc] init];
	_headPortraitImageView.layer.cornerRadius = 20;
	_headPortraitImageView.layer.masksToBounds = YES;
    _headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
	[self.headPortraitBGImageView addSubview:_headPortraitImageView];
    _headPortraitImageView.width = self.headPortraitBGImageView.width * 0.96;
    _headPortraitImageView.height = self.headPortraitBGImageView.height * 0.96;
    _headPortraitImageView.centerX = self.headPortraitBGImageView.width / 2;
    _headPortraitImageView.centerY = self.headPortraitBGImageView.height / 2;
    
	//昵称样式
	_nicknameLabel = [[UILabel alloc] init];
	[self.headView addSubview:_nicknameLabel];
	_nicknameLabel.textAlignment = NSTextAlignmentCenter;
	[_nicknameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE + 2]];
	[_nicknameLabel setTextColor:UIColor.blackColor];
	[_nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo((APP_SCREEN_WIDTH - MINE_HEAD_PORTRAIT_HEIGHT) / 2);
		make.top.equalTo(self.headViewBG.mas_bottom);
		make.left.equalTo(self.headPortraitBGImageView.mas_right);
		make.height.equalTo(self.headPortraitBGImageView).multipliedBy(0.5);
	}];

	//年龄样式
	_ageLabel = [[UILabel alloc] init];
	[self.headView addSubview:_ageLabel];
	_ageLabel.textAlignment = NSTextAlignmentCenter;
	[_ageLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE + 2]];
	[_ageLabel setTextColor:UIColor.blackColor];
	[_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(self.nicknameLabel);
        make.left.mas_equalTo(0);
	}];
	[self initButtonGroup];
}

- (void)initButtonGroup {
	//按钮组样式
	_buttonGroupView = [[UIView alloc] init];
	[self.tableHeaderView addSubview:_buttonGroupView];
    _buttonGroupView.backgroundColor = UIColor.whiteColor;
    _buttonGroupView.width = APP_SCREEN_WIDTH;
    _buttonGroupView.height  = MINE_BUTTON_GROUP_HEIGHT;
    _buttonGroupView.top = self.headView.bottom + APP_PRIMARY_MARGIN;
    _buttonGroupView.centerX = self.headView.centerX;

	//动态按钮样式
	_dynamicBtn = [[UIButton alloc] init];
	[self.buttonGroupView addSubview:_dynamicBtn];
	[_dynamicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(MINE_BUTTON_GROUP_HEIGHT);
        make.width.mas_equalTo(MINE_BUTTON_GROUP_BTN_WIDTH);
		make.left.top.mas_equalTo(0);
	}];
	UIImageView *dynamicBtnImageView = [[UIImageView alloc] init];
	dynamicBtnImageView.image = [UIImage imageNamed:@"dynamic"];
	[self.dynamicBtn addSubview:dynamicBtnImageView];
	[dynamicBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(APP_ICON_SIZE);
		make.centerX.equalTo(self.dynamicBtn);
		make.top.mas_equalTo((MINE_BUTTON_GROUP_HEIGHT - MINE_LABEL_HEIGHT - APP_ICON_SIZE - MINE_IMAGE_AND_LABEL_MARGIN) / 2);
	}];
	UILabel *dynamicBtnLabel = [[UILabel alloc] init];
	dynamicBtnLabel.text = @"动态";
    [dynamicBtnLabel setFont:[UIFont systemFontOfSize:APP_SMALL_FONT_SIZE]];
	[self.dynamicBtn addSubview:dynamicBtnLabel];
	dynamicBtnLabel.textAlignment = NSTextAlignmentCenter;
	[dynamicBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.equalTo(self.dynamicBtn);
		make.top.equalTo(dynamicBtnImageView.mas_bottom).mas_equalTo(MINE_IMAGE_AND_LABEL_MARGIN);
		make.height.mas_equalTo(MINE_LABEL_HEIGHT);
	}];

	//发帖按钮样式
	_postBtn = [[UIButton alloc] init];
	[self.buttonGroupView  addSubview:_postBtn];
	[_postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.dynamicBtn);
		make.left.equalTo(self.dynamicBtn.mas_right);
	}];
	UIImageView *postBtnImageView = [[UIImageView alloc] init];
	postBtnImageView.image = [UIImage imageNamed:@"post"];
	[self.postBtn addSubview:postBtnImageView];
	[postBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(dynamicBtnImageView);
		make.centerX.equalTo(self.postBtn);
	}];
	UILabel *postBtnLabel = [[UILabel alloc] init];
	postBtnLabel.text = @"发帖";
    [postBtnLabel setFont:[UIFont systemFontOfSize:APP_SMALL_FONT_SIZE]];
	[self.postBtn addSubview:postBtnLabel];
	postBtnLabel.textAlignment = NSTextAlignmentCenter;
	[postBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(dynamicBtnLabel);
	}];

	//收藏按钮样式
	_collectionBtn = [[UIButton alloc] init];
	[self.buttonGroupView  addSubview:_collectionBtn];
	[_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.dynamicBtn);
		make.left.equalTo(self.postBtn.mas_right);
	}];
	UIImageView *collectionBtnImageView = [[UIImageView alloc] init];
	collectionBtnImageView.image = [UIImage imageNamed:@"noCollection"];
	[self.collectionBtn addSubview:collectionBtnImageView];
	[collectionBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(dynamicBtnImageView);
		make.centerX.equalTo(self.collectionBtn);
	}];
	UILabel *collectionBtnLabel = [[UILabel alloc] init];
	collectionBtnLabel.text = @"收藏";
    [collectionBtnLabel setFont:[UIFont systemFontOfSize:APP_SMALL_FONT_SIZE]];
	[self.collectionBtn addSubview:collectionBtnLabel];
	collectionBtnLabel.textAlignment = NSTextAlignmentCenter;
	[collectionBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(dynamicBtnLabel);
	}];

	//点赞按钮样式
	_agreeBtn = [[UIButton alloc] init];
	[self.buttonGroupView  addSubview:_agreeBtn];
	[_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.dynamicBtn);
		make.left.equalTo(self.collectionBtn.mas_right);
	}];
	UIImageView *agreeBtnImageView = [[UIImageView alloc] init];
	agreeBtnImageView.image = [UIImage imageNamed:@"noAgree"];
	[self.agreeBtn addSubview:agreeBtnImageView];
	[agreeBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(dynamicBtnImageView);
		make.centerX.equalTo(self.agreeBtn);
	}];
	UILabel *agreeBtnLabel = [[UILabel alloc] init];
	agreeBtnLabel.text = @"点赞";
    [agreeBtnLabel setFont:[UIFont systemFontOfSize:APP_SMALL_FONT_SIZE]];
	[self.agreeBtn addSubview:agreeBtnLabel];
	agreeBtnLabel.textAlignment = NSTextAlignmentCenter;
	[agreeBtnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(dynamicBtnLabel);
	}];
}

//初始化底部选择菜单
- (void)initAlertView {
	self.actionSheet = [[UIAlertController alloc] init];
	UIAlertAction *userInfoAction = [UIAlertAction actionWithTitle:@"查看个人资料" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
		[self pushToUserInfo];
	}];
	UIAlertAction *changeBGAction = [UIAlertAction actionWithTitle:@"更改背景" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
		[self presentViewController:self.pickController animated:YES completion:nil];
	}];
    UIAlertAction *changeHeadBGGAction = [UIAlertAction actionWithTitle:@"更改头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self presentViewController:self.pickController animated:YES completion:nil];
    }];
	UIAlertAction *saveBGAction = [UIAlertAction actionWithTitle:@"保存背景图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
		[self saveBGImage];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

	[self.actionSheet addAction:userInfoAction];
	[self.actionSheet addAction:changeBGAction];
    [self.actionSheet addAction:changeHeadBGGAction];
	[self.actionSheet addAction:saveBGAction];
	[self.actionSheet addAction:cancelAction];
}

//将背景图片保存到相册
- (void)saveBGImage {
	UIImageWriteToSavedPhotosAlbum(self.headViewBG.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *) self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	if (!error) {
		MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:hud];
		hud.mode = MBProgressHUDModeText;
		hud.label.text = @"图片保存成功";
		[hud showAnimated:YES];
		[NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer *timer) {
			[hud hideAnimated:YES];
		}];
	}
}

//初始化背景选择控件
- (void)initPhotoChoose {
	self.pickController = [[UIImagePickerController alloc] init];
//	self.pickController.delegate = self;
	self.pickController.allowsEditing = YES;
	self.pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

//选择照片后
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *newImage = info[UIImagePickerControllerEditedImage];
    [UserHttpRequest setBackground:newImage successBlock:^(NSDictionary * _Nonnull data) {
            self.userModel.background = data[@"background"];
            [self.headViewBG sd_setImageWithURL:[[NSURL alloc] initWithString:self.userModel.background]];
    } failBlock:nil];
	[self dismissViewControllerAnimated:YES completion:nil];
}

//初始化,添加视图，添加事件
- (void)initView {
	self.extendedLayoutIncludesOpaqueBars = YES;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.navigationController.delegate = self;
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAlertView)];
	[self.headViewBG addGestureRecognizer:tapGestureRecognizer];
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserInfo)];
	[self.headView addGestureRecognizer:tapGestureRecognizer];
	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserInfo)];
	[self.headPortraitBGImageView addGestureRecognizer:tapGestureRecognizer];

	[self.settingBtn addTarget:self action:@selector(pushToSetting) forControlEvents:UIControlEventTouchUpInside];
	[self.postBtn addTarget:self action:@selector(pushToPost) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicBtn addTarget:self action:@selector(pushToDynamic:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeBtn addTarget:self action:@selector(pushToDynamic:) forControlEvents:UIControlEventTouchUpInside];
    [self.collectionBtn addTarget:self action:@selector(pushToDynamic:) forControlEvents:UIControlEventTouchUpInside];
}

//初始化获取用户信息成功和失败闭包
- (void)initBlocks {
	[self initUserInfoBlock];
	[self initUserDynamicBlock];
}

//跳转到个人信息
- (void)pushToUserInfo {
	self.hidesBottomBarWhenPushed = YES;
	UserInfoViewController *userInfoViewController = [[UserInfoViewController alloc] init];
	[self.navigationController pushViewController:userInfoViewController animated:YES];
	self.hidesBottomBarWhenPushed = NO;
}

//跳转到动态
- (void)pushToDynamic:(UIButton *)sender{
	self.hidesBottomBarWhenPushed = YES;
    
    DynamicViewController *dynamicViewController;
    if(sender == self.dynamicBtn){
        dynamicViewController  = [[DynamicViewController alloc] initWithType:all];
        [dynamicViewController setNaviTitle:@"动态"];
    }else if(sender == self.agreeBtn){
        dynamicViewController  = [[DynamicViewController alloc] initWithType:agree];
        [dynamicViewController setNaviTitle:@"点赞"];
    }else if(sender == self.collectionBtn){
        dynamicViewController  = [[DynamicViewController alloc] initWithType:collection];
        [dynamicViewController setNaviTitle:@"收藏"];
    }
   
	[self.navigationController pushViewController:dynamicViewController animated:YES];
	self.hidesBottomBarWhenPushed = NO;
}

- (void)openAlertView {
	[self presentViewController:self.actionSheet animated:YES completion:nil];
}

//跳转到设置
- (void)pushToSetting {
	self.hidesBottomBarWhenPushed = YES;
	SettingViewController *settingViewController = [[SettingViewController alloc] init];
	[self.navigationController pushViewController:settingViewController animated:YES];
	self.hidesBottomBarWhenPushed = NO;
}

//跳转到发帖
- (void)pushToPost {
	PostViewController *postViewController = [[PostViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MineTableViewCell" model:self.userDynamicArray[(NSUInteger)indexPath.section]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.userDynamicArray == nil){
        return 0;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.userDynamicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return APP_PRIMARY_MARGIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = APP_PRIMARY_MARGIN * 2 + MINE_CELL_HEAD_PORTRAIT_SIZE;     //头像及间距的高度
    NSString *content = self.userDynamicArray[(NSUInteger) indexPath.section].content;
	CGFloat contentHeight = [content calculateSizeOfString:MINE_CELL_CONTENT_WIDTH fontSize:APP_FONT_SIZE].height;
	height += contentHeight > 0 ? (contentHeight + APP_PRIMARY_MARGIN) : 0; //文本内容的高度，内容为空则高度为0
    NSArray<PictureModel*> *picArray =  self.userDynamicArray[(NSUInteger) indexPath.section].picture;
	if(picArray.count == 1){        //一张图的高度
        if(picArray[0].width != nil && picArray[0].height != nil){
            CGFloat proportion = [picArray[0].height floatValue]/[picArray[0].width floatValue];
            height += MINE_CELL_ONE_IMAGE_WIDTH * (proportion <= 2 ?proportion : 2) + APP_PRIMARY_MARGIN;
        }else{
            height += MINE_CELL_ONE_IMAGE_HEIGHT + APP_PRIMARY_MARGIN;
        }
		
	}else if(picArray.count == 2){  //两张图的高度
		height += MINE_CELL_TWO_IMAGE_HEIGHT + APP_PRIMARY_MARGIN;
	}else if(picArray.count >= 2){  //三张及以上的高度
		height += (MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + MINE_CELL_IMAGE_MARGIN) * ((int)(picArray.count - 1 ) / 3) + MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + APP_PRIMARY_MARGIN;
	}
	height += APP_ICON_SIZE + APP_PRIMARY_MARGIN;
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (- offset >= 0) {
        self.headViewBG.height = _headView.height - MINE_HEAD_PORTRAIT_HEIGHT / 2 - offset;
        self.headViewBG.top = offset;
    }
   CGFloat minAlphaOffset = - 64;
   CGFloat maxAlphaOffset = 200;
   CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    
    self.navigationBar.bgView.alpha = offset > 0 ? alpha : 0;
}

- (void)initUserInfoBlock{
	__weak typeof(self) weakSelf = self;

	self.userInfoBlock = ^(NSDictionary *data){
		__weak typeof(weakSelf) strongSelf = weakSelf;
        [UserCache saveUserInfo:data];
        strongSelf.userModel  = [[UserModel alloc]initWithDic:data];
        [strongSelf.headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:strongSelf.userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
        if([strongSelf.userModel.background isEqual:@""]){
            [strongSelf.headViewBG setImage:[UIImage imageNamed:@"noBg"] ];
        }else if (strongSelf.userModel.background != nil){
            [strongSelf.headViewBG sd_setImageWithURL:[[NSURL alloc] initWithString:strongSelf.userModel.background]];
        }
		strongSelf.nicknameLabel.text = strongSelf.userModel.nickname;
        strongSelf.navigationBar.titleLabel.text = strongSelf.userModel.nickname;
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@岁", strongSelf.userModel.age == nil ? @"0" : strongSelf.userModel.age]];
		NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image =  [data[@"gender"] isEqual: @"0"] ?[UIImage imageNamed:@"woman"]:[UIImage imageNamed:@"man"];
		attach.bounds = CGRectMake(0, -4, 20, 20);
		NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attach];
		[attr insertAttributedString:string1 atIndex:0];
		strongSelf.ageLabel.attributedText = attr;
	};
    
   NSDictionary *userDictionary = [UserCache getUserInfoDictionary];
    if (userDictionary.count > 0) {
        self.userInfoBlock([UserCache getUserInfoDictionary]);
    }
}

- (void)initUserDynamicBlock{
	self.userDynamicArray = [[DynamicCache getDynamic] mutableCopy];
    self.page = 1;
	[self.tableView reloadData];

	__weak typeof(self) weakSelf = self;
	self.userDynamicBlock = ^(NSDictionary *data){
		__weak typeof(weakSelf) strongSelf = weakSelf;
        NSArray *dataArray = data[@"data"][@"dynamic"];
        NSLog(@"%@",data);
        strongSelf.hasMore = [data[@"data"][@"hasMore"]  isEqual: @0] ? false : true;
        if (strongSelf.hasMore){
            [strongSelf.tableView.mj_footer setHidden:NO];
            strongSelf.page += 1;
        }else{
            [strongSelf.tableView.mj_footer setHidden:YES];
        }
		[DynamicCache saveDynamic:data];
		for (int i = 0; i < dataArray.count ; i++) {
            [strongSelf.userDynamicArray addObject:[[DynamicModel alloc]initWithDic:data[@"data"][@"dynamic"][i]]];
//            strongSelf.userDynamicArray[strongSelf.userDynamicArray.count + i] = [[DynamicModel alloc]initWithDic:data[@"data"][@"dynamic"][i]];
        }
		[strongSelf.tableView reloadData];
	};
}

//获取用户信息
- (void)getUserInfo {
    [UserHttpRequest getUserInfo:_userInfoBlock failBlock:nil];
}

//获取用户动态信息
- (void)getUserDynamic{
    [DynamicHttpRequest getDynamic:self.page successBlock:_userDynamicBlock failBlock:nil];
}

// 颜色转为图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
