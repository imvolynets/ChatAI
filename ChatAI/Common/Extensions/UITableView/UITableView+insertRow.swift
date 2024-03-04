//
//  UITableView+insertRow.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import UIKit

extension UITableView {
    func insertRow(row: Int, animation: UITableView.RowAnimation) {
        self.insertRows(at: [IndexPath(row: row, section: 0)], with: animation)
    }
}
