//
//  HttpRequestUtil.m
//  sparrow
//
//  Created by hwy on 2021/11/15.
//

#import "HttpRequestUtil.h"

@implementation HttpRequestUtil

//向请求头中添加个人信息
+ (NSDictionary *)setRequestHeader:(nullable NSDictionary <NSString *, NSString *> *)headers {
	NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithDictionary:headers];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	header[@"token"] = [defaults objectForKey:@"token"];
	header[@"userId"] = [defaults objectForKey:@"userId"];

	return header;
}

+ (void)getWithURLString:(NSString *)urlString
              parameters:(nullable id)parameters
                 headers:(nullable NSDictionary <NSString *, NSString *> *)headers
          successRequest:(nullable void (^)(NSURLSessionDataTask *_Nonnull, NSDictionary *_Nullable))successRequest
          failureRequest:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureRequest {

	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	manager.operationQueue.maxConcurrentOperationCount = 10;
	manager.requestSerializer.timeoutInterval = 30;

	__weak typeof(manager) weakManager = manager;
	[manager GET:urlString parameters:parameters headers:[self setRequestHeader:headers] progress:nil success:^(NSURLSessionDataTask *task, id data) {
		if (successRequest) {
			NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
			successRequest(task, dic);
			[weakManager invalidateSessionCancelingTasks:YES resetSession:YES];
		}
	}    failure:^(NSURLSessionDataTask *task, NSError *error) {
		if (failureRequest) {
			failureRequest(task, error);
            NSLog(@"网络异常，错误码：%ld ，地址：%@", (long)error.code,urlString);
			[weakManager invalidateSessionCancelingTasks:YES resetSession:YES];
		}
	}];
}

+ (void)postWithURLString:(NSString *)urlString
               parameters:(nullable id)parameters
                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
                    image:(NSArray *)imageArray
           successRequest:(nullable void (^)(NSURLSessionDataTask *_Nonnull, NSDictionary *_Nullable))successRequest
           failureRequest:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureRequest {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	manager.operationQueue.maxConcurrentOperationCount = 10;
	manager.requestSerializer.timeoutInterval = 30;

	__weak typeof(manager) weakManager = manager;
	[manager POST:urlString parameters:parameters headers:[self setRequestHeader:headers] constructingBodyWithBlock:^(id <AFMultipartFormData> _Nonnull formData) {
		for (int i = 0; i < imageArray.count; i++) {
			[formData appendPartWithFileData:imageArray[i] name:@"imageFile" fileName:[NSString stringWithFormat:@"%d.jpg", i] mimeType:@"image/jpeg"];
		}
	}    progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable data) {
		NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
		successRequest(task, dic);
		[weakManager invalidateSessionCancelingTasks:YES resetSession:YES];
	}     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        failureRequest(task, error);
        NSLog(@"网络异常，错误码：%ld ，地址：%@", (long)error.code,urlString);
        [weakManager invalidateSessionCancelingTasks:YES resetSession:YES];
	}];
}

+ (void)postWithURLString:(NSString *)urlString
               parameters:(nullable id)parameters
                  headers:(nullable NSDictionary <NSString *, NSString *> *)headers
           successRequest:(nullable void (^)(NSURLSessionDataTask *_Nonnull, NSDictionary *_Nullable))successRequest
           failureRequest:(nullable void (^)(NSURLSessionDataTask *_Nullable task, NSError *error))failureRequest {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	manager.operationQueue.maxConcurrentOperationCount = 10;
	manager.requestSerializer.timeoutInterval = 30;

	__weak typeof(manager) weakManager = manager;
	[manager POST:urlString parameters:parameters headers:[self setRequestHeader:headers] progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable data) {
		if (successRequest) {
			NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
			successRequest(task, dic);
			[weakManager invalidateSessionCancelingTasks:YES resetSession:YES];
		}
	}     failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
		failureRequest(task, error);
        NSLog(@"网络异常，错误码：%ld ，地址：%@", (long)error.code,urlString);
        [weakManager invalidateSessionCancelingTasks:YES resetSession:YES];
	}];
}

@end
