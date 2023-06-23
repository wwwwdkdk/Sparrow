//
//  FriendRequestModel.m
//  sparrow
//
//  Created by hwy on 2021/12/22.
//

#import "FriendRequestModel.h"

@implementation FriendRequestModel

- (instancetype)initWithDic:(NSDictionary *)dictionary{
    
    self = [super init];
    if(self){
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.requestId = value;
    }else if ([key isEqualToString:@"user"]){
        self.userModel = [[UserModel alloc]initWithDic:value];
    }else{
        [super setValue:value forKey:key];
    }
}


@end
