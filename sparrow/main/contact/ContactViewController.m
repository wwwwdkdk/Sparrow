//
//  ContactViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/29.
//

#import "ContactViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <SDWebImage/UIImageView+WebCache.h>
//#import <MJRefreshNormalHeader.h>
#import "FriendInfoViewController.h"
#import "AddViewController.h"
#import "UIImageView+WebCache.h"
#import "UINavigationController+Switch.h"
#import "NewFriendViewController.h"
#import "FriendHttpRequest.h"
#import "UserModel.h"
#import "FriendCache.h"
#import <MJRefresh.h>

#define CONTACT_HEAD_PORTRAIT_SIZE                APP_SCREEN_WIDTH * 0.12               //头像尺寸

@interface ContactViewController ()

@property(nonatomic, strong) UITableView *tableView;                                    //主体表格
@property(nonatomic, strong) UIButton *addBtn;                                          //添加按钮
@property(nonatomic, copy) void (^friendInfoBlock)(NSDictionary *data);                 //获取到用户信息后回调
@property(nonatomic, strong) NSMutableArray<UserModel *> *friendInfoArray;              //好友资料数据

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    [self initStyle];
    [self initView];
    [self initFriendInfoBlock];
    [self getFriendInfo];
}

//初始化样式
- (void)initStyle {
    [self initNavigation];
    [self initTable];
}

// 初始化导航栏
- (void)initNavigation {
    self.navigationItem.title = @"好友";
    UIView *rightView = [[UIView alloc] init];
    rightView.frame = CGRectMake(0, 0, APP_SQUARE_BUTTON_SIZE, APP_SQUARE_BUTTON_SIZE);
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView addSubview:_addBtn];
    _addBtn.frame = rightView.frame;
    [_addBtn addTarget:self action:@selector(pushToAdd) forControlEvents:UIControlEventTouchUpInside];
    [_addBtn setImage:[UIImage imageNamed:@"addBlack"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)initTable {
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = PRIMARY_BG_COLOR;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.mas_equalTo(APP_TABLE_WITH_TAB_BAR_HEIGHT);
    }];

    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getFriendInfo];
    }];

    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *) self.tableView.mj_header;
    [header.lastUpdatedTimeLabel setHidden:YES];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
}


- (void)initView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)pushToAdd {
    AddViewController *addViewController = [[AddViewController alloc] init];
    [self pushWithVc:addViewController];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];

    if (indexPath.row == 0) {
        cell = [[SearchViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchViewCell"];
        return cell;

    } else if (indexPath.row == 1) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell1"];
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newFriend"]];
        logoImageView.contentMode = UIViewContentModeCenter;
        logoImageView.backgroundColor = PRIMARY_BG_COLOR;
        logoImageView.layer.masksToBounds = YES;
        logoImageView.layer.cornerRadius = 15;
        [cell.contentView addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(APP_PRIMARY_MARGIN);
            make.width.height.mas_equalTo(CONTACT_HEAD_PORTRAIT_SIZE);
            make.left.mas_equalTo(APP_PRIMARY_MARGIN);
        }];
        UILabel *newFriendLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:newFriendLabel];
        newFriendLabel.text = @"新朋友";
        [newFriendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoImageView.mas_right).offset(APP_PRIMARY_MARGIN);
            make.height.equalTo(cell.contentView);
        }];

        return cell;
    }

    UserModel *userInfo = self.friendInfoArray[(NSUInteger) indexPath.row - 2];
    UIImageView *headPortraitImageView = [[UIImageView alloc] init];
    headPortraitImageView.layer.masksToBounds = YES;
    headPortraitImageView.layer.cornerRadius = 15;
    [cell.contentView addSubview:headPortraitImageView];
    headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
    if (userInfo.headPortrait == nil) {
        [headPortraitImageView setImage:[UIImage imageNamed:@"noHeadPortrait"]];
    } else {
        [headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:userInfo.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
    }
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_PRIMARY_MARGIN);
        make.width.height.mas_equalTo(CONTACT_HEAD_PORTRAIT_SIZE);
        make.left.mas_equalTo(APP_PRIMARY_MARGIN);
    }];

    UILabel *usernameLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:usernameLabel];
    [usernameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
    usernameLabel.text = userInfo.nickname;
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN);
        make.height.equalTo(headPortraitImageView).multipliedBy(0.5);
        make.top.equalTo(headPortraitImageView);
    }];

    UILabel *contentLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:contentLabel];
    [contentLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE - 2]];
    contentLabel.text = userInfo.city;
    contentLabel.textColor = UIColor.grayColor;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(usernameLabel);
        make.top.equalTo(usernameLabel.mas_bottom);
    }];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendInfoArray.count + 2;
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
    if (indexPath.row == 0) {
        return [SearchViewCell getHeight];
    }
    return CONTACT_HEAD_PORTRAIT_SIZE + APP_PRIMARY_MARGIN * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {return;}
    if (indexPath.row == 1) {
        NewFriendViewController *newFriendViewController = [[NewFriendViewController alloc] init];
        [self pushWithVc:newFriendViewController];
    } else {
        FriendInfoViewController *friendInfoViewController = [[FriendInfoViewController alloc] initWithUserModel:self.friendInfoArray[indexPath.row - 2]];
        [self pushWithVc:friendInfoViewController];
    }
}

- (void)initFriendInfoBlock {
    __weak typeof(self) weakSelf = self;
    self.friendInfoBlock = ^(NSDictionary *data) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.friendInfoArray = [[NSMutableArray alloc] init];
        NSArray *dataArray = data[@"data"];
        for (NSUInteger i = 0; i < dataArray.count; i++) {
            strongSelf.friendInfoArray[i] = [[UserModel alloc] initWithDic:data[@"data"][i]];
        }
        if (strongSelf.friendInfoArray.count == 0) {return;}
        [FriendCache saveContact:data];
        [strongSelf.tableView reloadData];
        [strongSelf.tableView.mj_header endRefreshing];
    };
}

- (void)getFriendInfo {
    self.friendInfoArray = [[FriendCache getContact] mutableCopy];
    [FriendHttpRequest getFriendList:1 successBlock:self.friendInfoBlock failBlock:nil];
}

@end
