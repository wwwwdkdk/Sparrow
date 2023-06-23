//
//  HttpRequestUtil.h
//  sparrow
//
//  Created by hwy on 2021/11/15.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface HttpRequestUtil : NSObject
/**
 *  发送get请求
 *
 *  @param urlString  	      请求的网址字符串
 *  @param parameters 	      请求的参数
 *  @param headers 		      请求头
 *  @param successRequest    请求成功的回调
 *  @param failureRequest    请求失败的回调
 */
+ (void)getWithURLString:(NSString *)urlString
              parameters:(nullable id)parameters
                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
          successRequest:(nullable void (^)(NSURLSessionDataTask *_Nonnull, NSDictionary *_Nullable))successRequest
          failureRequest:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureRequest;

/**
 *  发送纯文本的post请求
 *
 *  @param urlString               请求的网址字符串
 *  @param parameters             请求的参数
 *  @param headers                    请求头
 *  @param successRequest    请求成功的回调
 *  @param failureRequest    请求失败的回调
 */
+ (void)postWithURLString:(NSString *)urlString
               parameters:(nullable id)parameters
                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
           successRequest:(nullable void (^)(NSURLSessionDataTask *_Nonnull, NSDictionary *_Nullable))successRequest
           failureRequest:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureRequest;


/**
 *  发送携带图片的post请求
 *
 *  @param urlString  		 请求的网址字符串
 *  @param parameters 		 请求的参数
 *  @param headers 			 请求头
 *  @param imageArray  		 图片数组
 *  @param successRequest       请求成功的回调
 *  @param failureRequest       请求失败的回调
 */
+ (void)postWithURLString:(NSString *)urlString
               parameters:(nullable id)parameters
                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                    image:(NSArray *)imageArray
           successRequest:(nullable void (^)(NSURLSessionDataTask *_Nonnull, NSDictionary *_Nullable))successRequest
           failureRequest:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureRequest;

@end

NS_ASSUME_NONNULL_END
