//
//  UIFont+poppins.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

extension UIFont {
    enum Poppins {
        case semiBold(size: CGFloat)
        case medium(size: CGFloat)
        
        var font: UIFont {
            switch self {
            case .semiBold(let size):
                return UIFont(name: "Poppins-SemiBold", size: size.sizeW) ?? .systemFont(ofSize: size.sizeW)
            case .medium(let size):
                return UIFont(name: "Poppins-Medium", size: size.sizeW) ?? .systemFont(ofSize: size.sizeW)
            }
        }
    }
}
