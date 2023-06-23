//
//  SearchViewCell.swift
//  sparrow
//
//  Created by hwy on 2023/4/10.
//

import UIKit

//搜索栏
class SearchViewCell: UITableViewCell {
    
    lazy var searchView: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "请输入要搜索的内容"
        view.searchBarStyle = .minimal
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initStyle(){
        contentView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        separatorInset = .zero;
        layoutMargins = .zero;
        preservesSuperviewLayoutMargins = false;
        selectionStyle = .none;
    }
    
    @objc static func getHeight() -> CGFloat {
        return 50
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
