//
//  ChatsListView.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import SnapKit
import UIKit

class ChatsListView: UIView {
    let headerLogoStackView: UIStackView = {
        let obj = UIStackView()
        obj.spacing = 8.sizeW
        obj.alignment = .center
        return obj
    }()
    
    let smallLogoImage: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFit
        obj.image = .smallLogoIcon
        return obj
    }()
    
    let logoTitle: UILabel = {
        let obj = UILabel()
        obj.font = .Poppins.semiBold(size: 23.sizeW).font
        obj.textColor = .appBlackWhite
        obj.text = "chats_list_header_title".localized
        return obj
    }()
    
    let searchField: UITextField = {
        let obj = UITextField()
        obj.backgroundColor = .appAntiFlashWhiteYankeesBlue
        obj.layer.cornerRadius = 18.sizeW
        obj.textColor = .appBlackWhite
        obj.layer.masksToBounds = true
        obj.returnKeyType = .done
        obj.clearButtonMode = .always
        obj.autocorrectionType = .no
        return obj
    }()
    
    let searchIcon: UIImageView = {
        let obj = UIImageView()
        obj.image = .searchIcon
        obj.contentMode = .scaleAspectFit
        return obj
    }()
    
    let searchPlaceholderLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 16.sizeW, weight: .regular)
        obj.text = "chats_list_search_field_placholder".localized
        obj.textColor = .appBlackWhite
        obj.alpha = 0.35
        return obj
    }()
    
    let tableView: UITableView = {
        let obj = UITableView()
        obj.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60.sizeH, right: 0)
        return obj
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let obj = UIVisualEffectView(effect: blurEffect)
        obj.backgroundColor = .appAntiFlashWhiteYankeesBlue
        obj.alpha = 0.9
        return obj
    }()
    
    let borderBlurView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .appLightSilverPoliceBlue
        return obj
    }()
    
    let addNewChatButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(resource: .newChatButtonIcon), for: .normal)
        obj.tintColor = .purple
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setUpBackgroundColor()
        
        addSubview(headerLogoStackView)
        headerLogoStackView.addArrangedSubview(smallLogoImage)
        headerLogoStackView.addArrangedSubview(logoTitle)
        
        addSubview(searchField)
        searchField.addSubview(searchIcon)
        searchField.addSubview(searchPlaceholderLabel)
        
        addSubview(tableView)
        
        addSubview(blurView)
        addSubview(borderBlurView)
        blurView.contentView.addSubview(addNewChatButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        headerLogoStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20.sizeH)
            make.leading.trailing.equalToSuperview().inset(137.sizeW)
        }
        
        smallLogoImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 22.sizeW, height: 18.sizeH))
        }
        
        searchField.snp.makeConstraints { make in
            make.top.equalTo(headerLogoStackView.snp.bottom).offset(11.sizeH)
            make.leading.trailing.equalToSuperview().inset(18.sizeW)
            make.height.equalTo(40.sizeH)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20.sizeW)
            make.top.bottom.equalToSuperview().inset(11.sizeH)
        }
        
        searchPlaceholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchField.snp.bottom).offset(14.sizeH)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(addNewChatButton.snp.top).offset(-14.sizeH)
        }
        
        borderBlurView.snp.makeConstraints { make in
            make.bottom.equalTo(blurView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.3.sizeH)
        }
        
        addNewChatButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(135.sizeW)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-10.sizeH)
        }
    }
}

extension ChatsListView {
    private func setUpBackgroundColor() {
        backgroundColor = .appWhiteDarkGunmetal
    }
}

extension ChatsListView {
    func addLeftPaddingToSearchField() {
        let blankView = UIView(frame: CGRect(x: 0, y: 0,
                                             width: searchIcon.frame.maxX + 10,
                                             height: searchField.frame.height))
        searchField.leftView = blankView
        searchField.leftViewMode = .always
    }
}
