//
//  PictureModel.m
//  sparrow
//
//  Created by hwy on 2021/12/23.
//

#import "PictureModel.h"

@implementation PictureModel

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    self = [super init];
    if(self){
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.pictureId = value;
        }
}
@end
