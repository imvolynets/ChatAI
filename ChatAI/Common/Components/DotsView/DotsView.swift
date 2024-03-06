//
//  DotsView.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import SnapKit
import UIKit

class DotsView: UIView {
    let container: UIStackView = {
        let obj = UIStackView()
        obj.axis = .horizontal
        obj.alignment = .center
        obj.spacing = 2.sizeW
        return obj
    }()
    
    var dotViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(container)
        
        for _ in 0..<3 {
            let dot = UIView()
            dot.layer.masksToBounds = true
            dot.layer.cornerRadius = 2.sizeW
            dot.backgroundColor = .appMediumSlateBlueWhite
            
            container.addArrangedSubview(dot)
            dotViews.append(dot)
        }
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for index in 0..<dotViews.count {
            dotViews[index].snp.makeConstraints { make in
                make.size.equalTo(4.sizeW)
            }
        }
    }
}

extension DotsView {
    func animateDots() {
        for (index, dotView) in dotViews.enumerated() {
            let delay = TimeInterval(index) * 0.3
            UIView.animate(withDuration: 1.0, delay: delay, options: [.repeat, .autoreverse], animations: {
                dotView.alpha = 0.3
            }, completion: nil)
        }
    }
}
