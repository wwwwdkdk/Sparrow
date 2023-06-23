//
//  FriendInfoViewController.h
//  sparrow
//  好友信息页面
//  Created by hwy on 2021/11/29.
//

#import <UIKit/UIKit.h>

@class UserModel;

NS_ASSUME_NONNULL_BEGIN

@interface FriendInfoViewController : BaseViewController
	<UIScrollViewDelegate,
	UITableViewDataSource,
	UITableViewDelegate,
	UINavigationControllerDelegate,
	HideNavigationBarProtocol>

@property(nonatomic, strong) NSDictionary *userInfoDictionary;

- (instancetype)initWithUserModel:(UserModel *)userModel;

@end

NS_ASSUME_NONNULL_END
