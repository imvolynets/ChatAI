//
//  UserMessageTableViewCell.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 27.02.2024.
//

import Foundation
import SnapKit
import UIKit

protocol BubbleView {
    var bubbleView: BubbleMessageView { get }
}

class UserMessageTableViewCell: UITableViewCell, Reusable, BubbleView {
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
            make.trailing.equalTo(content.snp.trailing).offset(16.sizeW)
            make.leading.equalTo(content.snp.leading).offset(-12.sizeW)
            make.top.equalTo(content.snp.top).inset(-10.sizeH)
            make.bottom.equalTo(content.snp.bottom).inset(-10.sizeH)
        }
        
        content.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-23.sizeW)
            make.top.equalTo(contentView.snp.top).offset(14.sizeH)
            make.bottom.equalTo(contentView.snp.bottom).offset(-14.sizeH)
            make.leading.greaterThanOrEqualTo(contentView.snp.leading).offset(108.sizeW)
        }
    }
}

extension UserMessageTableViewCell {
    private func handleUI() {
        guard let model else { return }
        bubbleView.sentBy = .user
        content.text = model.content
    }
}

extension UserMessageTableViewCell {
    private func setupDefault() {
        selectionStyle = .none
        backgroundColor = .clear
    }
}
