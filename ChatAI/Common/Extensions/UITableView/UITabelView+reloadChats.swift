//
//  UITabelView.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import UIKit

extension UITableView {
    func reloadChats() {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            self.reloadData()
        }
    }
}
