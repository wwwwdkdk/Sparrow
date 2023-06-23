//
//  BaseResp.swift
//  sparrow
//
//  Created by hwy on 2023/5/6.
//

import Foundation

struct BaseResp<T> {
    var code: String?
    var msg: String?
    var data:T?
}
