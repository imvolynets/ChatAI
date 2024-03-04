//
//  UITableView+scrollToBottom.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let numberOfRows = self.numberOfRows(inSection: 0)
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
