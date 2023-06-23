//
// Created by hwy on 2022/1/20.
//

#import "SqliteUtil.h"


@implementation SqliteUtil

static id _instance;
static dispatch_once_t onceToken;
static sqlite3 *db;

+ (id)allocWithZone:(struct _NSZone *)zone {

    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [self connectDataBase];
    });
    return _instance;
}

+ (instancetype)sharedTcpTool {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [self connectDataBase];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

+ (void)connectDataBase {
    NSString *sqliteName = @"sparrow.sqlite";
    NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentArr firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@", documentPath, sqliteName];
    NSLog(@"数据库路径：%@", path);
    int databaseResult = sqlite3_open([path UTF8String], &db);
    if (databaseResult == SQLITE_OK) {
        NSLog(@"成功打开数据库");
    } else {
        NSLog(@"创建／打开数据库失败,%d", databaseResult);
    }
}

- (void)createTable:(NSString *)sql {
    char *errMsg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errMsg);
    if (result == SQLITE_OK) {
        NSLog(@"创建Message表成功");
    } else {
        printf("创建Message表失败---%s----%s---%d", errMsg, __FILE__, __LINE__);
    }
}

// 插入数据
- (void)insertData:(NSString *)sql {
    char *errMsg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errMsg);
    if (result == SQLITE_OK) {
        NSLog(@"插入数据成功 - %@", sql);
    } else {
        NSLog(@"插入数据失败 - %s", errMsg);
    }
}

- (void)updateData:(NSString *)sql {
    char *errMsg = NULL;
    int result = sqlite3_exec(db, sql.UTF8String, NULL, NULL, &errMsg);
    if (result == SQLITE_OK) {
        NSLog(@"修改数据成功 - %@", sql);
    } else {
        NSLog(@"修改数据失败 - %s", errMsg);
    }
}

// 查询操作
- (sqlite3_stmt *)selectData:(NSString *)sql {
    sqlite3_stmt *stmt = NULL;

    // 进行查询前的准备工作
    if (sqlite3_prepare_v2(db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {   
        NSLog(@"查询数据成功 - %@", sql);
    } else {
        NSLog(@"查询语句有问题");
    }
    return stmt;
}


@end
