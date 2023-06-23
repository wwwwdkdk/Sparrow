//
//  AddViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/29.
//

#import "AddViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "UserHttpRequest.h"
#import "UIImageView+WebCache.h"
#import "FriendInfoViewController.h"

#define CONTACT_ADD_SEARCH_FIELD_HEIGHT     APP_SCREEN_WIDTH * 0.1
#define CONTACT_ADD_HEAD_PORTRAIT_SIZE      APP_SCREEN_WIDTH * 0.12

@interface AddViewController ()

@property(nonatomic, strong) UITableView         *tableView;
@property(nonatomic, strong) UITextField         *searchField;
@property(nonatomic, strong) NSMutableDictionary *userInfoDictionary;                   //用户资料数据
@property(nonatomic, copy) void (^userInfoBlock)(NSDictionary *data);                   //获取到用户信息后回调
@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
    [self initView];
    [self initUserInfoBlock];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.searchField becomeFirstResponder];
}

- (void)initStyle {
    self.navigationItem.title = @"添加好友";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initSearchField];
    [self initTable];
}

- (void)initTable {
    _tableView = [[UITableView alloc] init];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(self.view.frame.size.height - CONTACT_ADD_SEARCH_FIELD_HEIGHT);
        make.top.equalTo(self.searchField.mas_bottom).offset(APP_PRIMARY_MARGIN);
    }];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = PRIMARY_BG_COLOR;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)initView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchField.delegate = self;
}

- (void)initSearchField {
    _searchField = [[UITextField alloc] init];
    [self.view addSubview:_searchField];
    _searchField.backgroundColor = UIColor.whiteColor;
    _searchField.layer.masksToBounds = YES;
    _searchField.layer.cornerRadius = 10;
    _searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    _searchField.leftViewMode = UITextFieldViewModeAlways;
    _searchField.placeholder = @"请输入您要搜索的好友";
    [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_PRIMARY_MARGIN);
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(APP_VIEW_WITH_MARGIN_WIDTH);
        make.height.mas_equalTo(CONTACT_ADD_SEARCH_FIELD_HEIGHT);
    }];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];

    NSDictionary *userInfo = self.userInfoDictionary[@"data"][(NSUInteger) indexPath.row];
    UIImageView *headPortraitImageView = [[UIImageView alloc] init];
    headPortraitImageView.layer.masksToBounds = YES;
    headPortraitImageView.layer.cornerRadius = 15;
    headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
    [cell.contentView addSubview:headPortraitImageView];
    if (userInfo[@"headPortrait"] == nil) {
        [headPortraitImageView setImage:[UIImage imageNamed:@"noHeadPortrait"]];
    } else {
        [headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:userInfo[@"headPortrait"]] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];

    }
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_PRIMARY_MARGIN);
        make.width.height.mas_equalTo(CONTACT_ADD_HEAD_PORTRAIT_SIZE);
        make.left.mas_equalTo(APP_PRIMARY_MARGIN);
    }];

    UILabel *usernameLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:usernameLabel];
    [usernameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
    usernameLabel.text = userInfo[@"nickname"];
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN);
        make.height.equalTo(headPortraitImageView).multipliedBy(0.5);
        make.top.equalTo(headPortraitImageView);
    }];

    UILabel *contentLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:contentLabel];
    [contentLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE - 2]];
    contentLabel.text = userInfo[@"city"];
    contentLabel.textColor = UIColor.grayColor;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(usernameLabel);
        make.top.equalTo(usernameLabel.mas_bottom);
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.userInfoDictionary[@"data"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CONTACT_ADD_HEAD_PORTRAIT_SIZE + APP_PRIMARY_MARGIN * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    FriendInfoViewController *friendInfoViewController = [[FriendInfoViewController alloc] init];
    [friendInfoViewController setUserInfoDictionary:self.userInfoDictionary[@"data"][indexPath.row]];
    [self.navigationController pushViewController:friendInfoViewController animated:YES];

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    [UserHttpRequest searchUser:textField.text successBlock:self.userInfoBlock failBlock:nil];
}

- (void)initUserInfoBlock {
    __weak typeof(self) weakSelf = self;
    self.userInfoBlock = ^(NSDictionary *data) {
        __weak typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.userInfoDictionary = [data mutableCopy];
        [strongSelf.tableView reloadData];
    };
}

@end
