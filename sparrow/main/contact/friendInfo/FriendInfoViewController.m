//
//  FriendInfoViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/29.
//

#import <UIImageView+WebCache.h>
#import "FriendInfoViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <objc/runtime.h>
#import "MineTableViewCell.h"
#import "NSString+Size.h"
#import "MineViewController.h"
#import "UINavigationController+Switch.h"
#import "HttpRequestUtil.h"
#import "UserModel.h"
#import "BaseModel.h"
#import "UserModel.h"
#import "DynamicModel.h"
#import "UserHttpRequest.h"
#import "DynamicHttpRequest.h"
#import "MJRefresh.h"
#import "ChatViewController.h"
#import "PictureModel.h"
#import "DynamicViewController.h"
#import "UIView+Size.h"
#import "FriendCache.h"
#import "FriendHttpRequest.h"
#import "EnumList.h"
#import "NewFriendViewController.h"

//用户头像尺寸
#define CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT           APP_SCREEN_WIDTH * 0.22
//表头的头部视图高度
#define CONTACT_FRIEND_HEAD_HEIGHT                    (APP_SCREEN_WIDTH * 0.5 + CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT)
//表头的中部视图高度
#define CONTACT_FRIEND_CENTER_HEIGHT                  APP_SCREEN_WIDTH * 0.5
//表头的底部视图高度
#define CONTACT_FRIEND_BOTTOM_HEIGHT                  APP_SCREEN_WIDTH * 0.3
//表头高度
#define CONTACT_FRIEND_TABLE_HEAD_HEIGHT              (CONTACT_FRIEND_HEAD_HEIGHT + APP_PRIMARY_MARGIN + CONTACT_FRIEND_BOTTOM_HEIGHT)

@interface FriendInfoViewController ()

@property (nonnull,strong)CustomNavigationBarView     *navigationBar;                          //导航栏
@property (nonatomic, strong) UserModel               *userModel;
@property (nonatomic, strong) UITableView             *tableView;                              //页面表格
@property (nonatomic, strong) UIView                  *tableHeaderView;                        //表头视图
@property (nonatomic, strong) UIView                  *headView;                               //头部视图
@property (nonatomic, strong) UIView                  *centerView;                             //中部视图
@property (nonatomic, strong) UIView                  *bottomView;                             //底部视图
@property (nonatomic, strong) UIImageView             *headViewBG;                             //头部视图背景
@property (nonatomic, strong) UIImageView             *headPortraitImageView;                  //头像
@property (nonatomic, strong) UIImageView             *headPortraitBGImageView;                //头像背景
@property (nonatomic, strong) UILabel                 *nicknameLabel;                          //昵称
@property (nonatomic, strong) UILabel                 *ageLabel;                               //年龄
@property (nonatomic, strong) UILabel                 *cityLabel;                              //城市
@property (nonatomic, strong) UIButton                *dynamicButton;                          //个人动态按钮
@property (nonatomic, strong) UIButton                *chatButton;                             //聊天按钮
@property (nonatomic, strong) UIButton                *callButton;                             //通话按钮
@property (nonatomic, assign) CGFloat                  navigationAlpha;                        //导航栏透明度
@property (nonatomic, assign) bool                    isFriend;                                //是否是好友
@property (nonatomic, copy)   void                    (^userInfoBlock)(UserModel *userModel);  //获取到用户信息后回调
@property (nonatomic, copy)   void                    (^userDynamicBlock)(NSDictionary *data); //获取到用户动态后回调
@property (nonatomic, strong) NSMutableArray<DynamicModel*> *userDynamicArray;                 //用户动态字典
@property (nonatomic, assign) FriendRequestType       type;


@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
    [self initBlocks];
    [self setUserInfo];
    [self getUserDynamic];
    [self getFriendState];
}

