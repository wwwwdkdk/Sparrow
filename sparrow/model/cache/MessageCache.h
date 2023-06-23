//
//  MessageCache.h
//  sparrow
//
//  Created by hwy on 2022/1/20.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class MessageModel;
@class MessageListModel;
NS_ASSUME_NONNULL_BEGIN

@interface MessageCache : NSObject

- (void)connectDataBase;

- (void)createTable;

- (void)insertMessage:(MessageModel *)model;

- (void)setMessageStateRead:(NSString *)sendId;

- (NSMutableArray<MessageModel *> *)getMessage:(NSString *)userId
                                      FriendId:(NSString *)friendId;

- (NSMutableArray<MessageListModel *> *)getMessageList;


@end

NS_ASSUME_NONNULL_END
