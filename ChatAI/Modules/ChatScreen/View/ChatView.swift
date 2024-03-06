//
//  ChatScreen.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import SnapKit
import UIKit

class ChatView: UIView {    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let obj = UIVisualEffectView(effect: blurEffect)
        obj.backgroundColor = .appWhiteYankeesBlue
        obj.alpha = 0.9
        return obj
    }()
    
    let borderBlurView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .appBrightGrayPoliceBlue
        return obj
    }()
    
    let backButton: UIButton = {
        let obj = UIButton()
        obj.setImage(UIImage(resource: .backButtonIcon), for: .normal)
        obj.tintColor = .purple
        return obj
    }()
    
    let chatName: UILabel = {
        let obj = UILabel()
        obj.textColor = .appBlackWhite
        obj.font = .Poppins.semiBold(size: 16).font
        return obj
    }()
    
    let avatarView: UIView = {
        let obj = UIView()
        obj.layer.cornerRadius = 18
        obj.clipsToBounds = true
        return obj
    }()
    
    let firstLetterName: UILabel = {
        let obj = UILabel()
        obj.font = .Poppins.semiBold(size: 19).font
        obj.textColor = .white
        return obj
    }()
    
    let container: UIStackView = {
        let obj = UIStackView()
        obj.axis = .horizontal
        obj.alignment = .center
        obj.spacing = 5.sizeW
        return obj
    }()
    
    let dots: DotsView = {
        let obj = DotsView()
        obj.isHidden = true
        return obj
    }()
    
    let statusLabel: UILabel = {
        let obj = UILabel()
        obj.font = .systemFont(ofSize: 12.sizeW, weight: .regular)
        obj.textColor = .appMediumSlateBlueWhite
        obj.text = "chat_status_online".localized // test
        return obj
    }()
    
    let tableView: UITableView = {
        let obj = UITableView()
        obj.backgroundColor = .clear
        obj.contentInset = UIEdgeInsets(top: 75.sizeH, left: 0, bottom: 0, right: 0)
        obj.separatorStyle = .none
        obj.keyboardDismissMode = .interactive
        return obj
    }()
    
    let messageView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .appWhiteYankeesBlue
        obj.layer.cornerRadius = 18.sizeW
        obj.layer.masksToBounds = true
        return obj
    }()
    
    let messageTextView: FlexibleTextView = {
        let obj = FlexibleTextView()
        obj.placeholder = "chat_message_placeholder".localized
        obj.font = .systemFont(ofSize: 16.sizeW, weight: .regular)
        obj.maxHeight = 150.sizeH
        obj.tintColor = .appMediumSlateBlue
        obj.backgroundColor = .appWhiteYankeesBlue
        obj.textColor = .appBlackWhite
        return obj
    }()
    
    let sendButton: UIButton = {
        let obj = UIButton()
        obj.setImage(.sendButtonIcon, for: .normal)
        obj.tintColor = .purple
        obj.isEnabled = false
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
        
        addSubview(tableView)
        
        addSubview(blurView)
        addSubview(borderBlurView)
        
        blurView.contentView.addSubview(backButton)
        blurView.contentView.addSubview(chatName)
        blurView.contentView.addSubview(container)
        container.addArrangedSubview(dots)
        container.addArrangedSubview(statusLabel)
        blurView.contentView.addSubview(avatarView)
        avatarView.addSubview(firstLetterName)
        addSubview(messageView)
        messageView.addSubview(messageTextView)
        addSubview(sendButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        blurView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(container.snp.bottom).offset(14.sizeH)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8.sizeW)
            make.bottom.equalToSuperview().offset(-17.sizeH)
        }
        
        chatName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(19.sizeH)
            make.centerX.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(chatName.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        borderBlurView.snp.makeConstraints { make in
            make.top.equalTo(blurView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.4.sizeH)
        }
        
        avatarView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-11.sizeW)
            make.bottom.equalToSuperview().offset(-14.sizeH)
            make.size.equalTo(36.sizeW)
        }
        
        firstLetterName.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(messageView.snp.top).offset(-15.sizeH)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12.sizeW)
            make.size.equalTo(CGSize(width: 42.sizeW, height: 40.sizeH))
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-9.sizeH)
        }
        
        messageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(13.sizeW)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10.sizeW)
            make.top.equalTo(messageTextView.snp.top)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-9.sizeH)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25.sizeW)
            make.trailing.equalToSuperview().inset(30.sizeW)
            make.top.bottom.equalToSuperview()
        }
    }
}

extension ChatView {
    private func setUpBackgroundColor() {
        backgroundColor = .appAntiFlashWhiteDarkGunmetal
    }
}

extension ChatView {
    func handle(model: Chat?) {
        guard let model else {
            return
        }
        chatName.text = model.chatName
        avatarView.backgroundColor = UIColor(hexString: model.avatarColor)
        firstLetterName.text = model.chatName.first?.uppercased()
    }
}
