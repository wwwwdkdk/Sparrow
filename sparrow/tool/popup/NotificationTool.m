//
//  NotificationTool.m
//  sparrow
//
//  Created by hwy on 2021/12/29.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MASConstraintMaker.h>
#import <View+MASAdditions.h>
#import <UIImageView+WebCache.h>
#import "NotificationTool.h"
#import "UIView+Size.h"
#import "MessageModel.h"
#import "MessageCache.h"
#import "FriendCache.h"
#import "UserModel.h"
#import "ChatViewController.h"
#include "TcpRequest.h"

#define NOTIFICATION_VIEW_TAG 1000

@implementation NotificationTool

static NSTimer *timer;
static UserModel *userModel;

+ (void)openLocalNotificationAlert:(NSString *)content
                        identifier:(NSString *)identifier {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeNotificationAlert];
        UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(10, -100, APP_SCREEN_WIDTH - 20, 90)];
        notificationView.backgroundColor = RGBA(255, 255, 255, 0.99);
        notificationView.tag = NOTIFICATION_VIEW_TAG;
        notificationView.accessibilityIdentifier = identifier;

        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, notificationView.width - APP_PRIMARY_MARGIN * 2, notificationView.height)];
        contentLabel.numberOfLines = 2;
        [contentLabel setFont:[UIFont systemFontOfSize:16]];
        contentLabel.text = content;
        [notificationView addSubview:contentLabel];
        notificationView.layer.shadowColor = [UIColor blackColor].CGColor;
        notificationView.layer.cornerRadius = 15;
        notificationView.layer.shadowOpacity = 0.4f;
        notificationView.layer.shadowRadius = 3.0f;
        notificationView.layer.shadowOffset = CGSizeMake(3, 3);
        //添加点击事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedNotificationAlert)];
        [notificationView addGestureRecognizer:tapGestureRecognizer];
        //添加上滑事件
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingUpNotificationAlert)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [notificationView addGestureRecognizer:recognizer];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:notificationView];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [UIView transitionWithView:notificationView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            notificationView.top = APP_STATUS_BAR_HEIGHT;
        }               completion:nil];
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
        if (@available(iOS 10.0, *)) {
            timer = [NSTimer scheduledTimerWithTimeInterval:6 repeats:NO block:^(NSTimer *timer) {
                [self slidingUpNotificationAlert];
            }];
        } else {
            timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(slidingUpNotificationAlert) userInfo:nil repeats:NO];
        }
    });
}


+ (void)openLocalNotificationAlert:(MessageModel *)model {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeNotificationAlert];
        UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(10, -100, APP_SCREEN_WIDTH - 20, 90)];
        notificationView.backgroundColor = RGBA(255, 255, 255, 0.99);
        notificationView.tag = NOTIFICATION_VIEW_TAG;

        NSArray<UserModel *> *friendArray = [FriendCache getContact];
