//
//  Login Errors.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import Foundation

struct JSONtoDictError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

struct DictToStringError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}
