//
//  CheckForEmpty.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation
import UIKit

class CheckForEmpty {
    static func checkForEmpty(textView: UITextView, range: NSRange, text: String) -> Bool {
        let newString = (textView.text as NSString).replacingCharacters(in: range, with: text) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
