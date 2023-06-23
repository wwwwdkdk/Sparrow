//
//  FriendRequestModel.h
//  sparrow
//
//  Created by hwy on 2021/12/22.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendRequestModel : NSObject

@property (nonatomic,copy)   NSString  *requestId;
@property (nonatomic,copy)   NSString  *sendId;
@property (nonatomic,copy)   NSString  *receivedId;
@property (nonatomic,copy)   NSString  *state;
@property (nonatomic,strong) UserModel *userModel;

- (instancetype)initWithDic:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
