//
//  ChatViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/16.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "Masonry.h"
#import "BaseModel.h"
#import "NSString+Size.h"
#import "FriendInfoViewController.h"
#import "TcpRequest.h"
#import "MessageHttpRequest.h"
#import "UserModel.h"
#import "BaseData.h"
#import "UIView+Size.h"
#import "MessageCache.h"
#import "SqliteUtil.h"
#import "NotificationTool.h"
#import <Photos/Photos.h>
#import "EnumList.h"

//底部视图高度
#define MESSAGE_CHAT_BOTTOM_HEIGHT              (IS_IPHONE_X ? APP_SCREEN_WIDTH * 0.2 :APP_PRIMARY_MARGIN * 2 + APP_TEXT_FIELD_HEIGHT )


@interface ChatViewController ()

@property (nonatomic, strong) UITableView         *tableView;                               //页面表格
@property (nonatomic, strong) UIView              *bottomView;                              //底部视图
@property (nonatomic, strong) UITextView          *messageTextView;                         //消息框
@property (nonatomic, strong) UIButton            *addButton;                               //添加更多按钮
@property (nonatomic, strong) UIView              *addView;                                 //添加更多视图
@property (nonatomic, strong) UIButton            *pictureButton;                           //添加图片按钮
@property (nonatomic, strong) UIButton            *cameraButton;                            //相机按钮
@property (nonatomic, strong) UIButton            *videoButton;                             //视频按钮
@property (nonatomic, strong) UIButton            *locationButton;                          //位置按钮
@property (nonatomic, strong) UIButton            *emojiButton;                             //表情按钮
@property (nonatomic, strong) UIButton            *phoneButton;                             //相机按钮
@property (nonatomic, strong) UIButton            *voiceButton;                             //语音按钮
@property (nonatomic, strong) UIButton            *fileButton;                              //文件按钮
@property (nonatomic, strong) NSMutableDictionary *messageDictionary;                       //消息数据
@property (nonatomic, strong) UserModel           *friendModel;
@property (nonatomic, assign) bool                isScrollToBottom;                         //是否已经滚动到底部
@property (nonatomic, assign) bool                isShowAddView;                            //是否展示添加更多视图
@property (nonatomic, copy)   void                (^messageBlock)(NSDictionary *data);      //获取到用户信息后回调
@property (nonatomic, strong) NSMutableArray<MessageModel*> *messageArray;                  //消息数据
@property (nonatomic, strong) QBImagePickerController       *imagePickerController;
@property (nonatomic,strong) PHImageRequestOptions          *requestOptions;

@end

@implementation ChatViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initStyle];
	[self initPhotoChoose];
	[self initView];
	[self initMessageBlock];
	[self getMessage];
	TcpRequest *tcpRequest = [[TcpRequest alloc] init];
	[tcpRequest addObserver:self forKeyPath:@"messageArray" options:NSKeyValueObservingOptionNew context:nil];
    [NSNotificationCenter.defaultCenter postNotification: [NSNotification notificationWithName:NotiName.newMessage object:nil]];
}

- (instancetype)initWithFriendInfo:(UserModel *)friendModel {
	if (self = [super init]) {
		_friendModel = friendModel;
		_isShowAddView = NO;
	}
	return self;
}

- (void)initStyle {
	self.isScrollToBottom = NO;
	self.navigationItem.title = self.friendModel.nickname;
	self.view.backgroundColor = UIColor.whiteColor;
	[self initTableView];
	[self initBottom];
	[self initAddView];
//    [self savePictureToLocal];
}

- (void)initTableView {
	self.messageDictionary = [[NSMutableDictionary alloc] init];
	_tableView = [[UITableView alloc] init];
	_tableView.showsVerticalScrollIndicator = NO;
	_tableView.backgroundColor = PRIMARY_BG_COLOR;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview:_tableView];
	_tableView.width = self.view.width;
	_tableView.height = APP_SCREEN_HEIGHT - MESSAGE_CHAT_BOTTOM_HEIGHT;
	_tableView.top = self.view.top;
	_tableView.left = self.view.left;
	if (@available(iOS 15.0, *)) {
		_tableView.sectionHeaderTopPadding = 0;
	}
}

