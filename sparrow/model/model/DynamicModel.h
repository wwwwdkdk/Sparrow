//
//  DynamicModel.h
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "PictureModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DynamicModel : NSObject

@property(nonatomic,copy)  NSString    *dynamicId;
@property(nonatomic,copy)  NSString    *userId;
@property(nonatomic,copy)  NSString    *time;
@property(nonatomic,copy)  NSString    *agreeCount;
@property(nonatomic,copy)  NSString    *collectionCount;
@property(nonatomic,copy)  NSString    *content;
@property(nonatomic,strong)NSMutableArray<PictureModel*>  *picture;
@property(nonatomic,strong)UserModel   *userModel;
@property(nonatomic,assign)bool         agree;
@property(nonatomic,assign)bool         collection;

- (instancetype)initWithDic:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