- (void)initStyle{
    [self initTableView];
    [self initHeadView];
    [self initNavigation];
    [self initView];
}
-(instancetype)initWithUserModel:(UserModel *)userModel{
    if (self == [super init]){
        _userModel = userModel;
    }
    return self;
}

- (void)initNavigation{
    _navigationBar = [[CustomNavigationBarView alloc]init];
    _navigationBar.bgView.alpha =  0;
    _navigationBar.titleLabel.text = _userModel.nickname;
    [_navigationBar.leftButton addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationBar];
    [_navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@APP_NAVIGATION_BAR_HEIGHT);
        make.left.top.equalTo(@0);
    }];
}


- (void)initTableView{
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
   //设置tableview从状态栏开始显示
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

}

- (void)initHeadView {
        _tableHeaderView = [[UIView alloc] init];
        self.tableView.tableHeaderView = _tableHeaderView;
        [self.tableView addSubview:_tableHeaderView];
        _tableHeaderView.backgroundColor = PRIMARY_BG_COLOR;
        _tableHeaderView.top = 0;
        _tableHeaderView.width = self.view.width;
        _tableHeaderView.height = CONTACT_FRIEND_TABLE_HEAD_HEIGHT;

        //头部视图样式
        _headView = [[UIView alloc] init];
        [self.tableHeaderView addSubview:_headView];
        _headView.backgroundColor = UIColor.whiteColor;
        _headView.width = self.tableHeaderView.width;
        _headView.height = CONTACT_FRIEND_HEAD_HEIGHT;
        _headView.top = 0;
        
        //头部视图背景
        _headViewBG = [[UIImageView alloc] init];
        [self.headView addSubview:_headViewBG];
        _headViewBG.userInteractionEnabled = YES;
        _headViewBG.contentMode = UIViewContentModeScaleAspectFill;
        [_headViewBG setClipsToBounds:YES];
        _headViewBG.width = self.headView.width;
        _headViewBG.height = CONTACT_FRIEND_HEAD_HEIGHT - CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT/2;
        _headViewBG.top = 0;
       
        //头像背景框样式
        _headPortraitBGImageView = [[UIImageView alloc] init];
        _headPortraitBGImageView.layer.cornerRadius = 20;
        _headPortraitBGImageView.layer.masksToBounds = YES;
        _headPortraitBGImageView.backgroundColor = RGB(255, 255, 255);
        _headPortraitBGImageView.userInteractionEnabled = YES;
        [self.headView addSubview:_headPortraitBGImageView];
        _headPortraitBGImageView.width = CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT;
        _headPortraitBGImageView.height = CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT;
        _headPortraitBGImageView.top = self.headViewBG.bottom - CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT / 2;
        _headPortraitBGImageView.centerX = self.headView.centerX;

        //头像样式
        _headPortraitImageView = [[UIImageView alloc] init];
        _headPortraitImageView.layer.cornerRadius = 20;
        _headPortraitImageView.layer.masksToBounds = YES;
        [self.headPortraitBGImageView addSubview:_headPortraitImageView];
        _headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
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
            make.width.mas_equalTo((APP_SCREEN_WIDTH - CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT) / 2);
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
    
    _bottomView = [[UIView alloc]init];
    [self.tableHeaderView addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.tableHeaderView);
        make.top.mas_equalTo(self.headView.mas_bottom).offset(APP_PRIMARY_MARGIN/2);
        make.height.mas_equalTo(CONTACT_FRIEND_BOTTOM_HEIGHT);
    }];
    
	_dynamicButton = [[UIButton alloc]init];
    [self.bottomView addSubview:_dynamicButton];
    [_dynamicButton setTitle:@"个人动态" forState:UIControlStateNormal];
    [_dynamicButton setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
    [_dynamicButton setBackgroundColor:UIColor.whiteColor];
    [_dynamicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.equalTo(self.bottomView);
        make.height.mas_equalTo((CONTACT_FRIEND_BOTTOM_HEIGHT-APP_PRIMARY_MARGIN/2)/2);
    }];

	_chatButton = [[UIButton alloc]init];
	[self.bottomView addSubview:_chatButton];
	[_chatButton setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
	[_chatButton setBackgroundColor:UIColor.whiteColor];
	[_chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(self.dynamicButton);
		make.top.equalTo(self.dynamicButton.mas_bottom).offset(APP_PRIMARY_MARGIN/2);
	}];
    

