//
//  BaseModel.m
//  sparrow
//
//  Created by hwy on 2021/11/17.
//

#import "BaseModel.h"


@implementation BaseModel

const static NSDictionary *httpRequestModel;    //网络请求地址字典
const static NSString     *httpBaseUrl;         //网络请求基地址

+ (void)initialize {
//    [self initData];
//    [self getUserInfo];
}

+ (NSString *)getHttpAddress:(NSString *)name {
    NSString *httpAddress = [NSString stringWithFormat:@"%@%@", APP_HTTP_BASE_ADDRESS, name];
    return httpAddress;
}


+ (NSString *)getUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return[defaults objectForKey:@"userId"];
}

@end
