//
//  UserInfoView.m
//  sparrow
//
//  Created by hwy on 2023/5/6.
//

#import "UserInfoView.h"
#import "UIView+Size.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import <UIImageView+WebCache.h>

//用户头像尺寸
#define USER_HEAD_PORTRAIT_HEIGHT    APP_SCREEN_WIDTH * 0.22
//头部视图高度
#define USER_HEAD_HEIGHT             (APP_SCREEN_WIDTH * 0.5 + USER_HEAD_PORTRAIT_HEIGHT)
//按钮中图片和标签间的间距
#define USER_IMAGE_AND_LABEL_MARGIN  APP_SCREEN_WIDTH * 0.01
//按钮中标签间高度
#define USER_LABEL_HEIGHT            APP_FONT_SIZE

@implementation UserInfoView


-(void)initStyle{

    //头部视图样式
    _headView = [[UIView alloc] init];
    [self addSubview:_headView];
    _headView.backgroundColor = UIColor.whiteColor;
    _headView.width = APP_SCREEN_WIDTH;
    _headView.height = USER_HEAD_HEIGHT;
    _headView.top = 0;
    
    //头部视图背景
    _headViewBG = [[UIImageView alloc] init];
    [self addSubview:_headViewBG];
    _headViewBG.userInteractionEnabled = YES;
    _headViewBG.contentMode = UIViewContentModeScaleAspectFill;
    [_headViewBG setClipsToBounds:YES];
    _headViewBG.width = self.headView.width;
    _headViewBG.height = USER_HEAD_HEIGHT - USER_HEAD_PORTRAIT_HEIGHT / 2;
    _headViewBG.top = 0;

    //头像背景框样式
    _headPortraitBGImageView = [[UIImageView alloc] init];
    _headPortraitBGImageView.layer.cornerRadius = 20;
    _headPortraitBGImageView.layer.masksToBounds = YES;
    _headPortraitBGImageView.backgroundColor = RGB(255, 255, 255);
    _headPortraitBGImageView.userInteractionEnabled = YES;
    [self addSubview:_headPortraitBGImageView];
    _headPortraitBGImageView.width = USER_HEAD_PORTRAIT_HEIGHT;
    _headPortraitBGImageView.height = USER_HEAD_PORTRAIT_HEIGHT;
    _headPortraitBGImageView.top = self.headViewBG.bottom - USER_HEAD_PORTRAIT_HEIGHT / 2;
    _headPortraitBGImageView.centerX = self.headView.centerX;

    //头像样式
    _headPortraitImageView = [[UIImageView alloc] init];
    _headPortraitImageView.layer.cornerRadius = 20;
    _headPortraitImageView.layer.masksToBounds = YES;
    _headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
    [self.headPortraitBGImageView addSubview:_headPortraitImageView];
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
        make.width.mas_equalTo((APP_SCREEN_WIDTH - USER_HEAD_PORTRAIT_HEIGHT) / 2);
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
}

- (instancetype)initWithFrame:(CGRect)frame{
    [self initStyle];
    return [super initWithFrame:frame];;
    
}

- (void)setData:(UserModel *)model{
    [self.headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
    if([model.background isEqual:@""]){
        [self.headViewBG setImage:[UIImage imageNamed:@"noBg"] ];
    }else if (model.background != nil){
        [self.headViewBG sd_setImageWithURL:[[NSURL alloc] initWithString:model.background]];
    }
    self.nicknameLabel.text = model.nickname;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@岁", model.age == nil ? @"0" : model.age]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image =  [model.gender isEqual: @"0"] ?[UIImage imageNamed:@"woman"]:[UIImage imageNamed:@"man"];
    attach.bounds = CGRectMake(0, -4, 20, 20);
    NSAttributedString *string1 = [NSAttributedString attributedStringWithAttachment:attach];
    [attr insertAttributedString:string1 atIndex:0];
    self.ageLabel.attributedText = attr;
}

@end
