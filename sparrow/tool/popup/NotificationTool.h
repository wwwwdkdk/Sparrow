//
//  NotificationTool.h
//  sparrow
//  
//  Created by hwy on 2021/12/29.
//

#import <Foundation/Foundation.h>

@class MessageModel;

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTool : NSObject

// 普通的通用弹窗
+ (void)openLocalNotificationAlert:(NSString *)content
                        identifier:(NSString *)identifier;

// 消息弹窗
+ (void)openLocalNotificationAlert:(MessageModel *)model;
@end

NS_ASSUME_NONNULL_END
