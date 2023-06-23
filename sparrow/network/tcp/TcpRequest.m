//
//  TcpRequest.m
//  sparrow
//
//  Created by hwy on 2021/12/28.
//
#import <AudioToolbox/AudioToolbox.h>
#import "TcpRequest.h"
#import "MessageCache.h"
#import "NotificationTool.h"
#import "MessageListViewController.h"
#import "ChatViewController.h"
#include "HttpAddressModel.h"
@interface TcpRequest ()

@property(nonatomic, strong) GCDAsyncSocket *clientSocket;
@property(nonatomic, strong) NSTimer *heartTimer;
@property(nonatomic, strong) NSMutableData *dataBuffer;
@property(nonatomic, assign) BOOL isConnected;
@property(nonatomic, strong) dispatch_queue_t socketQueue;

+ (instancetype)sharedTcpTool;

@end


@implementation TcpRequest

static id _instance;
static dispatch_once_t onceToken;

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

- (BOOL)connectToHost:(NSString *)host onPort:(uint16_t)port {
	NSError *error = nil;
	[self.clientSocket connectToHost:host onPort:port error:&error];
	return !error;
}

- (void)sendData:(NSData *)contentData {
	int length = (int) contentData.length;
	NSData *lengthData = [self switchEndianness:length];
	NSMutableData *data = [NSMutableData dataWithData:lengthData];
	[data appendData:contentData];
	[self.clientSocket writeData:data withTimeout:-1 tag:0];
}

- (void)sendDictionaryData:(NSMutableDictionary *)data {
	NSMutableDictionary *aData = [data mutableCopy];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	aData[Config.token] = [defaults objectForKey:@"token"];
	aData[Config.userId] = [defaults objectForKey:@"userId"];
	NSData *contentData = [NSJSONSerialization dataWithJSONObject:aData options:NSJSONWritingPrettyPrinted error:nil];
	NSUInteger length = (int) contentData.length;
	NSData *lengthData = [self switchEndianness:length];
	NSMutableData *sendData = [NSMutableData dataWithData:lengthData];
	[sendData appendData:contentData];
	[self.clientSocket writeData:sendData withTimeout:-1 tag:0];
}

- (void)disconnect {
	if (self.isConnected) {
		self.isConnected = NO;
		[self.clientSocket disconnect];
	}
}

//大小端字节序转换
- (NSData *)switchEndianness:(NSUInteger)lengthData {
    Byte b1 = (Byte) (lengthData & 0xff);
    Byte b2 = (Byte) ((lengthData >> 8) & 0xff);
    Byte b3 = (Byte) ((lengthData >> 16) & 0xff);
    Byte b4 = (Byte) ((lengthData >> 24) & 0xff);
    Byte byte[] = {b4, b3, b2, b1};
    NSData *data = [NSData dataWithBytes:byte length:sizeof(byte)];
    return data;
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	self.isConnected = YES;
	//向服务端注册tcp连接
	[self sendDictionaryData:[[NSMutableDictionary alloc] initWithDictionary:@{@"type": @"0",}]];
	NSLog(@"tcp连接成功");
	[sock readDataWithTimeout:-1 tag:0];
//	if (self.needHeart) {
	//开始发送心跳
//		[self startHeartTimer];
//	}
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSLog(@"收到数据:%@", data);
	[self.dataBuffer appendData:data];
	while (self.dataBuffer.length >= 4) {
		NSUInteger dataLength = 0;
		//获取数据长度
		[[self.dataBuffer subdataWithRange:(NSMakeRange(0, 4))] getBytes:&dataLength length:sizeof(dataLength)];
		NSData *lengthData = [self switchEndianness:dataLength];
		int i = *(int *) ([lengthData bytes]);

		if (self.dataBuffer.length >= (i + 4)) {
			NSData *realData = [self.dataBuffer subdataWithRange:NSMakeRange(4, i)];
			NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:realData options:NSJSONReadingMutableLeaves error:nil];
			if ([dic[@"type"] isEqual:@0] || [dic[@"type"] isEqual:@1]) {
				MessageModel *messageModel = [[MessageModel alloc] initWithDic:dic];
				[self saveNewMessage:messageModel]; //将收到的消息数据保存到数据库中
				[[self mutableArrayValueForKey:@"messageArray"] addObject:messageModel];
				NSLog(@"%@", self.messageArray);
			}
			self.dataBuffer = [[self.dataBuffer subdataWithRange:NSMakeRange(4 + i, self.dataBuffer.length - 4 - i)] mutableCopy];

		} else {
			break;
		}
	}
	[sock readDataWithTimeout:-1 tag:0];
}

