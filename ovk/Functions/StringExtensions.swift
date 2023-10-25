//
//  StringExtensions.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 26.10.2023.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
}
