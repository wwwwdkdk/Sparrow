//
//  FeedbackViewController.m
//  用户反馈页面
//  sparrow
//
//  Created by hwy on 2021/11/17.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property(strong,nonatomic)UITextView *feedBackTextView;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStyle];
}

-(void)initStyle{
    self.view.backgroundColor = UIColor.whiteColor;
    _feedBackTextView = [[UITextView alloc]init];
}

@end
