//
//  MessageTableViewCell.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//
import Foundation
import SnapKit
import UIKit

class MessageTableViewCell: UITableViewCell, Reusable {
    var model: Message? {
        didSet {
            handle()
        }
    }
    
    let bubbleMessageView: BubbleMessageView = {
        let obj = BubbleMessageView()
        obj.backgroundColor = .clear
        return obj
    }()
    
    let content: UILabel = {
        let obj = UILabel()
        obj.numberOfLines = 0
        obj.font = .systemFont(ofSize: 16.sizeW, weight: .regular)
        obj.textColor = .appBlackWhite
        return obj
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleMessageView.bezierPath = nil
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setupCell()
        contentView.addSubview(bubbleMessageView)
        bubbleMessageView.addSubview(content)
    }
    
    private func makeConstraints(sentBy: SenderRole) {
        bubbleMessageView.snp.remakeConstraints { make in
            make.trailing.equalTo(content.snp.trailing).offset(sentBy == .user ? 16.sizeW : 12.sizeW)
            make.leading.equalTo(content.snp.leading).offset(sentBy == .user ? -12.sizeW : -16.sizeW)
            make.top.equalTo(content.snp.top).inset(-10.sizeW)
            make.bottom.equalTo(content.snp.bottom).inset(-10.sizeW)
        }
        
        content.snp.remakeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-14.sizeH)
            make.top.equalTo(contentView.snp.top).offset(14.sizeH)
            
            if sentBy == .assistant {
                make.leading.equalTo(contentView.snp.leading).offset(24.sizeW)
                make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-111.sizeW)
            } else {
                make.trailing.equalTo(contentView.snp.trailing).offset(-23.sizeW)
                make.leading.greaterThanOrEqualTo(contentView.snp.leading).offset(108.sizeW)
            }
        }
    }
}

extension MessageTableViewCell {
    private func handle() {
        guard let model else {
            return
        }
        bubbleMessageView.bezierPath = UIBezierPath()
        bubbleMessageView.sentBy = model.role
        content.text = model.content
        makeConstraints(sentBy: model.role)
    }
}

extension MessageTableViewCell {
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
