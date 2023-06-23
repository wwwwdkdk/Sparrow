//
//  BaseNavigationController.m
//  sparrow
//
//  Created by hwy on 2023/4/9.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        barApp.backgroundImage = [UIImage new];
        barApp.backgroundColor = UIColor.whiteColor;
        self.navigationBar.scrollEdgeAppearance = barApp;
        self.navigationBar.standardAppearance = barApp;
    }else {
        self.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationBar setBackgroundColor:UIColor.whiteColor];
    }
    [self.navigationBar setTintColor:[UIColor grayColor]];
}



@end
