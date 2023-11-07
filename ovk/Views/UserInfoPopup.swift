//
//  Popup.swift
//  OpenVK Swift
//
//  Created by Isami Riša on 02.11.2023.
//

import Foundation
import SwiftUI
import WebKit

struct UserInfoPopup: View {   
    
    @Binding var music: String
    @Binding var movies: String
    @Binding var tv: String
    @Binding var books: String
    @Binding var city: String
    @Binding var interests: String
    
    var body: some View {
        Form {
            
            if interests != "" {
                VStack (alignment: .leading) {
                    Text("Интересы")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(interests)
                }
            }
            
            if music != "" {
                VStack (alignment: .leading) {
                    Text("Любимая музыка")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(music)
                }
            }
            
            if movies != "" {
                VStack (alignment: .leading) {
                    Text("Любимые фильмы")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(movies)
                }
            }
            
            if tv != "" {
                VStack (alignment: .leading) {
                    Text("Любимые ТВ-шоу")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(tv)
                }
            }
            
            if books != "" {
                VStack (alignment: .leading) {
                    Text("Любимые книги")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text(books)
                }
            }
            
            if books != "" {
                VStack (alignment: .leading) {
                    Text("Любимые цитаты")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text("< Вова обнови апи пж >")
                }
            }
            
            if tv != "" {
                VStack (alignment: .leading) {
                    Text("О себе")
                        .font(.callout.smallCaps())
                        .foregroundStyle(.secondary)
                    Text("< Вова обнови апи пж >")
                }
            }
            
            if city != "" {
                Section {
                    VStack (alignment: .leading) {
                        Text("Город")
                            .font(.callout.smallCaps())
                            .foregroundStyle(.secondary)
                        Text(city)
                    }
                }
            }
            
        }
    }
    
}
