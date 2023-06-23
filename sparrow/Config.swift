//
//  Config.swift
//  sparrow
//
//  Created by hwy on 2023/4/13.
//

import Foundation

@objcMembers class Config: NSObject{
    static let contactFileName = "contact.json"
    static let dynamicFileName = "dynamic.json"
    static let userFileName = "user.json"
    static let sqliteName = "sparrow.sqlite"
    
    static let token = "token"
    static let userId = "userId"
    static let data = "data"
}


@objcMembers class NotiName:NSObject{
    static let successLogin = NSNotification.Name("successLogin")    //登录成功通知
    static let newMessage = NSNotification.Name("newMessage")        //收到新消息通知
}


/// 遵循这个协议，可以隐藏导航栏
@objc protocol HideNavigationBarProtocol where Self: UIViewController {}
