//
//  UserModel.m
//  sparrow
//
//  Created by hwy on 2021/12/20.
//

#import "UserModel.h"

@implementation UserModel


- (instancetype)initWithDic:(NSDictionary *)dic {

	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dic];
	}
	return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	if ([key isEqualToString:@"id"]) {
		self.userId = [NSString stringWithFormat:@"%@", value];
	}
}

@end
