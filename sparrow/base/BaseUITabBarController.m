//
//  BaseUITabBarController.m
//  sparrow
//
//  Created by hwy on 2021/11/17.
//

#import "BaseUITabBarController.h"
#import "MineViewController.h"
#import "MessageListViewController.h"
#import "ContactViewController.h"
#import "BaseNavigationController.h"

@interface BaseUITabBarController ()

@end

@implementation BaseUITabBarController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tabBar setTintColor:PRIMARY_COLOR];
	self.tabBar.unselectedItemTintColor = UIColor.blackColor;

	//消息页面
	MessageListViewController *messageViewController = [[MessageListViewController alloc] init];
	messageViewController.tabBarItem.title = @"消息";
	messageViewController.tabBarItem.image = [[UIImage imageNamed:@"message"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	messageViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectMessage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	//联系人页面
	ContactViewController *contactViewController = [[ContactViewController alloc] init];
	contactViewController.tabBarItem.title = @"好友";
	contactViewController.tabBarItem.image = [[UIImage imageNamed:@"addressBook"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	contactViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectAddressBook"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	//我的页面
	MineViewController *mineViewController = [[MineViewController alloc] init];
	mineViewController.tabBarItem.title = @"我的";
	mineViewController.tabBarItem.image = [[UIImage imageNamed:@"mine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	mineViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"selectMine"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

	//导航
	UINavigationController *naviMine = [[BaseNavigationController alloc] initWithRootViewController:mineViewController];
	UINavigationController *naviContact = [[BaseNavigationController alloc] initWithRootViewController:contactViewController];
	UINavigationController *naviMessage = [[BaseNavigationController alloc] initWithRootViewController:messageViewController];
    self.viewControllers = @[naviMessage, naviContact, naviMine];
	if (@available(iOS 15.0, *)) {
		UITabBarAppearance *appearance = [UITabBarAppearance new];
		self.tabBar.scrollEdgeAppearance = appearance;
	}

}


@end
