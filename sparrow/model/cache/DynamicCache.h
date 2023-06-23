//
// Created by hwy on 2022/1/21.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class DynamicModel;


@interface DynamicCache : NSObject

+ (NSArray <DynamicModel *> *)getDynamic;

+ (void)saveDynamic:(NSDictionary *)dynamicDictionary;

@end
