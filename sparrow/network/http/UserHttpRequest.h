//
//  UserHttpRequest.h
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserHttpRequest : NSObject

//用户登录
+ (void)userLogin:(void (^)(NSDictionary *data))successBlock
         username:(NSString *)username
         password:(NSString *)password
        failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//用户注册
+ (void)userRegister:(void (^)(NSDictionary *data))successBlock
            username:(NSString *)username
            password:(NSString *)password
           failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取当前用户信息
+ (void)getUserInfo:(void (^)(NSDictionary *data))successBlock
          failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//设置背景图片
+ (void)setBackground:(UIImage *)background
         successBlock:(void (^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//设置头像
+ (void)setHeadPortrait:(UIImage *)headPortrait
           successBlock:(void (^)(NSDictionary *data))successBlock
              failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//搜索用户
+ (void)searchUser:(NSString *)search
      successBlock:(void (^)(NSDictionary *data))successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

@end

NS_ASSUME_NONNULL_END
