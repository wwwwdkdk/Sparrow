//
//  UserCache.m
//  sparrow
//
//  Created by hwy on 2022/2/9.
//

#import "UserCache.h"
#import "UserModel.h"
#import "DataCacheUtil.h"

@implementation UserCache

+ (UserModel *)getUserInfoModel {
    UserModel *model = [[UserModel alloc]initWithDic:[DataCacheUtil getDataFromFile:Config.userFileName]];
    return model;
}

+ (NSDictionary *)getUserInfoDictionary{
    return [DataCacheUtil getDataFromFile:Config.userFileName];
}

+ (void)saveUserInfo:(NSDictionary *)userDictionary; {
    [DataCacheUtil saveData:userDictionary pathName:Config.userFileName];
}

@end
