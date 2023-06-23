//
//  HttpAddressModel.h
//  sparrow
//
//  Created by hwy on 2021/12/29.
//

#ifndef     HttpAddressModel_h
#define     HttpAddressModel_h

#define     APP_HTTP_BASE_ADDRESS              @"http://192.168.31.248:8088"//网络基地址
#define     APP_TCP_BASE_ADDRESS               @"192.168.31.248"            //Tcp基地址
#define     APP_TCP_BASE_PORT                  5858                         //Tcp端口

#define     APP_HTTP_LOGIN                     @"/user/login"               //登录
#define     APP_HTTP_REGISTER                  @"/user/register"            //注册
#define     APP_HTTP_USER_INFO                 @"/user/info"                //获取用户信息
#define     APP_HTTP_HEAD_PORTRAIT             @"/user/headPortrait"        //改变用户头像
#define     APP_HTTP_BACKGROUND                @"/user/background"          //改变用户背景
#define     APP_HTTP_SEARCH                    @"/user/search"              //搜索用户
#define     APP_HTTP_FRIEND                    @"/friend"                   //获取好友列表
#define     APP_HTTP_SEND_REQUEST              @"/friend/send"              //获取用户发送的好友请求
#define     APP_HTTP_RECEIVE_REQUEST           @"/friend/receive"           //获取用户收到的好友请求
#define     APP_HTTP_REFUSE_REQUEST            @"/friend/refuse"            //拒绝好友请求
#define     APP_HTTP_AGREE_REQUEST             @"/friend/agree"             //同意好友请求
#define     APP_HTTP_FRIEND_INFO               @"/friend/info"              //获取好友信息
#define     APP_HTTP_REQUEST                   @"/friend/request"           //发送好友申请
#define     APP_HTTP_FRIEND_STATE              @"/friend/friendState"       //获取好友状态
#define     APP_HTTP_DYNAMIC                   @"/dynamic"                  //获取单个用户的动态
#define     APP_HTTP_FRIEND_DYNAMIC            @"/dynamic/friends"          //获取好友的动态
#define     APP_HTTP_MY_AGREE                  @"/dynamic/myAgree"          //获取点赞的动态
#define     APP_HTTP_MY_COLLECTION             @"/dynamic/myCollection"     //获取收藏的动态
#define     APP_HTTP_AGREE                     @"/dynamic/agree"            //点赞或取消点赞某条动态
#define     APP_HTTP_COLLECTION                @"/dynamic/collection"       //收藏或取消收藏某条动态
#define     APP_HTTP_DELETE_DYNAMIC            @"/dynamic/delete"           //删除某条动态
#define     APP_HTTP_POST                      @"/dynamic/post"             //发表动态
#define     APP_HTTP_UNREAD                    @"/message/unread"           //获取未读消息
#define     APP_HTTP_ALL_UNREAD                @"/message/allUnread"        //获取未读消息
#define     APP_HTTP_MESSAGE_DELETE            @"/message/delete"           //删除消息

//获取完整的网络请求地址
#define     GET_HTTP_ADDRESS(offsetAddress)    [NSString stringWithFormat:@"%@%@", APP_HTTP_BASE_ADDRESS, offsetAddress]

#endif
