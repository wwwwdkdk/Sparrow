//
//  PostViewController.m
//  sparrow
//
//  Created by hwy on 2021/12/1.
//

#import "PostViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "UITextView+Placeholder.h"
#import "DynamicHttpRequest.h"
#import <Photos/Photos.h>
#import <MBProgressHUD.h>

//文本框高度
#define MINE_POST_TEXT_VIEW_HEIGHT               APP_SCREEN_WIDTH * 0.5
//按钮宽度
#define MINE_POST_BUTTON_WIDTH                   APP_SCREEN_WIDTH * 0.2
//按钮高度
#define MINE_POST_BUTTON_HEIGHT                  MINE_POST_BUTTON_WIDTH * 0.4
//添加图片按钮尺寸
#define MINE_POST_ADD_BUTTON_SIZE                (APP_VIEW_WITH_MARGIN_WIDTH-APP_PRIMARY_MARGIN*4) / 3
//主视图高度
#define MINE_POST_CONTENT_HEIGHT                 (MINE_POST_TEXT_VIEW_HEIGHT + APP_PRIMARY_MARGIN * 2 + MINE_POST_ADD_BUTTON_SIZE)

@interface PostViewController ()

@property (nonatomic, strong) UIView                  *contentView;                 //主要视图
@property (nonatomic, strong) UITextView              *postTextView;                //发帖文本框
@property (nonatomic, strong) UIButton                *backBtn;                     //返回按钮
@property (nonatomic, strong) UIButton                *postBtn;                     //发表按钮
@property (nonatomic, strong) UIButton                *addBtn;                      //添加图片按钮
@property (nonatomic, strong) UIAlertController       *actionSheet;                 //底部选择菜单
@property (nonatomic, strong) QBImagePickerController *imagePickerController;
@property (nonatomic,strong) PHImageRequestOptions    *requestOptions;
@property (nonatomic,strong) NSMutableArray<UIImage*> *imageArray;

@end

@implementation PostViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self initPhotoChoose];
	[self initStyle];
	[self initView];
}

- (void)initStyle {
	[self initNavigation];
	[self initContentView];
	[self initAlertView];
}


// 初始化导航
- (void)initNavigation {
	NSDictionary *fontDic = @{NSForegroundColorAttributeName: [UIColor blackColor],
		NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
	if (@available(iOS 15.0, *)) {
		UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
		barApp.backgroundImage = [UIImage new];
		barApp.titleTextAttributes = fontDic;
		self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
		self.navigationController.navigationBar.standardAppearance = barApp;
	} else {
		self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
		self.navigationController.navigationBar.titleTextAttributes = fontDic;
		[self.navigationController.navigationBar setBackgroundColor:UIColor.whiteColor];
	}

	self.navigationController.navigationBar.tintColor = PRIMARY_COLOR;
	self.navigationItem.title = @"发帖";

	UIView *rightView = [[UIView alloc] init];
	rightView.frame = CGRectMake(0, 0, MINE_POST_BUTTON_WIDTH, MINE_POST_BUTTON_HEIGHT);
	_postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	_postBtn.layer.cornerRadius = 8;
	_postBtn.layer.masksToBounds = YES;
	[_postBtn setTitle:@"发表" forState:UIControlStateNormal];
	[_postBtn setBackgroundColor:PRIMARY_COLOR];
	[_postBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[rightView addSubview:_postBtn];
	_postBtn.frame = rightView.frame;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToLast)];
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
}

- (void)initBackBtn {
	_backBtn = [[UIButton alloc] init];
	[self.view addSubview:_backBtn];
	_backBtn.layer.cornerRadius = 8;
	_backBtn.layer.masksToBounds = YES;
	[_backBtn setTitle:@"取消" forState:UIControlStateNormal];
	[_backBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
	[_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(MINE_POST_BUTTON_WIDTH);
		make.height.mas_equalTo(MINE_POST_BUTTON_HEIGHT);
		make.top.mas_equalTo(APP_PRIMARY_MARGIN * 3);
		make.left.mas_equalTo(APP_PRIMARY_MARGIN);
	}];
}

- (void)initPostBtn {
	_postBtn = [[UIButton alloc] init];
	[self.view addSubview:_postBtn];
	_postBtn.layer.cornerRadius = 8;
	_postBtn.layer.masksToBounds = YES;
	[_postBtn setTitle:@"发表" forState:UIControlStateNormal];
	[_postBtn setBackgroundColor:PRIMARY_COLOR];
	[_postBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
	[_postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.top.equalTo(self.backBtn);
		make.right.mas_equalTo(-APP_PRIMARY_MARGIN);
	}];
}

