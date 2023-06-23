//
//  MessageModel.h
//  sparrow
//  消息
//  Created by hwy on 2021/12/28.
//

#import <Foundation/Foundation.h>
#import "ChatTableViewCell.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject

@property(nonatomic, copy)   NSString *messageId;         //id
@property(nonatomic, copy)   NSString *content;           //消息内容
@property(nonatomic, copy)   NSString *sendId;            //发送者id
@property(nonatomic, copy)   NSString *receivedId;        //接受者id
@property(nonatomic, strong) UIImage *image;              //消息图片（发送者为本人时使用）
@property(nonatomic, assign) NSNumber *type;              //消息类型
@property(nonatomic, assign) NSString *time;              //发送时间
@property(nonatomic, assign) NSString *state;             //状态

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
