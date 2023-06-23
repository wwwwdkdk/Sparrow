//
//  AboutViewController.swift
//  sparrow
//
//  Created by hwy on 2022/11/5.
//

import Foundation
import UIKit
import SnapKit

class AboutViewController: BaseViewController {

    lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "大四毕业设计，完成了简单的功能"
        return label
    }()

    override func viewDidLoad() {
        initStyle()
    }

    func initStyle() {
        view.backgroundColor = .white
        title = "关于"
        view.addSubview(aboutLabel)
        aboutLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-30)
            make.left.equalTo(15)
            make.top.equalTo(100)
        }
    }

}