//    _callButton = [[UIButton alloc]init];
//    [self.bottomView addSubview:_callButton];
//    [_callButton setTitle:@"视频通话" forState:UIControlStateNormal];
//    [_callButton setTitleColor:PRIMARY_COLOR forState:UIControlStateNormal];
//    [_callButton setBackgroundColor:UIColor.whiteColor];
//    [_callButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(self.chatButton);
//        make.top.equalTo(self.chatButton.mas_bottom).offset(APP_PRIMARY_MARGIN/2);
//    }];
}

- (void)initView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.chatButton addTarget:self action:@selector(pushToChat) forControlEvents:UIControlEventTouchUpInside];
    [self.dynamicButton addTarget:self action:@selector(pushToDynamic) forControlEvents:UIControlEventTouchUpInside];
}

-(void)pushToChat{
    
    switch (self.type) {
        case isFriend:{
            ChatViewController *chatViewController = [[ChatViewController alloc] initWithFriendInfo:self.userModel];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chatViewController animated:YES];
        }
            break;
        case isNotFriend:{
            [self sendFriendRequest];
        }
            break;
        case refuse:
        case isRefused:
        case isWait:{
            NewFriendViewController *newFriendViewController = [[NewFriendViewController alloc] init];
            [self.navigationController pushViewController:newFriendViewController animated:YES];
            
        }
            break;
        case waitDeal:{
            [self agreeFriendRequest];
        }
            break;
        default:
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineTableViewCell *cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL" model:self.userDynamicArray[(NSUInteger)indexPath.section]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
            height += MINE_CELL_ONE_IMAGE_WIDTH * (proportion <=2 ?proportion : 2)+APP_PRIMARY_MARGIN;
        }else{
            height += MINE_CELL_ONE_IMAGE_HEIGHT + APP_PRIMARY_MARGIN;
        }
    }else if(picArray.count == 2){  //两张图的高度
        height += MINE_CELL_TWO_IMAGE_HEIGHT + APP_PRIMARY_MARGIN;
    }else if(picArray.count > 2){  //三张及以上的高度
        height += (MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + MINE_CELL_IMAGE_MARGIN) * ((int)(picArray.count - 1 ) / 3) + MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + APP_PRIMARY_MARGIN;
    }
    height += APP_ICON_SIZE + APP_PRIMARY_MARGIN;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initUserDynamicBlock{
    self.userDynamicArray = [[NSMutableArray alloc]init];
    __weak typeof(self) weakSelf = self;
    self.userDynamicBlock = ^(NSDictionary *data){
        __weak typeof(weakSelf) strongSelf = weakSelf;
        NSArray *dataArray = data[@"data"][@"dynamic"];
        for (int i = 0; i <dataArray.count ; i++) {
            strongSelf.userDynamicArray[(NSUInteger) i] = [[DynamicModel alloc] initWithDic:data[@"data"][@"dynamic"][i]];
        }
        NSLog(@"%@",data);
        [strongSelf.tableView reloadData];
    };
}

//初始化获取用户信息成功和失败闭包
- (void)initBlocks {
//    [self initUserInfoBlock];
    [self initUserDynamicBlock];
}

