//
//  UserModel.h
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject

@property(nonatomic,copy) NSString *userId;        
@property(nonatomic,copy) NSString *gender;
@property(nonatomic,copy) NSString *age;
@property(nonatomic,copy) NSString *nickname;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *headPortrait;
@property(nonatomic,copy) NSString *background;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
