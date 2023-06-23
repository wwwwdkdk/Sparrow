//
//  NewFriendViewController.m
//  sparrow
//
//  Created by hwy on 2021/12/14.
//

#import "NewFriendViewController.h"
#import "View+MASAdditions.h"
#import "FriendHttpRequest.h"
#import "HttpRequestUtil.h"
#import "BaseModel.h"
#import "FriendRequestModel.h"
#import "UIImageView+WebCache.h"
#import "NewFriendTableViewCell.h"
#import "FriendInfoViewController.h"

@interface MyTitleView : UIView
@property(nonatomic, assign) CGSize intrinsicContentSize;
@end

@implementation MyTitleView
@end

//导航栏标题宽度
#define CONTACT_NEW_FRIEND_TITLE_VIEW_WIDTH          APP_SCREEN_WIDTH * 0.6

@interface NewFriendViewController ()

@property (nonatomic,strong) UIButton     *sendBtn;         //发出的验证按钮
@property (nonatomic,strong) UIButton     *receiveBtn;      //收到的验证按钮
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView  *sendTableView;
@property (nonatomic,strong) UITableView  *receivedTableView;
@property (nonatomic,strong) NSMutableArray<FriendRequestModel*> *sendModelArray;
@property (nonatomic,strong) NSMutableArray<FriendRequestModel*> *receivedModelArray;

@end

@implementation NewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
    [self getReceivedFriendRequest];
    [self getSendFriendRequest];
}
- (void)initNavigation{
    
    MyTitleView *titleView = [[MyTitleView alloc]initWithFrame:CGRectMake(0, 0, CONTACT_NEW_FRIEND_TITLE_VIEW_WIDTH, APP_NAVIGATION_BAR_HEIGHT - APP_STATUS_BAR_HEIGHT)];
    titleView.intrinsicContentSize = titleView.frame.size;
    self.navigationItem.titleView = titleView;
    titleView.backgroundColor = UIColor.whiteColor;

    _receiveBtn = [[UIButton alloc] init];
    [self.receiveBtn setTitle:@"我收到的   " forState:UIControlStateNormal];
    [self.receiveBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:APP_BIG_FONT_SIZE]];
    self.receiveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.receiveBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [titleView addSubview:self.receiveBtn];
    [_receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(CONTACT_NEW_FRIEND_TITLE_VIEW_WIDTH / 2);
        make.height.mas_equalTo(titleView);
    }];

    self.sendBtn = [[UIButton alloc] init];
    self.sendBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.sendBtn setTitle:@"   我发出的" forState:UIControlStateNormal];
    [self.sendBtn.titleLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
    [self.sendBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [titleView addSubview:self.sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CONTACT_NEW_FRIEND_TITLE_VIEW_WIDTH / 2);
        make.width.height.equalTo(self.receiveBtn);
    }];
    
    [self.receiveBtn addTarget:self action:@selector(changePageContent:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBtn addTarget:self action:@selector(changePageContent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initStyle{
    [self initNavigation];
    [self initScrollView];
    [self initTableView];
}

-(void)initScrollView{
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.left.top.height.equalTo(self.view);
    }];
    _scrollView.contentSize = CGSizeMake(APP_SCREEN_WIDTH * 2,0);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
}

- (void)initTableView {
    _receivedTableView = [[UITableView alloc] init];
    _receivedTableView.backgroundColor = UIColor.whiteColor;
    _receivedTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:_receivedTableView];
    [_receivedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.scrollView);
    }];

    if (@available(iOS 15.0, *)) {
        _receivedTableView.sectionHeaderTopPadding = 0;
    }
    self.receivedTableView.delegate = self;
    self.receivedTableView.dataSource = self;
    
    _sendTableView = [[UITableView alloc] init];
    _sendTableView.backgroundColor = UIColor.whiteColor;
    _sendTableView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:_sendTableView];
    [_sendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.width.height.equalTo(self.receivedTableView);
        make.left.equalTo(self.receivedTableView.mas_right);
    }];

    if (@available(iOS 15.0, *)) {
        _sendTableView.sectionHeaderTopPadding = 0;
    }
    _sendTableView.delegate = self;
    _sendTableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == self.sendTableView) {
        cell = [[NewFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL" sendModel:self.sendModelArray[indexPath.row]];
    }else if(tableView == self.receivedTableView){
        cell = [[NewFriendTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL" receivedModel:self.receivedModelArray[indexPath.row]];
    }else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.sendTableView) {
        return self.sendModelArray.count;
    }else if(tableView == self.receivedTableView){
        return self.receivedModelArray.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CONTACT_NEW_FRIEND_HEAD_PORTRAIT_SIZE + APP_PRIMARY_MARGIN * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendInfoViewController *friendInfoViewController = [[FriendInfoViewController alloc] init];
    
    if (tableView == self.sendTableView) {
        friendInfoViewController = [[FriendInfoViewController alloc]initWithUserModel:self.sendModelArray[indexPath.row].userModel];
    }else if(tableView == self.receivedTableView){
        friendInfoViewController = [[FriendInfoViewController alloc]initWithUserModel:self.receivedModelArray[indexPath.row].userModel];
    }
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendInfoViewController animated:YES];
}

- (void)changePageContent:(UIButton *)sender{
    if(sender == self.sendBtn){
        [self.sendBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:APP_BIG_FONT_SIZE]];
        [self.sendBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.receiveBtn.titleLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
        [self.receiveBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [self.scrollView setContentOffset:CGPointMake(APP_SCREEN_WIDTH, self.scrollView.contentOffset.y) animated:YES];
    }else if(sender == self.receiveBtn){
        [self.sendBtn.titleLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
        [self.sendBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [self.receiveBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:APP_BIG_FONT_SIZE]];
        [self.receiveBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
    }
}



//获取用户发出的好友请求
- (void)getSendFriendRequest{
    self.sendModelArray = [[NSMutableArray alloc]init];
    [FriendHttpRequest getSendFriendRequest:1 successBlock:^(NSDictionary * _Nonnull data) {
        NSArray *dataArray = data[@"data"];
        for (int i = 0; i < dataArray.count ; i++) {
            self.sendModelArray[i] = [[FriendRequestModel alloc]initWithDic:data[@"data"][i]];
        }
        [self.sendTableView reloadData];
    } failBlock:nil];
}

//获取用户收到的好友请求
- (void)getReceivedFriendRequest{
    self.receivedModelArray = [[NSMutableArray alloc]init];
    [FriendHttpRequest getReceivedFriendRequest:1 successBlock:^(NSDictionary * _Nonnull data) {
        NSArray *dataArray = data[@"data"];
        for (NSUInteger i = 0; i < dataArray.count ; i++) {
            self.receivedModelArray[i] = [[FriendRequestModel alloc]initWithDic:data[@"data"][i]];
        }
        [self.receivedTableView reloadData];
    } failBlock:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    if(self.scrollView.contentOffset.x == self.scrollView.contentSize.width/2){
        [self changePageContent:self.sendBtn];
    }else {
        [self changePageContent:self.receiveBtn];
    }
}

@end
