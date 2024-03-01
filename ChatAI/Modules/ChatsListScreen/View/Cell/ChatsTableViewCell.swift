//
//  ChatsTableViewCell.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import SnapKit
import UIKit

final class ChatsTableViewCell: UITableViewCell, Reusable {
    var model: Chat? {
        didSet {
            handle()
        }
    }
    
    let avatarView: UIView = {
        let obj = UIView()
        obj.layer.cornerRadius = 28.sizeW
        obj.clipsToBounds = true
        // test
        obj.backgroundColor = .purple
        return obj
    }()
    
    let chatName: UILabel = {
        let obj = UILabel()
        obj.font = .Poppins.medium(size: 15).font
        obj.textColor = .appBlackWhite
        return obj
    }()
    
    let lastMessage: UILabel = {
        let obj = UILabel()
        obj.numberOfLines = 2
        obj.font = .systemFont(ofSize: 14.sizeW, weight: .regular)
        obj.textColor = .appBlackWhite
        obj.alpha = 0.35
        return obj
    }()
    
    let firstLetterName: UILabel = {
        let obj = UILabel()
        obj.font = .Poppins.semiBold(size: 29).font
        obj.textColor = .white
        return obj
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        backgroundColor = selected ? .appAntiFlashWhiteYankeesBlue : .clear
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupCell()
        
        contentView.addSubview(avatarView)
        avatarView.addSubview(firstLetterName)
        contentView.addSubview(chatName)
        contentView.addSubview(lastMessage)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        avatarView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16.sizeW)
            make.size.equalTo(CGSize(width: 56.sizeW, height: 56.sizeH))
        }
        
        chatName.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(11.sizeW)
            make.top.equalToSuperview().offset(13.sizeH)
            make.trailing.equalToSuperview().offset(-16.sizeW)
        }
        
        lastMessage.snp.makeConstraints { make in
            make.leading.equalTo(avatarView.snp.trailing).offset(11.sizeW)
            make.trailing.equalToSuperview().offset(-16.sizeW)
            make.top.equalTo(chatName.snp.bottom).offset(9.sizeH)
            make.bottom.equalToSuperview().offset(-12.sizeH)
        }
        
        firstLetterName.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension ChatsTableViewCell {
    private func handle() {
        guard let model else {
            return
        }
        chatName.text = model.chatName
        lastMessage.text = model.lastMessage
        firstLetterName.text = model.chatName.first?.uppercased()
    }
}

extension ChatsTableViewCell {
    private func setupCell() {
        separatorInset = UIEdgeInsets(top: 0, left: 84.sizeW, bottom: 0, right: 19.sizeW)
        selectionStyle = .none
    }
}