- (void)initContentView {
	_contentView = [[UIView alloc] init];
	_contentView.backgroundColor = UIColor.whiteColor;
	_contentView.layer.cornerRadius = 10;
	_contentView.layer.masksToBounds = YES;
	[self.view addSubview:_contentView];
	[_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.width.mas_equalTo(APP_VIEW_WITH_MARGIN_WIDTH);
		make.top.mas_equalTo(APP_NAVIGATION_BAR_HEIGHT + APP_PRIMARY_MARGIN);
		make.height.mas_equalTo(MINE_POST_CONTENT_HEIGHT);
	}];

	_postTextView = [[UITextView alloc] init];
	_postTextView.backgroundColor = UIColor.whiteColor;
	_postTextView.placeholder = @"请输入您要分享的心情";
	_postTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 0, 8);
	[_postTextView becomeFirstResponder];
	[_postTextView setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	[self.contentView addSubview:_postTextView];
	[_postTextView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.view);
		make.width.equalTo(self.contentView);
		make.top.mas_equalTo(0);
		make.height.mas_equalTo(MINE_POST_TEXT_VIEW_HEIGHT);
	}];

	_addBtn = [[UIButton alloc] init];
	_addBtn.layer.cornerRadius = 10;
	_addBtn.layer.masksToBounds = YES;
	[_addBtn setBackgroundColor:PRIMARY_BG_COLOR];
	[_addBtn setBackgroundImage:[UIImage imageNamed:@"addGray"] forState:UIControlStateNormal];
	[self.contentView addSubview:_addBtn];
	[_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(MINE_POST_ADD_BUTTON_SIZE);
		make.left.mas_equalTo(APP_PRIMARY_MARGIN);
		make.top.equalTo(self.postTextView.mas_bottom).offset(APP_PRIMARY_MARGIN);
	}];
	[_addBtn addTarget:self action:@selector(openAlertView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initView {
	self.postTextView.delegate = self;
	[self.backBtn addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
	[self.postBtn addTarget:self action:@selector(postDynamic) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backToLast {
	[self dismissViewControllerAnimated:YES completion:nil];
}


//初始化底部选择菜单
- (void)initAlertView {
	self.actionSheet = [[UIAlertController alloc] init];
	UIAlertAction *changeBGAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {

	}];
	UIAlertAction *saveBGAction = [UIAlertAction actionWithTitle:@"本地图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
		[self presentViewController:self.imagePickerController animated:YES completion:NULL];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

	[self.actionSheet addAction:changeBGAction];
	[self.actionSheet addAction:saveBGAction];
	[self.actionSheet addAction:cancelAction];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
	[self pHAssetToUIImage:assets];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pHAssetToUIImage:(NSArray<PHAsset *> *)assets {
	self.requestOptions = [[PHImageRequestOptions alloc] init];
	self.requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
	self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
	self.requestOptions.synchronous = true;
	for (int i = 0; i < self.imageArray.count; i++) {
		[[self.view viewWithTag:i + 1] removeFromSuperview];
	}

	PHImageManager *manager = [PHImageManager defaultManager];
	self.imageArray = [NSMutableArray arrayWithCapacity:[assets count]];
	__block UIImage *ima;

	for (PHAsset *asset in assets) {
		[manager requestImageForAsset:asset
		                   targetSize:PHImageManagerMaximumSize
		                  contentMode:PHImageContentModeDefault
		                      options:self.requestOptions
		                resultHandler:^void(UIImage *image, NSDictionary *info) {
			                ima = image;
			                [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
				                make.centerX.equalTo(self.view);
				                make.width.mas_equalTo(APP_VIEW_WITH_MARGIN_WIDTH);
				                make.top.mas_equalTo(APP_NAVIGATION_BAR_HEIGHT + APP_PRIMARY_MARGIN);
				                make.height.mas_equalTo(MINE_POST_CONTENT_HEIGHT + assets.count  / 3 * (MINE_POST_ADD_BUTTON_SIZE + APP_PRIMARY_MARGIN));
			                }];

			                [self.imageArray addObject:ima];
			                [self initContentImageView:ima index:self.imageArray.count count:assets.count];
		                }];
	}
}

- (void)initContentImageView:(UIImage *)image
                       index:(NSInteger)index //第几张照片,从1开始
                       count:(NSInteger)count {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	imageView.tag = index;

	[self.contentView addSubview:imageView];
	imageView.layer.cornerRadius = 10;
	imageView.layer.masksToBounds = YES;
	imageView.contentMode = UIViewContentModeScaleAspectFill;
	[imageView setClipsToBounds:YES];
	imageView.userInteractionEnabled = YES;
	if (count == 9) {
		index += 2;
	}
	[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.size.equalTo(self.addBtn);
		make.top.equalTo(self.addBtn).offset((MINE_POST_ADD_BUTTON_SIZE + APP_PRIMARY_MARGIN) * ((int) index / 3));
		make.left.equalTo(self.addBtn).offset((MINE_POST_ADD_BUTTON_SIZE + APP_PRIMARY_MARGIN) * (index % 3));
	}];

}

//初始化背景选择控件
- (void)initPhotoChoose {
	_imagePickerController = [[QBImagePickerController alloc] init];
	_imagePickerController.delegate = self;
	_imagePickerController.allowsMultipleSelection = YES;
	_imagePickerController.maximumNumberOfSelection = 9;
	_imagePickerController.showsNumberOfSelectedAssets = YES;
}


- (void)openAlertView {
	[self presentViewController:self.actionSheet animated:YES completion:nil];
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

- (void)postDynamic {
    if([self.postTextView.text  isEqual: @""]){
		return;
	}
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.progress = 1;
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"发表中...";
    [hud showAnimated:YES];
	[DynamicHttpRequest postDynamic:self.postTextView.text pictureArray:self.imageArray successBlock:^(NSDictionary *data) {
        [self backToLast];
	} failBlock:nil];
}

@end
