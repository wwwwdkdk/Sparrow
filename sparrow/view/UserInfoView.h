//
//  UserInfoView.h
//  sparrow
//
//  Created by hwy on 2023/5/6.
//

#import <UIKit/UIKit.h>
#import"UserModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface UserInfoView : UIView

@property (nonatomic, strong) UIView                  *headView;                               //头部视图
@property (nonatomic, strong) UIImageView             *headViewBG;                             //头部视图背景
@property (nonatomic, strong) UIImageView             *headPortraitImageView;                  //头像
@property (nonatomic, strong) UIImageView             *headPortraitBGImageView;                //头像背景
@property (nonatomic, strong) UILabel                 *nicknameLabel;                          //昵称
@property (nonatomic, strong) UILabel                 *ageLabel;                               //年龄

- (void)setData:(UserModel *)model;

@end

NS_ASSUME_NONNULL_END
