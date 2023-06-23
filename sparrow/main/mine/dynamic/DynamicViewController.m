//
//  DynamicViewController.m
//  sparrow
//
//  Created by hwy on 2021/12/2.
//

#import <MASConstraintMaker.h>
#import "DynamicViewController.h"
#import "View+MASAdditions.h"
#import "MineTableViewCell.h"
#import "NSString+Size.h"
#import "PostViewController.h"
#import "DynamicModel.h"
#import "DynamicHttpRequest.h"
#import "MJRefresh.h"
#import "PictureModel.h"

@interface DynamicViewController ()

@property (nonatomic, strong) UITableView             *tableView;                              //页面表格
@property (nonatomic, strong) UIButton                *naviPostBtn;                            //发帖按钮
@property (nonatomic, assign) DynamicType             dynamicType;                             //动态类型
@property (nonatomic, strong) NSMutableArray<DynamicModel*> *dynamicArray;                     //用户动态字典
@property (nonatomic, copy)   void                    (^dynamicBlock)(NSDictionary *data);     //获取到用户动态后回调
@property(nonatomic,copy)     NSString                *userId;

@end

@implementation DynamicViewController

- (instancetype)initWithType:(DynamicType)dynamicType {
	if (self = [super init]) {
		self.dynamicType = dynamicType;
	}
	return self;
}

- (instancetype)initWithType:(DynamicType)dynamicType
                      userId:(NSString *)userId {
	if (self = [super init]) {
		self.dynamicType = dynamicType;
		self.userId = userId;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initStyle];
	[self initView];
	[self initDynamicBlock];
	[self getDynamic];
}

-(void)viewWillDisappear:(BOOL)animated {
	[self.tableView.mj_header setHidden:YES];
}

- (void)initStyle {
	self.view.backgroundColor = UIColor.whiteColor;
	[self initNavigation];
	[self initTableView];
}

- (void)initView {
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.naviPostBtn addTarget:self action:@selector(pushToPost) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initNavigation {
	self.navigationItem.title = self.naviTitle;

	if (self.dynamicType == 0) {
		UIView *rightView = [[UIView alloc] init];
		rightView.frame = CGRectMake(0, 0, APP_ICON_SIZE, APP_ICON_SIZE);
		_naviPostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[rightView addSubview:_naviPostBtn];
		_naviPostBtn.frame = rightView.frame;
		[_naviPostBtn setImage:[UIImage imageNamed:@"postBlack"] forState:UIControlStateNormal];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
	}

}

- (void)initTableView {
	_tableView = [[UITableView alloc] init];
	_tableView.backgroundColor = PRIMARY_BG_COLOR;
	_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	_tableView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:_tableView];
	[_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.left.width.equalTo(self.view);
		make.height.mas_equalTo(APP_TABLE_WITHOUT_TAB_BAR_HEIGHT);
	}];
	if (@available(iOS 15.0, *)) {
		_tableView.sectionHeaderTopPadding = 0;
	}
    
	_tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[self getDynamic];
	}];
    
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader*)self.tableView.mj_header;
    [header.lastUpdatedTimeLabel setHidden:YES];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中" forState:MJRefreshStateRefreshing];

}

//跳转到发帖
- (void)pushToPost {
	PostViewController *postViewController = [[PostViewController alloc] init];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postViewController];
	nav.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentViewController:nav animated:YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MineTableViewCell *cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL" model:self.dynamicArray[(NSUInteger) indexPath.section]];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.dynamicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return section == 0 ? APP_PRIMARY_MARGIN : 0;
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
	NSString *content = self.dynamicArray[(NSUInteger) indexPath.section].content;
	CGFloat contentHeight = [content calculateSizeOfString:MINE_CELL_CONTENT_WIDTH fontSize:APP_FONT_SIZE].height;
	height += contentHeight > 0 ? (contentHeight + APP_PRIMARY_MARGIN) : 0; //文本内容的高度，内容为空则高度为0
	NSArray<PictureModel *> *picArray = self.dynamicArray[(NSUInteger) indexPath.section].picture;
	if (picArray.count == 1) {        //一张图的高度
		if (picArray[0].width != nil && picArray[0].height != nil) {
			CGFloat proportion = [picArray[0].height floatValue] / [picArray[0].width floatValue];
			height += MINE_CELL_ONE_IMAGE_WIDTH * (proportion <= 2 ? proportion : 2) + APP_PRIMARY_MARGIN;
		} else {
			height += MINE_CELL_ONE_IMAGE_HEIGHT + APP_PRIMARY_MARGIN;
		}

	} else if (picArray.count == 2) {  //两张图的高度
		height += MINE_CELL_TWO_IMAGE_HEIGHT + APP_PRIMARY_MARGIN;
	} else if (picArray.count >= 2) {  //三张及以上的高度
		height += (MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + MINE_CELL_IMAGE_MARGIN) * ((int) (picArray.count - 1) / 3) + MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + APP_PRIMARY_MARGIN;
	}
	height += APP_ICON_SIZE + APP_PRIMARY_MARGIN;
	return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)initDynamicBlock {
	self.dynamicArray = [[NSMutableArray alloc] init];
	__weak typeof(self) weakSelf = self;
	self.dynamicBlock = ^(NSDictionary *data) {
		__weak typeof(weakSelf) strongSelf = weakSelf;
        NSLog(@"%@",data);
        
		NSArray *dataArray = data[@"data"][@"dynamic"];
		for (int i = 0; i < dataArray.count; i++) {
			strongSelf.dynamicArray[i] = [[DynamicModel alloc] initWithDic:dataArray[i]];
		}
		if (strongSelf.tableView.mj_header.isRefreshing) {
			[strongSelf.tableView.mj_header endRefreshing];
		}
		[strongSelf.tableView reloadData];
	};
}

//获取用户动态信息
- (void)getDynamic {

	switch (self.dynamicType) {
		case (DynamicType) 0:
			[DynamicHttpRequest getFriendDynamic:1 successBlock:self.dynamicBlock failBlock:nil];
			break;
		case (DynamicType) 1:
			[DynamicHttpRequest getAgreeDynamic:1 successBlock:self.dynamicBlock failBlock:nil];
			break;
		case (DynamicType) 2:
			[DynamicHttpRequest getCollectionDynamic:1 successBlock:self.dynamicBlock failBlock:nil];
			break;
		case (DynamicType) 3:
			[DynamicHttpRequest getDynamic:1 userId:self.userId successBlock:self.dynamicBlock failBlock:nil];
			break;
		default:
			break;
	}

}
@end