- (void)initAddView {
	_addView = [[UIView alloc] init];
	[self.view addSubview:_addView];
	_addView.width = self.view.width;
	_addView.height = self.view.width * 0.6;
	_addView.bottom = 0;
	[_addView setBackgroundColor:UIColor.whiteColor];
	[_addView setHidden:YES];

	_pictureButton = [[UIButton alloc] init];
	[self.addView addSubview:_pictureButton];
	_pictureButton.width = (APP_SCREEN_WIDTH - APP_PRIMARY_MARGIN * 5) / 4;
	_pictureButton.height = _pictureButton.width;
	_pictureButton.top = APP_PRIMARY_MARGIN;
	_pictureButton.left = APP_PRIMARY_MARGIN;
	_pictureButton.backgroundColor = PRIMARY_BG_COLOR;
	_pictureButton.layer.masksToBounds = YES;
	_pictureButton.layer.cornerRadius = 10;
	[_pictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];

	UIImageView *dynamicBtnImageView = [[UIImageView alloc] init];
	dynamicBtnImageView.image = [UIImage imageNamed:@"picture"];
	[self.pictureButton addSubview:dynamicBtnImageView];
	[dynamicBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.pictureButton);
	}];

	_cameraButton = [[UIButton alloc] init];
	[self.addView addSubview:_cameraButton];
	_cameraButton.width = self.pictureButton.width;
	_cameraButton.height = self.pictureButton.height;
	_cameraButton.top = self.pictureButton.top;
	_cameraButton.left = self.pictureButton.right + APP_PRIMARY_MARGIN;
	_cameraButton.backgroundColor = PRIMARY_BG_COLOR;
	_cameraButton.layer.masksToBounds = YES;
	_cameraButton.layer.cornerRadius = 10;

	UIImageView *cameraBtnImageView = [[UIImageView alloc] init];
	cameraBtnImageView.image = [UIImage imageNamed:@"camera"];
	[self.cameraButton addSubview:cameraBtnImageView];
	[cameraBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.cameraButton);
	}];

	_emojiButton = [[UIButton alloc] init];
	[self.addView addSubview:_emojiButton];
	_emojiButton.width = self.pictureButton.width;
	_emojiButton.height = self.pictureButton.height;
	_emojiButton.top = self.pictureButton.top;
	_emojiButton.left = self.cameraButton.right + APP_PRIMARY_MARGIN;
	_emojiButton.backgroundColor = PRIMARY_BG_COLOR;
	_emojiButton.layer.masksToBounds = YES;
	_emojiButton.layer.cornerRadius = 10;

	UIImageView *emojiBtnImageView = [[UIImageView alloc] init];
	emojiBtnImageView.image = [UIImage imageNamed:@"emoji"];
	[self.emojiButton addSubview:emojiBtnImageView];
	[emojiBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.emojiButton);
	}];

	_locationButton = [[UIButton alloc] init];
	[self.addView addSubview:_locationButton];
	_locationButton.width = self.pictureButton.width;
	_locationButton.height = self.pictureButton.height;
	_locationButton.top = self.pictureButton.top;
	_locationButton.left = self.emojiButton.right + APP_PRIMARY_MARGIN;
	_locationButton.backgroundColor = PRIMARY_BG_COLOR;
	_locationButton.layer.masksToBounds = YES;
	_locationButton.layer.cornerRadius = 10;

	UIImageView *locationBtnImageView = [[UIImageView alloc] init];
	locationBtnImageView.image = [UIImage imageNamed:@"location"];
	[self.locationButton addSubview:locationBtnImageView];
	[locationBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.locationButton);
	}];

	_videoButton = [[UIButton alloc] init];
	[self.addView addSubview:_videoButton];
	_videoButton.width = self.pictureButton.width;
	_videoButton.height = self.pictureButton.height;
	_videoButton.top = self.pictureButton.bottom + APP_PRIMARY_MARGIN;
	_videoButton.left = self.pictureButton.left;
	_videoButton.backgroundColor = PRIMARY_BG_COLOR;
	_videoButton.layer.masksToBounds = YES;
	_videoButton.layer.cornerRadius = 10;

	UIImageView *videoBtnImageView = [[UIImageView alloc] init];
	videoBtnImageView.image = [UIImage imageNamed:@"video"];
	[self.videoButton addSubview:videoBtnImageView];
	[videoBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.videoButton);
	}];

	_phoneButton = [[UIButton alloc] init];
	[self.addView addSubview:_phoneButton];
	_phoneButton.width = self.pictureButton.width;
	_phoneButton.height = self.pictureButton.height;
	_phoneButton.top = self.videoButton.top;
	_phoneButton.left = self.pictureButton.right + APP_PRIMARY_MARGIN;
	_phoneButton.backgroundColor = PRIMARY_BG_COLOR;
	_phoneButton.layer.masksToBounds = YES;
	_phoneButton.layer.cornerRadius = 10;

	UIImageView *phoneBtnImageView = [[UIImageView alloc] init];
	phoneBtnImageView.image = [UIImage imageNamed:@"phone"];
	[self.phoneButton addSubview:phoneBtnImageView];
	[phoneBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.phoneButton);
	}];

	_voiceButton = [[UIButton alloc] init];
	[self.addView addSubview:_voiceButton];
	_voiceButton.width = self.pictureButton.width;
	_voiceButton.height = self.pictureButton.height;
	_voiceButton.top = self.videoButton.top;
	_voiceButton.left = self.phoneButton.right + APP_PRIMARY_MARGIN;
	_voiceButton.backgroundColor = PRIMARY_BG_COLOR;
	_voiceButton.layer.masksToBounds = YES;
	_voiceButton.layer.cornerRadius = 10;

	UIImageView *voiceBtnImageView = [[UIImageView alloc] init];
	voiceBtnImageView.image = [UIImage imageNamed:@"voice"];
	[self.voiceButton addSubview:voiceBtnImageView];
	[voiceBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.voiceButton);
	}];

	_fileButton = [[UIButton alloc] init];
	[self.addView addSubview:_fileButton];
	_fileButton.width = self.pictureButton.width;
	_fileButton.height = self.pictureButton.height;
	_fileButton.top = self.videoButton.top;
	_fileButton.left = self.voiceButton.right + APP_PRIMARY_MARGIN;
	_fileButton.backgroundColor = PRIMARY_BG_COLOR;
	_fileButton.layer.masksToBounds = YES;
	_fileButton.layer.cornerRadius = 10;

	UIImageView *fileBtnImageView = [[UIImageView alloc] init];
	fileBtnImageView.image = [UIImage imageNamed:@"file"];
	[self.fileButton addSubview:fileBtnImageView];
	[fileBtnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.height.mas_equalTo(APP_ICON_SIZE * 1.5);
		make.centerX.centerY.equalTo(self.fileButton);
	}];
}

