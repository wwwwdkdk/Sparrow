//
//  MessageHttpRequest.m
//  sparrow
//
//  Created by hwy on 2021/12/29.
//

#import "MessageHttpRequest.h"
#import "BaseModel.h"
#import "HttpRequestUtil.h"

@implementation MessageHttpRequest

+ (void)getUnLoadMessage:(NSInteger)page
                    friendId:(NSString*)friendId
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
	[HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_UNREAD] parameters:@{@"page": @(page), @"friendId": friendId} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
		successBlock(data);
	}  failureRequest:failureBlock];
}

+ (void)getUnLoadMessageList:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
	[HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_ALL_UNREAD] parameters:nil headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
		successBlock(data);
	}  failureRequest:failureBlock];
}

+ (void)deleteMessage:(void (^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
	[HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_MESSAGE_DELETE] parameters:nil headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
		successBlock(data);
	}  failureRequest:failureBlock];
}
@end

