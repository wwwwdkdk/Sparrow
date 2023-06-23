//
//  SettingViewController.m
//  sparrow
//  设置页面
//  Created by hwy on 2021/11/17.
//

#import "SettingViewController.h"
#import "MineViewController.h"
#import "FeedBackViewController.h"
#import <Masonry.h>
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "LoginViewController.h"


@interface SettingViewController ()
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
    [self initView];
}

//初始化样式
- (void)initStyle {
    self.navigationItem.title = @"设置";
    [self initTableView];
}

//初始化表格的样式
- (void)initTableView {
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = PRIMARY_BG_COLOR;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.height.equalTo(self.view);
    }];
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
}

- (void)initView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CELL";
    UITableViewCell *mySettingTableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!mySettingTableCell) {
        mySettingTableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            mySettingTableCell.textLabel.text = @"关于我们";
            break;
        case 1:
            mySettingTableCell.textLabel.text = @"清除缓存";
            break;
        case 2:
            mySettingTableCell.textLabel.text = @"反馈意见";
            break;
        case 3:
            mySettingTableCell.textLabel.text = @"退出登录";
            break;
        default:
            break;
    }
    return mySettingTableCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:
        (NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[[AboutViewController alloc] init] animated:YES];
            break;
        case 1:

            break;
        case 2:
            [self.navigationController pushViewController:[[FeedbackViewController alloc] init] animated:YES];
            break;
        case 3:
            [self logout];
            self.view.window.rootViewController = [[LoginViewController alloc] init];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)logout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults removeObjectForKey:@"userId"];
}

@end
