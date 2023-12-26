//
//  Structs.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 26.12.2023.
//

import Foundation
import SwiftUI

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}

struct FormElevateOnWhiteBackground: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme != .dark {
            content.listRowBackground(Color(red: 0.95, green: 0.95, blue: 0.97))
        }
        else {
            content
        }
    }
}
