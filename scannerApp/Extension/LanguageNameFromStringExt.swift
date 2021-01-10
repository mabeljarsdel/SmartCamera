//
//  LanguageNameFromStringExt.swift
//  Translate Camera
//
//  Created by Maksym on 10.01.2021.
//

import Foundation
import UIKit

extension String {
    var languageName: String {
        Locale.current.localizedString(forLanguageCode: self) ?? "Wrong language code"
    }
}
