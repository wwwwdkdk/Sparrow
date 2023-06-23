//
//  UserCache.h
//  sparrow
//
//  Created by hwy on 2022/2/9.
//

#import <Foundation/Foundation.h>

@class UserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UserCache : NSObject

+ (UserModel *)getUserInfoModel;

+ (NSDictionary *)getUserInfoDictionary;

+ (void)saveUserInfo:(NSDictionary *)userDictionary;

@end

NS_ASSUME_NONNULL_END
