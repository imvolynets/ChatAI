//
//  BotMessageViewCell.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 27.02.2024.
//

import Foundation
import SnapKit
import UIKit

class BotMessageTableViewCell: UITableViewCell, Reusable {
    var model: Message? {
        didSet {
            handleUI()
        }
    }
    
    let bubbleView: BubbleMessageView = {
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleView.bezierPath = nil
    }
    
    private func setup() {
        setupDefault()
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(content)
        makeConstraints()
    }
    
    private func makeConstraints() {
        bubbleView.snp.makeConstraints { make in
            make.leading.equalTo(content.snp.leading).offset(-16.sizeW)
            make.trailing.equalTo(content.snp.trailing).offset(12.sizeW)
            make.top.equalTo(content.snp.top).inset(-10.sizeH)
            make.bottom.equalTo(content.snp.bottom).inset(-10.sizeH)
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(14.sizeH)
            make.bottom.equalTo(contentView.snp.bottom).offset(-14.sizeH)
            make.leading.equalTo(contentView.snp.leading).offset(24.sizeW)
            make.trailing.lessThanOrEqualTo(contentView.snp.trailing).offset(-111.sizeW)
        }
    }
}

extension BotMessageTableViewCell {
    private func handleUI() {
        guard let model else { return }
        bubbleView.sentBy = .assistant
        content.text = model.content
    }
}

extension BotMessageTableViewCell {
    private func setupDefault() {
        selectionStyle = .none
        backgroundColor = .clear
    }
}
