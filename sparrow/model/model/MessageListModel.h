//
//  MessageListModel.h
//  sparrow
//
//  Created by hwy on 2022/1/21.
//

#import <Foundation/Foundation.h>

@class UserModel;

NS_ASSUME_NONNULL_BEGIN

@interface MessageListModel : NSObject

@property(nonatomic, copy)   NSString  *messageListId;
@property(nonatomic, copy)   NSString  *time;
@property(nonatomic, copy)   NSString  *message;
@property(nonatomic, copy)   NSString  *unReadCount;
@property(nonatomic, assign) NSNumber  *type;              //消息类型
@property(nonatomic, strong) UserModel *userModel;


@end

NS_ASSUME_NONNULL_END
