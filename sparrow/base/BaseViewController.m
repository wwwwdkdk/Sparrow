//
//  BaseViewController.m
//  sparrow
//
//  Created by hwy on 2023/4/9.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = PRIMARY_BG_COLOR;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}


@end
