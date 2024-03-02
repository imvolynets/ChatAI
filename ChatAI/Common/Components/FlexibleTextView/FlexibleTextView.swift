//
//  FlexibleTextView.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import SnapKit
import UIKit

class FlexibleTextView: UITextView {
    var maxHeight: CGFloat = 0.0
    let placeholderTextView: UITextView = {
        let obj = UITextView()
        obj.backgroundColor = .clear
        obj.font = .systemFont(ofSize: 16.sizeW, weight: .regular)
        obj.isScrollEnabled = false
        obj.isUserInteractionEnabled = false
        obj.textColor = .appSilverSandRomanSilver
        return obj
    }()
    var placeholder: String? {
        get {
            return placeholderTextView.text
        }
        set {
            placeholderTextView.text = newValue
        }
    }
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    required init? (coder aDecoder: NSCoder) {
        super.init(frame: .zero, textContainer: NSTextContainer())
        setup()
    }
    func setup() {
        isScrollEnabled = false
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        placeholderTextView.font = font
        addSubview(placeholderTextView)
        
        placeholderTextView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    override var text: String! {
        didSet {
            invalidateIntrinsicContentSize()
            placeholderTextView.isHidden = !text.isEmpty
        }
    }
    override var font: UIFont? {
        didSet {
            placeholderTextView.font = font
            invalidateIntrinsicContentSize()
        }
    }
    override var contentInset: UIEdgeInsets {
        didSet {
            placeholderTextView.contentInset = contentInset
        }
    }
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric {
            layoutManager.glyphRange(for: textContainer)
            size.height = layoutManager.usedRect(for: textContainer).height
            + textContainerInset.top
            + textContainerInset.bottom
        }
        if maxHeight > 0.0 && size.height > maxHeight {
            size.height = maxHeight
            if !isScrollEnabled {
                isScrollEnabled = true
            }
        } else if isScrollEnabled {
            isScrollEnabled = false
        }
        return size
    }
}
