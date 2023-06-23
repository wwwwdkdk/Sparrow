//
//  PictureModel.h
//  sparrow
//  图片
//  Created by hwy on 2021/12/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PictureModel : NSObject

@property(nonatomic,copy)    NSString    *pictureId;    //图片id
@property(nonatomic,copy)    NSString    *picture;      //图片地址
@property(nonatomic,assign)  NSNumber    *width;        //图片宽度
@property(nonatomic,assign)  NSNumber    *height;       //图片高度

- (instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