-(void)setUserInfo{
    if ( self.userModel == nil) {
        self.userModel = [[UserModel alloc]initWithDic:self.userInfoDictionary];
    }
    if([self.userModel.background  isEqual: @""]){
        [self.headViewBG setImage:[UIImage imageNamed:@"noBg"] ];
    }else if(self.userModel.background != nil){
        [self.headViewBG sd_setImageWithURL:[[NSURL alloc] initWithString:self.userModel.background]];
    }
    if(self.userModel.headPortrait != nil){
        [self.headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
    }else{
        [self.headPortraitImageView setImage:[UIImage imageNamed:@"noHeadPortrait"]];
    }
    self.isFriend = [FriendCache isFriend:_userModel.userId];
    [self.chatButton setTitle:_isFriend?@"发消息":@"发送好友申请" forState:UIControlStateNormal];

    self.nicknameLabel.text = self.userModel.nickname;
        //创建富文本
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString: self.userModel.age == nil?@"0":self.userModel.age];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image =  [self.userModel.gender  isEqual: @"0"]?[UIImage imageNamed:@"woman"]:[UIImage imageNamed:@"man"];
        attach.bounds = CGRectMake(0, -4, 20, 20);
        NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attach];
        [attr insertAttributedString:string1 atIndex:0];
        self.ageLabel.attributedText = attr;
    }

////滚动事件
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (- offset >= 0) {
        self.headViewBG.height = _headView.height - CONTACT_FRIEND_HEAD_PORTRAIT_HEIGHT / 2 -offset;
        self.headViewBG.top = offset;
    }
    
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    self.navigationBar.bgView.alpha = offset > 0 ? alpha : 0;

}

-(void)pushToDynamic{
    if (self.type == waitDeal){
        [self refuseFriendRequest];
        return;
    }
    
	self.hidesBottomBarWhenPushed = YES;
    DynamicViewController *dynamicViewController  = [[DynamicViewController alloc] initWithType:mine userId:self.userModel.userId];
    [dynamicViewController setNaviTitle:@"动态"];
    [self.navigationController pushViewController:dynamicViewController animated:YES];
}

-(void)getFriendState{
    [FriendHttpRequest friendStateRequest:self.userModel.userId successBlock:^(NSDictionary * _Nonnull data) {
        NSNumber *result = data[@"ok"];
        self.type = result.intValue;
        switch (self.type) {
            case isFriend:
                [self.chatButton setTitle:@"发消息" forState:UIControlStateNormal];
                break;
            case isNotFriend:
                [self.chatButton setTitle:@"发送好友申请" forState:UIControlStateNormal];
                break;
            case refuse:
                [self.chatButton setTitle:@"对方拒绝" forState:UIControlStateNormal];
                break;
            case isRefused:
                [self.chatButton setTitle:@"您已拒绝" forState:UIControlStateNormal];
                break;
            case isWait:
                [self.chatButton setTitle:@"等待验证" forState:UIControlStateNormal];
                break;
            case waitDeal:
                [self.chatButton setTitle:@"同意好友申请" forState:UIControlStateNormal];
                [self.dynamicButton setTitle:@"拒绝好友申请" forState:UIControlStateNormal];
                [self.dynamicButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
                break;
            default:
                break;
        }
        } failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
    }];
}

- (void)pushBack{
    [self.navigationController popViewControllerAnimated:YES];
}



//获取用户动态信息
- (void)getUserDynamic{
    [DynamicHttpRequest getDynamic:1 userId:self.userModel.userId successBlock:_userDynamicBlock failBlock:nil];
}

- (void)sendFriendRequest{
    [FriendHttpRequest sendFriendRequest:self.userModel.userId successBlock:^(NSDictionary * _Nonnull data) {
        [self getFriendState];
        } failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}

- (void)agreeFriendRequest{
    [FriendHttpRequest agreeFriendRequest:self.userModel.userId successBlock:^(NSDictionary * _Nonnull data) {
        [self getFriendState];
        } failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}

- (void)refuseFriendRequest{
    [FriendHttpRequest refuseFriendRequest:self.userModel.userId successBlock:^(NSDictionary * _Nonnull data) {
        [self getFriendState];
        } failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {}];
}


@end
