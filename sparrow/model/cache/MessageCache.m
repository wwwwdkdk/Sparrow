//
//  MessageCache.m
//  sparrow
//
//  Created by hwy on 2022/1/20.
//

#import "MessageCache.h"
#import "SqliteUtil.h"
#import "MessageModel.h"
#import "MessageListModel.h"
#import "FriendCache.h"
#import "BaseData.h"

@interface MessageCache ()

@end


@implementation MessageCache

static id _instance;
static dispatch_once_t onceToken;
sqlite3 *db;

+ (id)allocWithZone:(struct _NSZone *)zone {

	dispatch_once(&onceToken, ^{
		_instance = [super allocWithZone:zone];
	});
	return _instance;
}

+ (instancetype)sharedTcpTool {

	dispatch_once(&onceToken, ^{
		_instance = [[self alloc] init];
	});
	return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
	return _instance;
}


- (void)connectDataBase {
	NSString *sqliteName = @"sparrow.sqlite";
	NSArray *documentArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentPath = [documentArr firstObject];
	NSString *path = [NSString stringWithFormat:@"%@/%@", documentPath, sqliteName];
	NSLog(@"%@", path);
	int databaseResult = sqlite3_open([path UTF8String], &db);
	if (databaseResult == SQLITE_OK) {
		NSLog(@"成功打开数据库sparrow");
	} else {
		NSLog(@"创建／打开数据库失败,%d", databaseResult);
	}
}

- (void)createTable {
	NSString *sql = @"CREATE TABLE IF NOT EXISTS`message` ("
	                "  `id` INTEGER  PRIMARY KEY AUTOINCREMENT,"
	                "  `content` text NOT NULL,"
	                "  `type` int DEFAULT NULL,"
	                "  `time` varchar DEFAULT NULL,"
	                "  `sendId` int NOT NULL,"
	                "  `receivedId` int NOT NULL,"
	                "  `state` int DEFAULT '1')";
	SqliteUtil *sqliteUtil = [[SqliteUtil alloc] init];
	[sqliteUtil createTable:sql];
}

- (void)insertMessage:(MessageModel *)model {
	NSDate *date = [NSDate date];// 获得时间对象
	NSDateFormatter *forMatter = [[NSDateFormatter alloc] init];
	NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得当前系统的时区
	[forMatter setTimeZone:zone];// 设定时区
	[forMatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateStr = [forMatter stringFromDate:date];
	if (model.time == nil) {
		[model setTime:dateStr];
	}
	NSLog(@"model.state=======%@",model.state);

	NSString *state = 	[[NSString stringWithFormat:@"%@", model.state] isEqualToString:@"1"] ? @"2" : @"1";
	NSString *sql = [NSString stringWithFormat:@"insert into message (content,type,time,sendId,receivedId,state)values('%@',%@,'%@',%@,%@,%@)",
	                                           model.content, model.type, model.time, model.sendId, model.receivedId,state];
	SqliteUtil *sqliteUtil = [[SqliteUtil alloc] init];
	[sqliteUtil insertData:sql];
	[self getMessageList];
}

- (NSMutableArray<MessageModel *> *)getMessage:(NSString *)userId
                                      FriendId:(NSString *)friendId {
	NSMutableArray *messageArray = [[NSMutableArray alloc] init];
	NSString *sql = [NSString stringWithFormat:@"select * from `message` where (`state` = 1 and `sendId` = %@ "
	                                           "and `receivedId` = %@) or "
											   " (`state` = 1 and `receivedId` = %@ "
											   "and `sendId` = %@)"
											   " order by `id` ", userId, friendId,userId,friendId];
	SqliteUtil *sqliteUtil = [[SqliteUtil alloc] init];
	sqlite3_stmt *stmt = [sqliteUtil selectData:sql];
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		int id = sqlite3_column_int(stmt, 0);
		const unsigned char *content = sqlite3_column_text(stmt, 1);
		int type = sqlite3_column_int(stmt, 2);
		const unsigned char *time = sqlite3_column_text(stmt, 3);
		int sendId = sqlite3_column_int(stmt, 4);
		int receivedId = sqlite3_column_int(stmt, 5);

		MessageModel *model = [[MessageModel alloc] init];
		[model setMessageId:[NSString stringWithFormat:@"%d", id]];
		[model setContent:[NSString stringWithUTF8String:(const char *) content]];
		[model setType:@(type)];
		[model setTime:[NSString stringWithFormat:@"%s", time]];
		[model setSendId:[NSString stringWithFormat:@"%d", sendId]];
		[model setReceivedId:[NSString stringWithFormat:@"%d", receivedId]];
		[messageArray addObject:model];
	}
	return messageArray;
}

- (NSMutableArray<MessageListModel *> *)getMessageList {
	NSMutableArray<MessageListModel *> *messageArray = [[NSMutableArray alloc] init];
	NSArray<UserModel *> *array = [FriendCache getContact];
	NSLog(@"%@", [BaseData sharedData].userModel.userId);
	for (NSUInteger i = 0; i < array.count; i++) {
		NSString *sql = [NSString stringWithFormat:@"select id,content,time,type from `message` where (`state` <> 0 and `sendId` = %@ "
		                                           "and `receivedId` = %@)or(`state` <> 0 and `sendId` = %@ "
		                                           "and `receivedId` = %@) order by `id` desc limit 1",
		                                           [BaseData sharedData].userModel.userId, array[i].userId,
		                                           array[i].userId, [BaseData sharedData].userModel.userId];

		SqliteUtil *sqliteUtil = [[SqliteUtil alloc] init];
		sqlite3_stmt *stmt = [sqliteUtil selectData:sql];
		while (sqlite3_step(stmt) == SQLITE_ROW) {
			int id = sqlite3_column_int(stmt, 0);
			const unsigned char *content = sqlite3_column_text(stmt, 1);
			const unsigned char *time = sqlite3_column_text(stmt, 2);
			int type = sqlite3_column_int(stmt, 3);

			printf("%d %s %d,%s\n", id, content, type, time);
			MessageListModel *model = [[MessageListModel alloc] init];
			[model setMessageListId:[NSString stringWithFormat:@"%d", id]];
			[model setMessage:[NSString stringWithUTF8String:(const char *) content]];
			[model setType:@(type)];
			[model setTime:[NSString stringWithFormat:@"%s", time]];
			[model setUserModel:array[i]];
			[model setUnReadCount: [NSString stringWithFormat:@"%d", [self getUnReadCount:array[i].userId]]];
            if([model.type  isEqual: @1]){
				[model setMessage:@"[图片]"];
			}
			[messageArray addObject:model];
		}
	}
	return messageArray;
}

- (int)getUnReadCount:(NSString *)sendId{
	NSString *sql = [NSString stringWithFormat:@"select count(*) from `message` where `state` = 2 and `sendId` = %@ and `receivedId` = %@",
	                          sendId, [BaseData sharedData].userModel.userId];
	SqliteUtil *sqliteUtil = [[SqliteUtil alloc] init];
	sqlite3_stmt *stmt = [sqliteUtil selectData:sql];
	while (sqlite3_step(stmt) == SQLITE_ROW) {
		return sqlite3_column_int(stmt, 0);
	}
	return 0;
}



- (void)setMessageStateRead:(NSString *)sendId{
	NSString *sql = [NSString stringWithFormat:@"update `message` set `state` = 1 where `state` = 2 and `sendId` = %@ and `receivedId` = %@",sendId, [BaseData sharedData].userModel.userId];
	SqliteUtil *sqliteUtil = [[SqliteUtil alloc] init];
	[sqliteUtil updateData:sql];
}

@end
