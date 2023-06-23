//
// Created by hwy on 2022/1/21.
//

#import "FriendCache.h"
#import "UserModel.h"
#import "DataCacheUtil.h"


@implementation FriendCache

static NSMutableArray<UserModel *> *model;

+ (NSArray<UserModel *> *)getContact {
    if(model != nil){
        return model;
    }
	NSMutableArray *array = [DataCacheUtil getDataFromFile:@"contact.json"][@"data"];
	model = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < array.count; i++) {
		model[i] = [[UserModel alloc] initWithDic:array[i]];
	}
	return model;
}

+ (void)saveContact:(NSDictionary *)friendDictionary {
	[DataCacheUtil saveData:friendDictionary pathName:@"contact.json"];
}

+ (bool)isFriend:(NSString*)userId{
    NSArray<UserModel *> *friendArray = [self getContact];
    for (NSUInteger i = 0; i < friendArray.count; i++) {
        if([userId isEqualToString:friendArray[i].userId]){
            return YES;
        }
    }
    return NO;
}

+ (UserModel* )getFriendModel:(NSString *)userId{
    NSArray<UserModel *> *friendArray = [self getContact];
    for (NSUInteger i = 0; i < friendArray.count; i++) {
        if([userId isEqualToString:friendArray[i].userId]){
            return friendArray[i];
        }
    }
    return  nil;
}

@end
