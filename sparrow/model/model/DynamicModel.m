//
//  DynamicModel.m
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import "DynamicModel.h"

@implementation DynamicModel
- (instancetype)initWithDic:(NSDictionary *)dictionary {

	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dictionary];
	}
	return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
	if ([key isEqualToString:@"id"]) {
		self.dynamicId = value;
	} else if ([key isEqualToString:@"user"]) {
		self.userModel = [[UserModel alloc] initWithDic:value];
	} else if ([key isEqualToString:@"picture"]) {
		self.picture = [[NSMutableArray alloc] init];
		NSArray *array = value;
		for (int i = 0; i < array.count; i++) {
			self.picture[i] = [[PictureModel alloc] initWithDic:array[i]];
		}

	} else {
		[super setValue:value forKey:key];
	}
}

@end
