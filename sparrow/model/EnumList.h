//
//  EnumList.h
//  sparrow
//  定义了一些公共枚举
//  Created by hwy on 2021/12/29.
//

#ifndef EnumList_h
#define EnumList_h

typedef NS_ENUM(NSInteger, TcpSendType) {
    sendRegister = 0,     //注册
    sendText = 1 << 0,   //图片消息
    sendImage = 1 << 1    //视频消息
};

typedef NS_ENUM(NSInteger, TcpReceiveType) {
    sendRegister1 = 0,     //注册
    sendText1 = 1 << 0,   //图片消息
    sendImage1 = 1 << 1    //视频消息
};

typedef NS_ENUM(NSInteger, MessageType) {
    messageText = 0,         //文本消息
    messageImage = 1 ,       //图片消息
    messageVideo = 2         //视频消息
};

//typedef NS_ENUM(NSInteger, RequestState) {
//    refuse = 0,         //文本消息
//    messageImage = 1 << 0,   //图片消息
//    messageVideo = 1 << 1    //视频消息
//};

typedef NS_ENUM(NSInteger, FriendRequestType) {
    isFriend = 1,
    isNotFriend = 2,
    refuse = 3,
    isWait = 4,
    isRefused = 5,
    waitDeal = 6
};


#endif /* EnumList_h */
