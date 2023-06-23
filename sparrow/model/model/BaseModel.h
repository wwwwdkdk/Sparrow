//
//  BaseModel.h
//  sparrow
//
//  Created by hwy on 2021/11/17.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "HttpAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

/**
 * 获取请求地址
 * @param name 地址表key值
 * @return 地址
 */
+ (NSString *)getHttpAddress:(NSString *)name;

//获取用户id
+ (NSString *)getUserId;


@end

NS_ASSUME_NONNULL_END
