//
//  ErrorHelper.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 06.03.2024.
//

import Foundation
import UIKit

class ErrorHelper {
    var alert: UIAlertController?
    
    func presentError(forError error: Error, inViewController viewController: UIViewController) {
        if error as? APIError == APIError.reachedResponsesLimit {
            alert = UIAlertController(
                title: APIError.reachedResponsesLimit.title,
                message: APIError.reachedResponsesLimit.description,
                preferredStyle: .alert
            )
        } else if error as? ValidationError == ValidationError.chatNameAlreadyExist {
            alert = UIAlertController(
                title: ValidationError.chatNameAlreadyExist.title,
                message: ValidationError.chatNameAlreadyExist.description,
                preferredStyle: .alert
            )
        }
        
        if let alert {
            alert.addAction(UIAlertAction(
                title: "ok".localized,
                style: .default,
                handler: nil)
            )
            viewController.present(alert, animated: true)
        }
    }
    
    deinit {
        print("errorHelper deinited")
    }
}
