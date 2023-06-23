//
//  UserInfoViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/18.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
}


//初始化样式
-(void)initStyle{
    self.navigationItem.title = @"个人资料";

}

-(void)viewWillDisappear:(BOOL)animated{

}



@end
