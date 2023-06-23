//
//  UserHttpRequest.m
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import "UserHttpRequest.h"
#import "BaseModel.h"
#import "HttpRequestUtil.h"

@implementation UserHttpRequest

+ (void)getUserInfo:(void (^)(NSDictionary *data))successBlock
          failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_USER_INFO] parameters:nil headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                  failureRequest:failureBlock];
}

+ (void)userLogin:(void (^)(NSDictionary *data))successBlock
         username:(NSString *)username
         password:(NSString *)password
        failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
    NSDictionary *parameters = @{
            @"username": username,
            @"password": password
    };
    [HttpRequestUtil postWithURLString:[BaseModel getHttpAddress:APP_HTTP_LOGIN] parameters:parameters headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                   failureRequest:failureBlock];
}

+ (void)userRegister:(void (^)(NSDictionary *data))successBlock
            username:(NSString *)username
            password:(NSString *)password
           failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
    NSDictionary *parameters = @{
            @"username": username,
            @"password": password
    };
    [HttpRequestUtil postWithURLString:[BaseModel getHttpAddress:APP_HTTP_REGISTER] parameters:parameters headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                   failureRequest:failureBlock];
}

+ (void)setBackground:(UIImage *)background
         successBlock:(void (^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
    NSData *data = UIImageJPEGRepresentation(background, 0.5);
    NSArray *array = @[data];
    [HttpRequestUtil postWithURLString:[BaseModel getHttpAddress:APP_HTTP_BACKGROUND] parameters:nil headers:nil image:array successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                   failureRequest:failureBlock];
}

+ (void)setHeadPortrait:(UIImage *)headPortrait
           successBlock:(void (^)(NSDictionary *data))successBlock
              failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
    NSData *data = UIImageJPEGRepresentation(headPortrait, 0.5);
    NSArray *array = @[data];
    [HttpRequestUtil postWithURLString:[BaseModel getHttpAddress:APP_HTTP_HEAD_PORTRAIT] parameters:nil headers:nil image:array successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                   failureRequest:failureBlock];
}

+ (void)searchUser:(NSString *)search
      successBlock:(void (^)(NSDictionary *data))successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock {
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_SEARCH] parameters:@{@"search": search} headers:nil successRequest:^(NSURLSessionDataTask *_Nonnull task, NSDictionary *_Nullable data) {
        successBlock(data);
    }                  failureRequest:failureBlock];
}

@end
