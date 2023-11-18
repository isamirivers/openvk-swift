//
//  SwiftUIView.swift
//  ovk
//
//  Created by Isami Riša on 25.10.2023.
//

import SwiftUI
import ImageViewerRemote

struct MainScreen: View {
    
    // Эта хрень обновляет view 👇🏼
    @State private var isViewUpdated = false
    @Binding var isMainViewUpdated: Bool
    
    @State private var profileHeader = ""
    
    @Binding var debug: Bool
    
    @State var selectedTab = "profile"
    
    @State var imageURL = ""
    @State var viewerShown = false
    
    var body: some View {
        
        @State var tabNames = [
            "profile": profileHeader,
            "debug": getLocalizedString(key: "Debug")
        ]
        
        @State var inlineTabs = [
            "profile"
        ]
        
        NavigationStack{
            TabView (selection: $selectedTab) {
                Profile(debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: $profileHeader, userIDtoGet: "0", imageURL: $imageURL, viewerShown: $viewerShown)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Профиль")
                }
                .tag("profile")
                
                LoginSettings(debug: $debug, isMainViewUpdated: $isMainViewUpdated)
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Debug")
                    }
                    .tag("debug")
                
            }
            .onChange(of: selectedTab) { newValue in
                
            }
            .navigationTitle(tabNames[String(describing: selectedTab)] ?? "")
            .navigationBarTitleDisplayMode(inlineTabs.contains(String(describing: selectedTab)) ? .inline : .automatic)
        }
            // Костыль, чтобы обновлять экран ¯\_(ツ)_/¯ 👇🏼 (не осуждайте пж)
            .background(isViewUpdated ? Color.clear : Color.clear)
            .overlay(ImageViewerRemote(imageURL: $imageURL, viewerShown: $viewerShown))
    }
}

#Preview {
    MainView()
}
