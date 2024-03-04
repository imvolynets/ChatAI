//
//  ErrorAlert.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 04.03.2024.
//

import Foundation
import UIKit

class ErrorAlert: UIViewController {
    static func showAlertError(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: "chat_create_validation_error_ok".localized,
            style: .default,
            handler: nil)
        )
        return alertController
    }
}
