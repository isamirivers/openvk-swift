//
//  SwiftUIView.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI

struct MainView: View {
    
    @State private var isMainViewUpdated = false
    @State private var debug = false
    
    var body: some View {
        Group {
            if (getValueFromKeychain(forKey:"token") == nil) {
                LoginView(debug: $debug, isMainViewUpdated: $isMainViewUpdated)
            }
            else {
                SwiftUIView(isMainViewUpdated: $isMainViewUpdated, debug: $debug)
            }
        }
        // Костыль, чтобы обновлять экран ¯\_(ツ)_/¯ 👇🏼 (не осуждайте пж)
        .background(isMainViewUpdated ? Color.clear : Color.clear)
    }
}

#Preview {
    MainView()
}
