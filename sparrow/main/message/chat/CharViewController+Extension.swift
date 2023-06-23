//
//  CharViewController+Extension.swift
//  sparrow
//
//  Created by wyh on 2023/2/25.
//

import Foundation

extension ChatViewController{
    
    @objc func getPictureName() -> String{
        let path = "\(NSHomeDirectory())/Documents/\(NSUUID().uuidString).png"
        return path
    }
}
