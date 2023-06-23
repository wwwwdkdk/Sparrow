//
// Created by hwy on 2022/1/21.
//

#import <Foundation/Foundation.h>

@class UserModel;


@interface FriendCache : NSObject

// 获取好友列表
+ (NSArray<UserModel *> *)getContact;

// 保存好友列表
+ (void)saveContact:(NSDictionary *)friendDictionary;

// 是否是好友
+ (bool)isFriend:(NSString*)userId;

// 获取单个好友信息
+ (UserModel*)getFriendModel:(NSString *)userId;


@end
