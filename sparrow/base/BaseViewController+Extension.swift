//
//  BaseViewController+Extension.swift
//  sparrow
//
//  Created by hwy on 2023/4/9.
//
import Foundation
import UIKit

extension BaseViewController{
    
 @objc func initUI(){
    initBackItem()
    navigationController?.delegate = self;
}
    
func initBackItem(){
    let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    navigationItem.backBarButtonItem = item;
}

@objc func push(vc: UIViewController){
    hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
    hidesBottomBarWhenPushed = false
}

}

extension UIViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            if (viewController is HideNavigationBarProtocol){
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }else {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
}