- (void)saveNewMessage:(MessageModel *)model {
	MessageCache *messageCache = [[MessageCache alloc] init];
	[model setState:@"1"];
	[messageCache insertMessage:model];
    [NSNotificationCenter.defaultCenter postNotification: [NSNotification notificationWithName:NotiName.newMessage object:nil]];

	if ([[TcpRequest getCurrentVC] isKindOfClass:[MessageListViewController class]]) {
		MessageListViewController *messageListViewController = (MessageListViewController *) [TcpRequest getCurrentVC];
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
		dispatch_async(dispatch_get_main_queue(), ^{
			[messageListViewController getMessageList];
		});
	} else if (![[TcpRequest getCurrentVC] isKindOfClass:[ChatViewController class]]) {
		[NotificationTool openLocalNotificationAlert:model];
	}
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
	if (self.isConnected != NO) {
		NSLog(@"服务器断开连接");
		[self connectToHost:APP_TCP_BASE_ADDRESS onPort:APP_TCP_BASE_PORT];
	}
}

- (void)sendTextMessage:(NSString *)content
             receivedId:(NSString *)receivedId
                   type:(NSString *)type {
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:@{
		@"type": @"1",
		@"data": @{
			@"content": content,
			@"receivedId": receivedId,
			@"type": @"0"
		}
	}];
	[self sendDictionaryData:dictionary];
}

- (void)sendImageMessage:(UIImage *)image
              receivedId:(NSString *)receivedId {
    if (image == nil) {return;}
	NSData *data = UIImageJPEGRepresentation(image, 1);
	NSString *imageData = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];

	[self sendDictionaryData:[[NSMutableDictionary alloc] initWithDictionary:
		@{
			@"type": @"1",
			@"data": @{
                @"content": imageData,
                @"type": @"1",
                @"receivedId": receivedId,
                @"suffix": @"png"
		}
		}
	]];
}


- (GCDAsyncSocket *)clientSocket {
	if (!_clientSocket) {
		_clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
	}
	return _clientSocket;
}

- (dispatch_queue_t)socketQueue {
	if (!_socketQueue) {
		_socketQueue = dispatch_queue_create("socketQueue", DISPATCH_QUEUE_SERIAL);
	}
	return _socketQueue;
}

- (NSMutableData *)dataBuffer {
	if (!_dataBuffer) {
		_dataBuffer = [NSMutableData data];
	}
	return _dataBuffer;
}

- (NSMutableArray<MessageModel *> *)messageArray {
	if (!_messageArray) {
		_messageArray = [NSMutableArray array];
	}
	return _messageArray;
}

//获取当前屏幕显示的viewController
+ (UIViewController *)getCurrentVC {
	UIViewController *result = nil;

	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	if (window.windowLevel != UIWindowLevelNormal) {
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for (UIWindow *tmpWin in windows) {
			if (tmpWin.windowLevel == UIWindowLevelNormal) {
				window = tmpWin;
				break;
			}
		}
	}

	UIView *frontView = [window subviews][0];
	id nextResponder = [frontView nextResponder];

	if ([nextResponder isKindOfClass:[UIViewController class]]) {
		result = nextResponder;
	} else {
		result = window.rootViewController;
	}


	if ([result isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tabbar = (UITabBarController *) result;
		UINavigationController *nav = tabbar.viewControllers[tabbar.selectedIndex];
		//或者 UINavigationController * nav = tabbar.selectedViewController;
		result = nav.childViewControllers.lastObject;
	} else if ([result isKindOfClass:[UINavigationController class]]) {
		//2、navigationController
		UIViewController *nav = result;
		result = nav.childViewControllers.lastObject;
	}

	return result;
}


+ (UIViewController *)getCurrentViewController {
	UIViewController *result = nil;
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	//app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
	if (window.windowLevel != UIWindowLevelNormal) {
		NSArray *windows = [[UIApplication sharedApplication] windows];
		for (UIWindow *tmpWin in windows) {
			if (tmpWin.windowLevel == UIWindowLevelNormal) {
				window = tmpWin;
				break;
			}
		}
	}
	id nextResponder = nil;
	UIViewController *appRootVC = window.rootViewController;
	//1、通过present弹出VC，appRootVC.presentedViewController不为nil
	if (appRootVC.presentedViewController) {
		nextResponder = appRootVC.presentedViewController;
	} else {
		//2、通过navigationController弹出VC
		NSLog(@"subviews == %@", [window subviews]);
		UIView *frontView = [window subviews][0];
		nextResponder = [frontView nextResponder];
	}
	//1、tabBarController
	if ([nextResponder isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tabbar = (UITabBarController *) nextResponder;
		UINavigationController *nav = tabbar.viewControllers[tabbar.selectedIndex];
		//或者 UINavigationController * nav = tabbar.selectedViewController;
		result = nav.childViewControllers.lastObject;
	} else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
		//2、navigationController
		UIViewController *nav = nextResponder;
		result = nav.childViewControllers.lastObject;
	} else {//3、viewControler
		result = nextResponder;
	}
	return result;
}
@end