- (void)initBottom {
	//底部视图样式
	_bottomView = [[UIView alloc] init];
	_bottomView.backgroundColor = UIColor.whiteColor;
	[self.view addSubview:_bottomView];
	_bottomView.height = MESSAGE_CHAT_BOTTOM_HEIGHT;
	_bottomView.width = self.view.width;
	_bottomView.bottom = 0;

	//消息框样式
	_messageTextView = [[UITextView alloc] init];
	_messageTextView.backgroundColor = PRIMARY_BG_COLOR;
	_messageTextView.layer.masksToBounds = YES;
	_messageTextView.layer.cornerRadius = 10;
	_messageTextView.textContainerInset = UIEdgeInsetsMake(8, 8, 0, 8);
	_messageTextView.returnKeyType = UIReturnKeySend;
	[_messageTextView setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	[self.bottomView addSubview:_messageTextView];
	_messageTextView.height = APP_TEXT_FIELD_HEIGHT;
	_messageTextView.width = self.bottomView.width * 0.8;
	_messageTextView.left = APP_PRIMARY_MARGIN;
	_messageTextView.top = APP_PRIMARY_MARGIN;

	//添加按钮样式
	_addButton = [[UIButton alloc] init];
	[_addButton setImage:[UIImage imageNamed:@"addBlack"] forState:UIControlStateNormal];
	[self.bottomView addSubview:_addButton];
	_addButton.width = APP_TEXT_FIELD_HEIGHT;
	_addButton.height = APP_TEXT_FIELD_HEIGHT;
	_addButton.top = self.messageTextView.top;
	_addButton.left = self.messageTextView.right + APP_PRIMARY_MARGIN;
}

- (void)initView {
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.messageTextView.delegate = self;
	[self.addButton addTarget:self action:@selector(openAddView) forControlEvents:UIControlEventTouchUpInside];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
	[self.tableView addGestureRecognizer:tapGestureRecognizer];
	[center addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
	[center addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//  键盘弹出触发该方法
- (void)keyboardDidShow:(NSNotification *)note {
	CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	CGFloat height = APP_TEXT_FIELD_HEIGHT + APP_PRIMARY_MARGIN * 2;
	self.tableView.height = APP_SCREEN_HEIGHT - rect.size.height - height;
	self.bottomView.height = height;
	self.bottomView.top = self.tableView.bottom;
	[self tableView:self.tableView scrollTableToFoot:NO];
}

//  键盘隐藏触发该方法
- (void)keyboardDidHide:(NSNotification *)note {
	if(!self.isShowAddView){
	self.tableView.height = self.view.height - MESSAGE_CHAT_BOTTOM_HEIGHT;
	self.bottomView.height = MESSAGE_CHAT_BOTTOM_HEIGHT;
	self.bottomView.bottom = 0;}
}

//收起键盘
- (void)closeKeyboard {
	[self.view endEditing:YES];
	if (self.isShowAddView) {
		self.isShowAddView = NO;
		[self.addView setHidden:YES];
		self.tableView.height = self.view.height - MESSAGE_CHAT_BOTTOM_HEIGHT;
		self.bottomView.height = MESSAGE_CHAT_BOTTOM_HEIGHT;
		self.bottomView.bottom = 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.messageArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (void)openAddView {
	if (!self.isShowAddView) { //展示添加更多视图
		[self.addView setHidden:NO];
		self.isShowAddView = YES;
		[self.view endEditing:YES];

		self.addView.top += self.view.width * 0.6;
		[UIView transitionWithView:self.tableView
		                  duration:0.25
		                   options:UIViewAnimationOptionCurveEaseInOut
		                animations:^{
			                CGFloat height = APP_TEXT_FIELD_HEIGHT + APP_PRIMARY_MARGIN * 2;
			                self.tableView.height = APP_SCREEN_HEIGHT - APP_SCREEN_WIDTH * 0.6 - height;
			                self.addView.top -= self.view.width * 0.6;
			                self.bottomView.top = self.tableView.bottom;
			                [self tableView:self.tableView scrollTableToFoot:NO];
		                }
		                completion:nil
		];

	} else { //收起添加更多视图
		self.isShowAddView = NO;
		[self.view endEditing:YES];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (!self.isScrollToBottom) {
		dispatch_after((dispatch_time_t) 0.1, dispatch_get_main_queue(), ^{
			[self tableView:self.tableView scrollTableToFoot:NO];
		});
		self.isScrollToBottom = YES;
	}
	ChatTableViewCell *cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL" messageModel:self.messageArray[indexPath.row] friendModel:self.friendModel];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToUserInfo)];
	cell.headPortraitImageView.userInteractionEnabled = YES;
	[cell.headPortraitImageView addGestureRecognizer:tapGestureRecognizer];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	MessageModel *messageModel = self.messageArray[(NSUInteger) indexPath.row];
	CGFloat messageHeight = 0;
	NSString *message = messageModel.content;
	switch ([messageModel.type intValue]) {
		case messageText:
			messageHeight = [message calculateSizeOfString:MESSAGE_CHAT_TEXT_MAX_WIDTH fontSize:APP_FONT_SIZE].height;
			break;
		case messageImage:
			messageHeight = MESSAGE_CHAT_IMAGE_HEIGHT;
			break;
		case messageVideo:
			messageHeight = MESSAGE_CHAT_IMAGE_HEIGHT;
			break;
		default:
			break;
	}
	return APP_PRIMARY_MARGIN * 2 + (messageHeight > MESSAGE_CHAT_HEAD_PORTRAIT_SIZE ? messageHeight + MESSAGE_CHAT_LABEL_BORDER_SIZE : MESSAGE_CHAT_HEAD_PORTRAIT_SIZE);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) { //判断输入的字是否是回车，即按下return
		[self sendMessage];
		return NO;
	}
	return YES;
}

- (void)sendMessage {
	if ([self.messageTextView.text isEqualToString:@""]) {
		return;
	}
	MessageModel *model = [[MessageModel alloc] initWithDic:@{@"sendId": [BaseData sharedData].userModel.userId,
		@"receivedId": self.friendModel.userId,
		@"type": @"0",
		@"content": self.messageTextView.text}];
	MessageCache *messageCache = [[MessageCache alloc] init];
	[messageCache insertMessage:model];
	[self.messageArray addObject:model];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
		[self tableView:self.tableView scrollTableToFoot:YES];
	});
	if (self.friendModel.userId == [BaseData sharedData].userModel.userId) {
		return;
	}else{
		TcpRequest *tcpRequest = [[TcpRequest alloc] init];
		[tcpRequest sendTextMessage:self.messageTextView.text receivedId:self.friendModel.userId type:@"0"];
	}
	[self.messageTextView setText:@""];

}

- (void)initBlock {

}

- (void)pushToUserInfo {
    self.hidesBottomBarWhenPushed = YES;
    FriendInfoViewController *friendInfoViewController = [[FriendInfoViewController alloc] initWithUserModel:self.friendModel];
	[self.navigationController pushViewController:friendInfoViewController animated:YES];
}

- (void)initMessageBlock {
	self.messageArray = [NSMutableArray array];
	__weak typeof(self) weakSelf = self;
	self.messageBlock = ^(NSDictionary *data) {
		__weak typeof(weakSelf) strongSelf = weakSelf;
		NSArray *dataArray = data[@"data"];
		for (NSUInteger i = 0; i < dataArray.count; i++) {
			strongSelf.messageArray[strongSelf.messageArray.count] = [[MessageModel alloc] initWithDic:data[@"data"][i]];
		}
		[strongSelf.tableView reloadData];
	};
}


- (void)tableView:(UITableView *)tableView scrollTableToFoot:(BOOL)animated {
	NSInteger s = [tableView numberOfSections];  /** 有多少组 */

	if (s < 1) {
		return;
	}  /** 无数据时不执行 要不会crash */
	NSInteger r = [tableView numberOfRowsInSection:s - 1]; /* 最后一组有多少行 */
	if (r < 1)
		return;
	NSIndexPath *ip = [NSIndexPath indexPathForRow:r - 1 inSection:s - 1];  /** 取最后一行数据 */
	[tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; /** 滚动到最后一行 */
}


- (void)getMessage {
	MessageCache *sqliteUtil = [[MessageCache alloc] init];
	[sqliteUtil setMessageStateRead:self.friendModel.userId];
	self.messageArray = [sqliteUtil getMessage:[BaseData sharedData].userModel.userId FriendId:self.friendModel.userId];
//	[MessageHttpRequest getUnLoadMessage:1 friendId:self.friendModel.userId successBlock:self.messageBlock failBlock:nil];

//	NSLog(@"%@",self.messageDictionary);
	[self.tableView reloadData];
}

#pragma mark - kvo

//当key路径对应的属性值发生改变时，监听器就会回调自身的监听方法，如下
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
	NSLog(@"获取到了数据");
	TcpRequest *request = object;
	NSString *sendId = [NSString stringWithFormat:@"%@",request.messageArray[0].sendId];
	NSString *friendId = [NSString stringWithFormat:@"%@",self.friendModel.userId];

	if([sendId isEqualToString:friendId]) {
		[self.messageArray addObject:request.messageArray[0]];
		MessageCache *messageCache = [[MessageCache alloc] init];
		[messageCache setMessageStateRead:sendId];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			[self tableView:self.tableView scrollTableToFoot:YES];
		});
	}else{
//		[NotificationTool openLocalNotificationAlert:request.messageArray[0].content identifier:@"sda"];
		[NotificationTool openLocalNotificationAlert:request.messageArray[0]];
	}


	[request.messageArray removeAllObjects];
}

- (void)dealloc {
	TcpRequest *tcpRequest = [[TcpRequest alloc] init];
	[tcpRequest removeObserver:self forKeyPath:@"messageArray"];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


//初始化背景选择控件
- (void)initPhotoChoose {
//    _imagePickerController = [[QBImagePickerController alloc] init];
//    _imagePickerController.delegate = self;
//    _imagePickerController.allowsMultipleSelection = YES;
//    _imagePickerController.maximumNumberOfSelection = 9;
//    _imagePickerController.showsNumberOfSelectedAssets = YES;
}

- (QBImagePickerController *)imagePickerController {
	if (!_imagePickerController) {
		_imagePickerController = [[QBImagePickerController alloc] init];
		_imagePickerController.delegate = self;
		_imagePickerController.allowsMultipleSelection = YES;
		_imagePickerController.maximumNumberOfSelection = 9;
		_imagePickerController.showsNumberOfSelectedAssets = YES;
	}
	[_imagePickerController.selectedAssets removeAllObjects];

	return _imagePickerController;
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

	PHImageManager *manager = [PHImageManager defaultManager];
	__block UIImage *ima;

	for (PHAsset *asset in assets) {
		[manager requestImageForAsset:asset
		                   targetSize:PHImageManagerMaximumSize
		                  contentMode:PHImageContentModeDefault
		                      options:self.requestOptions
		                resultHandler:^void(UIImage *image, NSDictionary *info) {
			                ima = image;
			                [self addPictureToMessage:ima];
			                [[[TcpRequest alloc] init] sendImageMessage:ima receivedId:self.friendModel.userId];
		                }];
	}


}

-(NSString *)savePictureToLocal:(UIImage*)image{
//    NSString *name = [[NSUUID UUID]UUIDString];
    NSString  *pngPath = [self getPictureName];
//	NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];

//	[UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];

	// Write image to PNG
	[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];


	NSError *error;
	NSFileManager *fileMgr = [NSFileManager defaultManager];

	// Point to Document directory
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];

	// Write out the contents of home directory to console
	NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    return pngPath;
}

- (void)addPictureToMessage:(UIImage *)image {
    if (image == nil) { return;}
	MessageModel *model = [[MessageModel alloc] initWithDic:@{@"sendId": [BaseData sharedData].userModel.userId,
		@"receivedId": self.friendModel.userId,
		@"type": @"1",
		@"image": image,
        @"content":[self savePictureToLocal:image]
	}];

	[self.messageTextView setText:@""];
	[self.messageArray addObject:model];
//	[self savePictureToLocal:image];
    MessageCache *cache =  [[MessageCache alloc]init];
    [cache insertMessage:model];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.tableView reloadData];
		[self tableView:self.tableView scrollTableToFoot:YES];
	});
}

- (void)addPicture {
	[self presentViewController:self.imagePickerController animated:YES completion:NULL];
}

@end


