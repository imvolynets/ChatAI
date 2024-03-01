//
//  String+localized.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import Foundation

extension String {
    var localized: String {
        return String(localized: LocalizationValue(self))
    }
}
