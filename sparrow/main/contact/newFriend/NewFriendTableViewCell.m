//
//  NewFriendTableViewCell.m
//  sparrow
//
//  Created by hwy on 2021/12/22.
//

#import "NewFriendTableViewCell.h"
#import "FriendHttpRequest.h"
#import "HttpRequestUtil.h"
#import "BaseModel.h"
#import "UIImageView+WebCache.h"
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>

@interface NewFriendTableViewCell ()

@property(nonatomic, strong) FriendRequestModel *model;

@end


@implementation NewFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    sendModel:(FriendRequestModel *)sendModel {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.model = sendModel;
        [self initStyle];
        [self initSendState];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                receivedModel:(FriendRequestModel *)receivedModel {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.model = receivedModel;
        [self initStyle];
        [self initReceiveState];
    }
    return self;
}

- (void)initStyle {
    UIImageView *headPortraitImageView = [[UIImageView alloc] init];
    headPortraitImageView.layer.masksToBounds = YES;
    headPortraitImageView.layer.cornerRadius = 15;
    headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
    headPortraitImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:headPortraitImageView];
    if (self.model.userModel.headPortrait != nil) {
        [headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.model.userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
    } else {
        [headPortraitImageView setImage:[UIImage imageNamed:@"noHeadPortrait"]];
    }

    [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(APP_PRIMARY_MARGIN);
        make.width.height.mas_equalTo(CONTACT_NEW_FRIEND_HEAD_PORTRAIT_SIZE);
        make.left.mas_equalTo(APP_PRIMARY_MARGIN);
    }];

    UILabel *nicknameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:nicknameLabel];
    nicknameLabel.text = self.model.userModel.nickname;
    [nicknameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
    [nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN);
        make.height.equalTo(headPortraitImageView).multipliedBy(0.5);
        make.top.equalTo(headPortraitImageView);
    }];

    UILabel *contentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:contentLabel];
    [contentLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE - 2]];
    contentLabel.text = self.model.userModel.city;
    contentLabel.textColor = UIColor.grayColor;
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(nicknameLabel);
        make.top.equalTo(nicknameLabel.mas_bottom);
    }];
}

- (void)initSendState {
    UILabel *stateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:stateLabel];
    stateLabel.textAlignment = NSTextAlignmentRight;
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(-APP_PRIMARY_MARGIN);
        make.height.mas_equalTo(self.contentView);
    }];
    if ([self.model.state isEqual:@"1"]) {
        stateLabel.text = @"等待验证";
    } else if ([self.model.state isEqual:@"0"]) {
        stateLabel.textColor = UIColor.redColor;
        stateLabel.text = @"对方拒绝";
    } else if ([self.model.state isEqual:@"2"]) {
        stateLabel.textColor = CORRECT_COLOR;
        stateLabel.text = @"添加成功";
    }
}

- (void)initReceiveState {
    UILabel *stateLabel = [[UILabel alloc] init];
    [self.contentView addSubview:stateLabel];
    stateLabel.textAlignment = NSTextAlignmentRight;
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.right.mas_equalTo(-APP_PRIMARY_MARGIN);
        make.height.mas_equalTo(self.contentView);
    }];
    if ([self.model.state isEqual:@"1"]) {
        stateLabel.text = @"待处理";
    } else if ([self.model.state isEqual:@"0"]) {
        stateLabel.textColor = UIColor.redColor;
        stateLabel.text = @"已拒绝";
    } else if ([self.model.state isEqual:@"2"]) {
        stateLabel.textColor = CORRECT_COLOR;
        stateLabel.text = @"已同意";
    }
}

@end
