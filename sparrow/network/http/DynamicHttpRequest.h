//
//  DynamicHttpRequest.h
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DynamicHttpRequest : NSObject

//获取一页当前用户的动态
+ (void)getDynamic:(NSInteger)page
      successBlock:(void (^)(NSDictionary *data))successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取一页好友动态
+ (void)getFriendDynamic:(NSInteger)page
            successBlock:(void (^)(NSDictionary *data))successBlock
               failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取一页当前用户点赞的动态
+ (void)getAgreeDynamic:(NSInteger)page
           successBlock:(void (^)(NSDictionary *data))successBlock
              failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取一页当前用户收藏的动态
+ (void)getCollectionDynamic:(NSInteger)page
                successBlock:(void (^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//获取一页指定用户的动态
+ (void)getDynamic:(NSInteger)page
            userId:(NSString *)userId
      successBlock:(void (^)(NSDictionary *data))successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//点赞或取消点赞动态
+ (void)agreeDynamic:(NSString *)dynamicId
        successBlock:(void (^)(NSDictionary *data))successBlock
           failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//收藏或取消收藏动态
+ (void)collectionDynamic:(NSString *)dynamicId
             successBlock:(void (^)(NSDictionary *data))successBlock
                failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//删除动态
+ (void)deleteDynamic:(NSString *)dynamicId
         successBlock:(void (^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;

//发表动态
+ (void)postDynamic:(NSString *)content
       pictureArray:(NSArray<UIImage *> *)pictureArray
       successBlock:(void (^)(NSDictionary *data))successBlock
          failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock;
@end

NS_ASSUME_NONNULL_END
