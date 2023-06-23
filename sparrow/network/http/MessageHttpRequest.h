//
//  MessageHttpRequest.h
//  sparrow
//
//  Created by hwy on 2021/12/29.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageHttpRequest : NSObject

// 获取未读信息
+ (void)getUnLoadMessageList:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

// 删除信息
+ (void)deleteMessage:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

// 获取未读信息
+ (void)getUnLoadMessage:(NSInteger)page
                    friendId:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
