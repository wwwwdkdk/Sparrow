//
//  DataCacheUtil.m
//  sparrow
//
//  Created by hwy on 2021/11/15.
//

#import "DataCacheUtil.h"

@implementation DataCacheUtil
+ (void)saveData:(NSDictionary *)dataDictionary pathName:(NSString *)pathName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSData *data = [NSJSONSerialization dataWithJSONObject:dataDictionary options:NSJSONWritingPrettyPrinted error:nil];
	NSString *path = paths[0];
	NSString *filePath = [path stringByAppendingPathComponent:pathName];
	[data writeToFile:filePath atomically:YES];
}

+ (NSMutableDictionary *)getDataFromFile:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = paths[0];
	NSString *filePath = [path stringByAppendingPathComponent:fileName];
	NSData *data = [NSData dataWithContentsOfFile:filePath];
	if (!data) {
		return nil;
	}
	NSMutableDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	return dataDictionary;
}


@end

