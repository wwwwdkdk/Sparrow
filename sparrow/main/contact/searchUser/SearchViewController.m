//
//  SearchViewController.m
//  sparrow
//
//  Created by hwy on 2021/11/29.
//

#import "SearchViewController.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>

@interface SearchViewController ()
@property(nonatomic, strong) UITextField *searchField;
@end

@implementation SearchViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initStyle];
}

- (void)initStyle {
	[self initSearchField];
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
		make.height.mas_equalTo(APP_SCREEN_WIDTH * 0.1);
	}];
}

//点击空白处收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:YES];
}

@end
