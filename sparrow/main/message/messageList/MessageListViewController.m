//
//  MessageListViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/15.
//

#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <UIImageView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessageListViewController.h"
#import "ChatViewController.h"
#import "Masonry.h"
#import "MessageListModel.h"
#import "MessageCache.h"
#import "FriendInfoViewController.h"
#import "UserModel.h"
#import "NSString+Size.h"
#import "FriendHttpRequest.h"
#import "MessageHttpRequest.h"
#import "MessageModel.h"

#define MESSAGE_HEAD_PORTRAIT_SIZE                APP_SCREEN_WIDTH * 0.14                   //头像尺寸
#define MESSAGE_NAVI_BTN_SIZE                     APP_SCREEN_WIDTH * 0.1                    //导航栏按钮尺寸

@interface MessageListViewController ()

//@property(nonatomic, strong) UIImageView *bgView;
@property(nonatomic, strong) UITableView *tableView;                                        //页面表格
@property(nonatomic, strong) NSMutableArray<MessageListModel *> *messageListArray;          //消息数据
@property(nonatomic, copy) void (^messageListBlock)(NSDictionary *data);                    //获取到用户信息后回调

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
    [self initView];
    [self initMessageListBlock];
    [self getUnreadMessage];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(setMessageBadge) name:NotiName.newMessage object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self getMessageList];
    [self setMessageBadge];
}


- (void)initStyle {
    self.title = @"消息";
    [self initTable];
}

- (void)initTable {
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = PRIMARY_BG_COLOR;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self.view);
        make.height.mas_equalTo(APP_TABLE_WITH_TAB_BAR_HEIGHT);
    }];
    
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)initView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)initBlocks {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListModel *model = self.messageListArray[(NSUInteger) indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    UIImageView *headPortraitImageView = [[UIImageView alloc] init];
    headPortraitImageView.layer.masksToBounds = YES;
    headPortraitImageView.layer.cornerRadius = 15;
    headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
    headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell.contentView addSubview:headPortraitImageView];
    if (model.userModel.headPortrait == nil) {
        [headPortraitImageView setImage:[UIImage imageNamed:@"noHeadPortrait"]];
    } else {
        [headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
    }
    
    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_PRIMARY_MARGIN);
        make.width.height.mas_equalTo(MESSAGE_HEAD_PORTRAIT_SIZE);
        make.left.mas_equalTo(APP_PRIMARY_MARGIN);
    }];
    
    UILabel *usernameLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:usernameLabel];
    usernameLabel.text = model.userModel.nickname;
    [usernameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
    [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN);
        make.height.equalTo(headPortraitImageView).multipliedBy(0.4);
        make.top.equalTo(headPortraitImageView).offset(MESSAGE_HEAD_PORTRAIT_SIZE * 0.1);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [cell.contentView addSubview:contentLabel];
    contentLabel.text = model.message;
    [contentLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE - 2]];
    contentLabel.textColor = UIColor.grayColor;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(usernameLabel);
        make.top.equalTo(usernameLabel.mas_bottom);
    }];
    
    NSString *unReadCount = [NSString stringWithFormat:@"%@",model.unReadCount];
    if(![unReadCount isEqualToString:@"0" ]){
        UILabel *badgeLabel = [[UILabel alloc] init];
        [cell.contentView addSubview:badgeLabel];
        badgeLabel.layer.masksToBounds = YES;
        badgeLabel.layer.cornerRadius = 10;
        badgeLabel.text = [unReadCount isEqualToString:@"0" ] ? @"":model.unReadCount;
        badgeLabel.textColor = UIColor.whiteColor;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = UIColor.redColor;
        [badgeLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE - 2]];
        [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(30);
            make.right.mas_equalTo(-APP_PRIMARY_MARGIN * 2);
            make.centerY.equalTo(cell.contentView);
        }];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageListArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MESSAGE_HEAD_PORTRAIT_SIZE + APP_PRIMARY_MARGIN * 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithFriendInfo:self.messageListArray[(NSUInteger) indexPath.row].userModel];
    chatViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatViewController animated:YES];
}


- (void)initMessageListBlock {
    //	__weak typeof(self) weakSelf = self;
    //	self.messageListBlock = ^(NSDictionary *data) {
    //		__weak typeof(weakSelf) strongSelf = weakSelf;
    //		strongSelf.messageListDictionary = [data mutableCopy];
    //		[strongSelf.tableView reloadData];
    //	};
}

//获取缓存消息
- (void)getMessageList {
    MessageCache *messageCache = [[MessageCache alloc] init];
    self.messageListArray = [[messageCache getMessageList] mutableCopy];
    [self.tableView reloadData];
}

//获取新消息
- (void)getUnreadMessage{
    [MessageHttpRequest getUnLoadMessageList:^(NSDictionary *data) {
        NSArray *dataArray = data[@"data"];
        for (int i = 0; i < dataArray.count; i++) {
            MessageCache *messageCache = [[MessageCache alloc] init];
            MessageModel *messageModel = [[MessageModel alloc] initWithDic:dataArray[i]];
            [messageCache insertMessage:messageModel];
        }
        [self.tableView reloadData];
        [self setMessageBadge];
        [MessageHttpRequest deleteMessage:^(NSDictionary *data) {
            
        } failBlock:nil];
    } failBlock:nil];
}

- (void)setMessageBadge{
    MessageCache *messageCache = [[MessageCache alloc] init];
    self.messageListArray = [[messageCache getMessageList] mutableCopy];
    
    int badgeCount = 0;
    for (int i = 0; i< self.messageListArray.count; i++) {
        badgeCount += [self.messageListArray[i].unReadCount intValue];
    }
    if (badgeCount > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",badgeCount];
        });
    }
}

- (void)addMessageBadge{
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",badgeCount];
    });
}

@end




