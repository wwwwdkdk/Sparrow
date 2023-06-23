//
//  DataCacheUtil.h
//  sparrow
//
//  Created by hwy on 2021/11/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataCacheUtil : NSObject

+ (void)saveData:(NSDictionary *)dataDictionary pathName:(NSString *)pathName;

+ (NSMutableDictionary *)getDataFromFile:(NSString *)fileName;
@end

NS_ASSUME_NONNULL_END
