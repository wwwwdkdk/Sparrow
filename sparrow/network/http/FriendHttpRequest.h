//
//  FriendHttpRequest.h
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendHttpRequest : NSObject

//获取一页好友列表
+ (void)getFriendList:(NSInteger)page
         successBlock:(void (^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取一页收到的好友申请
+ (void)getReceivedFriendRequest:(NSInteger)page
                    successBlock:(void (^)(NSDictionary *data))successBlock
                       failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取一页发出的好友申请
+ (void)getSendFriendRequest:(NSInteger)page
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//发送好友请求
+ (void)sendFriendRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//接受好友请求
+ (void)agreeFriendRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;
//拒绝好友请求
+ (void)refuseFriendRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取好友状态
+ (void)friendStateRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
