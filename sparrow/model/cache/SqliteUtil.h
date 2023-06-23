//
// Created by hwy on 2022/1/20.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteUtil : NSObject

+ (void)connectDataBase;

- (void)createTable:(NSString *)sql;

- (void)insertData:(NSString *)sql;

- (void)updateData:(NSString *)sql;

- (sqlite3_stmt *)selectData:(NSString *)sql;

@end