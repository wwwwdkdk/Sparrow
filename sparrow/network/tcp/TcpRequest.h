//
//  TcpRequest.h
//  sparrow
//  tcp连接(单例类)
//  Created by hwy on 2021/12/28.
//

#import <Foundation/Foundation.h>
#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TcpRequest : NSObject <GCDAsyncSocketDelegate>

@property(nonatomic,strong)NSMutableArray<MessageModel*> *messageArray;

//tcp连接
- (BOOL)connectToHost:(NSString *)host
               onPort:(uint16_t)port;

//发送NSData类型的数据
- (void)sendData:(NSData *)contentData;

//发送字典类型的数据
- (void)sendDictionaryData:(NSMutableDictionary *)data;

//发送文本类型的数据
- (void)sendTextMessage:(NSString*)content
            receivedId:(NSString*)receivedId
              type:(NSString*)type;

//发送图片类型的数据
- (void)sendImageMessage:(UIImage*)image
             receivedId:(NSString*)receivedId;

+ (UIViewController *)getCurrentVC ;

@end

NS_ASSUME_NONNULL_END
