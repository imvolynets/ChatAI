//
//  BubbleMessageView.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 02.03.2024.
//

import Foundation
import UIKit
// swiftlint:disable all
class BubbleMessageView: UIView {
    var bezierPath: UIBezierPath?
    var sentBy: SenderRole? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        bezierPath = UIBezierPath()
        guard let bezierPath = bezierPath else {return}
        
        if sentBy == .user {
            drawUserMessageBubble(bezierPath: bezierPath, bottom: rect.height, right: rect.width)

        } else {
            drawAssistantMessageBubble(bezierPath: bezierPath, bottom: rect.height, right: rect.width)
        }
        bezierPath.fill()
        bezierPath.stroke()
    }

}

extension BubbleMessageView {
    private func drawUserMessageBubble(bezierPath: UIBezierPath, bottom: CGFloat, right: CGFloat) {
        bezierPath.move(to: CGPoint(x: right - 22, y: bottom))
        bezierPath.addLine(to: CGPoint(x: 17, y: bottom))
        bezierPath.addCurve(to: CGPoint(x: 0, y: Int(bottom) - 18), controlPoint1: CGPoint(x: 7.61, y: bottom), controlPoint2: CGPoint(x: 0, y: bottom - 7.61))
        bezierPath.addLine(to: CGPoint(x: 0, y: 17))
        bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: Int(right) - 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: right - 4, y: 17), controlPoint1: CGPoint(x: right - 11.61, y: 0), controlPoint2: CGPoint(x: right - 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 11))
        bezierPath.addCurve(to: CGPoint(x: right, y: bottom), controlPoint1: CGPoint(x: right - 4, y: bottom - 1), controlPoint2: CGPoint(x: right, y: bottom))
        bezierPath.addLine(to: CGPoint(x: right + 0.05, y: bottom - 0.01))
        bezierPath.close()
        UIColor.appLavenderBlueOceanBlue.setStroke()
        UIColor.appLavenderBlueOceanBlue.setFill()
    }
    
    private func drawAssistantMessageBubble(bezierPath: UIBezierPath, bottom: CGFloat, right: CGFloat) {
        bezierPath.move(to: CGPoint(x: 22, y: bottom)) // 5
        bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
        bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17), controlPoint1: CGPoint(x: right - 7.61, y: bottom), controlPoint2: CGPoint(x: right, y: bottom - 7.61))
        bezierPath.addLine(to: CGPoint(x: right, y: 17))
        bezierPath.addCurve(to: CGPoint(x: Int(right) - 17, y: 0), controlPoint1: CGPoint(x: right, y: 7.61), controlPoint2: CGPoint(x: right - 7.61, y: 0))
        bezierPath.addLine(to: CGPoint(x: 21, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
        bezierPath.addLine(to: CGPoint(x: 4, y: bottom - 11))
        bezierPath.addCurve(to: CGPoint(x: 0, y: bottom), controlPoint1: CGPoint(x: 4, y: bottom - 1), controlPoint2: CGPoint(x: 0, y: bottom))
        bezierPath.addLine(to: CGPoint(x: 0.05, y: bottom - 0.01))
        bezierPath.close()
        
        UIColor.appWhiteYankeesBlue.setStroke()
        UIColor.appWhiteYankeesBlue.setFill()
    }
}
// swiftlint:enable all
