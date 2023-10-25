//
//  SwiftUIView.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI

struct SwiftUIView: View {
    
    // Эта хрень обновляет view 👇🏼
    @State private var isViewUpdated = false
    @Binding var isMainViewUpdated: Bool
    
    @Binding var debug: Bool
    
    @State var selectedTab = "profile"
    @State var tabNames = [
        "debug": getLocalizedString(key: "Debug")
    ]
    
    var body: some View {
        NavigationStack{
            TabView (selection: $selectedTab) {
                Profile(debug: $debug, isMainViewUpdated: $isMainViewUpdated)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Профиль")
                }
                .tag("profile")
                
                LoginSettings(debug: $debug)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Debug")
                    }
                    .tag("debug")
                
            }
            .onChange(of: selectedTab) { newValue in
                
            }
            .navigationTitle(tabNames[String(describing: selectedTab)] ?? "")
            //.navigationBarTitleDisplayMode(.inline)
        }
            // Костыль, чтобы обновлять экран ¯\_(ツ)_/¯ 👇🏼 (не осуждайте пж)
            .background(isViewUpdated ? Color.clear : Color.clear)
    }
}

#Preview {
    MainView()
}
