//
//  CustomNavigationBarView.swift
//  sparrow
//
//  Created by hwy on 2023/4/9.
//

//自定义的导航栏
import UIKit

class CustomNavigationBarView: UIView {
    
    @objc lazy var bgView = {
         let view = UIView()
        view.backgroundColor = .white
         return view
     }()
    
   @objc lazy var leftButton = {
        let button = UIButton()
       button.setImage(UIImage(named: "back"), for: .normal)
        return button
    }()
    
   @objc lazy var rightButton = {
        let button = UIButton()
        return button
    }()

    @objc lazy var titleLabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
       initStyle()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initStyle()
    }
    
    func initStyle(){
        backgroundColor = .clear
        addSubview(bgView)
        addSubview(leftButton)
        addSubview(titleLabel)
        addSubview(rightButton)

        rightButton.tintColor = .white

        leftButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.leading.equalTo(5)
            make.centerY.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height / 2)
        }

        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height / 2)
        }
    
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.centerY.equalToSuperview().offset(UIApplication.shared.statusBarFrame.size.height / 2)
            make.right.equalToSuperview().inset(15)
        }
    }

}
