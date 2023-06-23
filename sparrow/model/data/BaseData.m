//
//  BaseData.m
//  sparrow
//
//  Created by hwy on 2021/12/30.
//

#import "BaseData.h"

@interface BaseData()


@end

@implementation BaseData

static id _instance;
static dispatch_once_t onceToken;

+ (id)allocWithZone:(struct _NSZone *)zone {
   
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedData {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)getNewUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.userModel = [[UserModel alloc]init];
    NSString *userId = [defaults objectForKey:@"userId"];
    self.userModel.userId = userId;
    self.userModel.nickname = [defaults objectForKey:@"nickname"];
    self.userModel.headPortrait = [defaults objectForKey:@"headPortrait"];
    self.userModel.gender  = [defaults objectForKey:@"gender"];
    self.userModel.background = [defaults objectForKey:@"background"];
    self.userModel.city = [defaults objectForKey:@"city"];

    [UserHttpRequest getUserInfo:^(NSDictionary * _Nonnull data) {
        self.userModel = [[UserModel alloc]initWithDic:data];
        //缓存用户信息
        [defaults setObject:self.userModel.city forKey:@"city"];
        [defaults setObject:self.userModel.nickname forKey:@"nickname"];
        [defaults setObject:self.userModel.headPortrait forKey:@"headPortrait"];
        [defaults setObject:self.userModel.headPortrait forKey:@"background"];
        [defaults setObject:self.userModel.gender forKey:@"gender"];
    } failBlock:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

@end
