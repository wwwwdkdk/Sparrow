//
//  DynamicHttpRequest.m
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import "DynamicHttpRequest.h"
#import "BaseModel.h"
#import "HttpAddressModel.h"
#import "HttpRequestUtil.h"

@implementation DynamicHttpRequest

+ (void)getDynamic:(NSInteger)page
      successBlock:(void(^)(NSDictionary *data)) successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress: APP_HTTP_DYNAMIC] parameters:@{ @"userId":[defaults objectForKey:@"userId"],@"page":[NSNumber numberWithInteger:page]} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)getFriendDynamic:(NSInteger)page
      successBlock:(void(^)(NSDictionary *data)) successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress: APP_HTTP_FRIEND_DYNAMIC] parameters:@{ @"userId":[defaults objectForKey:@"userId"],@"page":[NSNumber numberWithInteger:page]} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)getDynamic:(NSInteger)page
            userId:(NSString *)userId
      successBlock:(void(^)(NSDictionary *data)) successBlock
         failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_DYNAMIC] parameters:@{ @"userId":userId,@"page":[NSNumber numberWithInteger:page]} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)getAgreeDynamic:(NSInteger)page
           successBlock:(void(^)(NSDictionary *data)) successBlock
              failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress: APP_HTTP_MY_AGREE] parameters:@{ @"page":[NSNumber numberWithInteger:page]} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)getCollectionDynamic:(NSInteger)page
                successBlock:(void(^)(NSDictionary *data))successBlock
                   failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_MY_COLLECTION] parameters:@{ @"page":[NSNumber numberWithInteger:page]} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)agreeDynamic:(NSString *)dynamicId
        successBlock:(void(^)(NSDictionary *data))successBlock
           failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress: APP_HTTP_AGREE] parameters:@{ @"dynamicId":dynamicId} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)collectionDynamic:(NSString *)dynamicId
             successBlock:(void(^)(NSDictionary *data))successBlock
                failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress: APP_HTTP_COLLECTION] parameters:@{ @"dynamicId":dynamicId} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)deleteDynamic:(NSString *)dynamicId
         successBlock:(void(^)(NSDictionary *data))successBlock
            failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
    [HttpRequestUtil getWithURLString:[BaseModel getHttpAddress:APP_HTTP_DELETE_DYNAMIC] parameters:@{ @"dynamicId":dynamicId} headers:nil successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
        successBlock(data);
    } failureRequest:failureBlock];
}

+ (void)postDynamic:(NSString *)content
       pictureArray:(NSArray<UIImage*> *)pictureArray
       successBlock:(void(^)(NSDictionary *data))successBlock
          failBlock:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureBlock{
	NSMutableArray *dataArray = [[NSMutableArray alloc] init];
	for(NSUInteger i = 0 ; i < pictureArray.count ; i++){
		dataArray[i] = UIImageJPEGRepresentation(pictureArray[i], 0.5);
	}
    [HttpRequestUtil postWithURLString:[BaseModel getHttpAddress: APP_HTTP_POST] parameters:@{@"content":content} headers:nil image:dataArray successRequest:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable data) {
		successBlock(data);
	} failureRequest:failureBlock];
}

@end
