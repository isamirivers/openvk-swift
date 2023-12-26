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
            "feed": getLocalizedString(key: "Feed"),
            "debug": getLocalizedString(key: "Debug")
        ]
        if UIDevice.isiPhone {
            NavigationView {
                TabView (selection: $selectedTab) {
                    Profile(debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: $profileHeader, userIDtoGet: "0", imageURL: $imageURL, viewerShown: $viewerShown)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Профиль")
                        }
                        .tag("profile")
                    
                    Feed(imageURL: $imageURL, viewerShown: $viewerShown)
                        .tabItem {
                            Image(systemName: "newspaper")
                            Text("Feed")
                        }
                        .tag("feed")
                    
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
                .safeAreaInset(edge: .top, content: {
                    Color.clear
                        .frame(height:0)
                        .background(.bar)
                        .border(.black)
                }) // https://mahfuzcse12.medium.com/transparent-background-problem-in-navigation-toolbar-while-scrolling-in-swiftui-711c58cd5fff
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
            // Костыль, чтобы обновлять экран ¯\_(ツ)_/¯ 👇🏼 (не осуждайте пж)
            .background(isViewUpdated ? Color.clear : Color.clear)
            .overlay(ImageViewerRemote(imageURL: $imageURL, viewerShown: $viewerShown))

        } else {
            NavigationView {
                List {
                    NavigationLink(destination: Profile(debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: $profileHeader, userIDtoGet: "0", imageURL: $imageURL, viewerShown: $viewerShown)) {
                        Label("Профиль", systemImage: "person.crop.circle")
                    }
                    
                    NavigationLink(destination: Feed(imageURL: $imageURL, viewerShown: $viewerShown)) {
                        Label("Feed", systemImage: "newspaper")
                    }
                    
                    NavigationLink(destination: LoginSettings(debug: $debug, isMainViewUpdated: $isMainViewUpdated)) {
                        Label("Debug", systemImage: "gear")
                    }
                }
                .navigationTitle("OpenVK Swift")
                Profile(debug: $debug, isMainViewUpdated: $isMainViewUpdated, profileHeader: $profileHeader, userIDtoGet: "0", imageURL: $imageURL, viewerShown: $viewerShown)
            }
            // Костыль, чтобы обновлять экран ¯\_(ツ)_/¯ 👇🏼 (не осуждайте пж)
            .background(isViewUpdated ? Color.clear : Color.clear)
            .overlay(ImageViewerRemote(imageURL: $imageURL, viewerShown: $viewerShown))

        }
    }
}

#Preview {
    MainView()
}
