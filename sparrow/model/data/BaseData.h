//
//  BaseData.h
//  sparrow
//  用于存放一些请求到的公共数据(单例类)
//  Created by hwy on 2021/12/30.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserHttpRequest.h"
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseData : NSObject

@property(nonatomic, strong) UserModel *userModel;                          //用户信息
@property(nonatomic, strong) NSMutableArray<MessageModel *> *messageArray;  //收到的新信息

+ (instancetype)sharedData;

- (void)getNewUserInfo;

@end

NS_ASSUME_NONNULL_END
