//
//  MessageModel.m
//  sparrow
//
//  Created by hwy on 2021/12/28.
//

#import "MessageModel.h"

@implementation MessageModel


- (instancetype)initWithDic:(NSDictionary *)dic {

	self = [super init];
	if (self) {
		[self setValuesForKeysWithDictionary:dic];
	}
	return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
	if ([key isEqualToString:@"id"]) {
		self.messageId = value;
	}
}

@end
