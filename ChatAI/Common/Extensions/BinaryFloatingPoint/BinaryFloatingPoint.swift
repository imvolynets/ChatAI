//
//  SizeHelper.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

extension BinaryFloatingPoint {
    private var size: CGSize {
        return CGSize(width: 375, height: 812)
    }
    
    var sizeW: CGFloat {
        (CGFloat(self) * UIScreen.main.bounds.width / size.width)
    }
    
    var sizeH: CGFloat {
        (CGFloat(self) * UIScreen.main.bounds.height / size.height)
    }
    
    var lessThanOrEqualToSizeW: CGFloat {
        UIScreen.main.bounds.width < size.width ? self.sizeW : CGFloat(self)
    }
    
    var lessThanOrEqualToSizeH: CGFloat {
        UIScreen.main.bounds.height < size.height ? self.sizeH : CGFloat(self)
    }
}

extension BinaryInteger {
    var sizeW: CGFloat {
        CGFloat(self).sizeW
    }
    
    var sizeH: CGFloat {
        CGFloat(self).sizeH
    }
    
    var lessThanOrEqualToSizeW: CGFloat {
        CGFloat(self).lessThanOrEqualToSizeW
    }
    
    var lessThanOrEqualToSizeH: CGFloat {
        CGFloat(self).lessThanOrEqualToSizeH
    }
}
