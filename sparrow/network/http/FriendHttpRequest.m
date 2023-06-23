//
//  FriendHttpRequest.m
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import "FriendHttpRequest.h"
#import "BaseModel.h"
#import "HttpRequestUtil.h"

@implementation FriendHttpRequest

+ (void)getFriendList:(NSInteger)page
         successBlock:(void (^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
	[HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_FRIEND] parameters:@{@"page": @(page)} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
		successBlock(data);
	}                  failureRequest:failureBlock];
}

+ (void)getReceivedFriendRequest:(NSInteger)page
                    successBlock:(void (^)(NSDictionary *data))successBlock
                       failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
	[HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_RECEIVE_REQUEST] parameters:nil headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
		successBlock(data);
	}                  failureRequest:nil];
}

+ (void)getSendFriendRequest:(NSInteger)page
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
	[HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_SEND_REQUEST] parameters:nil headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
		successBlock(data);
	}                  failureRequest:nil];
}


+ (void)sendFriendRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_REQUEST] parameters:@{@"friendId":friendId} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                  failureRequest:nil];
}


+ (void)agreeFriendRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                 failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_AGREE_REQUEST] parameters:@{@"sendId":friendId} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                  failureRequest:nil];
    
}

+ (void)refuseFriendRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                  failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_REFUSE_REQUEST] parameters:@{@"sendId":friendId} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                  failureRequest:nil];
}

+ (void)friendStateRequest:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                 failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_FRIEND_STATE] parameters:@{@"friendId":friendId} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                  failureRequest:nil];
}

@end