//        UserModel *userModel;
        for (int i = 0; i < friendArray.count; i++) {
            NSString *sendId = [NSString stringWithFormat:@"%@", model.sendId];
            NSString *friendId = [NSString stringWithFormat:@"%@", friendArray[i].userId];
            if ([friendId isEqualToString:sendId]) {
                userModel = friendArray[i];
            }
        }

        if (userModel == nil) {
            return;
        }

        UIImageView *headPortraitImageView = [[UIImageView alloc] init];
        headPortraitImageView.layer.masksToBounds = YES;
        headPortraitImageView.layer.cornerRadius = 15;
        headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
        [notificationView addSubview:headPortraitImageView];
        if (userModel.headPortrait == nil) {
            [headPortraitImageView setImage:[UIImage imageNamed:@"noHeadPortrait"]];
        } else {
            [headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
        }

        [headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(APP_PRIMARY_MARGIN);
            make.width.height.mas_equalTo(90 - APP_PRIMARY_MARGIN * 2);
            make.left.mas_equalTo(APP_PRIMARY_MARGIN);
        }];

        UILabel *nowLabel = [[UILabel alloc] init];
        [notificationView addSubview:nowLabel];
        nowLabel.text = @"现在";
        [nowLabel setFont:[UIFont systemFontOfSize:APP_SMALL_FONT_SIZE]];
        [nowLabel setTextColor:UIColor.grayColor];
        [nowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-APP_PRIMARY_MARGIN);
            make.height.mas_equalTo(20);
            make.top.equalTo(headPortraitImageView);
        }];

        UILabel *usernameLabel = [[UILabel alloc] init];
        [notificationView addSubview:usernameLabel];
        usernameLabel.text = userModel.nickname;
        [usernameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
        [usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN);
            make.height.equalTo(headPortraitImageView).multipliedBy(0.4);
            make.top.equalTo(headPortraitImageView).offset((90 - APP_PRIMARY_MARGIN * 2) * 0.1);
        }];

        UILabel *contentLabel = [[UILabel alloc] init];
        [notificationView addSubview:contentLabel];
        if ([model.type isEqual:@1]) {
            contentLabel.text = @"[图片]";
        } else {
            contentLabel.text = model.content;
        }

        [contentLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE - 2]];
        contentLabel.textColor = UIColor.grayColor;
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.height.equalTo(usernameLabel);
            make.top.equalTo(usernameLabel.mas_bottom);
        }];

        [notificationView addSubview:contentLabel];
        notificationView.layer.shadowColor = [UIColor blackColor].CGColor;
        notificationView.layer.cornerRadius = 15;
        notificationView.layer.shadowOpacity = 0.4f;
        notificationView.layer.shadowRadius = 3.0f;
        notificationView.layer.shadowOffset = CGSizeMake(3, 3);
        //添加点击事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedNotificationAlert)];
        [notificationView addGestureRecognizer:tapGestureRecognizer];
        //添加上滑事件
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slidingUpNotificationAlert)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [notificationView addGestureRecognizer:recognizer];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:notificationView];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [UIView transitionWithView:notificationView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            notificationView.top = APP_STATUS_BAR_HEIGHT;
                        } completion:nil];
        if (timer != nil) {
            [timer invalidate];
            timer = nil;
        }
        if (@available(iOS 10.0, *)) {
            timer = [NSTimer scheduledTimerWithTimeInterval:6 repeats:NO block:^(NSTimer *timer) {
                [self slidingUpNotificationAlert];
            }];
        } else {
            timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(slidingUpNotificationAlert) userInfo:nil repeats:NO];
        }
    });
}


// 移除前台通知弹窗
+ (void)removeNotificationAlert {
    UIView *uiView = [[UIApplication sharedApplication].keyWindow.rootViewController.view viewWithTag:NOTIFICATION_VIEW_TAG];
    if (uiView != nil) {
        [uiView removeFromSuperview];
    }
}

// 在前台点击通知后调用
+ (void)clickedNotificationAlert {
    UIView *uiView = [[UIApplication sharedApplication].keyWindow.rootViewController.view viewWithTag:NOTIFICATION_VIEW_TAG];
    NSLog(@"点击的通知:%@", uiView.accessibilityIdentifier);
    UILabel *contentLabel = uiView.subviews[1];
    NSLog(@"点击的通知内容:%@", contentLabel.text);
    [uiView removeFromSuperview];
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithFriendInfo:userModel];
    UIViewController *vc = [TcpRequest getCurrentVC];
    vc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:chatViewController animated:YES];
    vc.hidesBottomBarWhenPushed = NO;
}

// 向上滑动通知弹窗时调用
+ (void)slidingUpNotificationAlert {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    UIView *uiView = [[UIApplication sharedApplication].keyWindow.rootViewController.view viewWithTag:NOTIFICATION_VIEW_TAG];
    if (uiView != nil) {
        NSLog(@"上滑关闭通知");
        [UIView transitionWithView:uiView duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            uiView.top = -uiView.height;
        }               completion:^(BOOL finished) {
            [uiView removeFromSuperview];
        }];
    }
}

@end
