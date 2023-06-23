//
// Created by hwy on 2022/1/21.
//

#import "DynamicCache.h"
#import "UserModel.h"
#import "DynamicModel.h"
#import "DataCacheUtil.h"


@implementation DynamicCache

+ (NSArray<DynamicModel *> *)getDynamic {
    NSMutableArray *array = (NSMutableArray*)[DataCacheUtil getDataFromFile:Config.dynamicFileName][@"data"][@"dynamic"];;
	NSMutableArray<DynamicModel *> *mutableArray = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < array.count; i++) {
		mutableArray[i] = [[DynamicModel alloc] initWithDic:array[i]];
	}
	return mutableArray;
}

+ (void)saveDynamic:(NSDictionary *)dynamicDictionary {
	[DataCacheUtil saveData:dynamicDictionary pathName:Config.dynamicFileName];
}

@end
